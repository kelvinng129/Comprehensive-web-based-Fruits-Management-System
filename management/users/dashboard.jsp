<%-- 
    Document   : dashboard
    Created on : 2025年4月20日, 上午12:12:50
    Author     : kelvin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user-management.css">
</head>
<body>
    <jsp:include page="../includes/header.jsp" />
    
    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-md-2">
                <jsp:include page="../includes/sidebar.jsp" />
            </div>
            
            <div class="col-md-10">
                <div class="content-wrapper">
                    <div class="content-header">
                        <div class="container-fluid">
                            <div class="row mb-2">
                                <div class="col-sm-6">
                                    <h1 class="m-0">User Dashboard</h1>
                                </div>
                                <div class="col-sm-6">
                                    <ol class="breadcrumb float-sm-end">
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/management/dashboard">Home</a></li>
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/management/users">User Management</a></li>
                                        <li class="breadcrumb-item active">Dashboard</li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="content">
                        <div class="container-fluid">
                            <!-- User Stats Overview -->
                            <div class="row">
                                <div class="col-lg-3 col-6">
                                    <div class="small-box bg-info">
                                        <div class="inner">
                                            <h3>${roleCount['shop_staff'] + roleCount['warehouse_staff'] + roleCount['senior_management']}</h3>
                                            <p>Total Users</p>
                                        </div>
                                        <div class="icon">
                                            <i class="fas fa-users"></i>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/management/users" class="small-box-footer">
                                            More info <i class="fas fa-arrow-circle-right"></i>
                                        </a>
                                    </div>
                                </div>
                                
                                <div class="col-lg-3 col-6">
                                    <div class="small-box bg-success">
                                        <div class="inner">
                                            <h3>${statusCount['active'] != null ? statusCount['active'] : 0}</h3>
                                            <p>Active Users</p>
                                        </div>
                                        <div class="icon">
                                            <i class="fas fa-user-check"></i>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/management/users?status=active" class="small-box-footer">
                                            More info <i class="fas fa-arrow-circle-right"></i>
                                        </a>
                                    </div>
                                </div>
                                
                                <div class="col-lg-3 col-6">
                                    <div class="small-box bg-warning">
                                        <div class="inner">
                                            <h3>${activityMetrics['activeLast7Days'] != null ? activityMetrics['activeLast7Days'] : 0}</h3>
                                            <p>Active Last 7 Days</p>
                                        </div>
                                        <div class="icon">
                                            <i class="fas fa-sign-in-alt"></i>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/management/users" class="small-box-footer">
                                            More info <i class="fas fa-arrow-circle-right"></i>
                                        </a>
                                    </div>
                                </div>
                                
                                <div class="col-lg-3 col-6">
                                    <div class="small-box bg-danger">
                                        <div class="inner">
                                            <h3>${statusCount['inactive'] != null ? statusCount['inactive'] : 0}</h3>
                                            <p>Inactive Users</p>
                                        </div>
                                        <div class="icon">
                                            <i class="fas fa-user-times"></i>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/management/users?status=inactive" class="small-box-footer">
                                            More info <i class="fas fa-arrow-circle-right"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- User Role Distribution & New User Trends -->
                            <div class="row">
                                <!-- User Role Distribution -->
                                <div class="col-md-6">
                                    <div class="card card-primary">
                                        <div class="card-header">
                                            <h3 class="card-title">
                                                <i class="fas fa-user-tag mr-1"></i>
                                                User Role Distribution
                                            </h3>
                                        </div>
                                        <div class="card-body">
                                            <div class="chart-container">
                                                <canvas id="roleDistributionChart" style="min-height: 250px; height: 250px; max-height: 250px; max-width: 100%;"></canvas>
                                            </div>
                                        </div>
                                        <div class="card-footer bg-light p-0">
                                            <ul class="nav nav-pills flex-column">
                                                <li class="nav-item">
                                                    <a href="${pageContext.request.contextPath}/management/users?role=shop_staff" class="nav-link">
                                                        Shop Staff
                                                        <span class="float-end text-primary">
                                                            <i class="fas fa-store"></i> ${roleCount['shop_staff'] != null ? roleCount['shop_staff'] : 0}
                                                        </span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="${pageContext.request.contextPath}/management/users?role=warehouse_staff" class="nav-link">
                                                        Warehouse Staff
                                                        <span class="float-end text-danger">
                                                            <i class="fas fa-warehouse"></i> ${roleCount['warehouse_staff'] != null ? roleCount['warehouse_staff'] : 0}
                                                        </span>
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a href="${pageContext.request.contextPath}/management/users?role=senior_management" class="nav-link">
                                                        Senior Management
                                                        <span class="float-end text-warning">
                                                            <i class="fas fa-crown"></i> ${roleCount['senior_management'] != null ? roleCount['senior_management'] : 0}
                                                        </span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- New User Trends -->
                                <div class="col-md-6">
                                    <div class="card card-success">
                                        <div class="card-header">
                                            <h3 class="card-title">
                                                <i class="fas fa-user-plus mr-1"></i>
                                                New User Trends
                                            </h3>
                                        </div>
                                        <div class="card-body">
                                            <div class="chart-container">
                                                <canvas id="newUserTrendsChart" style="min-height: 250px; height: 250px; max-height: 250px; max-width: 100%;"></canvas>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- User Activity & Status Distribution -->
                            <div class="row">
                                <!-- User Activity -->
                                <div class="col-md-6">
                                    <div class="card card-info">
                                        <div class="card-header">
                                            <h3 class="card-title">
                                                <i class="fas fa-chart-line mr-1"></i>
                                                User Activity
                                            </h3>
                                        </div>
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="info-box bg-gradient-info">
                                                        <span class="info-box-icon"><i class="fas fa-calendar-day"></i></span>
                                                        <div class="info-box-content">
                                                            <span class="info-box-text">Active Last 7 Days</span>
                                                            <span class="info-box-number">${activityMetrics['activeLast7Days'] != null ? activityMetrics['activeLast7Days'] : 0}</span>
                                                            <div class="progress">
                                                                <div class="progress-bar" style="width: ${activityMetrics['activeLast7Days'] * 100 / (roleCount['shop_staff'] + roleCount['warehouse_staff'] + roleCount['senior_management'])}%"></div>
                                                            </div>
                                                            <span class="progress-description">
                                                                ${Math.round(activityMetrics['activeLast7Days'] * 100 / (roleCount['shop_staff'] + roleCount['warehouse_staff'] + roleCount['senior_management']))}% of all users
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <div class="col-md-6">
                                                    <div class="info-box bg-gradient-success">
                                                        <span class="info-box-icon"><i class="fas fa-calendar-week"></i></span>
                                                        <div class="info-box-content">
                                                            <span class="info-box-text">Active Last 30 Days</span>
                                                            <span class="info-box-number">${activityMetrics['activeLast30Days'] != null ? activityMetrics['activeLast30Days'] : 0}</span>
                                                            <div class="progress">
                                                                <div class="progress-bar" style="width: ${activityMetrics['activeLast30Days'] * 100 / (roleCount['shop_staff'] + roleCount['warehouse_staff'] + roleCount['senior_management'])}%"></div>
                                                            </div>
                                                            <span class="progress-description">
                                                                ${Math.round(activityMetrics['activeLast30Days'] * 100 / (roleCount['shop_staff'] + roleCount['warehouse_staff'] + roleCount['senior_management']))}% of all users
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="row mt-3">
                                                <div class="col-md-12">
                                                    <div class="info-box bg-gradient-danger">
                                                        <span class="info-box-icon"><i class="fas fa-user-slash"></i></span>
                                                        <div class="info-box-content">
                                                            <span class="info-box-text">Never Logged In</span>
                                                            <span class="info-box-number">${activityMetrics['neverLoggedIn'] != null ? activityMetrics['neverLoggedIn'] : 0}</span>
                                                            <div class="progress">
                                                                <div class="progress-bar" style="width: ${activityMetrics['neverLoggedIn'] * 100 / (roleCount['shop_staff'] + roleCount['warehouse_staff'] + roleCount['senior_management'])}%"></div>
                                                            </div>
                                                            <span class="progress-description">
                                                                ${Math.round(activityMetrics['neverLoggedIn'] * 100 / (roleCount['shop_staff'] + roleCount['warehouse_staff'] + roleCount['senior_management']))}% of all users
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- User Status Distribution -->
                                <div class="col-md-6">
                                    <div class="card card-warning">
                                        <div class="card-header">
                                            <h3 class="card-title">
                                                <i class="fas fa-toggle-on mr-1"></i>
                                                User Status Distribution
                                            </h3>
                                        </div>
                                        <div class="card-body">
                                            <div class="chart-container">
                                                <canvas id="statusDistributionChart" style="min-height: 250px; height: 250px; max-height: 250px; max-width: 100%;"></canvas>
                                            </div>
                                        </div>
                                        <div class="card-footer bg-light">
                                            <div class="row">
                                                <div class="col-sm-6">
                                                    <div class="text-center">
                                                        <span class="text-success">
                                                            <i class="fas fa-user-check fa-2x"></i>
                                                        </span>
                                                        <h5 class="mt-2">${statusCount['active'] != null ? statusCount['active'] : 0} Active</h5>
                                                    </div>
                                                </div>
                                                <div class="col-sm-6">
                                                    <div class="text-center">
                                                        <span class="text-danger">
                                                            <i class="fas fa-user-times fa-2x"></i>
                                                        </span>
                                                        <h5 class="mt-2">${statusCount['inactive'] != null ? statusCount['inactive'] : 0} Inactive</h5>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- User Actions -->
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title">
                                                <i class="fas fa-cogs mr-1"></i>
                                                User Management Actions
                                            </h3>
                                        </div>
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-3">
                                                    <a href="${pageContext.request.contextPath}/management/users/create" class="btn btn-block btn-success btn-lg">
                                                        <i class="fas fa-user-plus mr-2"></i> Add New User
                                                    </a>
                                                </div>
                                                <div class="col-md-3">
                                                    <a href="${pageContext.request.contextPath}/management/users?status=inactive" class="btn btn-block btn-warning btn-lg">
                                                        <i class="fas fa-user-check mr-2"></i> View Inactive Users
                                                    </a>
                                                </div>
                                                <div class="col-md-3">
                                                    <a href="${pageContext.request.contextPath}/management/users" class="btn btn-block btn-info btn-lg">
                                                        <i class="fas fa-users mr-2"></i> View All Users
                                                    </a>
                                                </div>
                                                <div class="col-md-3">
                                                    <a href="${pageContext.request.contextPath}/management/reports/dashboard" class="btn btn-block btn-primary btn-lg">
                                                        <i class="fas fa-chart-bar mr-2"></i> System Reports
                                                    </a>
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
        </div>
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Role Distribution Chart
            const roleCtx = document.getElementById('roleDistributionChart').getContext('2d');
            const roleChart = new Chart(roleCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Shop Staff', 'Warehouse Staff', 'Senior Management'],
                    datasets: [{
                        data: [
                            ${roleCount['shop_staff'] != null ? roleCount['shop_staff'] : 0},
                            ${roleCount['warehouse_staff'] != null ? roleCount['warehouse_staff'] : 0},
                            ${roleCount['senior_management'] != null ? roleCount['senior_management'] : 0}
                        ],
                        backgroundColor: [
                            '#3b7ddd',
                            '#dc3545',
                            '#ffc107'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
            
            // New User Trends Chart
            const newUserCtx = document.getElementById('newUserTrendsChart').getContext('2d');
            const newUserChart = new Chart(newUserCtx, {
                type: 'line',
                data: {
                    labels: [
                        <c:forEach var="entry" items="${newUsersCount}" varStatus="status">
                            '${entry.key}'${!status.last ? ',' : ''}
                        </c:forEach>
                    ],
                    datasets: [{
                        label: 'New Users',
                        data: [
                            <c:forEach var="entry" items="${newUsersCount}" varStatus="status">
                                ${entry.value}${!status.last ? ',' : ''}
                            </c:forEach>
                        ],
                        fill: false,
                        borderColor: '#28a745',
                        tension: 0.1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                stepSize: 1
                            }
                        }
                    }
                }
            });
            
            // Status Distribution Chart
            const statusCtx = document.getElementById('statusDistributionChart').getContext('2d');
            const statusChart = new Chart(statusCtx, {
                type: 'pie',
                data: {
                    labels: ['Active', 'Inactive'],
                    datasets: [{
                        data: [
                            ${statusCount['active'] != null ? statusCount['active'] : 0},
                            ${statusCount['inactive'] != null ? statusCount['inactive'] : 0}
                        ],
                        backgroundColor: [
                            '#28a745',
                            '#dc3545'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>