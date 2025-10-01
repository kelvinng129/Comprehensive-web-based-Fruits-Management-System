<%-- 
    Document   : countList
    Created on : 2025年4月19日, 下午12:21:54
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
    <title>Inventory Counts - Fruit Management System</title>
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
        .status-badge {
            font-size: 0.85rem;
            padding: 0.35rem 0.65rem;
        }
        .table-responsive {
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.05);
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/shopHeader.jsp" />
    
    <div class="container-fluid mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Inventory Counts</h1>
            <div>
                <a href="${pageContext.request.contextPath}/shop/inventory?action=showCountForm" class="btn btn-success me-2">
                    <i class="fa fa-plus-circle me-1"></i> New Count
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
                <div class="card bg-primary text-white mb-3">
                    <div class="card-body py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-0">Total Counts</h6>
                                <h2 class="mt-2 mb-0">${counts.size()}</h2>
                            </div>
                            <i class="fa fa-clipboard-check fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card bg-success text-white mb-3">
                    <div class="card-body py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-0">Completed</h6>
                                <h2 class="mt-2 mb-0">
                                    <jsp:useBean id="completedCount" class="java.lang.Integer" value="0" />
                                    <c:forEach var="count" items="${counts}">
                                        <c:if test="${count.status == 'completed'}">
                                            <jsp:setProperty name="completedCount" property="value" value="${completedCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${completedCount}
                                </h2>
                            </div>
                            <i class="fa fa-check-circle fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card bg-warning text-dark mb-3">
                    <div class="card-body py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-0">In Progress</h6>
                                <h2 class="mt-2 mb-0">
                                    <jsp:useBean id="inProgressCount" class="java.lang.Integer" value="0" />
                                    <c:forEach var="count" items="${counts}">
                                        <c:if test="${count.status == 'in_progress'}">
                                            <jsp:setProperty name="inProgressCount" property="value" value="${inProgressCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${inProgressCount}
                                </h2>
                            </div>
                            <i class="fa fa-spinner fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="card bg-danger text-white mb-3">
                    <div class="card-body py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-0">Cancelled</h6>
                                <h2 class="mt-2 mb-0">
                                    <jsp:useBean id="cancelledCount" class="java.lang.Integer" value="0" />
                                    <c:forEach var="count" items="${counts}">
                                        <c:if test="${count.status == 'cancelled'}">
                                            <jsp:setProperty name="cancelledCount" property="value" value="${cancelledCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${cancelledCount}
                                </h2>
                            </div>
                            <i class="fa fa-ban fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Counts Table -->
        <div class="card list-card mb-4">
            <div class="card-header bg-light">
                <h5 class="mb-0"><i class="fa fa-clipboard-list me-2"></i> Inventory Count History</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="countsTable" class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Started By</th>
                                <th>Completed By</th>
                                <th>Completion Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="count" items="${counts}">
                                <tr>
                                    <td>${count.countId}</td>
                                    <td><fmt:formatDate value="${count.countDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                    <td>
                                        <span class="badge bg-${count.statusColor} status-badge">
                                            ${count.formattedStatus}
                                        </span>
                                    </td>
                                    <td>${count.startedByName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${count.completedBy > 0}">
                                                ${count.completedByName}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${count.completedDate != null}">
                                                <fmt:formatDate value="${count.completedDate}" pattern="yyyy-MM-dd HH:mm" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/shop/inventory?action=viewCount&id=${count.countId}" class="btn btn-sm btn-primary">
                                            <i class="fa fa-eye"></i> View
                                        </a>
                                        
                                        <c:if test="${count.status == 'in_progress'}">
                                            <form action="${pageContext.request.contextPath}/shop/inventory" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="cancelCount">
                                                <input type="hidden" name="countId" value="${count.countId}">
                                                <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to cancel this count?');">
                                                    <i class="fa fa-times"></i> Cancel
                                                </button>
                                            </form>
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
                    <div class="col-md-4 mb-3">
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=showCountForm" class="btn btn-outline-primary d-block h-100 d-flex flex-column justify-content-center align-items-center py-3">
                            <i class="fa fa-clipboard-check fa-2x mb-2"></i>
                            Start New Inventory Count
                        </a>
                    </div>
                    <div class="col-md-4 mb-3">
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=list" class="btn btn-outline-success d-block h-100 d-flex flex-column justify-content-center align-items-center py-3">
                            <i class="fa fa-boxes-stacked fa-2x mb-2"></i>
                            View Current Inventory
                        </a>
                    </div>
                    <div class="col-md-4 mb-3">
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
    <script>
        $(document).ready(function() {
            $('#countsTable').DataTable({
                "order": [[ 1, "desc" ]], // Sort by date descending
                "pageLength": 10,
                "language": {
                    "emptyTable": "No inventory counts found"
                }
            });
        });
    </script>
</body>
</html>