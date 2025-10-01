<%-- 
    Document   : deliveryTracking
    Created on : 2025年4月20日, 上午5:53:40
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
    <title>Delivery Tracking - Warehouse Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <style>
        .tracking-container {
            max-width: 600px;
            margin: 0 auto;
        }
        .tracking-search {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.05);
        }
        .tracking-results {
            margin-top: 30px;
        }
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
        .status-badge {
            font-size: 0.9rem;
            padding: 6px 10px;
        }
        .status-pending { background-color: #ffc107; }
        .status-in-transit { background-color: #0d6efd; color: white; }
        .status-delivered { background-color: #198754; color: white; }
        .status-cancelled { background-color: #dc3545; color: white; }
    </style>
</head>
<body>
    <jsp:include page="../include/header.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1>Track Delivery</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/warehouse/delivery/list">Deliveries</a></li>
                        <li class="breadcrumb-item active">Track Delivery</li>
                    </ol>
                </nav>
            </div>
        </div>
        
        <div class="tracking-container">
            <div class="tracking-search">
                <h4 class="mb-4">Enter Tracking Number</h4>
                <form action="${pageContext.request.contextPath}/warehouse/delivery/tracking" method="get">
                    <div class="input-group mb-3">
                        <input type="text" class="form-control form-control-lg" name="trackingNumber" 
                               placeholder="e.g. AB12345678" value="${param.trackingNumber}" required>
                        <button class="btn btn-primary" type="submit">
                            <i class="fas fa-search me-1"></i> Track
                        </button>
                    </div>
                </form>
            </div>
            
            <c:if test="${not empty param.trackingNumber}">
                <div class="tracking-results">
                    <c:choose>
                        <c:when test="${foundDelivery}">
                            <div class="card">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">Delivery #${delivery.deliveryId}</h5>
                                    <span class="badge status-badge status-${delivery.status.toLowerCase()}">${delivery.status}</span>
                                </div>
                                <div class="card-body">
                                    <div class="row mb-4">
                                        <div class="col-6">
                                            <div class="text-muted small">FROM</div>
                                            <div class="fw-bold">${delivery.sourceLocationName}</div>
                                        </div>
                                        <div class="col-6 text-end">
                                            <div class="text-muted small">TO</div>
                                            <div class="fw-bold">${delivery.destinationLocationName}</div>
                                        </div>
                                    </div>
                                    
                                    <div class="timeline">
                                        <c:forEach var="status" items="${statusHistory}">
                                            <div class="timeline-item">
                                                <div class="timeline-point"></div>
                                                <div class="timeline-date">
                                                    <fmt:formatDate value="${status.statusDate}" pattern="yyyy-MM-dd HH:mm" />
                                                </div>
                                                <div class="fw-bold">${status.status}</div>
                                                <c:if test="${not empty status.comments}">
                                                    <div class="mt-1">${status.comments}</div>
                                                </c:if>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    
                                    <c:if test="${delivery.status eq 'DELIVERED'}">
                                        <div class="alert alert-success mt-4">
                                            <i class="fas fa-check-circle me-2"></i>
                                            This delivery has been successfully completed on 
                                            <fmt:formatDate value="${delivery.actualDeliveryDate}" 
                                                            pattern="yyyy-MM-dd 'at' HH:mm" />
                                        </div>
                                    </c:if>
                                    
                                    <div class="text-center mt-4">
                                        <a href="${pageContext.request.contextPath}/warehouse/delivery/details?id=${delivery.deliveryId}" 
                                           class="btn btn-primary">
                                            <i class="fas fa-info-circle me-1"></i> View Full Details
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-danger">
                                <i class="fas fa-exclamation-circle me-2"></i>
                                <strong>Tracking number not found:</strong> ${param.trackingNumber}
                                <p class="mb-0 mt-2">
                                    Please check the tracking number and try again. If you continue to have issues, 
                                    contact warehouse support.
                                </p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </div>
    </div>
    
    <jsp:include page="../include/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>