<%-- 
    Document   : deliveryList
    Created on : 2025年4月20日, 上午4:19:18
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
    <title>${pageTitle} - Warehouse Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <style>
        .status-badge {
            font-size: 0.8rem;
            padding: 5px 8px;
        }
        .status-pending { background-color: #ffc107; }
        .status-in-transit { background-color: #0d6efd; color: white; }
        .status-delivered { background-color: #198754; color: white; }
        .status-cancelled { background-color: #dc3545; color: white; }
        
        .delivery-card {
            transition: transform 0.2s;
            border-radius: 10px;
            overflow: hidden;
        }
        .delivery-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .location-label {
            font-size: 0.8rem;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <jsp:include page="../include/header.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1>${pageTitle}</h1>
                <p class="text-muted">Manage and track deliveries across locations</p>
            </div>
            <div>
                <c:if test="${not isPendingView}">
                    <a href="${pageContext.request.contextPath}/warehouse/delivery/new" class="btn btn-primary">
                        <i class="fas fa-plus-circle"></i> New Delivery
                    </a>
                    <a href="${pageContext.request.contextPath}/warehouse/delivery/checkout" class="btn btn-success ms-2">
                        <i class="fas fa-truck-loading"></i> Checkout
                    </a>
                </c:if>
            </div>
        </div>
        
        <!-- Status Filter -->
        <c:if test="${not isPendingView}">
            <div class="card mb-4">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col-md-4">
                            <h5 class="mb-0">Filter Deliveries</h5>
                        </div>
                        <div class="col-md-8">
                            <div class="d-flex flex-wrap gap-2">
                                <a href="${pageContext.request.contextPath}/warehouse/delivery/list" 
                                   class="btn ${empty statusFilter ? 'btn-primary' : 'btn-outline-primary'}">
                                    All
                                </a>
                                <a href="${pageContext.request.contextPath}/warehouse/delivery/list?status=PENDING" 
                                   class="btn ${statusFilter eq 'PENDING' ? 'btn-primary' : 'btn-outline-primary'}">
                                    Pending
                                </a>
                                <a href="${pageContext.request.contextPath}/warehouse/delivery/list?status=IN_TRANSIT" 
                                   class="btn ${statusFilter eq 'IN_TRANSIT' ? 'btn-primary' : 'btn-outline-primary'}">
                                    In Transit
                                </a>
                                <a href="${pageContext.request.contextPath}/warehouse/delivery/list?status=DELIVERED" 
                                   class="btn ${statusFilter eq 'DELIVERED' ? 'btn-primary' : 'btn-outline-primary'}">
                                    Delivered
                                </a>
                                <a href="${pageContext.request.contextPath}/warehouse/delivery/list?status=CANCELLED" 
                                   class="btn ${statusFilter eq 'CANCELLED' ? 'btn-primary' : 'btn-outline-primary'}">
                                    Cancelled
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
        
        <!-- Deliveries List -->
        <div class="row">
            <c:choose>
                <c:when test="${not empty deliveries}">
                    <c:forEach var="delivery" items="${deliveries}">
                        <div class="col-md-6 mb-4">
                            <div class="card delivery-card h-100">
                                <div class="card-header d-flex justify-content-between align-items-center bg-light">
                                    <h5 class="mb-0">Delivery #${delivery.deliveryId}</h5>
                                    <span class="badge status-badge status-${delivery.status.toLowerCase()}">
                                        ${delivery.status}
                                    </span>
                                </div>
                                <div class="card-body">
                                    <div class="row mb-3">
                                        <div class="col-6">
                                            <div class="location-label">FROM</div>
                                            <div class="fw-bold">${delivery.sourceLocationName}</div>
                                        </div>
                                        <div class="col-6 text-end">
                                            <div class="location-label">TO</div>
                                            <div class="fw-bold">${delivery.destinationLocationName}</div>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <small class="text-muted">Tracking #:</small>
                                        <span class="ms-1">${delivery.trackingNumber}</span>
                                    </div>
                                    
                                    <div class="row mb-3">
                                        <div class="col-6">
                                            <small class="text-muted">Created:</small>
                                            <div>
                                                <fmt:formatDate value="${delivery.createdAt}" pattern="yyyy-MM-dd HH:mm" />
                                            </div>
                                        </div>
                                        <div class="col-6 text-end">
                                            <small class="text-muted">Type:</small>
                                            <div>${delivery.deliveryType}</div>
                                        </div>
                                    </div>
                                    
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <small class="text-muted">Items:</small>
                                            <span class="badge bg-secondary ms-1">${delivery.totalItems}</span>
                                        </div>
                                        
                                        <c:if test="${isPendingView && delivery.status eq 'IN_TRANSIT'}">
                                            <a href="${pageContext.request.contextPath}/warehouse/delivery/checkin?id=${delivery.deliveryId}" 
                                               class="btn btn-success btn-sm">
                                                <i class="fas fa-check-circle me-1"></i> Check In
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="card-footer bg-white">
                                    <a href="${pageContext.request.contextPath}/warehouse/delivery/details?id=${delivery.deliveryId}" 
                                       class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-info-circle me-1"></i> View Details
                                    </a>
                                    
                                    <c:if test="${delivery.status eq 'PENDING'}">
                                        <a href="${pageContext.request.contextPath}/warehouse/delivery/edit?id=${delivery.deliveryId}" 
                                           class="btn btn-outline-secondary btn-sm ms-1">
                                            <i class="fas fa-edit me-1"></i> Edit
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12">
                        <div class="card">
                            <div class="card-body text-center py-5">
                                <i class="fas fa-truck-loading fa-4x text-muted mb-3"></i>
                                <h4>No Deliveries Found</h4>
                                <p class="text-muted">
                                    <c:choose>
                                        <c:when test="${isPendingView}">
                                            There are no pending deliveries to check in at your location.
                                        </c:when>
                                        <c:when test="${not empty statusFilter}">
                                            No deliveries with status "${statusFilter}" were found.
                                        </c:when>
                                        <c:otherwise>
                                            No deliveries have been created yet.
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                
                                <c:if test="${not isPendingView}">
                                    <div class="mt-3">
                                        <a href="${pageContext.request.contextPath}/warehouse/delivery/new" class="btn btn-primary">
                                            <i class="fas fa-plus-circle me-1"></i> Create New Delivery
                                        </a>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <jsp:include page="../include/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>