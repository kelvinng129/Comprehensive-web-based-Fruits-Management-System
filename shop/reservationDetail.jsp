<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservation Details - Fruit Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .detail-card {
            box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.1);
            border-radius: 15px;
            border: none;
        }
        .detail-card .card-header {
            border-radius: 15px 15px 0 0;
        }
        .detail-section {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .detail-label {
            font-weight: 600;
            color: #6c757d;
        }
        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 50rem;
            font-weight: bold;
        }
        .tracking-timeline {
            position: relative;
            padding-left: 45px;
        }
        .tracking-timeline:before {
            content: '';
            position: absolute;
            left: 15px;
            top: 0;
            height: 100%;
            width: 2px;
            background-color: #dee2e6;
        }
        .timeline-item {
            position: relative;
            padding-bottom: 30px;
        }
        .timeline-item:last-child {
            padding-bottom: 0;
        }
        .timeline-item:before {
            content: '';
            position: absolute;
            left: -30px;
            top: 5px;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background-color: #0d6efd;
            z-index: 1;
        }
        .timeline-item.completed:before {
            background-color: #198754;
        }
        .timeline-item.pending:before {
            background-color: #ffc107;
        }
        .timeline-item.cancelled:before {
            background-color: #dc3545;
        }
        .timeline-content {
            padding: 15px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.05);
        }
        .step-progress {
            display: flex;
            justify-content: space-between;
            margin-bottom: 2rem;
            position: relative;
        }
        .step-progress:before {
            content: '';
            position: absolute;
            top: 15px;
            left: 0;
            width: 100%;
            height: 3px;
            background-color: #dee2e6;
            z-index: 0;
        }
        .step {
            z-index: 1;
            text-align: center;
            width: 14.28%; /* 7 steps */
        }
        .step-icon {
            width: 30px;
            height: 30px;
            background-color: #dee2e6;
            color: #6c757d;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            margin: 0 auto 10px;
        }
        .step.active .step-icon {
            background-color: #0d6efd;
            color: white;
        }
        .step.completed .step-icon {
            background-color: #198754;
            color: white;
        }
        .step-label {
            font-size: 0.75rem;
            font-weight: 500;
        }
        .step.active .step-label {
            color: #0d6efd;
            font-weight: 600;
        }
        .step.completed .step-label {
            color: #198754;
        }
    </style>
