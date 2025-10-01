<%-- 
    Document   : inventory
    Created on : 2025年4月19日, 下午3:15:03
    Author     : kelvin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Warehouse Inventory Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <style>
        .inventory-card {
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s;
        }
        .inventory-card:hover {
            transform: translateY(-5px);
        }
        .dashboard-stats {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .stat-item {
            text-align: center;
            padding: 15px;
            border-radius: 8px;
        }
        .stat-value {
            font-size: 2rem;
            font-weight: bold;
        }
        .stat-label {
            font-size: 0.9rem;
            color: #6c757d;
        }
        .log-item {
            padding: 10px;
            border-left: 3px solid #dee2e6;
            margin-bottom: 10px;
        }
        .log-meta {
            font-size: 0.8rem;
            color: #6c757d;
        }
        .utilization-bar {
            height: 6px;
            border-radius: 3px;
        }
        .fruit-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 10px;
        }
        .filter-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            margin-right: 5px;
        }
    </style>
</head>
<body>
    <jsp:include page="../include/header.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1>Warehouse Inventory Management</h1>
                <p class="text-muted">Manage and track inventory levels across all warehouse locations</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/warehouse/inventory?action=list" class="btn btn-outline-secondary">
                    <i class="fas fa-sync-alt"></i> Refresh
                </a>
                <a href="${pageContext.request.contextPath}/warehouse/transfer?action=new" class="btn btn-primary">
                    <i class="fas fa-exchange-alt"></i> New Transfer
                </a>
            </div>
        </div>
        
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
        
        <!-- Dashboard Stats -->
        <div class="row dashboard-stats">
            <div class="col-md-3">
                <div class="stat-item bg-primary bg-opacity-10">
                    <div class="stat-value text-primary">${inventory.size()}</div>
                    <div class="stat-label">Total Items</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-item bg-danger bg-opacity-10">
                    <div class="stat-value text-danger">${lowStockCount}</div>
                    <div class="stat-label">Low Stock Items</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-item bg-warning bg-opacity-10">
                    <div class="stat-value text-warning">${highStockCount}</div>
                    <div class="stat-label">High Stock Items</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-item bg-info bg-opacity-10">
                    <div class="stat-value text-info">
                        <c:set var="totalUtilization" value="0" />
                        <c:forEach var="item" items="${inventory}">
                            <c:set var="totalUtilization" value="${totalUtilization + item.utilizationPercentage}" />
                        </c:forEach>
                        <fmt:formatNumber value="${totalUtilization / inventory.size()}" pattern="#0.0" />%
                    </div>
                    <div class="stat-label">Avg. Utilization</div>
                </div>
            </div>
        </div>
        
        <!-- Filters and Search -->
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="d-flex">
                    <a href="${pageContext.request.contextPath}/warehouse/inventory?action=list" 
                       class="filter-badge ${empty inventoryFilter ? 'bg-primary text-white' : 'bg-light'}">
                        All Items
                    </a>
                    <a href="${pageContext.request.contextPath}/warehouse/inventory?action=lowStock" 
                       class="filter-badge ${inventoryFilter == 'lowStock' ? 'bg-danger text-white' : 'bg-light'}">
                        Low Stock
                    </a>
                    <a href="${pageContext.request.contextPath}/warehouse/inventory?action=highStock" 
                       class="filter-badge ${inventoryFilter == 'highStock' ? 'bg-warning text-white' : 'bg-light'}">
                        High Stock
                    </a>
                </div>
            </div>
            <div class="col-md-6">
                <form action="${pageContext.request.contextPath}/warehouse/inventory" method="get" class="d-flex">
                    <input type="hidden" name="action" value="search">
                    <input type="text" name="searchTerm" class="form-control me-2" placeholder="Search inventory..." value="${searchTerm}">
                    <button type="submit" class="btn btn-outline-primary">Search</button>
                </form>
            </div>
        </div>
        
        <div class="row">
            <!-- Inventory List -->
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-box-open me-2"></i> Warehouse Inventory</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty inventory}">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Fruit</th>
                                                <th>Qty</th>
                                                <th>Location</th>
                                                <th>Status</th>
                                                <th>Utilization</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${inventory}">
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <div class="fruit-icon">
                                                                <i class="fas fa-apple-alt text-${item.stockStatusColor}"></i>
                                                            </div>
                                                            <span>${item.fruitName}</span>
                                                        </div>
                                                    </td>
                                                    <td>${item.quantity}</td>
                                                    <td>${item.warehouseSection}-${item.shelfNumber}</td>
                                                    <td>
                                                        <span class="badge bg-${item.stockStatusColor}">
                                                            ${item.stockStatus}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div class="progress">
                                                            <div class="progress-bar bg-${item.stockStatusColor}" 
                                                                role="progressbar" 
                                                                style="width: ${item.utilizationPercentage}%"
                                                                aria-valuenow="${item.utilizationPercentage}" 
                                                                aria-valuemin="0" 
                                                                aria-valuemax="100">
                                                                <fmt:formatNumber value="${item.utilizationPercentage}" pattern="#0.0" />%
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/warehouse/inventory?action=details&id=${item.id}" 
                                                           class="btn btn-sm btn-outline-primary">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/warehouse/inventory?action=showAdjustForm&id=${item.id}" 
                                                           class="btn btn-sm btn-outline-secondary">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/warehouse/transfer?action=new&inventoryId=${item.id}" 
                                                           class="btn btn-sm btn-outline-success">
                                                            <i class="fas fa-exchange-alt"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i> No inventory items found.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <!-- Recent Activity -->
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0"><i class="fas fa-history me-2"></i> Recent Activity</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty recentLogs}">
                                <c:forEach var="log" items="${recentLogs}">
                                    <div class="log-item">
                                        <div class="d-flex align-items-center mb-2">
                                            <span class="badge bg-${log.activityTypeColor} me-2">${log.activityTypeDisplay}</span>
                                            <span class="fw-bold">${log.fruitName}</span>
                                        </div>
                                        <c:if test="${not empty log.quantityChangeDisplay}">
                                            <p class="text-${log.quantityChangeColor} mb-1">
                                                ${log.quantityChangeDisplay} units
                                            </p>
                                        </c:if>
                                        <c:if test="${not empty log.notes}">
                                            <p class="mb-1 text-muted small">${log.notes}</p>
                                        </c:if>
                                        <div class="log-meta">
                                            <i class="fas fa-user-circle me-1"></i> ${log.performedByName}
                                            <i class="fas fa-clock ms-2 me-1"></i> <fmt:formatDate value="${log.activityDate}" pattern="MMM dd, yyyy HH:mm" />
                                        </div>
                                    </div>
                                </c:forEach>
                                <div class="text-center mt-3">
                                    <a href="${pageContext.request.contextPath}/warehouse/logs" class="btn btn-sm btn-outline-info">
                                        View All Activity
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i> No recent activity found.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <!-- Transfer Actions -->
                <div class="card mt-4">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="fas fa-exchange-alt me-2"></i> Transfer Actions</h5>
                    </div>
                    <div class="card-body">
                        <div class="list-group">
                            <a href="${pageContext.request.contextPath}/warehouse/transfer?action=new" class="list-group-item list-group-item-action">
                                <i class="fas fa-plus-circle me-2"></i> Create New Transfer
                            </a>
                            <a href="${pageContext.request.contextPath}/warehouse/transfer?action=pending" class="list-group-item list-group-item-action">
                                <i class="fas fa-hourglass-half me-2"></i> Pending Transfers
                            </a>
                            <a href="${pageContext.request.contextPath}/warehouse/transfer?action=inTransit" class="list-group-item list-group-item-action">
                                <i class="fas fa-truck me-2"></i> In-Transit Transfers
                            </a>
                            <a href="${pageContext.request.contextPath}/warehouse/transfer?action=list" class="list-group-item list-group-item-action">
                                <i class="fas fa-list me-2"></i> All Transfers
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../include/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>