package com.harrison.crm.workbench.dao;

import com.harrison.crm.workbench.domain.Tran;

public interface TranDao {

    int saveTran(Tran t);

    Tran getTranById(String tranId);

    int changeStage(String stage, String tranId);
}
