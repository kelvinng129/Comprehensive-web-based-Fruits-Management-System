<%-- 
    Document   : alertList
    Created on : 2025年4月19日, 下午12:43:19
    Author     : kelvin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Alert Management - Fruit Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
    <style>
        .list-card {
            box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            border: none;
        }
        .list-card .card-header {
            border-radius: 10px 10px 0 0;
        }
        .table-responsive {
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.05);
        }
        .alert-summary-card {
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .alert-summary-card:hover {
            transform: translateY(-5px);
            box-shadow: 0px 10px 20px rgba(0, 0, 0, 0.1);
        }
        .alert-type-icon {
            font-size: 2rem;
            margin-bottom: 10px;
        }
        .dashboard-filters {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.05);
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/shopHeader.jsp" />
    
    <div class="container-fluid mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Alert Management</h1>
            <div>
                <a href="${pageContext.request.contextPath}/shop/inventory?action=showAlertForm" class="btn btn-primary me-2">
                    <i class="fa fa-plus-circle me-1"></i> Create Alert
                </a>
                <a href="${pageContext.request.contextPath}/shop/inventory" class="btn btn-secondary">
                    <i class="fa fa-arrow-left me-1"></i> Dashboard
                </a>
            </div>
        </div>
        
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
        
        <!-- Alert Summary Cards -->
        <div class="row mb-4">
            <div class="col-md-3 mb-4">
                <div class="card alert-summary-card h-100 border-primary">
                    <div class="card-body text-center">
                        <i class="fa fa-bell alert-type-icon text-primary"></i>
                        <h5 class="card-title">Total Alerts</h5>
                        <h2 class="display-6">${alerts.size()}</h2>
                        <p class="card-text text-muted">Configured in the system</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-4">
                <div class="card alert-summary-card h-100 border-success">
                    <div class="card-body text-center">
                        <i class="fa fa-toggle-on alert-type-icon text-success"></i>
                        <h5 class="card-title">Active Alerts</h5>
                        <h2 class="display-6">
                            <jsp:useBean id="enabledCount" class="java.lang.Integer" value="0" />
                            <c:forEach var="alert" items="${alerts}">
                                <c:if test="${alert.enabled}">
                                    <jsp:setProperty name="enabledCount" property="value" value="${enabledCount + 1}" />
                                </c:if>
                            </c:forEach>
                            ${enabledCount}
                        </h2>
                        <p class="card-text text-muted">Enabled and monitoring</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-4">
                <div class="card alert-summary-card h-100 border-warning">
                    <div class="card-body text-center">
                        <i class="fa fa-triangle-exclamation alert-type-icon text-warning"></i>
                        <h5 class="card-title">Current Triggers</h5>
                        <h2 class="display-6">${activeAlertCount}</h2>
                        <p class="card-text text-muted">Alerts currently triggered</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-4">
                <div class="card alert-summary-card h-100 border-info">
                    <div class="card-body text-center">
                        <i class="fa fa-hourglass-half alert-type-icon text-info"></i>
                        <h5 class="card-title">Avg. Response Time</h5>
                        <h2 class="display-6">
                            <c:choose>
                                <c:when test="${avgResponseTime > 0}">
                                    <fmt:formatNumber value="${avgResponseTime}" pattern="#,##0" />
                                </c:when>
                                <c:otherwise>
                                    -
                                </c:otherwise>
                            </c:choose>
                        </h2>
                        <p class="card-text text-muted">Minutes to resolve</p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Filters Section -->
        <div class="dashboard-filters">
            <form action="${pageContext.request.contextPath}/shop/inventory" method="get" id="filterForm">
                <input type="hidden" name="action" value="listAlerts">
                <div class="row align-items-end">
                    <div class="col-md-3 mb-3 mb-md-0">
                        <label for="typeFilter" class="form-label">Filter by Type</label>
                        <select class="form-select" id="typeFilter" name="alertType">
                            <option value="">All Types</option>
                            <option value="lowStock" ${param.alertType == 'lowStock' ? 'selected' : ''}>Low Stock</option>
                            <option value="expirySoon" ${param.alertType == 'expirySoon' ? 'selected' : ''}>Expiry Soon</option>
                            <option value="highStock" ${param.alertType == 'highStock' ? 'selected' : ''}>High Stock</option>
                        </select>
                    </div>
                    <div class="col-md-3 mb-3 mb-md-0">
                        <label for="statusFilter" class="form-label">Filter by Status</label>
                        <select class="form-select" id="statusFilter" name="status">
                            <option value="">All Status</option>
                            <option value="enabled" ${param.status == 'enabled' ? 'selected' : ''}>Enabled</option>
                            <option value="disabled" ${param.status == 'disabled' ? 'selected' : ''}>Disabled</option>
                        </select>
                    </div>
                    <div class="col-md-4 mb-3 mb-md-0">
                        <label for="fruitFilter" class="form-label">Filter by Fruit</label>
                        <select class="form-select" id="fruitFilter" name="fruitId">
                            <option value="">All Fruits</option>
                            <option value="0" ${param.fruitId == '0' ? 'selected' : ''}>Global Alerts (All Fruits)</option>
                            <c:forEach var="fruit" items="${fruits}">
                                <option value="${fruit.fruitId}" ${param.fruitId == fruit.fruitId ? 'selected' : ''}>
                                    ${fruit.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2 mb-3 mb-md-0 d-grid">
                        <button type="submit" class="btn btn-primary">
                            <i class="fa fa-filter me-2"></i> Apply Filters
                        </button>
                    </div>
                </div>
            </form>
        </div>
        
        <!-- Alerts Table -->
        <div class="card list-card mb-4">
            <div class="card-header bg-light">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="fa fa-bell me-2"></i> Alert List</h5>
                    <c:if test="${not empty param.alertType || not empty param.status || not empty param.fruitId}">
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=listAlerts" class="btn btn-sm btn-outline-secondary">
                            <i class="fa fa-xmark me-1"></i> Clear Filters
                        </a>
                    </c:if>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="alertsTable" class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Type</th>
                                <th>Applies To</th>
                                <th>Threshold</th>
                                <th>Status</th>
                                <th>Last Triggered</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="alert" items="${alerts}">
                                <tr>
                                    <td>${alert.alertName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${alert.alertType == 'lowStock'}">
                                                <span class="badge bg-warning text-dark">
                                                    <i class="fa fa-triangle-exclamation me-1"></i> Low Stock
                                                </span>
                                            </c:when>
                                            <c:when test="${alert.alertType == 'expirySoon'}">
                                                <span class="badge bg-danger">
                                                    <i class="fa fa-calendar-xmark me-1"></i> Expiry Soon
                                                </span>
                                            </c:when>
                                            <c:when test="${alert.alertType == 'highStock'}">
                                                <span class="badge bg-success">
                                                    <i class="fa fa-chart-line me-1"></i> High Stock
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">
                                                    <i class="fa fa-bell me-1"></i> Other
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${alert.fruitId == 0}">
                                                <span class="badge bg-info">All Fruits</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-primary">${alert.fruitName}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${alert.alertType == 'lowStock'}">
                                                ≤ ${alert.threshold} units
                                            </c:when>
                                            <c:when test="${alert.alertType == 'expirySoon'}">
                                                ≤ ${alert.threshold} days
                                            </c:when>
                                            <c:when test="${alert.alertType == 'highStock'}">
                                                ≥ ${alert.threshold} units
                                            </c:when>
                                            <c:otherwise>
                                                ${alert.threshold}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${alert.enabled}">
                                                <span class="badge bg-success">Enabled</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger">Disabled</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty alert.lastTriggered}">
                                                <fmt:formatDate value="${alert.lastTriggered}" pattern="yyyy-MM-dd HH:mm" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Never</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/shop/inventory?action=viewAlert&id=${alert.alertId}" class="btn btn-sm btn-primary">
                                            <i class="fa fa-eye"></i> View
                                        </a>
                                        <a href="${pageContext.request.contextPath}/shop/inventory?action=editAlert&id=${alert.alertId}" class="btn btn-sm btn-info">
                                            <i class="fa fa-edit"></i> Edit
                                        </a>
                                        <form action="${pageContext.request.contextPath}/shop/inventory" method="post" class="d-inline">
                                            <input type="hidden" name="action" value="${alert.enabled ? 'disableAlert' : 'enableAlert'}">
                                            <input type="hidden" name="alertId" value="${alert.alertId}">
                                            <button type="submit" class="btn btn-sm btn-${alert.enabled ? 'warning' : 'success'}">
                                                <i class="fa fa-${alert.enabled ? 'toggle-off' : 'toggle-on'}"></i>
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/shop/inventory" method="post" class="d-inline">
                                            <input type="hidden" name="action" value="deleteAlert">
                                            <input type="hidden" name="alertId" value="${alert.alertId}">
                                            <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this alert?');">
                                                <i class="fa fa-trash-can"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        
        <!-- Active Alerts -->
        <div class="card list-card mb-4">
            <div class="card-header bg-warning text-dark">
                <h5 class="mb-0"><i class="fa fa-bell-on me-2"></i> Currently Active Alerts</h5>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty activeAlerts}">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Alert</th>
                                        <th>Fruit</th>
                                        <th>Triggered</th>
                                        <th>Status</th>
                                        <th>Message</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="activeAlert" items="${activeAlerts}">
                                        <tr>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/shop/inventory?action=viewAlert&id=${activeAlert.alertId}">
                                                    ${activeAlert.alertName}
                                                </a>
                                            </td>
                                            <td>${activeAlert.fruitName != null ? activeAlert.fruitName : 'All Fruits'}</td>
                                            <td><fmt:formatDate value="${activeAlert.triggeredDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                            <td>
                                                <span class="badge bg-${activeAlert.statusColor}">${activeAlert.formattedStatus}</span>
                                            </td>
                                            <td>${activeAlert.alertMessage}</td>
                                            <td>
                                                <c:if test="${activeAlert.status == 'triggered'}">
                                                    <form action="${pageContext.request.contextPath}/shop/inventory" method="post" class="d-inline">
                                                        <input type="hidden" name="action" value="acknowledgeAlert">
                                                        <input type="hidden" name="logId" value="${activeAlert.logId}">
                                                        <button type="submit" class="btn btn-sm btn-outline-primary">
                                                            <i class="fa fa-eye"></i> Acknowledge
                                                        </button>
                                                    </form>
                                                </c:if>
                                                <form action="${pageContext.request.contextPath}/shop/inventory" method="post" class="d-inline">
                                                    <input type="hidden" name="action" value="resolveAlert">
                                                    <input type="hidden" name="logId" value="${activeAlert.logId}">
                                                    <button type="submit" class="btn btn-sm btn-outline-success">
                                                        <i class="fa fa-check"></i> Resolve
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-success">
                            <i class="fa fa-check-circle me-2"></i> No active alerts at this time. All systems normal.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="card mb-4">
            <div class="card-header bg-dark text-white">
                <h5 class="mb-0"><i class="fa fa-bolt me-2"></i> Quick Actions</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3 mb-3">
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=showAlertForm" class="btn btn-outline-primary d-block h-100 d-flex flex-column justify-content-center align-items-center py-3">
                            <i class="fa fa-plus-circle fa-2x mb-2"></i>
                            Create New Alert
                        </a>
                    </div>
                    <div class="col-md-3 mb-3">
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=listAlertLogs" class="btn btn-outline-info d-block h-100 d-flex flex-column justify-content-center align-items-center py-3">
                            <i class="fa fa-history fa-2x mb-2"></i>
                            View Alert History
                        </a>
                    </div>
                    <div class="col-md-3 mb-3">
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=list" class="btn btn-outline-success d-block h-100 d-flex flex-column justify-content-center align-items-center py-3">
                            <i class="fa fa-boxes-stacked fa-2x mb-2"></i>
                            Manage Inventory
                        </a>
                    </div>
                    <div class="col-md-3 mb-3">
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=listBatches" class="btn btn-outline-warning d-block h-100 d-flex flex-column justify-content-center align-items-center py-3">
                            <i class="fa fa-box fa-2x mb-2"></i>
                            Manage Batches
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#alertsTable').DataTable({
                "pageLength": 10,
                "order": [[ 5, "desc" ]], // Sort by last triggered
                "language": {
                    "emptyTable": "No alerts found"
                }
            });
            
            // Auto-submit form when filters change
            $('#typeFilter, #statusFilter, #fruitFilter').change(function() {
                $('#filterForm').submit();
            });
            
            // Make entire card clickable
            $('.alert-summary-card').click(function() {
                // You can add navigation here if needed
            });
        });
    </script>
</body>
</html>