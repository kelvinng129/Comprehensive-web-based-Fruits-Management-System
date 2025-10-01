<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Reservations - Fruit Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
    <style>
        .list-card {
            box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.1);
            border-radius: 15px;
            border: none;
        }
        .list-card .card-header {
            border-radius: 15px 15px 0 0;
        }
        .table-responsive {
            border-radius: 10px;
            overflow: hidden;
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
        .delivery-progress {
            height: 8px;
            border-radius: 4px;
        }
        .delivery-step {
            max-width: 120px;
            text-align: center;
            position: relative;
        }
        .delivery-step .step-icon {
            width: 40px;
            height: 40px;
            background-color: #e9ecef;
            color: #adb5bd;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 10px;
        }
        .delivery-step.active .step-icon {
            background-color: #0d6efd;
            color: white;
        }
        .delivery-step.completed .step-icon {
            background-color: #198754;
            color: white;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/shopHeader.jsp" />
    
    <div class="container-fluid mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>My Reservations</h1>
            <div>
                <a href="${pageContext.request.contextPath}/shop/reservation?action=showReservationForm" class="btn btn-primary me-2">
                    <i class="fas fa-plus-circle me-1"></i> Create Reservation
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
                <input type="hidden" name="action" value="viewMyReservations">
                <div class="row align-items-end">
                    <div class="col-md-3 mb-3 mb-md-0">
                        <label for="statusFilter" class="form-label">Filter by Status</label>
                        <select class="form-select" id="statusFilter" name="status">
                            <option value="">All Statuses</option>
                            <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Pending</option>
                            <option value="approved" ${param.status == 'approved' ? 'selected' : ''}>Approved</option>
                            <option value="processing" ${param.status == 'processing' ? 'selected' : ''}>Processing</option>
                            <option value="shipped" ${param.status == 'shipped' ? 'selected' : ''}>Shipped</option>
                            <option value="delivered" ${param.status == 'delivered' ? 'selected' : ''}>Delivered</option>
                            <option value="cancelled" ${param.status == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                        </select>
                    </div>
                    <div class="col-md-3 mb-3 mb-md-0">
                        <label for="sourceFilter" class="form-label">Filter by Source</label>
                        <select class="form-select" id="sourceFilter" name="sourceId">
                            <option value="">All Sources</option>
                            <c:forEach var="source" items="${sourceWarehouses}">
                                <option value="${source.warehouseId}" ${param.sourceId == source.warehouseId ? 'selected' : ''}>
                                    ${source.name}, ${source.country}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4 mb-3 mb-md-0">
                        <label for="dateRange" class="form-label">Date Range</label>
                        <div class="input-group">
                            <input type="date" class="form-control" id="startDate" name="startDate" value="${param.startDate}">
                            <span class="input-group-text">to</span>
                            <input type="date" class="form-control" id="endDate" name="endDate" value="${param.endDate}">
                        </div>
                    </div>
                    <div class="col-md-2 mb-3 mb-md-0 d-grid">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-filter me-1"></i> Apply Filters
                        </button>
                    </div>
                </div>
            </form>
        </div>
        
        <!-- Reservations List -->
        <div class="card list-card">
            <div class="card-header bg-light">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="fas fa-clipboard-list me-2"></i> My Reservations</h5>
                    <c:if test="${not empty param.status || not empty param.sourceId || not empty param.startDate}">
                        <a href="${pageContext.request.contextPath}/shop/reservation?action=viewMyReservations" class="btn btn-sm btn-outline-secondary">
                            <i class="fas fa-times me-1"></i> Clear Filters
                        </a>
                    </c:if>
                </div>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty reservations}">
                        <div class="table-responsive">
                            <table id="reservationsTable" class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Reservation ID</th>
                                        <th>Date</th>
                                        <th>Expected Delivery</th>
                                        <th>Source</th>
                                        <th>Items</th>
                                        <th>Status</th>
                                        <th>Progress</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="reservation" items="${reservations}">
                                        <tr>
                                            <td><strong>#${reservation.reservationId}</strong></td>
                                            <td><fmt:formatDate value="${reservation.reservationDate}" pattern="yyyy-MM-dd" /></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty reservation.expectedDeliveryDate}">
                                                        <fmt:formatDate value="${reservation.expectedDeliveryDate}" pattern="yyyy-MM-dd" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Not specified</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${reservation.sourceWarehouseName}</td>
                                            <td>
                                                <span class="badge bg-info">${reservation.itemCount}</span> items
                                            </td>
                                            <td>
                                                <span class="status-badge bg-${reservation.statusColor}">
                                                    ${reservation.formattedStatus}
                                                </span>
                                            </td>
                                            <td style="width: 200px;">
                                                <c:choose>
                                                    <c:when test="${reservation.status == 'cancelled'}">
                                                        <div class="progress delivery-progress">
                                                            <div class="progress-bar bg-danger" role="progressbar" style="width: 100%"></div>
                                                        </div>
                                                        <small class="text-danger">Cancelled</small>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="progress delivery-progress">
                                                            <div class="progress-bar bg-${reservation.statusColor}" role="progressbar" 
                                                                 style="width: ${reservation.progressPercentage}%" 
                                                                 aria-valuenow="${reservation.progressPercentage}" 
                                                                 aria-valuemin="0" aria-valuemax="100">
                                                            </div>
                                                        </div>
                                                        <small class="text-muted">${reservation.progressPercentage}% complete</small>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/shop/reservation?action=viewReservation&id=${reservation.reservationId}" class="btn btn-sm btn-primary">
                                                    <i class="fas fa-eye"></i> View
                                                </a>
                                                <c:if test="${reservation.status == 'pending'}">
                                                    <a href="${pageContext.request.contextPath}/shop/reservation?action=editReservation&id=${reservation.reservationId}" class="btn btn-sm btn-warning">
                                                        <i class="fas fa-edit"></i> Edit
                                                    </a>
                                                    <form action="${pageContext.request.contextPath}/shop/reservation" method="post" class="d-inline">
                                                        <input type="hidden" name="action" value="cancelReservation">
                                                        <input type="hidden" name="reservationId" value="${reservation.reservationId}">
                                                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to cancel this reservation?')">
                                                            <i class="fas fa-times"></i>
                                                        </button>
                                                    </form>
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
                            <i class="fas fa-clipboard fa-4x mb-3 text-muted"></i>
                            <h4 class="text-muted">No reservations found</h4>
                            <p class="text-muted">You haven't made any reservations yet, or none match your filter criteria.</p>
                            <a href="${pageContext.request.contextPath}/shop/reservation?action=showReservationForm" class="btn btn-primary mt-3">
                                <i class="fas fa-plus-circle me-1"></i> Create New Reservation
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- Delivery Process Information -->
        <div class="card list-card mt-4">
            <div class="card-header bg-light">
                <h5 class="mb-0"><i class="fas fa-truck me-2"></i> Reservation & Delivery Process</h5>
            </div>
            <div class="card-body">
                <div class="d-flex justify-content-between flex-wrap">
                    <div class="delivery-step completed">
                        <div class="step-icon">
                            <i class="fas fa-calendar-plus"></i>
                        </div>
                        <p class="small mb-0">Reservation Created</p>
                    </div>
                    <div class="delivery-step active">
                        <div class="step-icon">
                            <i class="fas fa-clipboard-check"></i>
                        </div>
                        <p class="small mb-0">Warehouse Approval</p>
                    </div>
                    <div class="delivery-step">
                        <div class="step-icon">
                            <i class="fas fa-box-open"></i>
                        </div>
                        <p class="small mb-0">Processing</p>
                    </div>
                    <div class="delivery-step">
                        <div class="step-icon">
                            <i class="fas fa-truck-loading"></i>
                        </div>
                        <p class="small mb-0">Shipped to Central</p>
                    </div>
                    <div class="delivery-step">
                        <div class="step-icon">
                            <i class="fas fa-warehouse"></i>
                        </div>
                        <p class="small mb-0">At Central Warehouse</p>
                    </div>
                    <div class="delivery-step">
                        <div class="step-icon">
                            <i class="fas fa-shipping-fast"></i>
                        </div>
                        <p class="small mb-0">Local Delivery</p>
                    </div>
                    <div class="delivery-step">
                        <div class="step-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <p class="small mb-0">Delivered</p>
                    </div>
                </div>
                
                <div class="row mt-4">
                    <div class="col-md-4">
                        <div class="card mb-3">
                            <div class="card-body">
                                <h5 class="card-title"><i class="fas fa-info-circle text-primary me-2"></i> About Reservations</h5>
                                <p class="card-text">Reservations allow you to secure fruits from source warehouses up to 14 days in advance. This helps ensure you have the ingredients you need for upcoming bakery needs.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card mb-3">
                            <div class="card-body">
                                <h5 class="card-title"><i class="fas fa-hourglass-half text-warning me-2"></i> Processing Times</h5>
                                <p class="card-text">Warehouse staff typically process reservations within 24-48 hours. International shipping times vary based on distance, but central warehouses prioritize deliveries based on expected delivery dates.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card mb-3">
                            <div class="card-body">
                                <h5 class="card-title"><i class="fas fa-exclamation-triangle text-danger me-2"></i> Important Notes</h5>
                                <p class="card-text">You can edit or cancel reservations only while they are in "Pending" status. Once approved, contact warehouse staff directly for any urgent changes.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#reservationsTable').DataTable({
                "order": [[ 1, "desc" ]], // Sort by date descending by default
                "pageLength": 10,
                "language": {
                    "emptyTable": "No reservations found"
                }
            });
            
            // Auto-dismiss alerts after 5 seconds
            setTimeout(function() {
                $('.alert').alert('close');
            }, 5000);
            
            // Auto-submit form when filters change
            $('#statusFilter, #sourceFilter').change(function() {
                $('#filterForm').submit();
            });
        });
    </script>
</body>
</html>