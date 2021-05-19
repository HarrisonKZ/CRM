package com.harrison.crm.workbench.dao;

import com.harrison.crm.workbench.domain.Activity;
import com.harrison.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityDao {
    //List<User> getUserList();
    int saveActivity(Activity activity);
    List<Activity> getPageList(Activity activity);
    int getTotalSize(Activity activity);
    int deleteActivity(String[] ids);
    int getActivityRemarkNum(String[] aIds);
    int deleteActivityRemark(String[] aIds);
    Activity getActivityById(String id);
    Activity getActivityByIdDetail(String id);
    int updateActivity(Activity activity);
    int saveRemark(ActivityRemark activityRemark);
    List<ActivityRemark> getRemark(String activityId);
    int deleteRemark(String id);
    ActivityRemark getRemarkById(String id);
    int updateRemark(ActivityRemark activityRemark);
    ActivityRemark getRemarkEditByName(String editBy);

    List<Activity> getAllActivityByName(String name);
}

