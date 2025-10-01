<%-- 
    Document   : batchDetail
    Created on : 2025年4月19日, 下午12:12:21
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
    <title>Batch Details - Fruit Management System</title>
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
        .batch-info {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .detail-label {
            font-weight: 600;
            color: #6c757d;
        }
        .progress {
            height: 8px;
        }
        .freshness-indicator {
            font-weight: bold;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/shopHeader.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>
                Batch Details 
                <small class="text-muted">${batch.batchId}</small>
            </h1>
            <div>
                <a href="${pageContext.request.contextPath}/shop/inventory?action=listBatches" class="btn btn-outline-secondary me-2">
                    <i class="fa fa-list me-1"></i> All Batches
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
                    <div class="card-header bg-success text-white">
                        <h4 class="mb-0"><i class="fa fa-box me-2"></i> Batch Information</h4>
                    </div>
                    <div class="card-body">
                        <div class="batch-info">
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <h5>Basic Information</h5>
                                    <hr>
                                    <div class="mb-2">
                                        <span class="detail-label">Fruit:</span>
                                        <span class="fs-5 ms-2">${batch.fruitName}</span>
                                    </div>
                                    <div class="mb-2">
                                        <span class="detail-label">Batch ID:</span>
                                        <span>${batch.batchId}</span>
                                    </div>
                                    <div class="mb-2">
                                        <span class="detail-label">Quantity:</span>
                                        <span class="fs-5 badge bg-success">${batch.quantity}</span>
                                    </div>
                                    <div class="mb-2">
                                        <span class="detail-label">Location:</span>
                                        <span>${batch.locationName}</span>
                                    </div>
                                    <div class="mb-0">
                                        <span class="detail-label">Added By:</span>
                                        <span>${batch.addedByName}</span>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <h5>Dates & Tracking</h5>
                                    <hr>
                                    <div class="mb-2">
                                        <span class="detail-label">Received Date:</span>
                                        <span><fmt:formatDate value="${batch.receivedDate}" pattern="yyyy-MM-dd" /></span>
                                    </div>
                                    <div class="mb-2">
                                        <span class="detail-label">Expiry Date:</span>
                                        <c:choose>
                                            <c:when test="${not empty batch.expiryDate}">
                                                <span class="${batch.expiryStatusClass}">
                                                    <fmt:formatDate value="${batch.expiryDate}" pattern="yyyy-MM-dd" />
                                                    (${batch.daysUntilExpiry} days)
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Not specified</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="mb-2">
                                        <span class="detail-label">Supplier:</span>
                                        <c:choose>
                                            <c:when test="${not empty batch.supplierInfo}">
                                                <span>${batch.supplierInfo}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Not specified</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="mb-0">
                                        <span class="detail-label">Storage Conditions:</span>
                                        <c:choose>
                                            <c:when test="${not empty batch.storageConditions}">
                                                <span>${batch.storageConditions}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Not specified</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                            
                            <c:if test="${not empty batch.expiryDate}">
                                <h5>Freshness Status</h5>
                                <hr>
                                <c:set var="totalShelfLife" value="${batch.totalShelfLifeDays}" />
                                <c:set var="daysRemaining" value="${batch.daysUntilExpiry}" />
                                <c:set var="percentRemaining" value="${(daysRemaining / totalShelfLife) * 100}" />
                                <c:choose>
                                    <c:when test="${percentRemaining < 0}">
                                        <c:set var="percentRemaining" value="0" />
                                    </c:when>
                                    <c:when test="${percentRemaining > 100}">
                                        <c:set var="percentRemaining" value="100" />
                                    </c:when>
                                </c:choose>
                                
                                <div class="mb-2">
                                    <c:choose>
                                        <c:when test="${daysRemaining < 0}">
                                            <span class="freshness-indicator text-danger">
                                                Expired ${-daysRemaining} days ago
                                            </span>
                                        </c:when>
                                        <c:when test="${daysRemaining == 0}">
                                            <span class="freshness-indicator text-danger">
                                                Expires today
                                            </span>
                                        </c:when>
                                        <c:when test="${daysRemaining <= 3}">
                                            <span class="freshness-indicator text-danger">
                                                Expires in ${daysRemaining} days
                                            </span>
                                        </c:when>
                                        <c:when test="${daysRemaining <= 7}">
                                            <span class="freshness-indicator text-warning">
                                                Expires in ${daysRemaining} days
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="freshness-indicator text-success">
                                                Expires in ${daysRemaining} days
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div class="progress mb-2">
                                    <div class="progress-bar ${batch.expiryProgressClass}" role="progressbar" 
                                         style="width: ${percentRemaining}%" 
                                         aria-valuenow="${percentRemaining}" aria-valuemin="0" aria-valuemax="100">
                                    </div>
                                </div>
                                
                                <div class="d-flex justify-content-between">
                                    <small>Received: <fmt:formatDate value="${batch.receivedDate}" pattern="MMM d" /></small>
                                    <small>Expires: <fmt:formatDate value="${batch.expiryDate}" pattern="MMM d" /></small>
                                </div>
                            </c:if>
                            
                            <h5 class="mt-4">Notes</h5>
                            <hr>
                            <div class="p-3 bg-white rounded">
                                <c:choose>
                                    <c:when test="${not empty batch.notes}">
                                        <p class="mb-0">${batch.notes}</p>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-muted mb-0">No additional notes provided.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="d-flex justify-content-end gap-2">
                            <c:if test="${batch.quantity > 0}">
                                <a href="${pageContext.request.contextPath}/shop/inventory?action=showWastageForm&batchId=${batch.batchId}" class="btn btn-outline-danger">
                                    <i class="fa fa-trash-can me-1"></i> Record Wastage
                                </a>
                            </c:if>
                            <button type="button" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editBatchModal">
                                <i class="fa fa-edit me-1"></i> Edit Batch
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Related Transactions -->
                <div class="card detail-card">
                    <div class="card-header bg-info text-white">
                        <h4 class="mb-0"><i class="fa fa-clock-rotate-left me-2"></i> Batch Transactions</h4>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty batchTransactions}">
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover">
                                        <thead>
                                            <tr>
                                                <th>Date</th>
                                                <th>Type</th>
                                                <th>Quantity</th>
                                                <th>Performed By</th>
                                                <th>Notes</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="transaction" items="${batchTransactions}">
                                                <tr>
                                                    <td><fmt:formatDate value="${transaction.transactionDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                                    <td>
                                                        <span class="badge ${transaction.transactionTypeClass}">
                                                            ${transaction.formattedTransactionType}
                                                        </span>
                                                    </td>
                                                    <td class="${transaction.transactionTypeClass}">
                                                        ${transaction.formattedQuantityChange}
                                                    </td>
                                                    <td>${transaction.performedByName}</td>
                                                    <td>${transaction.reason}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info">
                                    <i class="fa fa-info-circle me-2"></i> No transactions found for this batch.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <!-- Current Quantity -->
                <div class="card detail-card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0"><i class="fa fa-box me-2"></i> Batch Quantity</h4>
                    </div>
                    <div class="card-body text-center">
                        <h5>${batch.fruitName}</h5>
                        <h1 class="display-4">
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
                        </h1>
                        <p class="text-muted">Current batch quantity</p>
                        
                        <c:if test="${batch.quantity > 0}">
                            <!-- Quick adjust quantity -->
                            <form action="${pageContext.request.contextPath}/shop/inventory" method="post" class="mt-3">
                                <input type="hidden" name="action" value="adjustBatchQuantity">
                                <input type="hidden" name="batchId" value="${batch.batchId}">
                                
                                <div class="input-group mb-3">
                                    <span class="input-group-text">Adjust</span>
                                    <input type="number" class="form-control" name="adjustmentQuantity" required>
                                    <button type="submit" class="btn btn-primary">Update</button>
                                </div>
                                <div class="form-text text-start">
                                    Enter a positive number to add or a negative number to reduce quantity.
                                </div>
                            </form>
                        </c:if>
                    </div>
                </div>
                
                <!-- Related Info -->
                <div class="card detail-card mb-4">
                    <div class="card-header bg-secondary text-white">
                        <h4 class="mb-0"><i class="fa fa-link me-2"></i> Related Information</h4>
                    </div>
                    <div class="card-body">
                        <div class="list-group">
                            <a href="${pageContext.request.contextPath}/shop/inventory?action=list" class="list-group-item list-group-item-action">
                                <i class="fa fa-boxes-stacked me-2"></i> Current Inventory
                            </a>
                            <a href="${pageContext.request.contextPath}/shop/inventory?action=showAdjustForm&fruitId=${batch.fruitId}" class="list-group-item list-group-item-action">
                                <i class="fa fa-edit me-2"></i> Adjust ${batch.fruitName} Inventory
                            </a>
                            <a href="${pageContext.request.contextPath}/shop/inventory?action=listBatches" class="list-group-item list-group-item-action">
                                <i class="fa fa-list me-2"></i> All Batches
                            </a>
                            <a href="${pageContext.request.contextPath}/shop/inventory?action=showBatchForm" class="list-group-item list-group-item-action">
                                <i class="fa fa-plus-circle me-2"></i> Add New Batch
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Batch Management Tips -->
                <div class="card detail-card">
                    <div class="card-header bg-info text-white">
                        <h4 class="mb-0"><i class="fa fa-lightbulb me-2"></i> Batch Management Tips</h4>
                    </div>
                    <div class="card-body">
                        <ul class="mb-0">
                            <li class="mb-2">Use FIFO (First In, First Out) rotation</li>
                            <li class="mb-2">Check expiry dates regularly</li>
                            <li class="mb-2">Keep batch records up to date</li>
                            <li class="mb-2">Store according to recommended conditions</li>
                            <li>Record any quality issues in notes</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Edit Batch Modal -->
    <div class="modal fade" id="editBatchModal" tabindex="-1" aria-labelledby="editBatchModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="editBatchModalLabel">Edit Batch ${batch.batchId}</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/shop/inventory" method="post">
                    <input type="hidden" name="action" value="updateBatch">
                    <input type="hidden" name="batchId" value="${batch.batchId}">
                    
                    <div class="modal-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="editExpiryDate" class="form-label">Expiry Date</label>
                                <input type="date" class="form-control" id="editExpiryDate" name="expiryDate" 
                                       value="<fmt:formatDate value="${batch.expiryDate}" pattern="yyyy-MM-dd" />">
                            </div>
                            <div class="col-md-6">
                                <label for="editSupplierInfo" class="form-label">Supplier Information</label>
                                <input type="text" class="form-control" id="editSupplierInfo" name="supplierInfo" 
                                       value="${batch.supplierInfo}">
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="editStorageConditions" class="form-label">Storage Conditions</label>
                                <input type="text" class="form-control" id="editStorageConditions" name="storageConditions"
                                       value="${batch.storageConditions}">
                            </div>
                            <div class="col-md-6">
                                <label for="editQuantity" class="form-label">Current Quantity</label>
                                <input type="number" class="form-control" id="editQuantity" name="quantity" 
                                       value="${batch.quantity}" min="0" required>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editNotes" class="form-label">Notes</label>
                            <textarea class="form-control" id="editNotes" name="notes" rows="3">${batch.notes}</textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
