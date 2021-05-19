package com.harrison.crm.web.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class LoginFilter implements Filter {
    public void destroy() {
    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;
        String path = request.getServletPath();
        if ("/index.html".equals(path) || "/login.jsp".equals(path)){
            chain.doFilter(req, resp);
            return;
        }
        if (request.getSession().getAttribute("user")!=null){
            chain.doFilter(req, resp);
            return;
        }

        response.sendRedirect(request.getContextPath()+"/index.html");

    }

    public void init(FilterConfig config) throws ServletException {

    }

}
