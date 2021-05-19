package com.harrison.crm.setting.services.impl;

import com.harrison.crm.setting.dao.DicTypeDao;
import com.harrison.crm.setting.dao.DicValueDao;
import com.harrison.crm.setting.domain.DicType;
import com.harrison.crm.setting.domain.DicValue;
import com.harrison.crm.setting.services.DicService;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DicServiceImpl implements DicService {

    @Resource
    private DicTypeDao dicTypeDao;

    @Resource
    private DicValueDao dicValueDao;

    @Override
    public Map<String, List<DicValue>> getDic() {
        Map<String, List<DicValue>> dicMap = new HashMap<>();
        List<DicType> dicTypeList = dicTypeDao.getCode();
        for(DicType dicType:dicTypeList){
            String code = dicType.getCode();
            List<DicValue> dicValueList = dicValueDao.getDicValueByCode(code);
            dicMap.put(code + "List",dicValueList);
        }
        return dicMap;
    }

    @Override
    public Map<String, String> getPMap() {
        Map<String, String> pMap = new HashMap<>();
        pMap.put("01资质审查","10");
        pMap.put("02需求分析","20");
        pMap.put("03价值建议","40");
        pMap.put("04确定决策者","60");
        pMap.put("05提案/报价","70");
        pMap.put("06谈判/复审","90");
        pMap.put("07成交","100");
        pMap.put("08丢失的线索","0");
        pMap.put("09因竞争丢失关闭","0");
        return pMap;
    }
}
