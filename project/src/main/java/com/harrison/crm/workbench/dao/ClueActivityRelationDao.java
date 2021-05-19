package com.harrison.crm.workbench.dao;

import com.harrison.crm.workbench.domain.Activity;
import com.harrison.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {

    int relateClueAct(ClueActivityRelation clueActivityRelation);

    List<Activity> getActivity(String id);

    int cancelRelate(String activityId,String clueId);

    List<ClueActivityRelation> getClueActivityRelation(String clueId);

    int deleteCARByClueId(String clueId);
}
