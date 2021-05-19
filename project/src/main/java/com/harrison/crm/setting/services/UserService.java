package com.harrison.crm.setting.services;

import com.harrison.crm.setting.domain.User;

public interface UserService {

    User login(String username,String userPwd,String ip);

}
