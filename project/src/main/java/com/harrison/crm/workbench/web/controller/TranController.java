package com.harrison.crm.workbench.web.controller;

import com.harrison.crm.workbench.domain.Tran;
import com.harrison.crm.workbench.services.TranService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class TranController {

    @Resource
    private TranService tranService;

    @RequestMapping("workbench/transaction/getCustomerName.do")
    @ResponseBody
    public List<String> getCustomerName(String name){
        return tranService.getCustomerName(name);
    }

    @RequestMapping("workbench/transaction/detail.do")
    public String detail(HttpServletRequest request,String tranId){
        Tran t = tranService.getDetail(tranId);
        request.setAttribute("t",t);
        return "workbench/transaction/detail";
    }

    @RequestMapping("workbench/transaction/changeStage.do")
    @ResponseBody
    public Tran changeStage(String stage,String tranId){
        return tranService.changeStage(stage,tranId);
    }
}
