package com.harrison.crm.setting.services;

import com.harrison.crm.setting.domain.DicValue;

import java.util.List;
import java.util.Map;

public interface DicService {
    Map<String, List<DicValue>> getDic();

    Map<String, String> getPMap();
}
