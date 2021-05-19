package com.harrison.crm.workbench.dao;

import com.harrison.crm.workbench.domain.Activity;
import com.harrison.crm.workbench.domain.Clue;
import com.harrison.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueDao {

    int saveClue(Clue clue);


    Clue getDetail(String id);

    List<Activity> searchActivity(String name, String cid);


    Clue getClueById(String clueId);

    List<ClueRemark> getClueRemark(String clueId);

    int deleteClueById(String clueId);

    List<Clue> getClueList(Clue clue);

    int getTotalSize(Clue clue);
}
