<%-- 
    Document   : dashboard.jsp
    Created on : 2025年4月19日, 上午5:52:59
    Author     : kelvin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="ict.bean.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Warehouse Dashboard - AIB System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="../css/dashboard.css">
</head>
<body>
    <% 
    User user = (User) session.getAttribute("user");
    if (user == null || !"warehouse_staff".equals(user.getRole())) {
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
                    <p>Warehouse Staff</p>
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
            </ul>
        </div>
    </li>
    
    <li><a href="inventory.jsp"><i class="fas fa-warehouse"></i> Warehouse Inventory</a></li>
    <li><a href="shipping.jsp"><i class="fas fa-truck"></i> Shipping</a></li>
    <li><a href="receiving.jsp"><i class="fas fa-dolly"></i> Receiving</a></li>
    <li><a href="profile.jsp"><i class="fas fa-user"></i> My Profile</a></li>
    <li><a href="../LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
</ul>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <div class="header">
                <h1>Warehouse Staff Dashboard</h1>
                <div class="header-right">
                    <span><i class="fas fa-bell"></i></span>
                    <span><i class="fas fa-envelope"></i></span>
                </div>
            </div>
            
            <div class="content">
                <div class="stats-cards">
                    <div class="card">
                        <div class="card-icon blue"><i class="fas fa-boxes"></i></div>
                        <div class="card-info">
                            <h3>Total Inventory</h3>
                            <h2>1,245 kg</h2>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-icon green"><i class="fas fa-truck-loading"></i></div>
                        <div class="card-info">
                            <h3>Pending Shipments</h3>
                            <h2>5</h2>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-icon orange"><i class="fas fa-dolly-flatbed"></i></div>
                        <div class="card-info">
                            <h3>Expected Deliveries</h3>
                            <h2>3</h2>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-icon red"><i class="fas fa-exclamation-triangle"></i></div>
                        <div class="card-info">
                            <h3>Low Stock Items</h3>
                            <h2>4</h2>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-8">
                        <div class="panel">
                            <div class="panel-header">
                                <h3>Warehouse Operations</h3>
                            </div>
                            <div class="panel-body">
                                <p>Welcome to the Warehouse Dashboard!</p>
                                <p>As a warehouse staff member, you can manage inventory, process shipments, and handle receiving operations.</p>
                                <p>Quick Actions:</p>
                                <div class="quick-actions">
                                    <a href="inventory.jsp" class="btn btn-primary"><i class="fas fa-search"></i> Check Inventory</a>
                                    <a href="shipping.jsp" class="btn btn-success"><i class="fas fa-truck"></i> Process Shipment</a>
                                    <a href="receiving.jsp" class="btn btn-info"><i class="fas fa-dolly"></i> Receive Delivery</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="panel">
                            <div class="panel-header">
                                <h3>Pending Tasks</h3>
                            </div>
                            <div class="panel-body">
                                <div class="task">
                                    <div class="task-header">
                                        <h4>Shipment #SH-2025-042</h4>
                                        <span class="badge badge-warning">Pending</span>
                                    </div>
                                    <p>Destination: Hong Kong Central</p>
                                    <p>Scheduled: Today, 2:00 PM</p>
                                    <a href="shipping.jsp?id=SH-2025-042" class="btn btn-sm btn-primary">Process</a>
                                </div>
                                <div class="task">
                                    <div class="task-header">
                                        <h4>Delivery #DEL-2025-037</h4>
                                        <span class="badge badge-info">Expected</span>
                                    </div>
                                    <p>From: Australian Farms Inc.</p>
                                    <p>Expected: Today, 4:30 PM</p>
                                    <a href="receiving.jsp?id=DEL-2025-037" class="btn btn-sm btn-primary">Details</a>
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
