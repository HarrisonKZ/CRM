package com.harrison.crm.workbench.services;

import com.harrison.crm.setting.domain.User;
import com.harrison.crm.workbench.domain.*;

import java.util.List;

public interface ClueService {
    List<User> getUserList();
    boolean saveClue(Clue clue);

    Clue getDetail(String id);

    List<Activity> searchActivity(String name, String cid);

    boolean relateClueAct(String cid, String[] ids);

    List<Activity> getActivity(String id);

    Boolean cancelRelate(String activityId,String clueId);


    void convert(String createBy, String clueId, String flag, Tran t);

    List<Activity> getAllActivityByName(String name);
}
