<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Batch Management - Fruit Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.3.6/css/buttons.bootstrap5.min.css">
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
        .dashboard-filters {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.05);
        }
        .badge-pill {
            border-radius: 50rem;
            padding: 0.35rem 0.65rem;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/shopHeader.jsp" />
    
    <div class="container-fluid mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Batch Management</h1>
            <div>
                <a href="${pageContext.request.contextPath}/shop/inventory?action=showBatchForm" class="btn btn-success me-2">
                    <i class="fa fa-plus-circle me-1"></i> Add New Batch
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
        
        <!-- Stats Cards -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card bg-success text-white mb-3">
                    <div class="card-body py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-0">Total Batches</h6>
                                <h2 class="mt-2 mb-0">${batches.size()}</h2>
                            </div>
                            <i class="fa fa-boxes-stacked fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card bg-warning text-dark mb-3">
                    <div class="card-body py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-0">Expiring Soon</h6>
                                <h2 class="mt-2 mb-0">
                                    <jsp:useBean id="expiringSoonCount" class="java.lang.Integer" value="0" />
                                    <c:forEach var="batch" items="${batches}">
                                        <c:if test="${batch.daysUntilExpiry >= 0 && batch.daysUntilExpiry <= 7}">
                                            <jsp:setProperty name="expiringSoonCount" property="value" value="${expiringSoonCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${expiringSoonCount}
                                </h2>
                            </div>
                            <i class="fa fa-calendar-xmark fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card bg-danger text-white mb-3">
                    <div class="card-body py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-0">Expired</h6>
                                <h2 class="mt-2 mb-0">
                                    <jsp:useBean id="expiredCount" class="java.lang.Integer" value="0" />
                                    <c:forEach var="batch" items="${batches}">
                                        <c:if test="${batch.daysUntilExpiry < 0}">
                                            <jsp:setProperty name="expiredCount" property="value" value="${expiredCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${expiredCount}
                                </h2>
                            </div>
                            <i class="fa fa-triangle-exclamation fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card bg-info text-white mb-3">
                    <div class="card-body py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-0">Total Units</h6>
                                <h2 class="mt-2 mb-0">
                                    <jsp:useBean id="totalUnits" class="java.lang.Integer" value="0" />
                                    <c:forEach var="batch" items="${batches}">
                                        <jsp:setProperty name="totalUnits" property="value" value="${totalUnits + batch.quantity}" />
                                    </c:forEach>
                                    ${totalUnits}
                                </h2>
                            </div>
                            <i class="fa fa-cubes-stacked fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Filters Section -->
        <div class="dashboard-filters">
            <form action="${pageContext.request.contextPath}/shop/inventory" method="get" id="filterForm">
                <input type="hidden" name="action" value="listBatches">
                <div class="row align-items-end">
                    <div class="col-md-3 mb-3 mb-md-0">
                        <label for="fruitFilter" class="form-label">Filter by Fruit</label>
                        <select class="form-select" id="fruitFilter" name="fruitId">
                            <option value="">All Fruits</option>
                            <c:forEach var="fruit" items="${fruits}">
                                <option value="${fruit.fruitId}" ${param.fruitId == fruit.fruitId ? 'selected' : ''}>
                                    ${fruit.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3 mb-3 mb-md-0">
                        <label for="expiryFilter" class="form-label">Filter by Expiry Status</label>
                        <select class="form-select" id="expiryFilter" name="expiryStatus">
                            <option value="">All Status</option>
                            <option value="expired" ${param.expiryStatus == 'expired' ? 'selected' : ''}>Expired</option>
                            <option value="expiringSoon" ${param.expiryStatus == 'expiringSoon' ? 'selected' : ''}>Expiring Soon (7 days)</option>
                            <option value="good" ${param.expiryStatus == 'good' ? 'selected' : ''}>Good</option>
                        </select>
                    </div>
                    <div class="col-md-4 mb-3 mb-md-0">
                        <label for="dateRange" class="form-label">Received Date Range</label>
                        <div class="input-group">
                            <input type="date" class="form-control" id="startDate" name="startDate" value="${param.startDate}">
                            <span class="input-group-text">to</span>
                            <input type="date" class="form-control" id="endDate" name="endDate" value="${param.endDate}">
                        </div>
                    </div>
                    <div class="col-md-2 mb-3 mb-md-0 d-grid">
                        <button type="submit" class="btn btn-primary">
                            <i class="fa fa-filter me-2"></i> Apply Filters
                        </button>
                    </div>
                </div>
            </form>
        </div>
        
        <!-- Batches Table -->
        <div class="card list-card mb-4">
            <div class="card-header bg-light">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="fa fa-box me-2"></i> Batch List</h5>
                    <c:if test="${not empty param.fruitId || not empty param.expiryStatus || not empty param.startDate}">
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=listBatches" class="btn btn-sm btn-outline-secondary">
                            <i class="fa fa-xmark me-1"></i> Clear Filters
                        </a>
                    </c:if>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="batchTable" class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>Batch ID</th>
                                <th>Fruit</th>
                                <th>Quantity</th>
                                <th>Received Date</th>
                                <th>Expiry Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="batch" items="${batches}">
                                <tr>
                                    <td>${batch.batchId}</td>
                                    <td>${batch.fruitName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${batch.quantity <= 0}">
                                                <span class="badge bg-danger">${batch.quantity}</span>
                                            </c:when>
                                            <c:when test="${batch.quantity <= 5}">
                                                <span class="badge bg-warning text-dark">${batch.quantity}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-success">${batch.quantity}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><fmt:formatDate value="${batch.receivedDate}" pattern="yyyy-MM-dd" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty batch.expiryDate}">
                                                <fmt:formatDate value="${batch.expiryDate}" pattern="yyyy-MM-dd" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">N/A</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${batch.daysUntilExpiry < 0}">
                                                <span class="badge-pill bg-danger">Expired</span>
                                            </c:when>
                                            <c:when test="${batch.daysUntilExpiry >= 0 && batch.daysUntilExpiry <= 3}">
                                                <span class="badge-pill bg-danger">Expires in ${batch.daysUntilExpiry} days</span>
                                            </c:when>
                                            <c:when test="${batch.daysUntilExpiry > 3 && batch.daysUntilExpiry <= 7}">
                                                <span class="badge-pill bg-warning text-dark">Expires in ${batch.daysUntilExpiry} days</span>
                                            </c:when>
                                            <c:when test="${not empty batch.expiryDate}">
                                                <span class="badge-pill bg-success">Good (${batch.daysUntilExpiry} days)</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-pill bg-secondary">No expiry</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/shop/inventory?action=viewBatch&id=${batch.batchId}" class="btn btn-sm btn-primary">
                                            <i class="fa fa-eye"></i> View
                                        </a>
                                        <c:if test="${batch.quantity > 0}">
                                            <a href="${pageContext.request.contextPath}/shop/inventory?action=showWastageForm&batchId=${batch.batchId}" class="btn btn-sm btn-danger">
                                                <i class="fa fa-trash-can"></i> Wastage
                                            </a>
                                        </c:if>
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
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=showBatchForm" class="btn btn-outline-success d-block h-100 d-flex flex-column justify-content-center align-items-center py-3">
                            <i class="fa fa-plus-circle fa-2x mb-2"></i>
                            Add New Batch
                        </a>
                    </div>
                    <div class="col-md-3 mb-3">
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=list" class="btn btn-outline-primary d-block h-100 d-flex flex-column justify-content-center align-items-center py-3">
                            <i class="fa fa-boxes-stacked fa-2x mb-2"></i>
                            View Current Inventory
                        </a>
                    </div>
                    <div class="col-md-3 mb-3">
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=showWastageForm" class="btn btn-outline-danger d-block h-100 d-flex flex-column justify-content-center align-items-center py-3">
                            <i class="fa fa-trash-can fa-2x mb-2"></i>
                            Record Wastage
                        </a>
                    </div>
                    <div class="col-md-3 mb-3">
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=transactions" class="btn btn-outline-info d-block h-100 d-flex flex-column justify-content-center align-items-center py-3">
                            <i class="fa fa-clock-rotate-left fa-2x mb-2"></i>
                            View Transactions
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
    <script src="https://cdn.datatables.net/buttons/2.3.6/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.3.6/js/buttons.bootstrap5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.3.6/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.3.6/js/buttons.print.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#batchTable').DataTable({
                dom: 'Bfrtip',
                buttons: [
                    {
                        extend: 'csv',
                        text: '<i class="fa fa-file-csv me-1"></i> Export CSV',
                        className: 'btn btn-outline-primary btn-sm me-2',
                        title: 'Batch_List_Export'
                    },
                    {
                        extend: 'excel',
                        text: '<i class="fa fa-file-excel me-1"></i> Export Excel',
                        className: 'btn btn-outline-success btn-sm me-2',
                        title: 'Batch_List_Export'
                    },
                    {
                        extend: 'pdf',
                        text: '<i class="fa fa-file-pdf me-1"></i> Export PDF',
                        className: 'btn btn-outline-danger btn-sm',
                        title: 'Batch_List_Export'
                    }
                ],
                "order": [[ 4, "asc" ]], // Sort by expiry date ascending
                "pageLength": 10,
                "language": {
                    "emptyTable": "No batches found"
                }
            });
            
            // Auto-submit form when filters change
            $('#fruitFilter, #expiryFilter').change(function() {
                $('#filterForm').submit();
            });
        });
    </script>
</body>
</html>