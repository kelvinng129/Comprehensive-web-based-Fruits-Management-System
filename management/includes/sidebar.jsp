<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="sidebar">
    <div class="sidebar-header">
        <h3>AIB System</h3>
    </div>
    
    <div class="user-info">
        <div class="user-avatar">
            <img src="${pageContext.request.contextPath}/assets/images/avatar.png" alt="User Avatar">
        </div>
        <div class="user-details">
            <h5>System</h5>
            <h6>Administrator</h6>
            <p>Management</p>
        </div>
    </div>
    
    <ul class="nav-menu">
        <li>
            <a href="${pageContext.request.contextPath}/management/dashboard.jsp">
                <i class="fas fa-tachometer-alt"></i> Dashboard
            </a>
        </li>
        
        <li>
            <a href="${pageContext.request.contextPath}/management/fruit-management.jsp">
                <i class="fas fa-apple-alt"></i> Fruit Management
            </a>
        </li>
        
        <li class="submenu">
            <a href="#">
                <i class=""></i> All Fruits
            </a>
        </li>
        
        <li class="submenu">
            <a href="#">
                <i class=""></i> Categories
            </a>
        </li>
        
        <li class="submenu">
            <a href="${pageContext.request.contextPath}/management/inventory/list">
                <i class=""></i> Inventory
            </a>
        </li>
        
        <li class="submenu">
            <a href="${pageContext.request.contextPath}/management/fruit/add">
                <i class=""></i> Add Fruit
            </a>
        </li>
        
        <li class="submenu">
            <a href="${pageContext.request.contextPath}/management/category/add">
                <i class=""></i> Add Category
            </a>
        </li>
        
        <li>
            <a href="${pageContext.request.contextPath}/management/reports/list">
                <i class="fas fa-chart-bar"></i> Reports
            </a>
        </li>
        
        <li>
            <a href="${pageContext.request.contextPath}/management/location/list">
                <i class="fas fa-map-marker-alt"></i> Locations
            </a>
        </li>
        
        <li>
            <a href="${pageContext.request.contextPath}/management/user/list">
                <i class="fas fa-users"></i> Users
            </a>
        </li>
        
        <li>
            <a href="${pageContext.request.contextPath}/auth/logout">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </li>
    </ul>
</div>