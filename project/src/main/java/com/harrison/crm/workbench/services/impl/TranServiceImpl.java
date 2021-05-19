package com.harrison.crm.workbench.services.impl;

import com.harrison.crm.workbench.dao.CustomerDao;
import com.harrison.crm.workbench.dao.TranDao;
import com.harrison.crm.workbench.domain.Customer;
import com.harrison.crm.workbench.domain.Tran;
import com.harrison.crm.workbench.services.TranService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class TranServiceImpl implements TranService {
    @Resource
    private CustomerDao customerDao;

    @Resource
    private TranDao tranDao;

    @Override
    public List<String> getCustomerName(String name) {
        return customerDao.getCustomersByName(name);
    }

    @Override
    public Tran getDetail(String tranId) {
        return tranDao.getTranById(tranId);
    }

    @Override
    public Tran changeStage(String stage, String tranId) {
        int res = tranDao.changeStage(stage,tranId);
        if (res ==1 ){
            return tranDao.getTranById(tranId);
        }
        return null;
    }
}