</head>
<body>
    
    <div class="container mt-4 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Reservation #${reservation.reservationId}</h1>
            <div>
                <a href="${pageContext.request.contextPath}/shop/reservation?action=viewMyReservations" class="btn btn-outline-secondary me-2">
                    <i class="fas fa-list me-1"></i> My Reservations
                </a>
                <a href="${pageContext.request.contextPath}/shop/reservation" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-1"></i> Dashboard
                </a>
            </div>
        </div>
        
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        
        <div class="row">
            <!-- Main Content Column -->
            <div class="col-lg-8">
                <!-- Status and Delivery Progress -->
                <div class="card detail-card mb-4">
                    <div class="card-header bg-primary text-white py-3">
                        <h4 class="mb-0"><i class="fas fa-truck me-2"></i> Delivery Status</h4>
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <span class="status-badge bg-${reservation.statusColor}">
                                    ${reservation.formattedStatus}
                                </span>
                            </div>
                            <div class="text-end">
                                <div class="detail-label">Expected Delivery</div>
                                <div class="fs-5">
                                    <c:choose>
                                        <c:when test="${not empty reservation.expectedDeliveryDate}">
                                            <fmt:formatDate value="${reservation.expectedDeliveryDate}" pattern="EEEE, MMMM d, yyyy" />
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Not specified</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Step Progress Visualization -->
                        <div class="step-progress">
                            <div class="step ${reservation.progressStep >= 1 ? 'completed' : (reservation.progressStep == 0.5 ? 'active' : '')}">
                                <div class="step-icon">
                                    <i class="fas fa-calendar-plus"></i>
                                </div>
                                <div class="step-label">Created</div>
                            </div>
                            <div class="step ${reservation.progressStep >= 2 ? 'completed' : (reservation.progressStep == 1.5 ? 'active' : '')}">
                                <div class="step-icon">
                                    <i class="fas fa-clipboard-check"></i>
                                </div>
                                <div class="step-label">Approved</div>
                            </div>
                            <div class="step ${reservation.progressStep >= 3 ? 'completed' : (reservation.progressStep == 2.5 ? 'active' : '')}">
                                <div class="step-icon">
                                    <i class="fas fa-box-open"></i>
                                </div>
                                <div class="step-label">Processing</div>
                            </div>
                            <div class="step ${reservation.progressStep >= 4 ? 'completed' : (reservation.progressStep == 3.5 ? 'active' : '')}">
                                <div class="step-icon">
                                    <i class="fas fa-truck-loading"></i>
                                </div>
                                <div class="step-label">Shipped</div>
                            </div>
                            <div class="step ${reservation.progressStep >= 5 ? 'completed' : (reservation.progressStep == 4.5 ? 'active' : '')}">
                                <div class="step-icon">
                                    <i class="fas fa-warehouse"></i>
                                </div>
                                <div class="step-label">At Central</div>
                            </div>
                            <div class="step ${reservation.progressStep >= 6 ? 'completed' : (reservation.progressStep == 5.5 ? 'active' : '')}">
                                <div class="step-icon">
                                    <i class="fas fa-shipping-fast"></i>
                                </div>
                                <div class="step-label">Local Delivery</div>
                            </div>
                            <div class="step ${reservation.progressStep >= 7 ? 'completed' : (reservation.progressStep == 6.5 ? 'active' : '')}">
                                <div class="step-icon">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div class="step-label">Delivered</div>
                            </div>
                        </div>
                        
                        <c:if test="${reservation.estimatedDeliveryDate != null && reservation.status != 'cancelled' && reservation.status != 'delivered'}">
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle me-2"></i> Expected arrival at your shop: 
                                <strong><fmt:formatDate value="${reservation.estimatedDeliveryDate}" pattern="EEEE, MMMM d, yyyy" /></strong>
                            </div>
                        </c:if>
                        
                        <c:if test="${reservation.status == 'cancelled'}">
                            <div class="alert alert-danger">
                                <i class="fas fa-exclamation-triangle me-2"></i> This reservation has been cancelled.
                                <c:if test="${not empty reservation.cancellationReason}">
                                    <div class="mt-2">Reason: ${reservation.cancellationReason}</div>
                                </c:if>
                            </div>
                        </c:if>
                        
                        <!-- Action Buttons -->
                        <div class="d-flex justify-content-end mt-3">
                            <c:if test="${reservation.status == 'pending'}">
                                <a href="${pageContext.request.contextPath}/shop/reservation?action=editReservation&id=${reservation.reservationId}" class="btn btn-warning me-2">
                                    <i class="fas fa-edit me-1"></i> Edit Reservation
                                </a>
                                <form action="${pageContext.request.contextPath}/shop/reservation" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="cancelReservation">
                                    <input type="hidden" name="reservationId" value="${reservation.reservationId}">
                                    <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to cancel this reservation?')">
                                        <i class="fas fa-times me-1"></i> Cancel Reservation
                                    </button>
                                </form>
                            </c:if>
                            
                            <c:if test="${reservation.status == 'delivered'}">
                                <a href="${pageContext.request.contextPath}/shop/inventory?action=receiveDelivery&reservationId=${reservation.reservationId}" class="btn btn-success">
                                    <i class="fas fa-clipboard-check me-1"></i> Record Receipt
                                </a>
                            </c:if>
                        </div>
                    </div>
                </div>
                
                <!-- Reservation Details -->
                <div class="card detail-card mb-4">
                    <div class="card-header bg-info text-white py-3">
                        <h4 class="mb-0"><i class="fas fa-info-circle me-2"></i> Reservation Information</h4>
                    </div>
                    <div class="card-body">
                        <div class="detail-section">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <div class="detail-label">Reservation ID</div>
                                        <div>#${reservation.reservationId}</div>
                                    </div>
                                    <div class="mb-3">
                                        <div class="detail-label">Created By</div>
                                        <div>${reservation.createdByName}</div>
                                    </div>
                                    <div class="mb-3">
                                        <div class="detail-label">Shop</div>
                                        <div>${reservation.shopName}</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <div class="detail-label">Reservation Date</div>
                                        <div><fmt:formatDate value="${reservation.reservationDate}" pattern="yyyy-MM-dd" /></div>
                                    </div>
                                    <div class="mb-3">
                                        <div class="detail-label">Expected Delivery Date</div>
                                        <div>
                                            <c:choose>
                                                <c:when test="${not empty reservation.expectedDeliveryDate}">
                                                    <fmt:formatDate value="${reservation.expectedDeliveryDate}" pattern="yyyy-MM-dd" />
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Not specified</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <div class="detail-label">Last Updated</div>
                                        <div><fmt:formatDate value="${reservation.lastUpdated}" pattern="yyyy-MM-dd HH:mm" /></div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="mb-3">
                                        <div class="detail-label">Source Warehouse</div>
                                        <div>${reservation.sourceWarehouseName} (${reservation.sourceWarehouseCity}, ${reservation.sourceWarehouseCountry})</div>
                                    </div>
                                </div>
                            </div>
                            
                            <c:if test="${not empty reservation.notes}">
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="mb-0">
                                            <div class="detail-label">Special Instructions</div>
                                            <div>${reservation.notes}</div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                        
                        <!-- Reserved Items -->
                        <h5 class="mb-3">Reserved Items</h5>
                        <div class="table-responsive mb-4">
                            <table class="table table-hover table-bordered">
                                <thead class="table-light">
                                    <tr>
                                        <th>Fruit</th>
                                        <th>Quantity</th>
                                        <th>Status</th>
                                        <th>Notes</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${reservationItems}">
                                        <tr>
                                            <td>${item.fruitName}</td>
                                            <td>${item.quantity}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${item.status == 'fulfilled'}">
                                                        <span class="badge bg-success">Fulfilled</span>
                                                    </c:when>
                                                    <c:when test="${item.status == 'partial'}">
                                                        <span class="badge bg-warning text-dark">Partial (${item.fulfilledQuantity}/${item.quantity})</span>
                                                    </c:when>
                                                    <c:when test="${item.status == 'cancelled'}">
                                                        <span class="badge bg-danger">Cancelled</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Pending</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty item.notes}">
                                                        ${item.notes}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">-</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        
                        <!-- Shipping Information (if available) -->
                        <c:if test="${reservation.status != 'pending' && reservation.status != 'cancelled'}">
                            <h5 class="mb-3">Shipping Information</h5>
                            <div class="detail-section">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <div class="detail-label">Tracking Number</div>
                                            <div>
                                                <c:choose>
                                                    <c:when test="${not empty reservation.trackingNumber}">
                                                        ${reservation.trackingNumber}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Not available yet</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <div class="detail-label">Shipping Method</div>
                                            <div>
                                                <c:choose>
                                                    <c:when test="${not empty reservation.shippingMethod}">
                                                        ${reservation.shippingMethod}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Not specified</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <div class="detail-label">Estimated Delivery Date</div>
                                            <div>
                                                <c:choose>
                                                    <c:when test="${not empty reservation.estimatedDeliveryDate}">
                                                        <fmt:formatDate value="${reservation.estimatedDeliveryDate}" pattern="yyyy-MM-dd" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Not available yet</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <div class="detail-label">Shipped Date</div>
                                            <div>
                                                <c:choose>
                                                    <c:when test="${not empty reservation.shippedDate}">
                                                        <fmt:formatDate value="${reservation.shippedDate}" pattern="yyyy-MM-dd" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Not shipped yet</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <c:if test="${not empty reservation.shippingNotes}">
                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="mb-0">
                                                <div class="detail-label">Shipping Notes</div>
                                                <div>${reservation.shippingNotes}</div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
            
            <!-- Sidebar Column -->
            <div class="col-lg-4">
                <!-- Status History -->
                <div class="card detail-card mb-4">
                    <div class="card-header bg-secondary text-white py-3">
                        <h4 class="mb-0"><i class="fas fa-history me-2"></i> Status History</h4>
                    </div>
                    <div class="card-body">
                        <div class="tracking-timeline">
                            <c:forEach var="update" items="${statusUpdates}" varStatus="status">
                                <div class="timeline-item ${update.status == 'cancelled' ? 'cancelled' : (update.status == 'delivered' ? 'completed' : '')}">
                                    <div class="timeline-content">
                                        <div class="d-flex justify-content-between">
                                            <span class="badge bg-${update.statusColor} mb-2">${update.formattedStatus}</span>
                                            <small class="text-muted">
                                                <fmt:formatDate value="${update.updateDate}" pattern="yyyy-MM-dd HH:mm" />
                                            </small>
                                        </div>
                                        <p class="mb-1">${update.updateMessage}</p>
                                        <c:if test="${not empty update.updatedByName}">
                                            <small class="text-muted">Updated by: ${update.updatedByName}</small>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty statusUpdates}">
                                <div class="text-center py-3">
                                    <i class="fas fa-hourglass-start text-muted mb-2"></i>
                                    <p class="text-muted mb-0">No status updates yet</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
                
                <!-- Contact Information -->
                <div class="card detail-card mb-4">
                    <div class="card-header bg-success text-white py-3">
                        <h4 class="mb-0"><i class="fas fa-address-card me-2"></i> Contact Information</h4>
                    </div>
                    <div class="card-body">
                        <div class="mb-4">
                            <h5 class="mb-3">Source Warehouse</h5>
                            <div>
                                <i class="fas fa-warehouse me-2"></i> ${reservation.sourceWarehouseName}
                            </div>
                            <div>
                                <i class="fas fa-map-marker-alt me-2"></i> ${reservation.sourceWarehouseCity}, ${reservation.sourceWarehouseCountry}
                            </div>
                            <c:if test="${not empty reservation.sourceWarehouseContact}">
                                <div>
                                    <i class="fas fa-phone me-2"></i> ${reservation.sourceWarehouseContact}
                                </div>
                            </c:if>
                            <c:if test="${not empty reservation.sourceWarehouseEmail}">
                                <div>
                                    <i class="fas fa-envelope me-2"></i> ${reservation.sourceWarehouseEmail}
                                </div>
                            </c:if>
                        </div>
                        
                        <div>
                            <h5 class="mb-3">Destination Shop</h5>
                            <div>
                                <i class="fas fa-store me-2"></i> ${reservation.shopName}
                            </div>
                            <div>
                                <i class="fas fa-map-marker-alt me-2"></i> ${reservation.shopCity}, ${reservation.shopCountry}
                            </div>
                            <c:if test="${not empty reservation.shopContact}">
                                <div>
                                    <i class="fas fa-phone me-2"></i> ${reservation.shopContact}
                                </div>
                            </c:if>
                            <c:if test="${not empty reservation.shopEmail}">
                                <div>
                                    <i class="fas fa-envelope me-2"></i> ${reservation.shopEmail}
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
                
                <!-- Related Actions -->
                <div class="card detail-card">
                    <div class="card-header bg-light py-3">
                        <h4 class="mb-0"><i class="fas fa-link me-2"></i> Related Actions</h4>
                    </div>
                    <div class="card-body">
                        <div class="list-group">
                            <a href="${pageContext.request.contextPath}/shop/reservation?action=viewMyReservations" class="list-group-item list-group-item-action">
                                <i class="fas fa-clipboard-list me-2"></i> View All Reservations
                            </a>
                            <c:if test="${reservation.status == 'pending'}">
                                <a href="${pageContext.request.contextPath}/shop/reservation?action=editReservation&id=${reservation.reservationId}" class="list-group-item list-group-item-action">
                                    <i class="fas fa-edit me-2"></i> Edit This Reservation
                                </a>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/shop/reservation?action=showReservationForm" class="list-group-item list-group-item-action">
                                <i class="fas fa-plus-circle me-2"></i> Create New Reservation
                            </a>
                            <a href="${pageContext.request.contextPath}/shop/reservation?action=viewSourceInventory&sourceId=${reservation.sourceWarehouseId}" class="list-group-item list-group-item-action">
                                <i class="fas fa-warehouse me-2"></i> View Source Inventory
                            </a>
                            <c:if test="${reservation.status == 'delivered'}">
                                <a href="${pageContext.request.contextPath}/shop/inventory?action=receiveDelivery&reservationId=${reservation.reservationId}" class="list-group-item list-group-item-action">
                                    <i class="fas fa-clipboard-check me-2"></i> Record Receipt
                                </a>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script>
        $(document).ready(function() {
            // Auto-dismiss alerts after 5 seconds
            setTimeout(function() {
                $('.alert').alert('close');
            }, 5000);
        });
    </script>
</body>
</html>