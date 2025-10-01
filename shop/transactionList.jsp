<%-- 
    Document   : transactionList
    Created on : 2025年4月19日, 下午12:11:22
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
    <title>Inventory Transactions - Fruit Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.3.6/css/buttons.bootstrap5.min.css">
    <style>
        .transaction-card {
            box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            border: none;
        }
        .transaction-card .card-header {
            border-radius: 10px 10px 0 0;
        }
        .transaction-badge {
            font-size: 0.85rem;
            padding: 0.35rem 0.65rem;
        }
        .table-responsive {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        }
        .transaction-amount {
            font-weight: 600;
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
            <h1>Inventory Transactions</h1>
            <a href="${pageContext.request.contextPath}/shop/inventory" class="btn btn-secondary">
                <i class="fa fa-arrow-left me-2"></i> Back to Dashboard
            </a>
        </div>
        
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
        
        <!-- Filters Section -->
        <div class="dashboard-filters">
            <form action="${pageContext.request.contextPath}/shop/inventory" method="get" id="filterForm">
                <input type="hidden" name="action" value="transactions">
                <div class="row align-items-end">
                    <div class="col-md-3 mb-3 mb-md-0">
                        <label for="fruitFilter" class="form-label">Filter by Fruit</label>
                        <select class="form-select" id="fruitFilter" name="fruitId">
                            <option value="">All Fruits</option>
                            <c:forEach var="fruit" items="${fruits}">
                                <option value="${fruit.fruitId}" ${selectedFruitId == fruit.fruitId ? 'selected' : ''}>
                                    ${fruit.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3 mb-3 mb-md-0">
                        <label for="typeFilter" class="form-label">Filter by Type</label>
                        <select class="form-select" id="typeFilter" name="type">
                            <option value="">All Types</option>
                            <option value="addition" ${selectedType == 'addition' ? 'selected' : ''}>Addition</option>
                            <option value="reduction" ${selectedType == 'reduction' ? 'selected' : ''}>Reduction</option>
                            <option value="adjustment" ${selectedType == 'adjustment' ? 'selected' : ''}>Adjustment</option>
                            <option value="wastage" ${selectedType == 'wastage' ? 'selected' : ''}>Wastage</option>
                            <option value="transfer" ${selectedType == 'transfer' ? 'selected' : ''}>Transfer</option>
                            <option value="count" ${selectedType == 'count' ? 'selected' : ''}>Inventory Count</option>
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
        
        <!-- Transactions Table -->
        <div class="card transaction-card mb-4">
            <div class="card-header bg-light">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="fa fa-clock-rotate-left me-2"></i> Transaction History</h5>
                    <c:if test="${not empty selectedFruitId || not empty selectedType || not empty param.startDate}">
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=transactions" class="btn btn-sm btn-outline-secondary">
                            <i class="fa fa-xmark me-1"></i> Clear Filters
                        </a>
                    </c:if>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="transactionTable" class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Date & Time</th>
                                <th>Fruit</th>
                                <th>Type</th>
                                <th>Change</th>
                                <th>Before</th>
                                <th>After</th>
                                <th>Reason</th>
                                <th>Performed By</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="transaction" items="${transactions}">
                                <tr>
                                    <td>${transaction.transactionId}</td>
                                    <td><fmt:formatDate value="${transaction.transactionDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                    <td>${transaction.fruitName}</td>
                                    <td>
                                        <span class="badge ${transaction.transactionTypeClass} transaction-badge">
                                            ${transaction.formattedTransactionType}
                                        </span>
                                    </td>
                                    <td class="transaction-amount ${transaction.transactionTypeClass}">
                                        ${transaction.formattedQuantityChange}
                                    </td>
                                    <td>${transaction.previousQuantity}</td>
                                    <td>${transaction.newQuantity}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty transaction.reason}">
                                                ${transaction.reason}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">N/A</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${transaction.performedByName}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        
        <!-- Stats Cards -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card bg-info text-white mb-3">
                    <div class="card-body py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-0">Total Transactions</h6>
                                <h2 class="mt-2 mb-0">${transactions.size()}</h2>
                            </div>
                            <i class="fa fa-list fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card bg-success text-white mb-3">
                    <div class="card-body py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-0">Additions</h6>
                                <h2 class="mt-2 mb-0">
                                    <jsp:useBean id="additionCount" class="java.lang.Integer" value="0" />
                                    <c:forEach var="trans" items="${transactions}">
                                        <c:if test="${trans.transactionType == 'addition'}">
                                            <jsp:setProperty name="additionCount" property="value" value="${additionCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${additionCount}
                                </h2>
                            </div>
                            <i class="fa fa-plus-circle fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card bg-danger text-white mb-3">
                    <div class="card-body py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-0">Reductions</h6>
                                <h2 class="mt-2 mb-0">
                                    <jsp:useBean id="reductionCount" class="java.lang.Integer" value="0" />
                                    <c:forEach var="trans" items="${transactions}">
                                        <c:if test="${trans.transactionType == 'reduction' || trans.transactionType == 'wastage'}">
                                            <jsp:setProperty name="reductionCount" property="value" value="${reductionCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${reductionCount}
                                </h2>
                            </div>
                            <i class="fa fa-minus-circle fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card bg-warning text-dark mb-3">
                    <div class="card-body py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-0">Adjustments</h6>
                                <h2 class="mt-2 mb-0">
                                    <jsp:useBean id="adjustmentCount" class="java.lang.Integer" value="0" />
                                    <c:forEach var="trans" items="${transactions}">
                                        <c:if test="${trans.transactionType == 'adjustment' || trans.transactionType == 'count'}">
                                            <jsp:setProperty name="adjustmentCount" property="value" value="${adjustmentCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${adjustmentCount}
                                </h2>
                            </div>
                            <i class="fa fa-balance-scale fa-3x opacity-50"></i>
                        </div>
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
            $('#transactionTable').DataTable({
                dom: 'Bfrtip',
                buttons: [
                    {
                        extend: 'csv',
                        text: '<i class="fa fa-file-csv me-1"></i> Export CSV',
                        className: 'btn btn-outline-primary btn-sm me-2',
                        title: 'Inventory_Transactions_Export'
                    },
                    {
                        extend: 'excel',
                        text: '<i class="fa fa-file-excel me-1"></i> Export Excel',
                        className: 'btn btn-outline-success btn-sm me-2',
                        title: 'Inventory_Transactions_Export'
                    },
                    {
                        extend: 'pdf',
                        text: '<i class="fa fa-file-pdf me-1"></i> Export PDF',
                        className: 'btn btn-outline-danger btn-sm',
                        title: 'Inventory_Transactions_Export'
                    }
                ],
                "pageLength": 15,
                "order": [[ 1, "desc" ]], // Sort by date descending
                "language": {
                    "emptyTable": "No transactions found"
                }
            });
        });

        // Auto-submit form when fruit or type filter changes
        document.getElementById('fruitFilter').addEventListener('change', function() {
            document.getElementById('filterForm').submit();
        });
        
        document.getElementById('typeFilter').addEventListener('change', function() {
            document.getElementById('filterForm').submit();
        });
    </script>
</body>
</html>