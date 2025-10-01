<%-- 
    Document   : deliveryDetails
    Created on : 2025年4月20日, 上午4:19:36
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
    <title>Delivery Details - Warehouse Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <style>
        .status-badge {
            font-size: 0.9rem;
            padding: 6px 10px;
        }
        .status-pending { background-color: #ffc107; }
        .status-in-transit { background-color: #0d6efd; color: white; }
        .status-delivered { background-color: #198754; color: white; }
        .status-cancelled { background-color: #dc3545; color: white; }
        
        .timeline {
            position: relative;
            padding-left: 30px;
        }
        .timeline-item {
            position: relative;
            padding-bottom: 25px;
        }
        .timeline-item:last-child {
            padding-bottom: 0;
        }
        .timeline-item::before {
            content: "";
            width: 2px;
            height: 100%;
            background-color: #dee2e6;
            position: absolute;
            left: -18px;
            top: 0;
        }
        .timeline-item:last-child::before {
            height: 0;
        }
        .timeline-point {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background-color: #0d6efd;
            position: absolute;
            left: -23px;
            top: 5px;
        }
        .timeline-date {
            color: #6c757d;
            font-size: 0.8rem;
            margin-bottom: 5px;
        }
        .status-point-pending { background-color: #ffc107; }
        .status-point-in-transit { background-color: #0d6efd; }
        .status-point-delivered { background-color: #198754; }
        .status-point-cancelled { background-color: #dc3545; }
    </style>
</head>
<body>
    <jsp:include page="../include/header.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1>Delivery #${delivery.deliveryId}</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/warehouse/delivery/list">Deliveries</a></li>
                        <li class="breadcrumb-item active">Delivery #${delivery.deliveryId}</li>
                    </ol>
                </nav>
            </div>
            <div>
                <c:if test="${delivery.status eq 'PENDING'}">
                    <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#cancelDeliveryModal">
                        <i class="fas fa-times-circle me-1"></i> Cancel Delivery
                    </button>
                    <a href="${pageContext.request.contextPath}/warehouse/delivery/edit?id=${delivery.deliveryId}" class="btn btn-primary">
                        <i class="fas fa-edit me-1"></i> Edit Delivery
                    </a>
                </c:if>
                
                <c:if test="${canCheckin}">
                    <a href="${pageContext.request.contextPath}/warehouse/delivery/checkin?id=${delivery.deliveryId}" class="btn btn-success">
                        <i class="fas fa-check-circle me-1"></i> Check In
                    </a>
                </c:if>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-8">
                <!-- Delivery Info -->
                <div class="card mb-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Delivery Information</h5>
                        <span class="badge status-badge status-${delivery.status.toLowerCase()}">${delivery.status}</span>
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
                                <label class="form-label text-muted">Delivery Type</label>
                                <div>${delivery.deliveryType}</div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted">Created By</label>
                                <div>${delivery.createdByName}</div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted">Created At</label>
                                <div><fmt:formatDate value="${delivery.createdAt}" pattern="yyyy-MM-dd HH:mm" /></div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted">Estimated Delivery Date</label>
                                <div>
                                    <c:choose>
                                        <c:when test="${not empty delivery.estimatedDeliveryDate}">
                                            <fmt:formatDate value="${delivery.estimatedDeliveryDate}" pattern="yyyy-MM-dd" />
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Not specified</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted">Actual Delivery Date</label>
                                <div>
                                    <c:choose>
                                        <c:when test="${not empty delivery.actualDeliveryDate}">
                                            <fmt:formatDate value="${delivery.actualDeliveryDate}" pattern="yyyy-MM-dd HH:mm" />
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Not delivered yet</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            
                            <c:if test="${not empty delivery.notes}">
                                <div class="col-12 mb-3">
                                    <label class="form-label text-muted">Notes</label>
                                    <div>${delivery.notes}</div>
                                </div>
                            </c:if>
                            
                            <c:if test="${delivery.status eq 'PENDING'}">
                                <div class="col-12 mt-3">
                                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#updateStatusModal">
                                        <i class="fas fa-truck me-1"></i> Mark as In Transit
                                    </button>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
                
                <!-- Delivery Items -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">Delivery Items</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty items}">
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover">
                                        <thead>
                                            <tr>
                                                <th>Fruit</th>
                                                <th>Quantity</th>
                                                <th>Unit Price</th>
                                                <th>Notes</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${items}">
                                                <tr>
                                                    <td>${item.fruitName}</td>
                                                    <td>${item.quantity}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty item.unitPrice}">
                                                                $${item.unitPrice}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">N/A</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${item.notes}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info">
                                    No items added to this delivery yet.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <!-- Delivery Status Timeline -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">Status Timeline</h5>
                    </div>
                    <div class="card-body">
                        <div class="timeline">
                            <c:forEach var="status" items="${statusHistory}">
                                <div class="timeline-item">
                                    <div class="timeline-point status-point-${status.status.toLowerCase()}"></div>
                                    <div class="timeline-date">
                                        <fmt:formatDate value="${status.statusDate}" pattern="yyyy-MM-dd HH:mm" />
                                    </div>
                                    <div class="fw-bold">${status.status}</div>
                                    <div>
                                        <span class="text-muted">By:</span> ${status.updatedByName}
                                    </div>
                                    <c:if test="${not empty status.comments}">
                                        <div class="mt-1">${status.comments}</div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
                
                <!-- Quick Links -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Quick Links</h5>
                    </div>
                    <div class="card-body">
                        <div class="list-group">
                            <a href="${pageContext.request.contextPath}/warehouse/delivery/list" class="list-group-item list-group-item-action">
                                <i class="fas fa-list me-2"></i> All Deliveries
                            </a>
                            <a href="${pageContext.request.contextPath}/warehouse/delivery/list?status=IN_TRANSIT" class="list-group-item list-group-item-action">
                                <i class="fas fa-truck me-2"></i> In Transit Deliveries
                            </a>
                            <a href="${pageContext.request.contextPath}/warehouse/delivery/tracking" class="list-group-item list-group-item-action">
                                <i class="fas fa-search me-2"></i> Track a Delivery
                            </a>
                            <a href="${pageContext.request.contextPath}/warehouse/delivery/checkout" class="list-group-item list-group-item-action">
                                <i class="fas fa-truck-loading me-2"></i> New Checkout
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Update Status Modal -->
    <div class="modal fade" id="updateStatusModal" tabindex="-1" aria-labelledby="updateStatusModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/warehouse/delivery" method="post">
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="deliveryId" value="${delivery.deliveryId}">
                    <input type="hidden" name="status" value="IN_TRANSIT">
                    
                    <div class="modal-header">
                        <h5 class="modal-title" id="updateStatusModalLabel">Mark as In Transit</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to mark this delivery as In Transit?</p>
                        
                        <div class="mb-3">
                            <label for="comments" class="form-label">Comments</label>
                            <textarea class="form-control" id="comments" name="comments" rows="3" 
                                      placeholder="Add any notes about this status change"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-truck me-1"></i> Mark as In Transit
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Cancel Delivery Modal -->
    <div class="modal fade" id="cancelDeliveryModal" tabindex="-1" aria-labelledby="cancelDeliveryModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/warehouse/delivery" method="post">
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="deliveryId" value="${delivery.deliveryId}">
                    <input type="hidden" name="status" value="CANCELLED">
                    
                    <div class="modal-header">
                        <h5 class="modal-title" id="cancelDeliveryModalLabel">Cancel Delivery</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Are you sure you want to cancel this delivery? This action cannot be undone.
                        </div>
                        
                        <div class="mb-3">
                            <label for="cancelComments" class="form-label">Reason for Cancellation</label>
                            <textarea class="form-control" id="cancelComments" name="comments" rows="3" 
                                      placeholder="Please provide a reason for cancellation" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-times-circle me-1"></i> Cancel Delivery
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <jsp:include page="../include/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>