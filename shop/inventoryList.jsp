<%-- 
    Document   : inventoryList
    Created on : 2025年4月19日, 下午12:11:01
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
    <title>Inventory List - Fruit Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
    <style>
        .stock-badge {
            font-size: 0.85rem;
            padding: 0.35rem 0.65rem;
        }
        .table-responsive {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        }
        .action-buttons .btn {
            margin-right: 0.25rem;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/shopHeader.jsp" />
    
    <div class="container-fluid mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Inventory Management</h1>
            <div>
                <a href="${pageContext.request.contextPath}/shop/inventory" class="btn btn-outline-secondary me-2">
                    <i class="fa fa-gauge-high"></i> Dashboard
                </a>
                <a href="#" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#filterModal">
                    <i class="fa fa-filter me-1"></i> Filter
                </a>
            </div>
        </div>
        
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
        
        <!-- Inventory Stats Cards -->
        <div class="row mb-4">
            <div class="col-md-3 mb-3">
                <div class="card text-bg-primary">
                    <div class="card-body py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-0">Total Fruits</h6>
                                <h2 class="mt-2 mb-0">${inventory.size()}</h2>
                            </div>
                            <i class="fa fa-apple-whole fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3 mb-3">
                <div class="card text-bg-success">
                    <div class="card-body py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-0">Total Units</h6>
                                <h2 class="mt-2 mb-0">
                                    <jsp:useBean id="totalUnits" class="java.lang.Integer" value="0" />
                                    <c:forEach var="item" items="${inventory}">
                                        <jsp:setProperty name="totalUnits" property="value" value="${totalUnits + item.quantity}" />
                                    </c:forEach>
                                    ${totalUnits}
                                </h2>
                            </div>
                            <i class="fa fa-cubes-stacked fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3 mb-3">
                <div class="card text-bg-warning">
                    <div class="card-body py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-0">Low Stock Items</h6>
                                <h2 class="mt-2 mb-0">
                                    <jsp:useBean id="lowStockCount" class="java.lang.Integer" value="0" />
                                    <c:forEach var="item" items="${inventory}">
                                        <c:if test="${item.quantity <= 5}">
                                            <jsp:setProperty name="lowStockCount" property="value" value="${lowStockCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${lowStockCount}
                                </h2>
                            </div>
                            <i class="fa fa-triangle-exclamation fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3 mb-3">
                <div class="card text-bg-info">
                    <div class="card-body py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-0">Last Updated</h6>
                                <h5 class="mt-2 mb-0">
                                    <jsp:useBean id="lastUpdated" class="java.util.Date" />
                                    <c:forEach var="item" items="${inventory}">
                                        <c:if test="${item.lastChecked.time > lastUpdated.time}">
                                            <jsp:setProperty name="lastUpdated" property="time" value="${item.lastChecked.time}" />
                                        </c:if>
                                    </c:forEach>
                                    <fmt:formatDate value="${lastUpdated}" pattern="yyyy-MM-dd HH:mm" />
                                </h5>
                            </div>
                            <i class="fa fa-clock-rotate-left fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Inventory Table -->
        <div class="card mb-4">
            <div class="card-header bg-light">
                <h5 class="mb-0"><i class="fa fa-boxes-stacked me-2"></i> Inventory List</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="inventoryTable" class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Fruit</th>
                                <th>Quantity</th>
                                <th>Status</th>
                                <th>Last Updated</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${inventory}">
                                <tr>
                                    <td>${item.inventoryId}</td>
                                    <td>
                                        <strong>${item.fruitName}</strong>
                                    </td>
                                    <td>${item.quantity}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.quantity <= 0}">
                                                <span class="badge bg-danger stock-badge">Out of Stock</span>
                                            </c:when>
                                            <c:when test="${item.quantity <= 5}">
                                                <span class="badge bg-warning text-dark stock-badge">Low Stock</span>
                                            </c:when>
                                            <c:when test="${item.quantity <= 10}">
                                                <span class="badge bg-info text-dark stock-badge">Medium Stock</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-success stock-badge">In Stock</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><fmt:formatDate value="${item.lastChecked}" pattern="yyyy-MM-dd HH:mm" /></td>
                                    <td class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/shop/inventory?action=showAdjustForm&fruitId=${item.fruitId}" class="btn btn-sm btn-primary">
                                            <i class="fa fa-edit"></i> Adjust
                                        </a>
                                        <a href="${pageContext.request.contextPath}/shop/inventory?action=transactions&fruitId=${item.fruitId}" class="btn btn-sm btn-info">
                                            <i class="fa fa-history"></i> History
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
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
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=showCountForm" class="btn btn-outline-primary d-block h-100 d-flex flex-column justify-content-center align-items-center py-3">
                            <i class="fa fa-clipboard-check fa-2x mb-2"></i>
                            Start Inventory Count
                        </a>
                    </div>
                    <div class="col-md-3 mb-3">
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=showBatchForm" class="btn btn-outline-success d-block h-100 d-flex flex-column justify-content-center align-items-center py-3">
                            <i class="fa fa-box fa-2x mb-2"></i>
                            Add New Batch
                        </a>
                    </div>
                    <div class="col-md-3 mb-3">
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=listCounts" class="btn btn-outline-info d-block h-100 d-flex flex-column justify-content-center align-items-center py-3">
                            <i class="fa fa-list-check fa-2x mb-2"></i>
                            View Count History
                        </a>
                    </div>
                    <div class="col-md-3 mb-3">
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=transactions" class="btn btn-outline-secondary d-block h-100 d-flex flex-column justify-content-center align-items-center py-3">
                            <i class="fa fa-clock-rotate-left fa-2x mb-2"></i>
                            View Transactions
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Filter Modal -->
    <div class="modal fade" id="filterModal" tabindex="-1" aria-labelledby="filterModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="filterModalLabel">Filter Inventory</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="filterForm" action="${pageContext.request.contextPath}/shop/inventory" method="get">
                        <input type="hidden" name="action" value="list">
                        
                        <div class="mb-3">
                            <label for="statusFilter" class="form-label">Stock Status</label>
                            <select id="statusFilter" name="status" class="form-select">
                                <option value="all">All Items</option>
                                <option value="outOfStock">Out of Stock</option>
                                <option value="lowStock">Low Stock</option>
                                <option value="inStock">In Stock</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="sortBy" class="form-label">Sort By</label>
                            <select id="sortBy" name="sortBy" class="form-select">
                                <option value="name">Fruit Name</option>
                                <option value="quantityAsc">Quantity (Low to High)</option>
                                <option value="quantityDesc">Quantity (High to Low)</option>
                                <option value="updated">Last Updated</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" form="filterForm" class="btn btn-primary">Apply Filters</button>
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
            $('#inventoryTable').DataTable({
                "pageLength": 10,
                "language": {
                    "emptyTable": "No inventory items found"
                },
                "order": [[ 2, "asc" ]] // Sort by quantity ascending by default
            });
        });
    </script>
</body>
</html>