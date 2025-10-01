<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wastage Details - Fruit Management System</title>
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
        .wastage-info {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .detail-label {
            font-weight: 600;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/shopHeader.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>
                Wastage Record 
                <small class="text-muted">#${wastage.wastageId}</small>
            </h1>
            <div>
                <a href="${pageContext.request.contextPath}/shop/inventory?action=listWastage" class="btn btn-outline-secondary me-2">
                    <i class="fa fa-list me-1"></i> All Wastage
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
        
        <div class="row">
            <div class="col-md-8">
                <div class="card detail-card mb-4">
                    <div class="card-header bg-danger text-white">
                        <h4 class="mb-0"><i class="fa fa-trash-can me-2"></i> Wastage Details</h4>
                    </div>
                    <div class="card-body">
                        <div class="wastage-info">
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <h5>Basic Information</h5>
                                    <hr>
                                    <div class="mb-2">
                                        <span class="detail-label">Fruit:</span>
                                        <span class="fs-5 ms-2">${wastage.fruitName}</span>
                                    </div>
                                    <div class="mb-2">
                                        <span class="detail-label">Location:</span>
                                        <span>${wastage.locationName}</span>
                                    </div>
                                    <div class="mb-2">
                                        <span class="detail-label">Date:</span>
                                        <span><fmt:formatDate value="${wastage.recordedDate}" pattern="yyyy-MM-dd HH:mm" /></span>
                                    </div>
                                    <div class="mb-0">
                                        <span class="detail-label">Recorded By:</span>
                                        <span>${wastage.recordedByName}</span>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <h5>Wastage Details</h5>
                                    <hr>
                                    <div class="mb-2">
                                        <span class="detail-label">Quantity:</span>
                                        <span class="fs-5 badge bg-danger">${wastage.quantity}</span>
                                    </div>
                                    <div class="mb-2">
                                        <span class="detail-label">Reason:</span>
                                        <span>${wastage.reason}</span>
                                    </div>
                                    <div class="mb-0">
                                        <span class="detail-label">Batch ID:</span>
                                        <c:choose>
                                            <c:when test="${not empty wastage.batchId}">
                                                <a href="${pageContext.request.contextPath}/shop/inventory?action=viewBatch&id=${wastage.batchId}">${wastage.batchId}</a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Not specified</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                            
                            <h5>Notes</h5>
                            <hr>
                            <div class="p-3 bg-white rounded">
                                <c:choose>
                                    <c:when test="${not empty wastage.notes}">
                                        <p class="mb-0">${wastage.notes}</p>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-muted mb-0">No additional notes provided.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <div class="alert alert-info">
                            <div class="d-flex">
                                <div class="me-3">
                                    <i class="fa fa-info-circle fa-2x"></i>
                                </div>
                                <div>
                                    <h5 class="alert-heading">Inventory Adjustment</h5>
                                    <p class="mb-0">This wastage record resulted in a reduction of <strong>${wastage.quantity} units</strong> from the inventory. The adjustment has been automatically applied and recorded in the system.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Transaction Info -->
                <div class="card detail-card">
                    <div class="card-header bg-info text-white">
                        <h4 class="mb-0"><i class="fa fa-receipt me-2"></i> Transaction Information</h4>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <tr>
                                    <th style="width: 30%">Transaction Type:</th>
                                    <td><span class="badge bg-danger">Wastage</span></td>
                                </tr>
                                <tr>
                                    <th>Previous Quantity:</th>
                                    <td>${wastage.previousQuantity}</td>
                                </tr>
                                <tr>
                                    <th>New Quantity:</th>
                                    <td>${wastage.previousQuantity - wastage.quantity}</td>
                                </tr>
                                <tr>
                                    <th>Change:</th>
                                    <td><span class="text-danger">-${wastage.quantity}</span></td>
                                </tr>
                                <tr>
                                    <th>Reference:</th>
                                    <td>Wastage Record #${wastage.wastageId}</td>
                                </tr>
                            </table>
                        </div>
                        
                        <div class="text-end mt-3">
                            <a href="${pageContext.request.contextPath}/shop/inventory?action=transactions" class="btn btn-outline-info">
                                <i class="fa fa-clock-rotate-left me-1"></i> View All Transactions
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <!-- Current Inventory -->
                <div class="card detail-card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0"><i class="fa fa-box me-2"></i> Current Inventory</h4>
                    </div>
                    <div class="card-body">
                        <div class="text-center mb-3">
                            <h5>${wastage.fruitName}</h5>
                            <h1 class="display-4">
                                <c:set var="currentQuantity" value="${wastage.previousQuantity - wastage.quantity}" />
                                <c:choose>
                                    <c:when test="${currentQuantity <= 0}">
                                        <span class="badge bg-danger">${currentQuantity}</span>
                                    </c:when>
                                    <c:when test="${currentQuantity <= 5}">
                                        <span class="badge bg-warning text-dark">${currentQuantity}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-success">${currentQuantity}</span>
                                    </c:otherwise>
                                </c:choose>
                            </h1>
                            <p class="text-muted">Current inventory quantity</p>
                        </div>
                        
                        <div class="text-center">
                            <a href="${pageContext.request.contextPath}/shop/inventory?action=showAdjustForm&fruitId=${wastage.fruitId}" class="btn btn-outline-primary">
                                <i class="fa fa-edit me-1"></i> Adjust Inventory
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Related Resources -->
                <div class="card detail-card mb-4">
                    <div class="card-header bg-secondary text-white">
                        <h4 class="mb-0"><i class="fa fa-link me-2"></i> Related Resources</h4>
                    </div>
                    <div class="card-body">
                        <div class="list-group">
                            <a href="${pageContext.request.contextPath}/shop/inventory?action=list" class="list-group-item list-group-item-action">
                                <i class="fa fa-boxes-stacked me-2"></i> Current Inventory
                            </a>
                            <c:if test="${not empty wastage.batchId}">
                                <a href="${pageContext.request.contextPath}/shop/inventory?action=viewBatch&id=${wastage.batchId}" class="list-group-item list-group-item-action">
                                    <i class="fa fa-box me-2"></i> Related Batch
                                </a>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/shop/inventory?action=listWastage" class="list-group-item list-group-item-action">
                                <i class="fa fa-trash-can me-2"></i> All Wastage Records
                            </a>
                            <a href="${pageContext.request.contextPath}/shop/inventory?action=showWastageForm" class="list-group-item list-group-item-action">
                                <i class="fa fa-plus me-2"></i> Record New Wastage
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Wastage Tips -->
                <div class="card detail-card">
                    <div class="card-header bg-info text-white">
                        <h4 class="mb-0"><i class="fa fa-lightbulb me-2"></i> Wastage Reduction Tips</h4>
                    </div>
                    <div class="card-body">
                        <ul class="mb-0">
                            <li class="mb-2">Monitor expiry dates regularly</li>
                            <li class="mb-2">Use FIFO (First In, First Out) approach</li>
                            <li class="mb-2">Optimize storage conditions</li>
                            <li class="mb-2">Implement proper handling procedures</li>
                            <li class="mb-2">Train staff on proper rotation practices</li>
                            <li>Analyze wastage patterns to identify issues</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>