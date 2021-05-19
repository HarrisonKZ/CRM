package com.harrison.crm.workbench.services.impl;

import com.harrison.crm.setting.dao.UserDao;
import com.harrison.crm.setting.domain.User;
import com.harrison.crm.utils.DateTimeUtil;
import com.harrison.crm.utils.UUIDUtil;
import com.harrison.crm.workbench.dao.*;
import com.harrison.crm.workbench.domain.*;
import com.harrison.crm.workbench.exception.ConvertException;
import com.harrison.crm.workbench.services.ClueService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

@Service
public class ClueServiceImpl implements ClueService {

    @Resource
    private ClueDao clueDao;

    @Resource
    private ClueRemarkDao clueRemarkDao;

    @Resource
    private UserDao userDao;

    @Resource
    private ActivityDao activityDao;

    @Resource
    private ClueActivityRelationDao clueActivityRelationDao;

    @Resource
    private CustomerDao customerDao;

    @Resource
    private ContactsDao contactsDao;

    @Resource
    private CustomerRemarkDao customerRemarkDao;

    @Resource
    private ContactsRemarkDao contactsRemarkDao;

    @Resource
    private ContactsActivityRelationDao contactsActivityRelationDao;

    @Resource
    private TranDao tranDao;

    @Override
    public List<User> getUserList() {
        return userDao.getUserList();
    }

    @Override
    public boolean saveClue(Clue clue) {
        clue.setId(UUIDUtil.getUUID());
        clue.setCreateTime(DateTimeUtil.getSysTime());
        int res = clueDao.saveClue(clue);
        return res==1;
    }

    @Override
    public Clue getDetail(String id) {
        return clueDao.getDetail(id);
    }

    @Override
    public List<Activity> searchActivity(String name, String cid) {
        return clueDao.searchActivity(name,cid);
    }

    @Transactional
    @Override
    public boolean relateClueAct(String cid, String[] ids) {
        int res = 0;
        for (String id : ids) {
            ClueActivityRelation clueActivityRelation = new ClueActivityRelation();
            clueActivityRelation.setId(UUIDUtil.getUUID());
            clueActivityRelation.setActivityId(id);
            clueActivityRelation.setClueId(cid);
            res += clueActivityRelationDao.relateClueAct(clueActivityRelation);
        }
        return res==ids.length;
    }

    @Override
    public List<Activity> getActivity(String id) {
        return clueActivityRelationDao.getActivity(id);
    }

    @Override
    public Boolean cancelRelate(String activityId,String clueId) {
        int res =  clueActivityRelationDao.cancelRelate(activityId,clueId);
        return res ==1;
    }

    @Override
    public List<Activity> getAllActivityByName(String name) {
        return activityDao.getAllActivityByName(name);
    }

