<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservation Dashboard - Fruit Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .dashboard-card {
            box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.1);
            border-radius: 15px;
            border: none;
            transition: transform 0.3s;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        .stat-card {
            color: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        }
        .stat-icon {
            font-size: 2.5rem;
            opacity: 0.7;
        }
        .quick-action-button {
            border-radius: 10px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            transition: all 0.3s;
        }
        .quick-action-button:hover {
            transform: translateY(-3px);
            box-shadow: 0px 6px 12px rgba(0, 0, 0, 0.15);
        }
        .status-badge {
            font-size: 0.8rem;
            padding: 0.35rem 0.65rem;
            border-radius: 50rem;
        }
        .timeline-item {
            position: relative;
            padding-left: 28px;
            padding-bottom: 20px;
        }
        .timeline-item:before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            width: 2px;
            background-color: #dee2e6;
        }
        .timeline-item:after {
            content: '';
            position: absolute;
            left: -4px;
            top: 8px;
            height: 10px;
            width: 10px;
            border-radius: 50%;
            background-color: #0d6efd;
            z-index: 1;
        }
        .timeline-content {
            padding: 10px 15px;
            background-color: #f8f9fa;
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/shopHeader.jsp" />
    
    <div class="container-fluid mt-4">
        <h1 class="mb-4">Reservation Dashboard</h1>
        
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
        
        <!-- Stats Cards Row -->
        <div class="row mb-4">
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="stat-card bg-primary">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-uppercase mb-1">Total Reservations</h6>
                            <h2 class="mb-0">${totalReservations}</h2>
                            <div class="small text-white-50">All time</div>
                        </div>
                        <i class="fas fa-shopping-cart stat-icon"></i>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="stat-card bg-success">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-uppercase mb-1">Completed</h6>
                            <h2 class="mb-0">${completedReservations}</h2>
                            <div class="small text-white-50">Successfully delivered</div>
                        </div>
                        <i class="fas fa-check-circle stat-icon"></i>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="stat-card bg-warning text-dark">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-uppercase mb-1">Pending</h6>
                            <h2 class="mb-0">${pendingReservations}</h2>
                            <div class="small text-dark">Awaiting approval</div>
                        </div>
                        <i class="fas fa-clock stat-icon"></i>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="stat-card bg-info">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-uppercase mb-1">On Transit</h6>
                            <h2 class="mb-0">${onTransitReservations}</h2>
                            <div class="small text-white-50">Currently in delivery</div>
                        </div>
                        <i class="fas fa-truck stat-icon"></i>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Quick Actions Row -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card dashboard-card">
                    <div class="card-header bg-light">
                        <h5 class="mb-0"><i class="fas fa-bolt me-2"></i> Quick Actions</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3 mb-3">
                                <a href="${pageContext.request.contextPath}/shop/reservation?action=showReservationForm" class="btn btn-primary quick-action-button w-100 h-100 py-4">
                                    <i class="fas fa-plus-circle fa-2x mb-2"></i>
                                    <div>Create New Reservation</div>
                                </a>
                            </div>
                            <div class="col-md-3 mb-3">
                                <a href="${pageContext.request.contextPath}/shop/reservation?action=viewSourceInventory" class="btn btn-success quick-action-button w-100 h-100 py-4">
                                    <i class="fas fa-warehouse fa-2x mb-2"></i>
                                    <div>View Source Inventory</div>
                                </a>
                            </div>
                            <div class="col-md-3 mb-3">
                                <a href="${pageContext.request.contextPath}/shop/reservation?action=viewMyReservations" class="btn btn-info quick-action-button w-100 h-100 py-4">
                                    <i class="fas fa-clipboard-list fa-2x mb-2"></i>
                                    <div>My Reservations</div>
                                </a>
                            </div>
                            <div class="col-md-3 mb-3">
                                <a href="${pageContext.request.contextPath}/shop/reservation?action=viewReservationHistory" class="btn btn-secondary quick-action-button w-100 h-100 py-4">
                                    <i class="fas fa-history fa-2x mb-2"></i>
                                    <div>Reservation History</div>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Recent Reservations and Status Updates -->
        <div class="row">
            <!-- Recent Reservations -->
            <div class="col-lg-8 mb-4">
                <div class="card dashboard-card h-100">
                    <div class="card-header bg-light d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="fas fa-clipboard-list me-2"></i> Recent Reservations</h5>
                        <a href="${pageContext.request.contextPath}/shop/reservation?action=viewMyReservations" class="btn btn-sm btn-outline-primary">View All</a>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty recentReservations}">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Reservation ID</th>
                                                <th>Date</th>
                                                <th>Items</th>
                                                <th>Source</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="reservation" items="${recentReservations}">
                                                <tr>
                                                    <td><strong>#${reservation.reservationId}</strong></td>
                                                    <td><fmt:formatDate value="${reservation.reservationDate}" pattern="yyyy-MM-dd" /></td>
                                                    <td>${reservation.itemCount} items</td>
                                                    <td>${reservation.sourceWarehouseName}</td>
                                                    <td>
                                                        <span class="status-badge bg-${reservation.statusColor}">
                                                            ${reservation.formattedStatus}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/shop/reservation?action=viewReservation&id=${reservation.reservationId}" class="btn btn-sm btn-outline-primary">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <c:if test="${reservation.status == 'pending'}">
                                                            <a href="${pageContext.request.contextPath}/shop/reservation?action=editReservation&id=${reservation.reservationId}" class="btn btn-sm btn-outline-warning">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/shop/reservation?action=cancelReservation&id=${reservation.reservationId}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Are you sure you want to cancel this reservation?')">
                                                                <i class="fas fa-times"></i>
                                                            </a>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="fas fa-clipboard fa-3x mb-3 text-muted"></i>
                                    <h5 class="text-muted">No recent reservations found</h5>
                                    <a href="${pageContext.request.contextPath}/shop/reservation?action=showReservationForm" class="btn btn-primary mt-3">
                                        Create New Reservation
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <!-- Status Updates -->
            <div class="col-lg-4 mb-4">
                <div class="card dashboard-card h-100">
                    <div class="card-header bg-light">
                        <h5 class="mb-0"><i class="fas fa-bell me-2"></i> Recent Status Updates</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty statusUpdates}">
                                <div class="timeline">
                                    <c:forEach var="update" items="${statusUpdates}">
                                        <div class="timeline-item">
                                            <div class="timeline-content">
                                                <div class="d-flex justify-content-between">
                                                    <span class="status-badge bg-${update.statusColor}">${update.formattedStatus}</span>
                                                    <small class="text-muted"><fmt:formatDate value="${update.updateDate}" pattern="yyyy-MM-dd HH:mm" /></small>
                                                </div>
                                                <p class="mb-1 mt-2">
                                                    <strong>Reservation #${update.reservationId}</strong>: ${update.updateMessage}
                                                </p>
                                                <small>
                                                    <a href="${pageContext.request.contextPath}/shop/reservation?action=viewReservation&id=${update.reservationId}">
                                                        View Details
                                                    </a>
                                                </small>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="fas fa-bell-slash fa-3x mb-3 text-muted"></i>
                                    <h5 class="text-muted">No recent updates</h5>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Upcoming Deliveries and Low Stock Alerts -->
        <div class="row">
            <!-- Upcoming Deliveries -->
            <div class="col-lg-6 mb-4">
                <div class="card dashboard-card h-100">
                    <div class="card-header bg-light">
                        <h5 class="mb-0"><i class="fas fa-truck me-2"></i> Upcoming Deliveries</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty upcomingDeliveries}">
                                <div class="list-group">
                                    <c:forEach var="delivery" items="${upcomingDeliveries}">
                                        <div class="list-group-item list-group-item-action">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h6 class="mb-1">Reservation #${delivery.reservationId}</h6>
                                                    <p class="mb-1 small">
                                                        <i class="fas fa-cube me-1"></i> ${delivery.itemCount} items from ${delivery.sourceWarehouseName}
                                                    </p>
                                                </div>
                                                <div class="text-end">
                                                    <span class="status-badge bg-${delivery.statusColor}">
                                                        ${delivery.formattedStatus}
                                                    </span>
                                                    <div class="small text-muted mt-1">
                                                        <c:choose>
                                                            <c:when test="${not empty delivery.estimatedDeliveryDate}">
                                                                <fmt:formatDate value="${delivery.estimatedDeliveryDate}" pattern="yyyy-MM-dd" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                Date pending
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="fas fa-truck fa-3x mb-3 text-muted"></i>
                                    <h5 class="text-muted">No upcoming deliveries</h5>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <!-- Low Stock Alerts -->
            <div class="col-lg-6 mb-4">
                <div class="card dashboard-card h-100">
                    <div class="card-header bg-light">
                        <h5 class="mb-0"><i class="fas fa-exclamation-triangle me-2"></i> Low Stock Alerts</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty lowStockItems}">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Fruit</th>
                                                <th>Current Stock</th>
                                                <th>Min. Level</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${lowStockItems}">
                                                <tr>
                                                    <td>${item.fruitName}</td>
                                                    <td>
                                                        <span class="text-danger fw-bold">${item.currentStock}</span>
                                                    </td>
                                                    <td>${item.minimumLevel}</td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/shop/reservation?action=showReservationForm&fruitId=${item.fruitId}" class="btn btn-sm btn-outline-primary">
                                                            Reserve
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/shop/borrow?action=showBorrowForm&fruitId=${item.fruitId}" class="btn btn-sm btn-outline-success">
                                                            Borrow
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="fas fa-check-circle fa-3x mb-3 text-success"></i>
                                    <h5 class="text-muted">All stock levels are adequate</h5>
                                </div>
                            </c:otherwise>
                        </c:choose>
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