package com.harrison.crm.web.listener;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.harrison.crm.setting.domain.DicValue;
import com.harrison.crm.setting.services.DicService;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import javax.servlet.http.HttpSessionBindingEvent;
import java.util.List;
import java.util.Map;

public class DicListener implements ServletContextListener,
        HttpSessionListener, HttpSessionAttributeListener {

    // Public constructor is required by servlet spec
    public DicListener() {
    }

    // -------------------------------------------------------
    // ServletContextListener implementation
    // -------------------------------------------------------
    public void contextInitialized(ServletContextEvent sce) {
      /* This method is called when the servlet context is
         initialized(when the Web application is deployed). 
         You can initialize servlet context related data here.
      */
        ServletContext application = sce.getServletContext();
        DicService dicService = WebApplicationContextUtils.getRequiredWebApplicationContext(application).getBean(DicService.class);
        Map<String, List<DicValue>> dicMapObj =  dicService.getDic();
        ObjectMapper om = new ObjectMapper();
        try {
            String dicMap = om.writeValueAsString(dicMapObj);
            application.setAttribute("dicMap",dicMap);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            application.setAttribute("dicMap","添加数据字典出错！");
        }
        Map<String,String> pMapObj = dicService.getPMap();

        try {
            String pMap = om.writeValueAsString(pMapObj);
            application.setAttribute("pMap",pMap);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            application.setAttribute("pMap","添加阶段对应的可能性出错！");
        }
    }

    public void contextDestroyed(ServletContextEvent sce) {
      /* This method is invoked when the Servlet Context 
         (the Web application) is undeployed or 
         Application Server shuts down.
      */
    }

    // -------------------------------------------------------
    // HttpSessionListener implementation
    // -------------------------------------------------------
    public void sessionCreated(HttpSessionEvent se) {
        /* Session is created. */
    }

    public void sessionDestroyed(HttpSessionEvent se) {
        /* Session is destroyed. */
    }

    // -------------------------------------------------------
    // HttpSessionAttributeListener implementation
    // -------------------------------------------------------

    public void attributeAdded(HttpSessionBindingEvent sbe) {
      /* This method is called when an attribute 
         is added to a session.
      */
    }

    public void attributeRemoved(HttpSessionBindingEvent sbe) {
      /* This method is called when an attribute
         is removed from a session.
      */
    }

    public void attributeReplaced(HttpSessionBindingEvent sbe) {
      /* This method is invoked when an attribute
         is replaced in a session.
      */
    }
}
