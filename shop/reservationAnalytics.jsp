<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservation Analytics - Fruit Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .analytics-card {
            box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.1);
            border-radius: 15px;
            border: none;
            transition: transform 0.3s;
            height: 100%;
        }
        .analytics-card:hover {
            transform: translateY(-5px);
        }
        .analytics-card .card-header {
            border-radius: 15px 15px 0 0;
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
        .dashboard-filters {
            background-color: #f8f9fa;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.05);
        }
        .status-badge {
            font-size: 0.8rem;
            padding: 0.35rem 0.65rem;
            border-radius: 50rem;
        }
        .fruit-item {
            padding: 10px 15px;
            border-radius: 8px;
            margin-bottom: 8px;
            background-color: #f8f9fa;
            box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.05);
        }
        .fruit-item:hover {
            background-color: #e9ecef;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/shopHeader.jsp" />
    
    <div class="container-fluid mt-4 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Reservation Analytics</h1>
            <div>
                <a href="${pageContext.request.contextPath}/shop/reservation?action=viewMyReservations" class="btn btn-outline-primary me-2">
                    <i class="fas fa-clipboard-list me-1"></i> My Reservations
                </a>
                <a href="${pageContext.request.contextPath}/shop/reservation" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-1"></i> Dashboard
                </a>
            </div>
        </div>
        
        <!-- Filters Section -->
        <div class="dashboard-filters mb-4">
            <form action="${pageContext.request.contextPath}/shop/reservation" method="get" id="filterForm">
                <input type="hidden" name="action" value="viewAnalytics">
                <div class="row align-items-end">
                    <div class="col-md-3 mb-3 mb-md-0">
                        <label for="timeframeFilter" class="form-label">Timeframe</label>
                        <select class="form-select" id="timeframeFilter" name="timeframe">
                            <option value="30" ${param.timeframe == '30' || empty param.timeframe ? 'selected' : ''}>Last 30 Days</option>
                            <option value="90" ${param.timeframe == '90' ? 'selected' : ''}>Last 90 Days</option>
                            <option value="180" ${param.timeframe == '180' ? 'selected' : ''}>Last 180 Days</option>
                            <option value="365" ${param.timeframe == '365' ? 'selected' : ''}>Last Year</option>
                        </select>
                    </div>
                    <div class="col-md-3 mb-3 mb-md-0">
                        <label for="sourceFilter" class="form-label">Source Warehouse</label>
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
                        <label for="fruitFilter" class="form-label">Fruit Category</label>
                        <select class="form-select" id="fruitFilter" name="category">
                            <option value="">All Categories</option>
                            <c:forEach var="category" items="${fruitCategories}">
                                <option value="${category}" ${param.category == category ? 'selected' : ''}>
                                    ${category}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2 mb-3 mb-md-0 d-grid">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-filter me-1"></i> Apply Filters
                        </button>
                    </div>
                </div>
            </form>
        </div>
        
        <!-- Stats Cards Row -->
        <div class="row mb-4">
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="stat-card bg-primary">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-uppercase mb-1">Total Reservations</h6>
                            <h2 class="mb-0">${totalReservations}</h2>
                            <div class="small text-white-50">in selected period</div>
                        </div>
                        <i class="fas fa-calendar-alt stat-icon"></i>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="stat-card bg-success">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-uppercase mb-1">Fulfilled</h6>
                            <h2 class="mb-0">${fulfilledReservations}</h2>
                            <div class="small text-white-50">${fulfilledPercentage}% success rate</div>
                        </div>
                        <i class="fas fa-check-circle stat-icon"></i>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="stat-card bg-info">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-uppercase mb-1">Total Units</h6>
                            <h2 class="mb-0">${totalUnits}</h2>
                            <div class="small text-white-50">across all reservations</div>
                        </div>
                        <i class="fas fa-cubes stat-icon"></i>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="stat-card bg-warning text-dark">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-uppercase mb-1">Avg. Delivery Time</h6>
                            <h2 class="mb-0">${avgDeliveryDays} days</h2>
                            <div class="small text-dark">from reservation to delivery</div>
                        </div>
                        <i class="fas fa-hourglass-half stat-icon"></i>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Charts and Analytics Section -->
        <div class="row">
            <!-- Reservation Trends -->
            <div class="col-lg-8 mb-4">
                <div class="card analytics-card">
                    <div class="card-header bg-light py-3">
                        <h4 class="mb-0"><i class="fas fa-chart-line me-2"></i> Reservation Trends</h4>
                    </div>
                    <div class="card-body">
                        <canvas id="reservationTrendsChart" height="300"></canvas>
                    </div>
                </div>
            </div>
            
            <!-- Status Distribution -->
            <div class="col-lg-4 mb-4">
                <div class="card analytics-card">
                    <div class="card-header bg-light py-3">
                        <h4 class="mb-0"><i class="fas fa-chart-pie me-2"></i> Status Distribution</h4>
                    </div>
                    <div class="card-body">
                        <canvas id="statusDistributionChart" height="300"></canvas>
                    </div>
                </div>
            </div>
            
            <!-- Top Fruits -->
            <div class="col-lg-6 mb-4">
                <div class="card analytics-card">
                    <div class="card-header bg-light py-3">
                        <h4 class="mb-0"><i class="fas fa-star me-2"></i> Top Reserved Fruits</h4>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty topFruits}">
                                <div class="row mb-3">
                                    <div class="col-md-7">
                                        <canvas id="topFruitsChart" height="200"></canvas>
                                    </div>
                                    <div class="col-md-5">
                                        <div class="mt-md-0 mt-3" style="max-height: 200px; overflow-y: auto;">
                                            <c:forEach var="fruit" items="${topFruits}" varStatus="status">
                                                <div class="fruit-item">
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <span>
                                                            <span class="fw-bold">${status.index + 1}.</span> ${fruit.fruitName}
                                                        </span>
                                                        <span class="badge bg-primary">${fruit.quantity} units</span>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="fas fa-chart-bar text-muted fa-3x mb-3"></i>
                                    <h5 class="text-muted">No data available</h5>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <!-- Source Distribution -->
            <div class="col-lg-6 mb-4">
                <div class="card analytics-card">
                    <div class="card-header bg-light py-3">
                        <h4 class="mb-0"><i class="fas fa-warehouse me-2"></i> Source Distribution</h4>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty sourceDistribution}">
                                <canvas id="sourceDistributionChart" height="240"></canvas>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="fas fa-chart-bar text-muted fa-3x mb-3"></i>
                                    <h5 class="text-muted">No data available</h5>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <!-- Recent Delivery Times -->
            <div class="col-lg-4 mb-4">
                <div class="card analytics-card">
                    <div class="card-header bg-light py-3">
                        <h4 class="mb-0"><i class="fas fa-clock me-2"></i> Recent Delivery Times</h4>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty recentDeliveries}">
                                <div class="table-responsive" style="max-height: 300px; overflow-y: auto;">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Source</th>
                                                <th>Days</th>
                                                <th>Date</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="delivery" items="${recentDeliveries}">
                                                <tr>
                                                    <td>#${delivery.reservationId}</td>
                                                    <td>${delivery.sourceName}</td>
                                                    <td>
                                                        <span class="badge ${delivery.deliveryDays <= avgDeliveryDays ? 'bg-success' : 'bg-warning text-dark'}">
                                                            ${delivery.deliveryDays} days
                                                        </span>
                                                    </td>
                                                    <td><fmt:formatDate value="${delivery.deliveryDate}" pattern="yyyy-MM-dd" /></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="fas fa-hourglass text-muted fa-3x mb-3"></i>
                                    <h5 class="text-muted">No recent deliveries</h5>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <!-- Reservation by Category -->
            <div class="col-lg-4 mb-4">
                <div class="card analytics-card">
                    <div class="card-header bg-light py-3">
                        <h4 class="mb-0"><i class="fas fa-tags me-2"></i> Fruit Categories</h4>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty categoryDistribution}">
                                <canvas id="categoryDistributionChart" height="240"></canvas>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="fas fa-chart-pie text-muted fa-3x mb-3"></i>
                                    <h5 class="text-muted">No data available</h5>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <!-- Monthly Comparison -->
            <div class="col-lg-4 mb-4">
                <div class="card analytics-card">
                    <div class="card-header bg-light py-3">
                        <h4 class="mb-0"><i class="fas fa-calendar me-2"></i> Monthly Comparison</h4>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty monthlyComparison}">
                                <canvas id="monthlyComparisonChart" height="240"></canvas>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="fas fa-chart-bar text-muted fa-3x mb-3"></i>
                                    <h5 class="text-muted">No data available</h5>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Seasonal Analysis -->
        <div class="card analytics-card mb-4">
            <div class="card-header bg-light py-3">
                <h4 class="mb-0"><i class="fas fa-snowflake me-2"></i> Seasonal Analysis</h4>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty seasonalAnalysis}">
                        <div class="row">
                            <div class="col-lg-8">
                                <canvas id="seasonalAnalysisChart" height="300"></canvas>
                            </div>
                            <div class="col-lg-4">
                                <h5 class="mb-3">Seasonal Insights</h5>
                                <div class="mb-3">
                                    <div class="fw-bold mb-1">Highest Demand Season</div>
                                    <div>${highestDemandSeason}</div>
                                </div>
                                <div class="mb-3">
                                    <div class="fw-bold mb-1">Lowest Demand Season</div>
                                    <div>${lowestDemandSeason}</div>
                                </div>
                                <div class="mb-3">
                                    <div class="fw-bold mb-1">Seasonal Variation</div>
                                    <div>${seasonalVariationPercentage}% difference between highest and lowest</div>
                                </div>
                                <div class="mt-4">
                                    <h5 class="mb-3">Recommendations</h5>
                                    <ul class="mb-0">
                                        <li>Plan for increased capacity during ${highestDemandSeason}</li>
                                        <li>Consider promotions during ${lowestDemandSeason}</li>
                                        <li>Adjust inventory levels based on seasonal patterns</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <i class="fas fa-chart-line text-muted fa-3x mb-3"></i>
                            <h5 class="text-muted">Insufficient data for seasonal analysis</h5>
                            <p class="text-muted">More historical data is needed to provide accurate seasonal insights.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        $(document).ready(function() {
            // Auto-submit form when filters change
            $('#timeframeFilter, #sourceFilter, #fruitFilter').change(function() {
                $('#filterForm').submit();
            });
            
            // Initialize charts
            initializeCharts();
        });
        
        function initializeCharts() {
            // Parse JSON data from server
            const reservationTrendsData = ${reservationTrendsJson || 'null'};
            const statusDistributionData = ${statusDistributionJson || 'null'};
            const topFruitsData = ${topFruitsJson || 'null'};
            const sourceDistributionData = ${sourceDistributionJson || 'null'};
            const categoryDistributionData = ${categoryDistributionJson || 'null'};
            const monthlyComparisonData = ${monthlyComparisonJson || 'null'};
            const seasonalAnalysisData = ${seasonalAnalysisJson || 'null'};
            
            // Set up colors
            const colors = [
                '#0d6efd', '#6610f2', '#6f42c1', '#d63384', '#dc3545', 
                '#fd7e14', '#ffc107', '#198754', '#20c997', '#0dcaf0'
            ];
            
            // Reservation Trends Chart
            if (reservationTrendsData) {
                const reservationTrendsCtx = document.getElementById('reservationTrendsChart').getContext('2d');
                new Chart(reservationTrendsCtx, {
                    type: 'line',
                    data: {
                        labels: reservationTrendsData.map(item => item.date),
                        datasets: [
                            {
                                label: 'Reservations',
                                data: reservationTrendsData.map(item => item.count),
                                borderColor: '#0d6efd',
                                backgroundColor: 'rgba(13, 110, 253, 0.1)',
                                borderWidth: 2,
                                tension: 0.3,
                                fill: true
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: {
                                position: 'top',
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true
                            }
                        }
                    }
                });
            }
            
            // Status Distribution Chart
            if (statusDistributionData) {
                const statusDistributionCtx = document.getElementById('statusDistributionChart').getContext('2d');
                new Chart(statusDistributionCtx, {
                    type: 'doughnut',
                    data: {
                        labels: statusDistributionData.map(item => item.status),
                        datasets: [{
                            data: statusDistributionData.map(item => item.count),
                            backgroundColor: [
                                '#ffc107', // pending
                                '#0dcaf0', // approved
                                '#6f42c1', // processing
                                '#fd7e14', // shipped
                                '#198754', // delivered
                                '#dc3545'  // cancelled
                            ],
                            borderWidth: 1
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
            
            // Top Fruits Chart
            if (topFruitsData) {
                const topFruitsCtx = document.getElementById('topFruitsChart').getContext('2d');
                new Chart(topFruitsCtx, {
                    type: 'pie',
                    data: {
                        labels: topFruitsData.map(item => item.fruitName),
                        datasets: [{
                            data: topFruitsData.map(item => item.quantity),
                            backgroundColor: colors,
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: {
                                display: false
                            }
                        }
                    }
                });
            }
            
            // Source Distribution Chart
            if (sourceDistributionData) {
                const sourceDistributionCtx = document.getElementById('sourceDistributionChart').getContext('2d');
                new Chart(sourceDistributionCtx, {
                    type: 'bar',
                    data: {
                        labels: sourceDistributionData.map(item => item.sourceName),
                        datasets: [{
                            label: 'Reservations',
                            data: sourceDistributionData.map(item => item.count),
                            backgroundColor: colors,
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: {
                                display: false
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true
                            }
                        }
                    }
                });
            }
            
            // Category Distribution Chart
            if (categoryDistributionData) {
                const categoryDistributionCtx = document.getElementById('categoryDistributionChart').getContext('2d');
                new Chart(categoryDistributionCtx, {
                    type: 'polarArea',
                    data: {
                        labels: categoryDistributionData.map(item => item.category),
                        datasets: [{
                            data: categoryDistributionData.map(item => item.count),
                            backgroundColor: colors,
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: {
                                position: 'right',
                                align: 'start'
                            }
                        }
                    }
                });
            }
            
            // Monthly Comparison Chart
            if (monthlyComparisonData) {
                const monthlyComparisonCtx = document.getElementById('monthlyComparisonChart').getContext('2d');
                new Chart(monthlyComparisonCtx, {
                    type: 'bar',
                    data: {
                        labels: monthlyComparisonData.map(item => item.month),
                        datasets: [
                            {
                                label: 'This Year',
                                data: monthlyComparisonData.map(item => item.thisYear),
                                backgroundColor: '#0d6efd',
                                borderWidth: 1
                            },
                            {
                                label: 'Last Year',
                                data: monthlyComparisonData.map(item => item.lastYear),
                                backgroundColor: '#6c757d',
                                borderWidth: 1
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: {
                                position: 'top'
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true
                            }
                        }
                    }
                });
            }
            
            // Seasonal Analysis Chart
            if (seasonalAnalysisData) {
                const seasonalAnalysisCtx = document.getElementById('seasonalAnalysisChart').getContext('2d');
                new Chart(seasonalAnalysisCtx, {
                    type: 'line',
                    data: {
                        labels: ['Winter', 'Spring', 'Summer', 'Fall'],
                        datasets: [
                            {
                                label: 'Reservation Count',
                                data: seasonalAnalysisData.map(item => item.count),
                                borderColor: '#0d6efd',
                                backgroundColor: 'rgba(13, 110, 253, 0.1)',
                                borderWidth: 2,
                                tension: 0.3,
                                fill: true
                            },
                            {
                                label: 'Total Units',
                                data: seasonalAnalysisData.map(item => item.units),
                                borderColor: '#dc3545',
                                backgroundColor: 'rgba(220, 53, 69, 0.1)', 
                                borderWidth: 2,
                                tension: 0.3,
                                fill: true,
                                yAxisID: 'y1'
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: {
                                position: 'top'
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                title: {
                                    display: true,
                                    text: 'Reservation Count'
                                }
                            },
                            y1: {
                                beginAtZero: true,
                                position: 'right',
                                grid: {
                                    drawOnChartArea: false
                                },
                                title: {
                                    display: true,
                                    text: 'Total Units'
                                }
                            }
                        }
                    }
                });
            }
        }
    </script>
</body>
</html>