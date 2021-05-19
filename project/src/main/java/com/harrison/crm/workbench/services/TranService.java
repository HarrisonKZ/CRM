package com.harrison.crm.workbench.services;

import com.harrison.crm.workbench.domain.Tran;

import java.util.List;

public interface TranService {
    List<String> getCustomerName(String name);

    Tran getDetail(String tranId);

    Tran changeStage(String stage, String tranId);
}
