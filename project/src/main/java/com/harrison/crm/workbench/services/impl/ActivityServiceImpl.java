package com.harrison.crm.workbench.services.impl;

import com.github.pagehelper.PageHelper;
import com.harrison.crm.exception.DeleteActivityException;
import com.harrison.crm.setting.dao.UserDao;
import com.harrison.crm.setting.domain.User;
import com.harrison.crm.utils.DateTimeUtil;
import com.harrison.crm.utils.UUIDUtil;
import com.harrison.crm.workbench.dao.ActivityDao;
import com.harrison.crm.workbench.domain.Activity;
import com.harrison.crm.workbench.domain.ActivityRemark;
import com.harrison.crm.workbench.services.ActivityService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {
    @Resource
    private ActivityDao activityDao;

    @Resource
    private UserDao userDao;

    @Override
    public List<User> getUserList() {
        return userDao.getUserList();
    }

    @Override
    public int saveActivity(Activity activity) {
        activity.setId(UUIDUtil.getUUID());
        activity.setCreateTime(DateTimeUtil.getSysTime());
        return activityDao.saveActivity(activity);
    }


    @Override
    @Transactional
    public boolean deleteActivity(String[] ids) {
        int activityRemarkNum = activityDao.getActivityRemarkNum(ids);
        int deleteActivityRemarkNum = activityDao.deleteActivityRemark(ids);
        if (activityRemarkNum != deleteActivityRemarkNum){
            throw new DeleteActivityException("删除市场活动备注失败");
        }
        int deleteActivityNum = activityDao.deleteActivity(ids);
        if (deleteActivityNum != ids.length){
            throw new DeleteActivityException("删除市场活动失败");
        }
        return true;
    }



    @Override
    public Map<String,Object> getPageList(String pageNo, String pageSize,Activity activity) {
        int i_pageNo = Integer.parseInt(pageNo);
        int i_pageSize = Integer.parseInt(pageSize);
        int totalSize = activityDao.getTotalSize(activity);
        PageHelper.startPage(i_pageNo,i_pageSize);
        List<Activity> activityList = activityDao.getPageList(activity);
        Map<String,Object> dataMap = new HashMap<>();
        dataMap.put("totalSize", Integer.toString(totalSize));
        dataMap.put("activityList",activityList);
        return dataMap;
    }

    @Override
    public Map<String, Object> editActivity(String id) {
        List<User> userList = userDao.getUserList();
        Activity activity = activityDao.getActivityById(id);
        Map<String,Object> resMap = new HashMap<>();
        resMap.put("userList",userList);
        resMap.put("activity",activity);
        return resMap;
    }

    @Override
    public boolean updateActivity(Activity activity) {
        int res = activityDao.updateActivity(activity);
        return res==1;
    }

    @Override
    public Activity getActivityById(String id) {
        return activityDao.getActivityByIdDetail(id);
    }

    @Override
    public boolean saveRemark(HttpSession session,String noteContent,String activityId) {
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setCreateTime(DateTimeUtil.getSysTime());
        User user = (User) session.getAttribute("user");
        activityRemark.setCreateBy(user.getId());
        activityRemark.setActivityId(activityId);
        activityRemark.setEditFlag("0");
        activityRemark.setNoteContent(noteContent);
        activityRemark.setId(UUIDUtil.getUUID());
        int res = activityDao.saveRemark(activityRemark);
        return res==1;
    }

    @Override
    public Map<String, Object> getRemark(String activityId) {
        List<ActivityRemark> remarkList = activityDao.getRemark(activityId);
        for (ActivityRemark activityRemark:remarkList){
            if ("1".equals(activityRemark.getEditFlag())){
                activityRemark.setEditBy(activityDao.getRemarkEditByName(activityRemark.getEditBy()).getEditBy());
            }
        }
        Activity activity = activityDao.getActivityById(activityId);
        Map<String, Object> resMap = new HashMap<>();
        resMap.put("remarkList",remarkList);
        resMap.put("activity",activity);
        return resMap;
    }

    @Override
    public boolean deleteRemark(String id) {
        int res = activityDao.deleteRemark(id);
        return res==1;
    }

    @Override
    public ActivityRemark editRemark(String id) {
        return activityDao.getRemarkById(id);
    }

    @Override
    public boolean updateRemark(HttpSession session,String id,String noteContent) {
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setId(id);
        activityRemark.setNoteContent(noteContent);
        User user = (User) session.getAttribute("user");
        activityRemark.setEditBy(user.getId());
        activityRemark.setEditTime(DateTimeUtil.getSysTime());
        activityRemark.setEditFlag("1");


        int res =  activityDao.updateRemark(activityRemark);
        return res == 1;
    }
}
