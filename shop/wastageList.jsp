<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wastage Records - Fruit Management System</title>
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
    </style>
</head>
<body>
    <jsp:include page="../includes/shopHeader.jsp" />
    
    <div class="container-fluid mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Wastage Records</h1>
            <div>
                <a href="${pageContext.request.contextPath}/shop/inventory?action=showWastageForm" class="btn btn-danger me-2">
                    <i class="fa fa-plus-circle me-1"></i> Record Wastage
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
                <div class="card bg-danger text-white mb-3">
                    <div class="card-body py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-0">Total Wastage Records</h6>
                                <h2 class="mt-2 mb-0">${wastageList.size()}</h2>
                            </div>
                            <i class="fa fa-trash-can fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card bg-warning text-dark mb-3">
                    <div class="card-body py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-0">Total Units Wasted</h6>
                                <h2 class="mt-2 mb-0">
                                    <jsp:useBean id="totalWasted" class="java.lang.Integer" value="0" />
                                    <c:forEach var="wastage" items="${wastageList}">
                                        <jsp:setProperty name="totalWasted" property="value" value="${totalWasted + wastage.quantity}" />
                                    </c:forEach>
                                    ${totalWasted}
                                </h2>
                            </div>
                            <i class="fa fa-cubes-stacked fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card bg-info text-white mb-3">
                    <div class="card-body py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-0">Common Reason</h6>
                                <h5 class="mt-2 mb-0">
                                    <c:set var="reasons" value="${{}}"/>
                                    <c:forEach var="wastage" items="${wastageList}">
                                        <c:set var="currentCount" value="${reasons[wastage.reason] != null ? reasons[wastage.reason] : 0}"/>
                                        <c:set target="${reasons}" property="${wastage.reason}" value="${currentCount + 1}"/>
                                    </c:forEach>
                                    
                                    <c:set var="maxCount" value="0"/>
                                    <c:set var="maxReason" value=""/>
                                    <c:forEach var="reason" items="${reasons}">
                                        <c:if test="${reason.value > maxCount}">
                                            <c:set var="maxCount" value="${reason.value}"/>
                                            <c:set var="maxReason" value="${reason.key}"/>
                                        </c:if>
                                    </c:forEach>
                                    
                                    ${maxReason != '' ? maxReason : 'N/A'}
                                </h5>
                            </div>
                            <i class="fa fa-chart-simple fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card bg-success text-white mb-3">
                    <div class="card-body py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-0">Last Recorded</h6>
                                <h5 class="mt-2 mb-0">
                                    <c:if test="${not empty wastageList}">
                                        <fmt:formatDate value="${wastageList[0].recordedDate}" pattern="yyyy-MM-dd" />
                                    </c:if>
                                </h5>
                            </div>
                            <i class="fa fa-calendar-day fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Filters Section -->
        <div class="dashboard-filters">
            <form action="${pageContext.request.contextPath}/shop/inventory" method="get" id="filterForm">
                <input type="hidden" name="action" value="listWastage">
                <div class="row align-items-end">
                    <div class="col-md-3 mb-3 mb-md-0">
                        <label for="fruitFilter" class="form-label">Filter by Fruit</label>
                        <select class="form-select" id="fruitFilter" name="fruitId">
                            <option value="">All Fruits</option>
                            <c:forEach var="item" items="${fruits}">
                                <option value="${item.fruitId}" ${param.fruitId == item.fruitId ? 'selected' : ''}>
                                    ${item.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3 mb-3 mb-md-0">
                        <label for="reasonFilter" class="form-label">Filter by Reason</label>
                        <select class="form-select" id="reasonFilter" name="reason">
                            <option value="">All Reasons</option>
                            <option value="Damaged" ${param.reason == 'Damaged' ? 'selected' : ''}>Damaged</option>
                            <option value="Expired" ${param.reason == 'Expired' ? 'selected' : ''}>Expired</option>
                            <option value="Quality issues" ${param.reason == 'Quality issues' ? 'selected' : ''}>Quality issues</option>
                            <option value="Spoiled" ${param.reason == 'Spoiled' ? 'selected' : ''}>Spoiled</option>
                            <option value="Contaminated" ${param.reason == 'Contaminated' ? 'selected' : ''}>Contaminated</option>
                            <option value="Other" ${param.reason == 'Other' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>
                    <div class="col-md-4 mb-3 mb-md-0">
                        <label for="dateRange" class="form-label">Date Range</label>
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
        
        <!-- Wastage Table -->
        <div class="card list-card mb-4">
            <div class="card-header bg-light">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="fa fa-trash-can me-2"></i> Wastage History</h5>
                    <c:if test="${not empty param.fruitId || not empty param.reason || not empty param.startDate}">
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=listWastage" class="btn btn-sm btn-outline-secondary">
                            <i class="fa fa-xmark me-1"></i> Clear Filters
                        </a>
                    </c:if>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="wastageTable" class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Date</th>
                                <th>Fruit</th>
                                <th>Quantity</th>
                                <th>Reason</th>
                                <th>Batch ID</th>
                                <th>Recorded By</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="wastage" items="${wastageList}">
                                <tr>
                                    <td>${wastage.wastageId}</td>
                                    <td><fmt:formatDate value="${wastage.recordedDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                    <td>${wastage.fruitName}</td>
                                    <td>
                                        <span class="badge bg-danger">${wastage.quantity}</span>
                                    </td>
                                    <td>${wastage.reason}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty wastage.batchId}">
                                                <a href="${pageContext.request.contextPath}/shop/inventory?action=viewBatch&id=${wastage.batchId}">${wastage.batchId}</a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${wastage.recordedByName}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/shop/inventory?action=viewWastage&id=${wastage.wastageId}" class="btn btn-sm btn-primary">
                                            <i class="fa fa-eye"></i> View
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
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=showWastageForm" class="btn btn-outline-danger d-block h-100 d-flex flex-column justify-content-center align-items-center py-3">
                            <i class="fa fa-trash-can fa-2x mb-2"></i>
                            Record New Wastage
                        </a>
                    </div>
                    <div class="col-md-3 mb-3">
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=list" class="btn btn-outline-primary d-block h-100 d-flex flex-column justify-content-center align-items-center py-3">
                            <i class="fa fa-boxes-stacked fa-2x mb-2"></i>
                            View Current Inventory
                        </a>
                    </div>
                    <div class="col-md-3 mb-3">
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=listBatches" class="btn btn-outline-success d-block h-100 d-flex flex-column justify-content-center align-items-center py-3">
                            <i class="fa fa-box fa-2x mb-2"></i>
                            View Batches
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
            $('#wastageTable').DataTable({
                dom: 'Bfrtip',
                buttons: [
                    {
                        extend: 'csv',
                        text: '<i class="fa fa-file-csv me-1"></i> Export CSV',
                        className: 'btn btn-outline-primary btn-sm me-2',
                        title: 'Wastage_Records_Export'
                    },
                    {
                        extend: 'excel',
                        text: '<i class="fa fa-file-excel me-1"></i> Export Excel',
                        className: 'btn btn-outline-success btn-sm me-2',
                        title: 'Wastage_Records_Export'
                    },
                    {
                        extend: 'pdf',
                        text: '<i class="fa fa-file-pdf me-1"></i> Export PDF',
                        className: 'btn btn-outline-danger btn-sm',
                        title: 'Wastage_Records_Export'
                    }
                ],
                "order": [[ 1, "desc" ]], // Sort by date descending
                "pageLength": 10,
                "language": {
                    "emptyTable": "No wastage records found"
                }
            });
            
            // Auto-submit form when filters change
            $('#fruitFilter, #reasonFilter').change(function() {
                $('#filterForm').submit();
            });
        });
    </script>
</body>
</html>