<%-- 
    Document   : message.jsp
    Created on : 2025年4月19日, 上午10:05:33
    Author     : kelvin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="alert-container">
    <% if (request.getAttribute("successMessage") != null) { %>
    <div class="alert alert-success alert-dismissible">
        <%= request.getAttribute("successMessage") %>
        <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
    <% } %>
    
    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="alert alert-danger alert-dismissible">
        <%= request.getAttribute("errorMessage") %>
        <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
    <% } %>
    
    <% if (request.getAttribute("infoMessage") != null) { %>
    <div class="alert alert-info alert-dismissible">
        <%= request.getAttribute("infoMessage") %>
        <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
    <% } %>
    
    <% if (request.getAttribute("warningMessage") != null) { %>
    <div class="alert alert-warning alert-dismissible">
        <%= request.getAttribute("warningMessage") %>
        <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
    <% } %>
</div>
