<%-- 
    Document   : pageHeader.jsp
    Created on : 2025年4月19日, 上午10:06:00
    Author     : kelvin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="page-header">
    <div class="container">
        <div class="page-header-content">
            <h1 class="page-title">${param.pageTitle}</h1>
            
            <% if (request.getParameter("description") != null) { %>
            <p class="page-description">${param.description}</p>
            <% } %>
            
            <% if (request.getParameter("showButton") != null && request.getParameter("showButton").equals("true")) { %>
            <div class="page-actions">
                <a href="${param.buttonUrl}" class="btn btn-primary">
                    <i class="fas ${param.buttonIcon}"></i> ${param.buttonText}
                </a>
            </div>
            <% } %>
        </div>
    </div>
</div>