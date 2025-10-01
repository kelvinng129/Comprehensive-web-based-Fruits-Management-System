<%-- 
    Document   : dashboard.jsp
    Created on : 2025年4月19日, 上午5:52:31
    Author     : kelvin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="ict.bean.User" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Shop Dashboard - AIB System</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link rel="stylesheet" href="../css/dashboard.css">
    </head>
    <body>
        <%
            User user = (User) session.getAttribute("user");
            if (user == null || !"shop_staff".equals(user.getRole())) {
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
                        <h3><%= user.getFullName()%></h3>
                        <p>Shop Staff</p>
                    </div>
                </div>
                <ul class="sidebar-menu">
                    <li class="active"><a href="dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>

                    <!-- Add Fruit Management Section -->
                    <li class="sidebar-dropdown">
                        <a href="#"><i class="fas fa-apple-alt"></i> Fruit Management</a>
                        <div class="sidebar-submenu">
                            <ul>
                                <li><a href="${pageContext.request.contextPath}/fruit?action=list">View Fruits</a></li>
                                <li><a href="${pageContext.request.contextPath}/inventory?action=list">Check Inventory</a></li>
                            </ul>
                        </div>
                    </li>

                    <li><a href="inventory.jsp"><i class="fas fa-warehouse"></i> Shop Inventory</a></li>
                    <li><a href="orders.jsp"><i class="fas fa-shopping-cart"></i> Orders</a></li>
                    <li><a href="profile.jsp"><i class="fas fa-user"></i> My Profile</a></li>
                    <li><a href="../LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <div class="header">
                    <h1>Shop Staff Dashboard</h1>
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
                                <h3>Fruit Types</h3>
                                <h2>12</h2>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-icon green"><i class="fas fa-shopping-cart"></i></div>
                            <div class="card-info">
                                <h3>Today's Sales</h3>
                                <h2>23</h2>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-icon red"><i class="fas fa-exclamation-triangle"></i></div>
                            <div class="card-info">
                                <h3>Low Stock Items</h3>
                                <h2>2</h2>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-8">
                            <div class="panel">
                                <div class="panel-header">
                                    <h3>Shop Inventory</h3>
                                </div>
                                <div class="panel-body">
                                    <p>Welcome to the Shop Staff Dashboard!</p>
                                    <p>As a shop staff member, you can manage inventory for your shop location, process orders, and update stock levels.</p>
                                    <p>Quick Actions:</p>
                                    <div class="quick-actions">
                                        <a href="inventory.jsp" class="btn btn-primary"><i class="fas fa-search"></i> View Inventory</a>
                                        <a href="orders.jsp" class="btn btn-success"><i class="fas fa-plus"></i> New Order</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="panel">
                                <div class="panel-header">
                                    <h3>Low Stock Alert</h3>
                                </div>
                                <div class="panel-body">
                                    <div class="alert alert-warning">
                                        <i class="fas fa-exclamation-circle"></i>
                                        <div>
                                            <strong>Apples</strong>
                                            <p>Current stock: 5 kg (Below minimum)</p>
                                        </div>
                                    </div>
                                    <div class="alert alert-warning">
                                        <i class="fas fa-exclamation-circle"></i>
                                        <div>
                                            <strong>Bananas</strong>
                                            <p>Current stock: 3 kg (Below minimum)</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Reservations Summary Card -->
        <div class="col-md-6">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Recent Reservations</h5>
                    <a href="${pageContext.request.contextPath}/reservation?action=list" class="btn btn-sm btn-primary">View All</a>
                </div>
                <div class="card-body">
                    <c:if test="${not empty recentReservations}">
                        <div class="table-responsive">
                            <table class="table table-sm table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Request Date</th>
                                        <th>Delivery Date</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="reservation" items="${recentReservations}" varStatus="status">
                                    <c:if test="${status.index < 5}">
                                        <tr>
                                            <td><a href="${pageContext.request.contextPath}/reservation?action=view&id=${reservation.reservationID}">#${reservation.reservationID}</a></td>
                                            <td><fmt:formatDate value="${reservation.requestDate}" pattern="yyyy-MM-dd" /></td>
                                        <td><fmt:formatDate value="${reservation.deliveryDate}" pattern="yyyy-MM-dd" /></td>
                                        <td>
                                            <span class="badge 
                                                  ${reservation.status == 'pending' ? 'badge-warning' : 
                                                    reservation.status == 'approved' ? 'badge-success' : 
                                                    reservation.status == 'rejected' ? 'badge-danger' : 
                                                    'badge-info'}">
                                                      ${reservation.formattedStatus}
                                                  </span>
                                            </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                        <c:if test="${empty recentReservations}">
                            <div class="text-center py-4">
                                <i class="fas fa-clipboard-list fa-3x text-muted mb-3"></i>
                                <p class="text-muted">No recent reservations found</p>
                                <a href="${pageContext.request.contextPath}/reservation?action=showCreateForm" class="btn btn-sm btn-primary">Create Reservation</a>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>


            <!-- Borrowing Summary Card -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Borrowing Summary</h5>
                        <a href="${pageContext.request.contextPath}/borrowing?action=list" class="btn btn-sm btn-primary">View All</a>
                    </div>
                    <div class="card-body p-0">
                        <div class="row m-0">
                            <div class="col-6 p-3 border-right">
                                <h6 class="text-muted">Pending Requests</h6>
                                <h2 class="mb-0">${pendingBorrows}</h2>
                            </div>
                            <div class="col-6 p-3">
                                <h6 class="text-muted">Currently Borrowed</h6>
                                <h2 class="mb-0">${activeBorrows}</h2>
                            </div>
                        </div>
                        <div class="row m-0 border-top">
                            <div class="col-6 p-3 border-right">
                                <h6 class="text-muted">Lending Requests</h6>
                                <h2 class="mb-0">${pendingLendings}</h2>
                            </div>
                            <div class="col-6 p-3 ${overdueBorrows > 0 ? 'bg-danger-light' : ''}">
                                <h6 class="text-muted">Overdue Items</h6>
                                <h2 class="mb-0 ${overdueBorrows > 0 ? 'text-danger' : ''}">${overdueBorrows}</h2>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </body>
    </html>