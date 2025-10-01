<%-- 
    Document   : formLayout.jsp
    Created on : 2025年4月19日, 上午10:06:37
    Author     : kelvin
--%>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="form-container">
    <form action="${param.formAction}" method="${param.formMethod}" class="needs-validation" novalidate enctype="${param.enctype}">
        <input type="hidden" name="action" value="${param.actionValue}">
        
        <% if (request.getParameter("showCardLayout") != null && request.getParameter("showCardLayout").equals("true")) { %>
        <div class="card">
            <div class="card-header">
                <h4 class="card-title mb-0">${param.formTitle}</h4>
            </div>
            <div class="card-body">
                <jsp:doBody/>
            </div>
            <div class="card-footer">
                <button type="submit" class="btn btn-primary">
                    ${param.submitButtonText}
                </button>
                
                <% if (request.getParameter("showCancelButton") != null && request.getParameter("showCancelButton").equals("true")) { %>
                <a href="${param.cancelButtonUrl}" class="btn btn-secondary">
                    Cancel
                </a>
                <% } %>
            </div>
        </div>
        <% } else { %>
        <h4 class="form-title mb-4">${param.formTitle}</h4>
        
        <jsp:doBody/>
        
        <div class="form-actions mt-4">
            <button type="submit" class="btn btn-primary">
                ${param.submitButtonText}
            </button>
            
            <% if (request.getParameter("showCancelButton") != null && request.getParameter("showCancelButton").equals("true")) { %>
            <a href="${param.cancelButtonUrl}" class="btn btn-secondary ml-2">
                Cancel
            </a>
            <% } %>
        </div>
        <% } %>
    </form>
</div>