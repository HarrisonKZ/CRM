package com.harrison.crm.setting.dao;

import com.harrison.crm.setting.domain.DicValue;

import java.util.List;

public interface DicValueDao {
    List<DicValue> getDicValueByCode(String code);
}
