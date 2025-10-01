<%-- 
    Document   : reservationStatusUpdates
    Created on : 2025年4月19日, 下午1:41:43
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
    <title>Status Updates - Fruit Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .updates-card {
            box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.1);
            border-radius: 15px;
            border: none;
        }
        .updates-card .card-header {
            border-radius: 15px 15px 0 0;
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
        .status-badge {
            font-size: 0.8rem;
            padding: 0.35rem 0.65rem;
            border-radius: 50rem;
        }
        .dashboard-filters {
            background-color: #f8f9fa;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.05);
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/shopHeader.jsp" />
    
    <div class="container mt-4 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Reservation Status Updates</h1>
            <div>
                <a href="${pageContext.request.contextPath}/shop/reservation?action=viewReservation&id=${reservationId}" class="btn btn-outline-primary me-2">
                    <i class="fas fa-eye me-1"></i> View Reservation
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
        
        <!-- Filters Section -->
        <div class="dashboard-filters mb-4">
            <form action="${pageContext.request.contextPath}/shop/reservation" method="get" id="filterForm">
                <input type="hidden" name="action" value="viewStatusUpdates">
                <input type="hidden" name="reservationId" value="${reservationId}">
                <div class="row align-items-end">
                    <div class="col-md-4 mb-3 mb-md-0">
                        <label for="statusFilter" class="form-label">Filter by Status</label>
                        <select class="form-select" id="statusFilter" name="status">
                            <option value="">All Status Updates</option>
                            <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Pending</option>
                            <option value="approved" ${param.status == 'approved' ? 'selected' : ''}>Approved</option>
                            <option value="processing" ${param.status == 'processing' ? 'selected' : ''}>Processing</option>
                            <option value="shipped" ${param.status == 'shipped' ? 'selected' : ''}>Shipped</option>
                            <option value="delivered" ${param.status == 'delivered' ? 'selected' : ''}>Delivered</option>
                            <option value="cancelled" ${param.status == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                        </select>
                    </div>
                    <div class="col-md-5 mb-3 mb-md-0">
                        <label for="dateRange" class="form-label">Date Range</label>
                        <div class="input-group">
                            <input type="date" class="form-control" id="startDate" name="startDate" value="${param.startDate}">
                            <span class="input-group-text">to</span>
                            <input type="date" class="form-control" id="endDate" name="endDate" value="${param.endDate}">
                        </div>
                    </div>
                    <div class="col-md-3 mb-3 mb-md-0 d-grid">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-filter me-1"></i> Apply Filters
                        </button>
                    </div>
                </div>
            </form>
        </div>
        
        <div class="row">
            <!-- Status Timeline -->
            <div class="col-lg-8">
                <div class="card updates-card">
                    <div class="card-header bg-primary text-white py-3">
                        <h4 class="mb-0"><i class="fas fa-history me-2"></i> Status Timeline</h4>
                    </div>
                    <div class="card-body">
                        <div class="tracking-timeline">
                            <c:choose>
                                <c:when test="${not empty statusUpdates}">
                                    <c:forEach var="update" items="${statusUpdates}" varStatus="status">
                                        <div class="timeline-item ${update.status == 'cancelled' ? 'cancelled' : (update.status == 'delivered' ? 'completed' : '')}">
                                            <div class="timeline-content">
                                                <div class="d-flex justify-content-between">
                                                    <span class="status-badge bg-${update.statusColor} mb-2">${update.formattedStatus}</span>
                                                    <small class="text-muted">
                                                        <fmt:formatDate value="${update.updateDate}" pattern="yyyy-MM-dd HH:mm" />
                                                    </small>
                                                </div>
                                                <p class="mb-1">${update.updateMessage}</p>
                                                <div class="d-flex justify-content-between align-items-center mt-2">
                                                    <small class="text-muted">
                                                        <c:if test="${not empty update.updatedByName}">
                                                            Updated by: ${update.updatedByName}
                                                        </c:if>
                                                    </small>
                                                    <c:if test="${not empty update.location}">
                                                        <small class="badge bg-light text-dark">
                                                            <i class="fas fa-map-marker-alt me-1"></i> ${update.location}
                                                        </small>
                                                    </c:if>
                                                </div>
                                                <c:if test="${not empty update.notes}">
                                                    <div class="alert alert-light mt-2 mb-0 py-2 px-3">
                                                        <small class="mb-0"><i class="fas fa-sticky-note me-1 text-muted"></i> ${update.notes}</small>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-5">
                                        <i class="fas fa-hourglass text-muted fa-3x mb-3"></i>
                                        <h5 class="text-muted">No status updates found</h5>
                                        <p class="text-muted">Status updates will appear here as they happen.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Sidebar -->
            <div class="col-lg-4">
                <!-- Reservation Details -->
                <div class="card updates-card mb-4">
                    <div class="card-header bg-info text-white py-3">
                        <h4 class="mb-0"><i class="fas fa-info-circle me-2"></i> Reservation Details</h4>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <span class="fw-bold">Reservation ID:</span>
                            <span class="float-end">#${reservation.reservationId}</span>
                        </div>
                        <div class="mb-3">
                            <span class="fw-bold">Created Date:</span>
                            <span class="float-end"><fmt:formatDate value="${reservation.reservationDate}" pattern="yyyy-MM-dd" /></span>
                        </div>
                        <div class="mb-3">
                            <span class="fw-bold">Expected Delivery:</span>
                            <span class="float-end">
                                <c:choose>
                                    <c:when test="${not empty reservation.expectedDeliveryDate}">
                                        <fmt:formatDate value="${reservation.expectedDeliveryDate}" pattern="yyyy-MM-dd" />
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Not specified</span>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="mb-3">
                            <span class="fw-bold">Current Status:</span>
                            <span class="float-end">
                                <span class="status-badge bg-${reservation.statusColor}">
                                    ${reservation.formattedStatus}
                                </span>
                            </span>
                        </div>
                        <div class="mb-3">
                            <span class="fw-bold">Source Warehouse:</span>
                            <span class="float-end">${reservation.sourceWarehouseName}</span>
                        </div>
                        <div class="mb-3">
                            <span class="fw-bold">Items:</span>
                            <span class="float-end">${reservation.itemCount} items</span>
                        </div>
                        <div class="mb-3">
                            <span class="fw-bold">Last Updated:</span>
                            <span class="float-end"><fmt:formatDate value="${reservation.lastUpdated}" pattern="yyyy-MM-dd HH:mm" /></span>
                        </div>
                        
                        <div class="d-grid mt-4">
                            <a href="${pageContext.request.contextPath}/shop/reservation?action=viewReservation&id=${reservation.reservationId}" class="btn btn-primary">
                                <i class="fas fa-eye me-1"></i> View Full Details
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Expected Timeline -->
                <div class="card updates-card">
                    <div class="card-header bg-secondary text-white py-3">
                        <h4 class="mb-0"><i class="fas fa-calendar-alt me-2"></i> Expected Timeline</h4>
                    </div>
                    <div class="card-body">
                        <ul class="list-group">
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <i class="fas fa-calendar-plus text-primary me-2"></i> Reservation Created
                                </div>
                                <span><fmt:formatDate value="${reservation.reservationDate}" pattern="MMM d" /></span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <i class="fas fa-clipboard-check text-primary me-2"></i> Approval Expected
                                </div>
                                <span>
                                    <c:choose>
                                        <c:when test="${not empty expectedApprovalDate}">
                                            <fmt:formatDate value="${expectedApprovalDate}" pattern="MMM d" />
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">~1-2 days</span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <i class="fas fa-box-open text-primary me-2"></i> Processing Expected
                                </div>
                                <span>
                                    <c:choose>
                                        <c:when test="${not empty expectedProcessingDate}">
                                            <fmt:formatDate value="${expectedProcessingDate}" pattern="MMM d" />
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">~2-3 days</span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <i class="fas fa-shipping-fast text-primary me-2"></i> Shipping Expected
                                </div>
                                <span>
                                    <c:choose>
                                        <c:when test="${not empty expectedShippingDate}">
                                            <fmt:formatDate value="${expectedShippingDate}" pattern="MMM d" />
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">~3-5 days</span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <i class="fas fa-check-circle text-success me-2"></i> Delivery Expected
                                </div>
                                <span>
                                    <c:choose>
                                        <c:when test="${not empty reservation.expectedDeliveryDate}">
                                            <fmt:formatDate value="${reservation.expectedDeliveryDate}" pattern="MMM d" />
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Not set</span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </li>
                        </ul>
                        
                        <div class="alert alert-light mt-3 mb-0">
                            <small class="mb-0 text-muted">
                                <i class="fas fa-info-circle me-1"></i> These dates are estimated and may change based on warehouse processing times and shipping conditions.
                            </small>
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
                $('.alert-dismissible').alert('close');
            }, 5000);
            
            // Auto-submit form when filters change
            $('#statusFilter').change(function() {
                $('#filterForm').submit();
            });
        });
    </script>
</body>
</html>
