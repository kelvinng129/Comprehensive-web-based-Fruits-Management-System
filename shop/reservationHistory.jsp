<%-- 
    Document   : reservationHistory
    Created on : 2025年4月19日, 下午1:09:06
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
    <title>Reservation History - Fruit Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.3.6/css/buttons.bootstrap5.min.css">
    <style>
        .history-card {
            box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.1);
            border-radius: 15px;
            border: none;
        }
        .history-card .card-header {
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
        .analytics-card {
            border-radius: 15px;
            margin-bottom: 20px;
            transition: transform 0.3s;
        }
        .analytics-card:hover {
            transform: translateY(-5px);
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/shopHeader.jsp" />
    
    <div class="container-fluid mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Reservation History</h1>
            <div>
                <a href="${pageContext.request.contextPath}/shop/reservation?action=viewMyReservations" class="btn btn-outline-primary me-2">
                    <i class="fas fa-clipboard-list me-1"></i> Active Reservations
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
        
        <!-- Analytics Cards -->
        <div class="row mb-4">
            <div class="col-md-3 mb-4 mb-md-0">
                <div class="card analytics-card bg-primary text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-1">Total Reservations</h6>
                                <h2 class="mb-0">${totalReservations}</h2>
                            </div>
                            <i class="fas fa-calendar-alt fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-4 mb-md-0">
                <div class="card analytics-card bg-success text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-1">Fulfilled</h6>
                                <h2 class="mb-0">${fulfilledReservations}</h2>
                            </div>
                            <i class="fas fa-check-circle fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-4 mb-md-0">
                <div class="card analytics-card bg-danger text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-1">Cancelled</h6>
                                <h2 class="mb-0">${cancelledReservations}</h2>
                            </div>
                            <i class="fas fa-times-circle fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-4 mb-md-0">
                <div class="card analytics-card bg-info text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="card-title mb-1">Avg. Delivery Time</h6>
                                <h2 class="mb-0">${averageDeliveryDays} days</h2>
                            </div>
                            <i class="fas fa-clock fa-3x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Filters Section -->
        <div class="dashboard-filters mb-4">
            <form action="${pageContext.request.contextPath}/shop/reservation" method="get" id="filterForm">
                <input type="hidden" name="action" value="viewReservationHistory">
                <div class="row align-items-end">
                    <div class="col-md-3 mb-3 mb-md-0">
                        <label for="statusFilter" class="form-label">Filter by Status</label>
                        <select class="form-select" id="statusFilter" name="status">
                            <option value="">All Statuses</option>
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
        
        <!-- History Table -->
        <div class="card history-card">
            <div class="card-header bg-light">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="fas fa-history me-2"></i> Reservation History</h5>
                    <c:if test="${not empty param.status || not empty param.sourceId || not empty param.startDate}">
                        <a href="${pageContext.request.contextPath}/shop/reservation?action=viewReservationHistory" class="btn btn-sm btn-outline-secondary">
                            <i class="fas fa-times me-1"></i> Clear Filters
                        </a>
                    </c:if>
                </div>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty reservations}">
                        <div class="table-responsive">
                            <table id="historyTable" class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Date</th>
                                        <th>Delivery Date</th>
                                        <th>Source</th>
                                        <th>Items</th>
                                        <th>Status</th>
                                        <th>Delivery Time</th>
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
                                                    <c:when test="${not empty reservation.deliveryDate}">
                                                        <fmt:formatDate value="${reservation.deliveryDate}" pattern="yyyy-MM-dd" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">N/A</span>
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
                                            <td>
                                                <c:choose>
                                                    <c:when test="${reservation.status == 'delivered' && not empty reservation.deliveryDays}">
                                                        ${reservation.deliveryDays} days
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">N/A</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/shop/reservation?action=viewReservation&id=${reservation.reservationId}" class="btn btn-sm btn-primary">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <c:if test="${reservation.status == 'delivered'}">
                                                    <a href="${pageContext.request.contextPath}/shop/reservation?action=printReservation&id=${reservation.reservationId}" class="btn btn-sm btn-info" target="_blank">
                                                        <i class="fas fa-print"></i>
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
                            <i class="fas fa-history fa-4x mb-3 text-muted"></i>
                            <h4 class="text-muted">No reservation history found</h4>
                            <p class="text-muted">There are no completed or cancelled reservations to display, or none match your filter criteria.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- History Charts -->
        <div class="row mt-4">
            <!-- Monthly Reservations Chart -->
            <div class="col-md-6 mb-4">
                <div class="card history-card h-100">
                    <div class="card-header bg-light">
                        <h5 class="mb-0"><i class="fas fa-chart-bar me-2"></i> Monthly Reservations</h5>
                    </div>
                    <div class="card-body">
                        <canvas id="monthlyReservationsChart" height="250"></canvas>
                    </div>
                </div>
            </div>
            
            <!-- Top Fruits Chart -->
            <div class="col-md-6 mb-4">
                <div class="card history-card h-100">
                    <div class="card-header bg-light">
                        <h5 class="mb-0"><i class="fas fa-chart-pie me-2"></i> Top Reserved Fruits</h5>
                    </div>
                    <div class="card-body">
                        <canvas id="topFruitsChart" height="250"></canvas>
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
    <script src="https://cdn.datatables.net/buttons/2.3.6/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.3.6/js/buttons.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.3.6/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.3.6/js/buttons.print.min.js"></script>
    <script>
        $(document).ready(function() {
            // Initialize DataTable
            $('#historyTable').DataTable({
                dom: 'Bfrtip',
                buttons: [
                    {
                        extend: 'excel',
                        text: '<i class="fas fa-file-excel me-1"></i> Excel',
                        className: 'btn btn-success btn-sm me-1',
                        exportOptions: {
                            columns: [0, 1, 2, 3, 4, 5, 6]
                        }
                    },
                    {
                        extend: 'pdf',
                        text: '<i class="fas fa-file-pdf me-1"></i> PDF',
                        className: 'btn btn-danger btn-sm me-1',
                        exportOptions: {
                            columns: [0, 1, 2, 3, 4, 5, 6]
                        }
                    },
                    {
                        extend: 'print',
                        text: '<i class="fas fa-print me-1"></i> Print',
                        className: 'btn btn-primary btn-sm',
                        exportOptions: {
                            columns: [0, 1, 2, 3, 4, 5, 6]
                        }
                    }
                ],
                "order": [[ 1, "desc" ]], // Sort by date descending by default
                "pageLength": 10,
                "language": {
                    "emptyTable": "No reservation history found"
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
            
            // Initialize charts
            initializeCharts();
        });
        
        function initializeCharts() {
            // Monthly Reservations Chart
            const monthlyCtx = document.getElementById('monthlyReservationsChart').getContext('2d');
            
            // Parse the JSON data from the server
            const monthlyData = ${monthlyReservationsJson};
            
            new Chart(monthlyCtx, {
                type: 'bar',
                data: {
                    labels: monthlyData.map(d => d.month),
                    datasets: [
                        {
                            label: 'Delivered',
                            backgroundColor: '#198754',
                            data: monthlyData.map(d => d.delivered)
                        },
                        {
                            label: 'Cancelled',
                            backgroundColor: '#dc3545',
                            data: monthlyData.map(d => d.cancelled)
                        }
                    ]
                },
                options: {
                    responsive: true,
                    scales: {
                        x: {
                            stacked: false
                        },
                        y: {
                            stacked: false,
                            beginAtZero: true
                        }
                    }
                }
            });
            
            // Top Fruits Chart
            const topFruitsCtx = document.getElementById('topFruitsChart').getContext('2d');
            
            // Parse the JSON data from the server
            const topFruitsData = ${topFruitsJson};
            
            new Chart(topFruitsCtx, {
                type: 'pie',
                data: {
                    labels: topFruitsData.map(d => d.fruitName),
                    datasets: [{
                        data: topFruitsData.map(d => d.quantity),
                        backgroundColor: [
                            '#0d6efd', 
                            '#6610f2', 
                            '#6f42c1', 
                            '#d63384', 
                            '#dc3545', 
                            '#fd7e14', 
                            '#ffc107', 
                            '#198754', 
                            '#20c997', 
                            '#0dcaf0'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'right'
                        }
                    }
                }
            });
        }
    </script>
</body>
</html>