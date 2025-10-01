<%-- 
    Document   : checkinForm
    Created on : 2025年4月20日, 上午5:22:13
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
    <title>Check-in Delivery #${delivery.deliveryId} - Warehouse Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <style>
        .checkin-container {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
        }
        .status-badge {
            font-size: 0.9rem;
            padding: 6px 10px;
        }
        .status-in-transit { background-color: #0d6efd; color: white; }
        .item-quantity-match { color: #198754; }
        .item-quantity-mismatch { color: #dc3545; }
    </style>
</head>
<body>
    <jsp:include page="../include/header.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1>Check-in Delivery #${delivery.deliveryId}</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/warehouse/delivery/list">Deliveries</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/warehouse/delivery/details?id=${delivery.deliveryId}">Delivery #${delivery.deliveryId}</a></li>
                        <li class="breadcrumb-item active">Check-in</li>
                    </ol>
                </nav>
            </div>
            <span class="badge status-badge status-in-transit">IN TRANSIT</span>
        </div>
        
        <div class="row">
            <div class="col-md-8">
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">Delivery Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted">Source Location</label>
                                <div class="fw-bold">${delivery.sourceLocationName}</div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted">Destination Location</label>
                                <div class="fw-bold">${delivery.destinationLocationName}</div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted">Tracking Number</label>
                                <div>${delivery.trackingNumber}</div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted">Created At</label>
                                <div><fmt:formatDate value="${delivery.createdAt}" pattern="yyyy-MM-dd HH:mm" /></div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Check-in Items</h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/warehouse/delivery" method="post" id="checkinForm">
                            <input type="hidden" name="action" value="checkin">
                            <input type="hidden" name="deliveryId" value="${delivery.deliveryId}">
                            
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Fruit</th>
                                            <th class="text-center">Expected Quantity</th>
                                            <th class="text-center">Received Quantity</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${items}">
                                            <tr>
                                                <td>
                                                    <div class="fw-bold">${item.fruitName}</div>
                                                    <c:if test="${not empty item.notes}">
                                                        <small class="text-muted">${item.notes}</small>
                                                    </c:if>
                                                </td>
                                                <td class="text-center">${item.quantity}</td>
                                                <td class="text-center">
                                                    <input type="number" class="form-control form-control-sm quantity-input text-center"
                                                           name="receivedQuantity_${item.fruitId}" 
                                                           value="${item.quantity}" min="0" max="${item.quantity * 2}"
                                                           data-expected="${item.quantity}">
                                                </td>
                                                <td>
                                                    <span class="quantity-status item-quantity-match">
                                                        <i class="fas fa-check-circle"></i> Match
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            
                            <div class="mb-3">
                                <label for="comments" class="form-label">Check-in Comments</label>
                                <textarea class="form-control" id="comments" name="comments" rows="3" 
                                          placeholder="Add any notes about this check-in"></textarea>
                            </div>
                            
                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/warehouse/delivery/details?id=${delivery.deliveryId}" 
                                   class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left me-1"></i> Back to Details
                                </a>
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-check-circle me-1"></i> Complete Check-in
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card mb-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">Check-in Instructions</h5>
                    </div>
                    <div class="card-body">
                        <ol class="mb-0">
                            <li class="mb-2">
                                <strong>Verify the items received</strong> - Count each fruit type and enter the actual quantity received.
                            </li>
                            <li class="mb-2">
                                <strong>Record any discrepancies</strong> - If there's a difference between expected and actual quantities, make sure to note it in the comments.
                            </li>
                            <li class="mb-2">
                                <strong>Check for damage</strong> - Inspect fruits for any damage and note in comments if necessary.
                            </li>
                            <li class="mb-2">
                                <strong>Complete the check-in</strong> - After verification, click the "Complete Check-in" button to update inventory.
                            </li>
                        </ol>
                        
                        <div class="alert alert-warning mt-4">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Once checked in, items will be added to your location's inventory automatically.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../include/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const quantityInputs = document.querySelectorAll('.quantity-input');
            
            quantityInputs.forEach(input => {
                input.addEventListener('input', function() {
                    const expected = parseInt(this.dataset.expected);
                    const actual = parseInt(this.value) || 0;
                    const statusEl = this.closest('tr').querySelector('.quantity-status');
                    
                    if (actual === expected) {
                        statusEl.className = 'quantity-status item-quantity-match';
                        statusEl.innerHTML = '<i class="fas fa-check-circle"></i> Match';
                    } else if (actual < expected) {
                        statusEl.className = 'quantity-status item-quantity-mismatch';
                        statusEl.innerHTML = '<i class="fas fa-exclamation-circle"></i> Short ' + (expected - actual);
                    } else if (actual > expected) {
                        statusEl.className = 'quantity-status item-quantity-mismatch';
                        statusEl.innerHTML = '<i class="fas fa-exclamation-circle"></i> Extra ' + (actual - expected);
                    }
                });
            });
            
            const checkinForm = document.getElementById('checkinForm');
            checkinForm.addEventListener('submit', function(event) {
                // Check if any quantity is zero
                let hasZeroQuantity = false;
                quantityInputs.forEach(input => {
                    if (parseInt(input.value) === 0) {
                        hasZeroQuantity = true;
                    }
                });
                
                if (hasZeroQuantity) {
                    const confirmed = confirm('One or more items have zero quantity. Continue with check-in?');
                    if (!confirmed) {
                        event.preventDefault();
                    }
                }
            });
        });
    </script>
</body>
</html>