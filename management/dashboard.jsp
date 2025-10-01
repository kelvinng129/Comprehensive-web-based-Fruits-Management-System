<%-- 
    Document   : dashboard
    Created on : 2025年4月19日, 上午5:51:49
    Author     : kelvin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="ict.bean.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Management Dashboard - AIB System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="../css/dashboard.css">
</head>
<body>
    <% 
    User user = (User) session.getAttribute("user");
    if (user == null || !"senior_management".equals(user.getRole())) {
        response.sendRedirect("../unauthorized.jsp");
        return;
    }
    %>
    
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <h2>AIB System</h2>
            </div>
            <div class="sidebar-user">
                <i class="fas fa-user-circle"></i>
                <div class="user-info">
                    <h3><%= user.getFullName() %></h3>
                    <p>Management</p>
                </div>
            </div>
            <ul class="sidebar-menu">
    <li class="active"><a href="dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
    
    <!-- Add Fruit Management Section -->
    <li class="sidebar-dropdown">
        <a href="#"><i class="fas fa-apple-alt"></i> Fruit Management</a>
        <div class="sidebar-submenu">
            <ul>
                <li><a href="${pageContext.request.contextPath}/fruit?action=list">All Fruits</a></li>
                <li><a href="${pageContext.request.contextPath}/category?action=list">Categories</a></li>
                <li><a href="${pageContext.request.contextPath}/inventory?action=list">Inventory</a></li>
                <li><a href="${pageContext.request.contextPath}/fruit?action=showAddForm">Add Fruit</a></li>
                <li><a href="${pageContext.request.contextPath}/category?action=showAddForm">Add Category</a></li>
            </ul>
        </div>
    </li>
    
    <li><a href="reports.jsp"><i class="fas fa-chart-bar"></i> Reports</a></li>
    <li><a href="locations.jsp"><i class="fas fa-map-marker-alt"></i> Locations</a></li>
    <li><a href="users.jsp"><i class="fas fa-users"></i> Users</a></li>
    <li><a href="../LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
</ul>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <div class="header">
                <h1>Management Dashboard</h1>
                <div class="header-right">
                    <span><i class="fas fa-bell"></i></span>
                    <span><i class="fas fa-envelope"></i></span>
                </div>
            </div>
            
            <div class="content">
                <div class="stats-cards">
                    <div class="card">
                        <div class="card-icon blue"><i class="fas fa-apple-alt"></i></div>
                        <div class="card-info">
                            <h3>Total Fruits</h3>
                            <h2>15</h2>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-icon green"><i class="fas fa-store"></i></div>
                        <div class="card-info">
                            <h3>Locations</h3>
                            <h2>8</h2>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-icon orange"><i class="fas fa-users"></i></div>
                        <div class="card-info">
                            <h3>Users</h3>
                            <h2>24</h2>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-icon red"><i class="fas fa-exclamation-triangle"></i></div>
                        <div class="card-info">
                            <h3>Low Stock Alerts</h3>
                            <h2>3</h2>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-8">
                        <div class="panel">
                            <div class="panel-header">
                                <h3>Inventory Summary</h3>
                            </div>
                            <div class="panel-body">
                                <p>Welcome to the Management Dashboard!</p>
                                <p>As a member of the senior management team, you have access to all system features including:</p>
                                <ul>
                                    <li>Complete inventory management across all locations</li>
                                    <li>Analytics and reporting tools</li>
                                    <li>User management capabilities</li>
                                    <li>System configuration and settings</li>
                                </ul>
                                <p>Please use the navigation menu to access different sections of the system.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="panel">
                            <div class="panel-header">
                                <h3>Recent Activities</h3>
                            </div>
                            <div class="panel-body">
                                <div class="activity">
                                    <span class="activity-time">Today, 10:30 AM</span>
                                    <div class="activity-detail">
                                        <span class="activity-icon"><i class="fas fa-sync"></i></span>
                                        <div class="activity-info">
                                            <p><strong>Inventory Updated</strong></p>
                                            <p>Hong Kong Central - 50 Apples added</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="activity">
                                    <span class="activity-time">Yesterday, 3:45 PM</span>
                                    <div class="activity-detail">
                                        <span class="activity-icon"><i class="fas fa-user-plus"></i></span>
                                        <div class="activity-info">
                                            <p><strong>New User Added</strong></p>
                                            <p>John Smith - Shop Staff</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="activity">
                                    <span class="activity-time">Yesterday, 11:15 AM</span>
                                    <div class="activity-detail">
                                        <span class="activity-icon"><i class="fas fa-chart-line"></i></span>
                                        <div class="activity-info">
                                            <p><strong>Report Generated</strong></p>
                                            <p>Monthly Inventory Report - March 2025</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>