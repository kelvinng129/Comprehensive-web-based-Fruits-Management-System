<%-- 
    Document   : shopHeader.jsp
    Created on : 2025年4月19日, 下午1:15:41
    Author     : kelvin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="ict.bean.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String currentRole = currentUser != null ? currentUser.getRole() : "";
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.title} - Fruit Shop System</title>
    <!-- Common CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= contextPath %>/css/main.css">
    <!-- Page specific CSS if needed -->
    <% if (request.getParameter("pageCss") != null) { %>
    <link rel="stylesheet" href="<%= contextPath %>/css/<%= request.getParameter("pageCss") %>.css">
    <% } %>
</head>
<body>
    <!-- Top Navigation Bar -->
    <header class="top-header bg-dark">
        <div class="container">
            <nav class="main-nav">
                <div class="brand">
                    <a href="<%= contextPath %>/index.jsp">
                        <i class="fas fa-apple-alt text-primary mr-2"></i>
                        <span>Fruit Shop System</span>
                    </a>
                </div>
                
                <ul class="nav-menu">
                    <li><a href="<%= contextPath %>/index.jsp">Home</a></li>
                    
                    <!-- Shop Staff Navigation -->
                    <% if (currentRole.equals("shop_staff")) { %>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle">Reservations <i class="fas fa-chevron-down ml-1"></i></a>
                        <ul class="dropdown-menu">
                            <li><a href="<%= contextPath %>/shop/batchList.jsp">View All Batches</a></li>
                            <li><a href="<%= contextPath %>/shop/batchForm.jsp">Create New Batch</a></li>
                            <li><a href="<%= contextPath %>/shop/batchReservationForm.jsp">Batch Reservation</a></li>
                            <li><a href="<%= contextPath %>/shop/reservation.jsp">View Reservations</a></li>
                        </ul>
                    </li>
                    
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle">Borrowing <i class="fas fa-chevron-down ml-1"></i></a>
                        <ul class="dropdown-menu">
                            <li><a href="<%= contextPath %>/shop/borrowList.jsp">View Borrowings</a></li>
                            <li><a href="<%= contextPath %>/shop/borrowForm.jsp">New Borrowing</a></li>
                            <li><a href="<%= contextPath %>/shop/returnForm.jsp">Return Items</a></li>
                        </ul>
                    </li>
                    
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle">Inventory <i class="fas fa-chevron-down ml-1"></i></a>
                        <ul class="dropdown-menu">
                            <li><a href="<%= contextPath %>/shop/inventory.jsp">Shop Inventory</a></li>
                            <li><a href="<%= contextPath %>/shop/inventoryAdjust.jsp">Adjust Inventory</a></li>
                            <li><a href="<%= contextPath %>/shop/alertList.jsp">Inventory Alerts</a></li>
                            <li><a href="<%= contextPath %>/shop/alertForm.jsp">Create Alert</a></li>
                        </ul>
                    </li>
                    <% } %>
                    
                    <!-- Warehouse Staff Navigation -->
                    <% if (currentRole.equals("warehouse_staff")) { %>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle">Warehouse <i class="fas fa-chevron-down ml-1"></i></a>
                        <ul class="dropdown-menu">
                            <li><a href="<%= contextPath %>/warehouse/inventory.jsp">Warehouse Inventory</a></li>
                            <li><a href="<%= contextPath %>/warehouse/delivery.jsp">Deliveries</a></li>
                            <li><a href="<%= contextPath %>/warehouse/approvals.jsp">Approval Requests</a></li>
                        </ul>
                    </li>
                    <% } %>
                    
                    <!-- Senior Management Navigation -->
                    <% if (currentRole.equals("senior_management")) { %>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle">Management <i class="fas fa-chevron-down ml-1"></i></a>
                        <ul class="dropdown-menu">
                            <li><a href="<%= contextPath %>/management/dashboard.jsp">Dashboard</a></li>
                            <li><a href="<%= contextPath %>/management/reports.jsp">Reports</a></li>
                            <li><a href="<%= contextPath %>/management/userList.jsp">User Management</a></li>
                            <li><a href="<%= contextPath %>/management/settings.jsp">System Settings</a></li>
                        </ul>
                    </li>
                    <% } %>
                    
                    <!-- Common Navigation Items -->
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle">Fruits <i class="fas fa-chevron-down ml-1"></i></a>
                        <ul class="dropdown-menu">
                            <li><a href="<%= contextPath %>/fruit?action=list">View All Fruits</a></li>
                            <% if (currentRole.equals("senior_management") || currentRole.equals("warehouse_staff")) { %>
                            <li><a href="<%= contextPath %>/fruit?action=showAddForm">Add New Fruit</a></li>
                            <% } %>
                        </ul>
                    </li>
                </ul>
                
                <div class="nav-right">
                    <% if (currentUser != null) { %>
                    <div class="user-dropdown dropdown">
                        <a href="#" class="dropdown-toggle">
                            <i class="fas fa-user-circle mr-1"></i>
                            <%= currentUser.getFullName() %> <i class="fas fa-chevron-down ml-1"></i>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-right">
                            <li><a href="<%= contextPath %>/profile.jsp"><i class="fas fa-user mr-2"></i> My Profile</a></li>
                            <li><a href="<%= contextPath %>/settings.jsp"><i class="fas fa-cog mr-2"></i> Settings</a></li>
                            <li class="divider"></li>
                            <li><a href="<%= contextPath %>/LogoutServlet"><i class="fas fa-sign-out-alt mr-2"></i> Logout</a></li>
                        </ul>
                    </div>
                    <% } else { %>
                    <div class="auth-buttons">
                        <a href="<%= contextPath %>/login.jsp" class="btn btn-outline-primary btn-sm mr-2">Login</a>
                        <a href="<%= contextPath %>/register.jsp" class="btn btn-primary btn-sm">Register</a>
                    </div>
                    <% } %>
                </div>
                
                <!-- Mobile menu toggle -->
                <div class="menu-toggle">
                    <i class="fas fa-bars"></i>
                </div>
            </nav>
        </div>
    </header>
    
    <!-- Main Content Container -->
    <main class="main-content">
        <% if (request.getParameter("showBreadcrumb") != null && request.getParameter("showBreadcrumb").equals("true")) { %>
        <!-- Breadcrumb -->
        <div class="breadcrumb-container bg-light">
            <div class="container">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="<%= contextPath %>/index.jsp">Home</a></li>
                        <% if (request.getParameter("breadcrumbParent") != null) { %>
                        <li class="breadcrumb-item"><a href="<%= contextPath %>/<%= request.getParameter("breadcrumbParentUrl") %>"><%= request.getParameter("breadcrumbParent") %></a></li>
                        <% } %>
                        <li class="breadcrumb-item active" aria-current="page">${param.breadcrumbActive}</li>
                    </ol>
                </nav>
            </div>
        </div>
        <% } %>