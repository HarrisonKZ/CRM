package com.harrison.crm.setting.web.controller;

import com.harrison.crm.setting.domain.User;
import com.harrison.crm.setting.services.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {

    @Resource
    private UserService userService;

    @RequestMapping("/login.do")
    @ResponseBody
    public Map<String,Object> login(HttpServletRequest request,String username,String userPwd){
        Map<String,Object> map = new HashMap<String,Object>();
        try {
            User user = userService.login(username,userPwd,"192.168.1.1");
            request.getSession().setAttribute("user",user);
            map.put("success",true);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("success",false);
            map.put("msg",e.getMessage());
        }
        return map;
    }

}
