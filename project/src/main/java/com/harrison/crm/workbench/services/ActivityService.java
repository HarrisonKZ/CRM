package com.harrison.crm.workbench.services;

import com.harrison.crm.setting.domain.User;
import com.harrison.crm.workbench.domain.Activity;
import com.harrison.crm.workbench.domain.ActivityRemark;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

public interface ActivityService {
    List<User> getUserList();
    int saveActivity(Activity activity);
    Map<String,Object> getPageList(String pageNo,String pageSize, Activity activity);
    boolean deleteActivity(String[] ids);
    Map<String,Object> editActivity(String id);
    boolean updateActivity(Activity activity);
    Activity getActivityById(String id);
    boolean saveRemark(HttpSession session,String noteContent,String activityId);
    Map<String,Object> getRemark(String activityId);
    boolean deleteRemark(String id);
    ActivityRemark editRemark(String id);
    boolean updateRemark(HttpSession session,String id,String noteContent);
}
