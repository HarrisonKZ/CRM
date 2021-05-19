package com.harrison.crm.setting.dao;

import com.harrison.crm.setting.domain.User;

import java.util.List;
import java.util.Map;

public interface UserDao {
    User login(Map<String,String> map);
    List<User> getUserList();
}