    @Override
    @Transactional
    public void convert(String createBy, String clueId, String flag, Tran t) {
        //获取clue信息
        Clue clue = clueDao.getClueById(clueId);
        //创建客户
        Customer customer = customerDao.getCustomerByName(clue.getCompany());
        if (customer == null){
            customer = new Customer();
            customer.setCreateBy(createBy);
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setId(UUIDUtil.getUUID());
            customer.setAddress(clue.getAddress());
            customer.setContactSummary(clue.getContactSummary());
            customer.setDescription(clue.getDescription());
            customer.setName(clue.getCompany());
            customer.setNextContactTime(clue.getNextContactTime());
            customer.setOwner(clue.getOwner());
            customer.setPhone(clue.getPhone());
            customer.setWebsite(clue.getWebsite());
            int cusRes = customerDao.saveCustomer(customer);
            if (cusRes != 1){
                throw new ConvertException("创建客户失败！");
            }
        }

        //创建联系人
        Contacts contacts = new Contacts();
        contacts.setCreateBy(createBy);
        contacts.setAddress(clue.getAddress());
        contacts.setAppellation(clue.getAppellation());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setCustomerId(customer.getId());
        contacts.setDescription(clue.getDescription());
        contacts.setEmail(clue.getEmail());
        contacts.setFullname(clue.getFullname());
        contacts.setId(UUIDUtil.getUUID());
        contacts.setJob(clue.getJob());
        contacts.setMphone(clue.getMphone());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setOwner(clue.getOwner());
        contacts.setSource(clue.getSource());
        contacts.setCreateTime(DateTimeUtil.getSysTime());
        int conRes = contactsDao.saveContacts(contacts);
        if (conRes != 1){
            throw new ConvertException("创建联系人失败！");
        }
        //获取clueRemark信息
        List<ClueRemark> clueRemarkList = clueDao.getClueRemark(clueId);
        //创建客户备注
        int res1 = 0;
        CustomerRemark customerRemark = new CustomerRemark();
        for (ClueRemark clueRemark:clueRemarkList){
            customerRemark.setId(clueRemark.getId());
            customerRemark.setCreateBy(clueRemark.getCreateBy());
            customerRemark.setCreateTime(clueRemark.getCreateTime());
            customerRemark.setCustomerId(customer.getId());
            customerRemark.setEditBy(clueRemark.getEditBy());
            customerRemark.setEditTime(clueRemark.getEditTime());
            customerRemark.setEditFlag(clueRemark.getEditFlag());
            customerRemark.setNoteContent(clueRemark.getNoteContent());
            res1 += customerRemarkDao.saveCustomerRemark(customerRemark);
        }
        if (res1 != clueRemarkList.size()){
            throw new ConvertException("创建客户备注失败！");
        }
        //创建联系人备注
        int res2 = 0;
        ContactsRemark contactsRemark = new ContactsRemark();
        for (ClueRemark clueRemark:clueRemarkList){
            contactsRemark.setId(clueRemark.getId());
            contactsRemark.setCreateBy(clueRemark.getCreateBy());
            contactsRemark.setCreateTime(clueRemark.getCreateTime());
            contactsRemark.setEditBy(clueRemark.getEditBy());
            contactsRemark.setEditTime(clueRemark.getEditTime());
            contactsRemark.setEditFlag(clueRemark.getEditFlag());
            contactsRemark.setNoteContent(clueRemark.getNoteContent());
            contactsRemark.setContactsId(contacts.getId());
            res2 += contactsRemarkDao.saveContactsRemark(contactsRemark);
        }
        if (res2 != clueRemarkList.size()){
            throw new ConvertException("创建联系人备注失败！");
        }
        //转移市场活动关联
        int res3 = 0;
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationDao.getClueActivityRelation(clueId);
        ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
        for (ClueActivityRelation clueActivityRelation:clueActivityRelationList){
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
            contactsActivityRelation.setContactsId(contacts.getId());
            res3 += contactsActivityRelationDao.saveRelate(contactsActivityRelation);
        }
        if (res3 != clueActivityRelationList.size()){
            throw new ConvertException("转移市场活动关联失败！");
        }
        //创建交易
        if ("1".equals(flag)){
            t.setContactsId(contacts.getId());
            t.setContactSummary(contacts.getContactSummary());
            t.setCreateBy(createBy);
            t.setCreateTime(DateTimeUtil.getSysTime());
            t.setCustomerId(customer.getId());
            t.setId(UUIDUtil.getUUID());
            t.setNextContactTime(contacts.getNextContactTime());
            t.setOwner(clue.getOwner());
            t.setSource(clue.getSource());
            t.setDescription(clue.getDescription());
            int res4 = tranDao.saveTran(t);
            if (res4 != 1){
                throw new ConvertException("添加交易失败！");
            }
        }
        //删除clue
        int res5 = clueDao.deleteClueById(clueId);
        if (res5 != 1){
            throw new ConvertException("删除clue失败！");
        }
        //删除clue备注
        int res6 = clueRemarkDao.deleteClueRemarkByClueId(clueId);
        if (res6 != clueRemarkList.size()){
            throw new ConvertException("删除clueRemark失败！");
        }
        //删除clue关联关系
        int res7 = clueActivityRelationDao.deleteCARByClueId(clueId);
        if (res7 != clueActivityRelationList.size()){
            throw new ConvertException("删除clue关联关系失败！");
        }

    }
}
