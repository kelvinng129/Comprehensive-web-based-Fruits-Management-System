<%-- 
    Document   : countDetail
    Created on : 2025年4月19日, 下午12:11:43
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
    <title>Inventory Count Detail - Fruit Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .detail-card {
            box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            border: none;
        }
        .detail-card .card-header {
            border-radius: 10px 10px 0 0;
        }
        .count-info {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .status-badge {
            font-size: 1rem;
            padding: 0.5rem 1rem;
        }
        .discrepancy-positive {
            color: #198754;
        }
        .discrepancy-negative {
            color: #dc3545;
        }
        .no-discrepancy {
            color: #0d6efd;
        }
        .table-responsive {
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.05);
        }
        .count-actions {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
        }
        .input-actual {
            width: 100px;
        }
    </style>
</head>
<body>
    <jsp:include page="../include/shopHeader.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>
                Inventory Count 
                <small class="text-muted">#${count.countId}</small>
            </h1>
            <div>
                <a href="${pageContext.request.contextPath}/shop/inventory?action=listCounts" class="btn btn-outline-secondary me-2">
                    <i class="fa fa-list me-1"></i> All Counts
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
        
        <!-- Count Info -->
        <div class="row mb-4">
            <div class="col-md-8">
                <div class="card detail-card">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0"><i class="fa fa-clipboard-check me-2"></i> Count Information</h4>
                    </div>
                    <div class="card-body">
                        <div class="count-info">
                            <div class="row">
                                <div class="col-md-6">
                                    <p><strong>Location:</strong> ${count.locationName}</p>
                                    <p><strong>Started By:</strong> ${count.startedByName}</p>
                                    <p><strong>Started On:</strong> <fmt:formatDate value="${count.countDate}" pattern="yyyy-MM-dd HH:mm" /></p>
                                    <p><strong>Notes:</strong> 
                                        <c:choose>
                                            <c:when test="${not empty count.notes}">
                                                ${count.notes}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">No notes provided</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                                <div class="col-md-6">
                                    <div class="text-center mb-3">
                                        <span class="badge bg-${count.statusColor} status-badge">
                                            ${count.formattedStatus}
                                        </span>
                                    </div>
                                    
                                    <div class="text-center">
                                        <c:choose>
                                            <c:when test="${count.status == 'completed'}">
                                                <p><strong>Completed By:</strong> ${count.completedByName}</p>
                                                <p><strong>Completed On:</strong> <fmt:formatDate value="${count.completedDate}" pattern="yyyy-MM-dd HH:mm" /></p>
                                                <p><strong>Total Items:</strong> ${count.totalItems}</p>
                                                <p><strong>Discrepancies Found:</strong> ${count.totalDiscrepancies}</p>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="alert alert-info mb-0">
                                                    <i class="fa fa-info-circle me-2"></i> This count is still in progress. Complete the count to apply adjustments to inventory.
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Count Items Table -->
                        <h5 class="mb-3">Count Items</h5>
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>Fruit</th>
                                        <th class="text-center">Expected</th>
                                        <th class="text-center">Actual</th>
                                        <th class="text-center">Discrepancy</th>
                                        <th class="text-center">Status</th>
                                        <th class="text-end">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${count.items}">
                                        <tr>
                                            <td>${item.fruitName}</td>
                                            <td class="text-center">${item.expectedQuantity}</td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${count.status == 'in_progress'}">
                                                        <form action="${pageContext.request.contextPath}/shop/inventory" method="post" class="d-inline">
                                                            <input type="hidden" name="action" value="updateCountItem">
                                                            <input type="hidden" name="countItemId" value="${item.countItemId}">
                                                            <input type="hidden" name="countId" value="${count.countId}">
                                                            <input type="number" class="form-control form-control-sm input-actual" name="actualQuantity" value="${item.actualQuantity}" min="0">
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${item.actualQuantity}
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${item.discrepancy > 0}">
                                                        <span class="discrepancy-positive">+${item.discrepancy}</span>
                                                    </c:when>
                                                    <c:when test="${item.discrepancy < 0}">
                                                        <span class="discrepancy-negative">${item.discrepancy}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="no-discrepancy">0</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${item.discrepancy == 0}">
                                                        <span class="badge bg-success">Match</span>
                                                    </c:when>
                                                    <c:when test="${item.adjustmentApplied}">
                                                        <span class="badge bg-info">Adjusted</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning text-dark">Mismatch</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end">
                                                <c:if test="${count.status == 'in_progress'}">
                                                    <form action="${pageContext.request.contextPath}/shop/inventory" method="post" class="d-inline">
                                                        <input type="hidden" name="action" value="updateCountItem">
                                                        <input type="hidden" name="countItemId" value="${item.countItemId}">
                                                        <input type="hidden" name="countId" value="${count.countId}">
                                                        <input type="hidden" name="actualQuantity" value="${item.actualQuantity}">
                                                        <button type="submit" class="btn btn-sm btn-outline-primary">Update</button>
                                                    </form>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                                <tfoot class="table-light">
                                    <tr>
                                        <th>Total</th>
                                        <th class="text-center">
                                            <jsp:useBean id="totalExpected" class="java.lang.Integer"  />
                                            <c:forEach var="item" items="${count.items}">
                                                <jsp:setProperty name="totalExpected" property="value" value="${totalExpected + item.expectedQuantity}" />
                                            </c:forEach>
                                            ${totalExpected}
                                        </th>
                                        <th class="text-center">
                                            <jsp:useBean id="totalActual" class="java.lang.Integer" />
                                            <c:forEach var="item" items="${count.items}">
                                                <jsp:setProperty name="totalActual" property="value" value="${totalActual + item.actualQuantity}" />
                                            </c:forEach>
                                            ${totalActual}
                                        </th>
                                        <th class="text-center">
                                            <jsp:useBean id="totalDiscrepancy" class="java.lang.Integer"  />
                                            <c:forEach var="item" items="${count.items}">
                                                <jsp:setProperty name="totalDiscrepancy" property="value" value="${totalDiscrepancy + item.discrepancy}" />
                                            </c:forEach>
                                            <c:choose>
                                                <c:when test="${totalDiscrepancy > 0}">
                                                    <span class="discrepancy-positive">+${totalDiscrepancy}</span>
                                                </c:when>
                                                <c:when test="${totalDiscrepancy < 0}">
                                                    <span class="discrepancy-negative">${totalDiscrepancy}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="no-discrepancy">0</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </th>
                                        <th colspan="2"></th>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <!-- Count Actions -->
                <div class="card detail-card mb-4">
                    <div class="card-header bg-secondary text-white">
                        <h4 class="mb-0"><i class="fa fa-cogs me-2"></i> Count Actions</h4>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${count.status == 'in_progress'}">
                                <div class="count-actions">
                                    <div class="mb-4">
                                        <h5>Complete Inventory Count</h5>
                                        <p>Complete this count to apply all discrepancies as inventory adjustments.</p>
                                        <form action="${pageContext.request.contextPath}/shop/inventory" method="post">
                                            <input type="hidden" name="action" value="completeCount">
                                            <input type="hidden" name="countId" value="${count.countId}">
                                            <button type="submit" class="btn btn-success w-100" onclick="return confirm('Are you sure you want to complete this count and apply adjustments to inventory?');">
                                                <i class="fa fa-check-circle me-2"></i> Complete Count
                                            </button>
                                        </form>
                                    </div>
                                    
                                    <div>
                                        <h5>Cancel Inventory Count</h5>
                                        <p>Cancel this count without applying any adjustments.</p>
                                        <form action="${pageContext.request.contextPath}/shop/inventory" method="post">
                                            <input type="hidden" name="action" value="cancelCount">
                                            <input type="hidden" name="countId" value="${count.countId}">
                                            <button type="submit" class="btn btn-outline-danger w-100" onclick="return confirm('Are you sure you want to cancel this count? No changes will be made to inventory.');">
                                                <i class="fa fa-times-circle me-2"></i> Cancel Count
                                            </button>
                                        </form>
                                    </div>
                                </div>
                                
                                <div class="alert alert-warning mt-4">
                                    <div class="d-flex">
                                        <div class="me-3">
                                            <i class="fa fa-triangle-exclamation fa-2x"></i>
                                        </div>
                                        <div>
                                            <h5 class="alert-heading">Important!</h5>
                                            <p class="mb-0">Completing this count will apply all discrepancies as inventory adjustments. This action cannot be undone.</p>
                                        </div>
                                    </div>
                                </div>
                            </c:when>
                            <c:when test="${count.status == 'completed'}">
                                <div class="alert alert-success">
                                    <div class="d-flex">
                                        <div class="me-3">
                                            <i class="fa fa-check-circle fa-2x"></i>
                                        </div>
                                        <div>
                                            <h5 class="alert-heading">Count Completed</h5>
                                            <p>This inventory count has been completed and all adjustments have been applied.</p>
                                            <hr>
                                            <p class="mb-0">Completed on: <fmt:formatDate value="${count.completedDate}" pattern="yyyy-MM-dd HH:mm" /></p>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="count-actions">
                                    <h5>Count Summary</h5>
                                    <table class="table table-sm">
                                        <tr>
                                            <th>Total Items:</th>
                                            <td>${count.items.size()}</td>
                                        </tr>
                                        <tr>
                                            <th>Items with Discrepancies:</th>
                                            <td>${count.totalDiscrepancies}</td>
                                        </tr>
                                        <tr>
                                            <th>Initial Total:</th>
                                            <td>${totalExpected}</td>
                                        </tr>
                                        <tr>
                                            <th>Final Total:</th>
                                            <td>${totalActual}</td>
                                        </tr>
                                        <tr>
                                            <th>Net Adjustment:</th>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${totalDiscrepancy > 0}">
                                                        <span class="discrepancy-positive">+${totalDiscrepancy}</span>
                                                    </c:when>
                                                    <c:when test="${totalDiscrepancy < 0}">
                                                        <span class="discrepancy-negative">${totalDiscrepancy}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="no-discrepancy">0</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                
                                <div class="mt-4">
                                    <a href="${pageContext.request.contextPath}/shop/inventory?action=transactions" class="btn btn-outline-primary w-100">
                                        <i class="fa fa-clock-rotate-left me-2"></i> View Transactions
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-danger">
                                    <div class="d-flex">
                                        <div class="me-3">
                                            <i class="fa fa-times-circle fa-2x"></i>
                                        </div>
                                        <div>
                                            <h5 class="alert-heading">Count Cancelled</h5>
                                            <p class="mb-0">This inventory count was cancelled. No adjustments were made to inventory.</p>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="mt-4">
                                    <a href="${pageContext.request.contextPath}/shop/inventory?action=showCountForm" class="btn btn-primary w-100">
                                        <i class="fa fa-clipboard-check me-2"></i> Start New Count
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <!-- Count Tips -->
                <div class="card detail-card">
                    <div class="card-header bg-info text-white">
                        <h4 class="mb-0"><i class="fa fa-lightbulb me-2"></i> Count Tips</h4>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${count.status == 'in_progress'}">
                                <div class="alert alert-info">
                                    <i class="fa fa-info-circle me-2"></i> Enter the actual quantities for each item as you count them physically.
                                </div>
                                
                                <ul class="mb-0">
                                    <li class="mb-2">Count each fruit type separately and carefully</li>
                                    <li class="mb-2">Make sure to count all storage areas</li>
                                    <li class="mb-2">Keep track of any discrepancies as you go</li>
                                    <li class="mb-2">Click "Update" after entering each actual quantity</li>
                                    <li>When finished, click "Complete Count" to finalize</li>
                                </ul>
                            </c:when>
                            <c:otherwise>
                                <ul class="mb-0">
                                    <li class="mb-2">Regular inventory counts improve accuracy</li>
                                    <li class="mb-2">Investigate large discrepancies</li>
                                    <li class="mb-2">Consider implementing cycle counts</li>
                                    <li>Document your findings for future reference</li>
                                </ul>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../include/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>