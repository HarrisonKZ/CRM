package com.harrison.crm.workbench.web.controller;

import com.harrison.crm.setting.domain.User;
import com.harrison.crm.workbench.domain.Activity;
import com.harrison.crm.workbench.domain.ActivityRemark;
import com.harrison.crm.workbench.services.ActivityService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
public class ActivityController {
    @Resource
    private ActivityService activityService;


    @RequestMapping("/workbench/activity/getUserList.do")
    @ResponseBody
    public List<User> getUserList(){
        return activityService.getUserList();
    }

    @RequestMapping("/workbench/activity/saveActivity.do")
    @ResponseBody
    public String saveActivity(HttpServletRequest request,Activity activity){
        HttpSession session =request.getSession(false);
        User user = (User) session.getAttribute("user");
        activity.setCreateBy(user.getName());
        int res = activityService.saveActivity(activity);
        return res == 1?"{\"success\":\"true\"}":"{\"success\":\"false\"}";
    }

    @RequestMapping("/workbench/activity/getPageList.do")
    @ResponseBody
    public Map<String,Object> getPageList(String pageNo,String pageSize,Activity activity){
        return activityService.getPageList(pageNo,pageSize,activity);
    }

    @RequestMapping("workbench/activity/deleteActivity.do")
    @ResponseBody
    public String deleteActivity(String id){
        String[] ids = id.split(",");
        return activityService.deleteActivity(ids)?"{\"success\":\"true\"}":"{\"success\":\"false\"}";
    }

    @RequestMapping("workbench/activity/editActivity.do")
    @ResponseBody
    public Map<String,Object> editActivity(String id){
        return activityService.editActivity(id);
    }

    @RequestMapping("workbench/activity/updateActivity.do")
    @ResponseBody
    public String updateActivity(Activity activity){
        return activityService.updateActivity(activity)?"{\"success\":\"true\"}":"{\"success\":\"false\"}";
    }


    @RequestMapping("workbench/activity/getDetail.do")
    @ResponseBody
    public Activity getDetail(String id){
        return activityService.getActivityById(id);
    }

    @RequestMapping("workbench/activity/saveRemark.do")
    @ResponseBody
    public String saveRemark(HttpServletRequest request,String noteContent,String activityId){
        HttpSession session = request.getSession(false);
        return activityService.saveRemark(session,noteContent,activityId)?"{\"success\":\"true\"}":"{\"success\":\"false\"}";
    }

    @RequestMapping("workbench/activity/getRemark.do")
    @ResponseBody
    public Map<String,Object> getRemark(String activityId){
        return activityService.getRemark(activityId);
    }

    @RequestMapping("workbench/activity/deleteRemark.do")
    @ResponseBody
    public String deleteRemark(String id){
        return activityService.deleteRemark(id)?"{\"success\":\"true\"}":"{\"success\":\"false\"}";
    }

    @RequestMapping("workbench/activity/editRemark.do")
    @ResponseBody
    public ActivityRemark editRemark(String id){
        return activityService.editRemark(id);
    }

    @RequestMapping("workbench/activity/updateRemark.do")
    @ResponseBody
    public String updateRemark(HttpServletRequest request,String id,String noteContent){
        HttpSession session = request.getSession(false);
        return activityService.updateRemark(session,id,noteContent)?"{\"success\":\"true\"}":"{\"success\":\"false\"}";
    }
}
