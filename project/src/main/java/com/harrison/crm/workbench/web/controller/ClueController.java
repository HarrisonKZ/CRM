package com.harrison.crm.workbench.web.controller;

import com.harrison.crm.setting.domain.User;
import com.harrison.crm.workbench.domain.*;
import com.harrison.crm.workbench.services.ClueService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@Controller
public class ClueController {

    @Resource
    private ClueService clueService;

    @RequestMapping("workbench/clue/addClue.do")
    @ResponseBody
    public List<User> addClue(){
        return clueService.getUserList();
    }

    @RequestMapping("workbench/clue/saveClue.do")
    @ResponseBody
    public String saveClue(HttpServletRequest request,Clue clue){
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        clue.setCreateBy(user.getId());
        return clueService.saveClue(clue)?"{\"success\":\"true\"}":"{\"success\":\"false\"}";
    }


    @RequestMapping("workbench/clue/getDetail.do")
    @ResponseBody
    public Clue getDetail(String id){
        return clueService.getDetail(id);
    }


    @RequestMapping("workbench/clue/searchActivity.do")
    @ResponseBody
    public List<Activity> searchActivity(String name,String cid){
        return clueService.searchActivity(name,cid);
    }

    @RequestMapping("workbench/clue/relateClueAct.do")
    @ResponseBody
    public String relateClueAct(String cid,String id){
        String[] ids = id.split("&");
        return clueService.relateClueAct(cid,ids)?"{\"success\":\"true\"}":"{\"success\":\"false\"}";
    }

    @RequestMapping("workbench/clue/getActivity.do")
    @ResponseBody
    public List<Activity> getActivity(String id){
        return clueService.getActivity(id);
    }

    @RequestMapping("workbench/clue/cancelRelate.do")
    @ResponseBody
    public String cancelRelate(String activityId,String clueId){
        return clueService.cancelRelate(activityId,clueId)?"{\"success\":\"true\"}":"{\"success\":\"false\"}";
    }

    @RequestMapping("workbench/clue/convert.do")
    @ResponseBody
    public String convert(HttpServletRequest request, HttpServletResponse response, String clueId, String flag, Tran t) throws IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String createBy = user.getId();

        clueService.convert(createBy,clueId,flag,t);
        return "{\"success\":\"true\"}";
    }


    @RequestMapping("workbench/clue/getAllActivityByName.do")
    @ResponseBody
    public List<Activity> getAllActivityByName(String name){
        return clueService.getAllActivityByName(name);
    }
}
