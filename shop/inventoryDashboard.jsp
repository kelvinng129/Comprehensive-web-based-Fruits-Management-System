<%-- 
    Document   : inventoryDashboard
    Created on : 2025年4月19日, 下午12:10:16
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
    <title>Inventory Dashboard - Fruit Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .card-counter {
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 20px;
        }
        .card-counter:hover {
            transform: translateY(-4px);
            box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.1);
        }
        .card-counter .count-icon {
            font-size: 3rem;
            opacity: 0.7;
        }
        .card-counter .count-title {
            margin: 0;
            font-size: 1.2rem;
        }
        .card-counter .count-number {
            font-size: 2.3rem;
            font-weight: 700;
        }
        .bg-info-light {
            background-color: #e1f5fe;
        }
        .bg-success-light {
            background-color: #e8f5e9;
        }
        .bg-warning-light {
            background-color: #fff8e1;
        }
        .bg-danger-light {
            background-color: #ffebee;
        }
        .table-responsive {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        }
        .alert-status {
            display: inline-block;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.875rem;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/shopHeader.jsp" />
    
    <div class="container-fluid mt-4">
        <h1 class="mb-4">Inventory Dashboard</h1>
        
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
        
        <!-- Stats Cards -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card-counter bg-info-light text-primary">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h5 class="count-title">Total Fruits</h5>
                            <h2 class="count-number">${totalFruits}</h2>
                        </div>
                        <i class="fa fa-apple-whole count-icon"></i>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card-counter bg-success-light text-success">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h5 class="count-title">Total Inventory</h5>
                            <h2 class="count-number">${totalQuantity}</h2>
                        </div>
                        <i class="fa fa-cubes-stacked count-icon"></i>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card-counter bg-warning-light text-warning">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h5 class="count-title">Low Stock Items</h5>
                            <h2 class="count-number">${lowStockItems.size()}</h2>
                        </div>
                        <i class="fa fa-triangle-exclamation count-icon"></i>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card-counter bg-danger-light text-danger">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h5 class="count-title">Active Alerts</h5>
                            <h2 class="count-number">${activeAlerts.size()}</h2>
                        </div>
                        <i class="fa fa-bell count-icon"></i>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <!-- Low Stock Items -->
            <div class="col-md-6 mb-4">
                <div class="card h-100">
                    <div class="card-header bg-warning text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="fa fa-triangle-exclamation me-2"></i> Low Stock Items</h5>
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=list" class="btn btn-sm btn-light">View All</a>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty lowStockItems}">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Fruit</th>
                                                <th>Quantity</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${lowStockItems}">
                                                <tr>
                                                    <td>${item.fruitName}</td>
                                                    <td>
                                                        <span class="badge bg-danger">${item.quantity}</span>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/shop/inventory?action=showAdjustForm&fruitId=${item.fruitId}" class="btn btn-sm btn-outline-primary">
                                                            <i class="fa fa-edit"></i> Adjust
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p class="text-center">No low stock items found.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <!-- Recent Transactions -->
            <div class="col-md-6 mb-4">
                <div class="card h-100">
                    <div class="card-header bg-info text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="fa fa-clock-rotate-left me-2"></i> Recent Transactions</h5>
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=transactions" class="btn btn-sm btn-light">View All</a>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty recentTransactions}">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Fruit</th>
                                                <th>Type</th>
                                                <th>Quantity</th>
                                                <th>Date</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="transaction" items="${recentTransactions}">
                                                <tr>
                                                    <td>${transaction.fruitName}</td>
                                                    <td>
                                                        <span class="${transaction.transactionTypeClass}">${transaction.formattedTransactionType}</span>
                                                    </td>
                                                    <td>${transaction.formattedQuantityChange}</td>
                                                    <td><fmt:formatDate value="${transaction.transactionDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p class="text-center">No recent transactions found.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <!-- Expiring Batches -->
            <div class="col-md-6 mb-4">
                <div class="card h-100">
                    <div class="card-header bg-danger text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="fa fa-calendar-times me-2"></i> Expiring Soon</h5>
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=listBatches" class="btn btn-sm btn-light">View All Batches</a>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty expiringBatches}">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Batch ID</th>
                                                <th>Fruit</th>
                                                <th>Quantity</th>
                                                <th>Expires</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="batch" items="${expiringBatches}">
                                                <tr>
                                                    <td><a href="${pageContext.request.contextPath}/shop/inventory?action=viewBatch&id=${batch.batchId}">${batch.batchId}</a></td>
                                                    <td>${batch.fruitName}</td>
                                                    <td>${batch.quantity}</td>
                                                    <td>
                                                        <span class="${batch.expiryStatusClass}">
                                                            <fmt:formatDate value="${batch.expiryDate}" pattern="yyyy-MM-dd" />
                                                            (${batch.daysUntilExpiry} days)
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p class="text-center">No expiring batches found.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <!-- Active Alerts -->
            <div class="col-md-6 mb-4">
                <div class="card h-100">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="fa fa-bell me-2"></i> Active Alerts</h5>
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=listAlertLogs" class="btn btn-sm btn-light">View All</a>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty activeAlerts}">
                                <div class="list-group">
                                    <c:forEach var="alert" items="${activeAlerts}">
                                        <div class="list-group-item list-group-item-action">
                                            <div class="d-flex w-100 justify-content-between">
                                                <h6 class="mb-1">
                                                    <i class="fa ${alert.alertIcon} me-2 text-${alert.statusColor}"></i>
                                                    ${alert.fruitName}
                                                </h6>
                                                <small><fmt:formatDate value="${alert.triggeredDate}" pattern="yyyy-MM-dd HH:mm" /></small>
                                            </div>
                                            <p class="mb-1">${alert.alertMessage}</p>
                                            <div class="text-end mt-2">
                                                <form action="${pageContext.request.contextPath}/shop/inventory" method="post" style="display: inline;">
                                                    <input type="hidden" name="action" value="acknowledgeAlert">
                                                    <input type="hidden" name="logId" value="${alert.logId}">
                                                    <button type="submit" class="btn btn-sm btn-outline-warning">Acknowledge</button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/shop/inventory" method="post" style="display: inline;">
                                                    <input type="hidden" name="action" value="resolveAlert">
                                                    <input type="hidden" name="logId" value="${alert.logId}">
                                                    <button type="submit" class="btn btn-sm btn-outline-success">Resolve</button>
                                                </form>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p class="text-center">No active alerts found.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header bg-dark text-white">
                        <h5 class="mb-0"><i class="fa fa-bolt me-2"></i> Quick Actions</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3 mb-3">
                                <a href="${pageContext.request.contextPath}/shop/inventory?action=list" class="btn btn-outline-primary d-block h-100 d-flex flex-column justify-content-center align-items-center py-3">
                                    <i class="fa fa-boxes-stacked fa-2x mb-2"></i>
                                    View Inventory
                                </a>
                            </div>
                            <div class="col-md-3 mb-3">
                                <a href="${pageContext.request.contextPath}/shop/inventory?action=showCountForm" class="btn btn-outline-success d-block h-100 d-flex flex-column justify-content-center align-items-center py-3">
                                    <i class="fa fa-clipboard-check fa-2x mb-2"></i>
                                    Start Inventory Count
                                </a>
                            </div>
                            <div class="col-md-3 mb-3">
                                <a href="${pageContext.request.contextPath}/shop/inventory?action=showWastageForm" class="btn btn-outline-danger d-block h-100 d-flex flex-column justify-content-center align-items-center py-3">
                                    <i class="fa fa-trash-can fa-2x mb-2"></i>
                                    Record Wastage
                                </a>
                            </div>
                            <div class="col-md-3 mb-3">
                                <a href="${pageContext.request.contextPath}/shop/inventory?action=showBatchForm" class="btn btn-outline-info d-block h-100 d-flex flex-column justify-content-center align-items-center py-3">
                                    <i class="fa fa-box fa-2x mb-2"></i>
                                    Add New Batch
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
