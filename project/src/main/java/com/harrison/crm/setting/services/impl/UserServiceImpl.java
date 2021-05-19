package com.harrison.crm.setting.services.impl;

import com.harrison.crm.setting.dao.UserDao;
import com.harrison.crm.setting.domain.User;
import com.harrison.crm.exception.LoginException;
import com.harrison.crm.setting.services.UserService;
import com.harrison.crm.utils.DateTimeUtil;
import com.harrison.crm.utils.MD5Util;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {

    @Resource
    private UserDao userDao;


    @Override
    public User login(String username,String userPwd,String ip) {
        Map<String,String> loginMap = new HashMap<>();
        userPwd = MD5Util.getMD5(userPwd);
        loginMap.put("loginAct",username);
        loginMap.put("loginPwd",userPwd);
        User user = userDao.login(loginMap);
        if (user == null){
            throw new LoginException("用户不存在或密码错误！");
        }
        if (DateTimeUtil.getSysTime().compareTo(user.getExpireTime()) > 1){
            throw new LoginException("用户有效期已过！");
        }
        if ("0".equals(user.getLockState())){
            throw new LoginException("用户已被锁定！");
        }
        if (!(user.getAllowIps().contains(ip))){
            throw new LoginException("您的IP不允许登陆此用户！");
        }
        return user;
    }
}
