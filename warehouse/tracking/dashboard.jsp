<%-- 
    Document   : dashboard
    Created on : 2025年4月20日, 上午6:17:41
    Author     : kelvin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cross-Location Tracking Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/tracking.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <jsp:include page="../includes/header.jsp" />
    
    <div class="container mt-4">
        <h1 class="mb-4">Cross-Location Tracking Dashboard</h1>
        
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="card-title mb-0">Navigation</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3 mb-3">
                                <a href="${pageContext.request.contextPath}/warehouse/tracking/movements" class="btn btn-outline-primary w-100 h-100 d-flex flex-column justify-content-center align-items-center p-4">
                                    <i class="fas fa-exchange-alt fa-3x mb-3"></i>
                                    <span>Movement History</span>
                                </a>
                            </div>
                            <div class="col-md-3 mb-3">
                                <a href="${pageContext.request.contextPath}/warehouse/tracking/inventory-map" class="btn btn-outline-success w-100 h-100 d-flex flex-column justify-content-center align-items-center p-4">
                                    <i class="fas fa-map-marked-alt fa-3x mb-3"></i>
                                    <span>Inventory Map</span>
                                </a>
                            </div>
                            <div class="col-md-3 mb-3">
                                <a href="${pageContext.request.contextPath}/warehouse/tracking/reports" class="btn btn-outline-info w-100 h-100 d-flex flex-column justify-content-center align-items-center p-4">
                                    <i class="fas fa-chart-bar fa-3x mb-3"></i>
                                    <span>Reports</span>
                                </a>
                            </div>
                            <div class="col-md-3 mb-3">
                                <a href="${pageContext.request.contextPath}/warehouse/tracking/search" class="btn btn-outline-warning w-100 h-100 d-flex flex-column justify-content-center align-items-center p-4">
                                    <i class="fas fa-search fa-3x mb-3"></i>
                                    <span>Advanced Search</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mb-4">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5 class="card-title mb-0">Recent Movements</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Fruit</th>
                                        <th>From</th>
                                        <th>To</th>
                                        <th>Quantity</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="movement" items="${recentMovements}">
                                        <tr>
                                            <td><fmt:formatDate value="${movement.movementDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                            <td>${movement.fruitName}</td>
                                            <td>${movement.sourceLocationName}</td>
                                            <td>${movement.destinationLocationName}</td>
                                            <td>${movement.quantity}</td>
                                            <td>
                                                <span class="badge ${movement.status == 'DELIVERED' ? 'bg-success' : 
                                                                      movement.status == 'IN_TRANSIT' ? 'bg-primary' : 
                                                                      movement.status == 'PENDING' ? 'bg-warning' : 'bg-secondary'}">
                                                    ${movement.status}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <a href="${pageContext.request.contextPath}/warehouse/tracking/movements" class="btn btn-sm btn-success mt-2">View All Movements</a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5 class="card-title mb-0">Inventory Overview</h5>
                    </div>
                    <div class="card-body">
                        <canvas id="inventoryChart" width="100%" height="200"></canvas>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-warning text-dark">
                        <h5 class="card-title mb-0">Location Inventory Status</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <c:forEach var="summary" items="${inventorySummaries}">
                                <div class="col-md-4 mb-3">
                                    <div class="card">
                                        <div class="card-header ${summary.locationType == 'central_warehouse' ? 'bg-primary' : 
                                                                  summary.locationType == 'source_warehouse' ? 'bg-success' : 'bg-info'} text-white">
                                            <h6 class="card-title mb-0">${summary.locationName}</h6>
                                            <small>${summary.locationType}</small>
                                        </div>
                                        <div class="card-body">
                                            <p><strong>Total Fruit Types:</strong> ${summary.totalFruitTypes}</p>
                                            <p><strong>Total Quantity:</strong> ${summary.totalQuantity}</p>
                                            <c:if test="${summary.mostStockedFruit != null}">
                                                <p><strong>Most Stocked:</strong> ${summary.mostStockedFruit} (${summary.mostStockedQuantity})</p>
                                            </c:if>
                                            <c:if test="${summary.leastStockedFruit != null}">
                                                <p><strong>Least Stocked:</strong> ${summary.leastStockedFruit} (${summary.leastStockedQuantity})</p>
                                            </c:if>
                                            <c:if test="${summary.lastReceiptDate != null}">
                                                <p><strong>Last Receipt:</strong> <fmt:formatDate value="${summary.lastReceiptDate}" pattern="yyyy-MM-dd" /></p>
                                            </c:if>
                                            <c:if test="${summary.lastShipmentDate != null}">
                                                <p><strong>Last Shipment:</strong> <fmt:formatDate value="${summary.lastShipmentDate}" pattern="yyyy-MM-dd" /></p>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Extract inventory data for the chart
            const locationLabels = [];
            const inventoryData = [];
            
            <c:forEach var="summary" items="${inventorySummaries}">
                locationLabels.push('${summary.locationName}');
                inventoryData.push(${summary.totalQuantity});
            </c:forEach>
            
            // Create inventory chart
            const ctx = document.getElementById('inventoryChart').getContext('2d');
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: locationLabels,
                    datasets: [{
                        label: 'Total Inventory',
                        data: inventoryData,
                        backgroundColor: [
                            'rgba(54, 162, 235, 0.7)',
                            'rgba(75, 192, 192, 0.7)',
                            'rgba(255, 206, 86, 0.7)',
                            'rgba(255, 99, 132, 0.7)',
                            'rgba(153, 102, 255, 0.7)',
                            'rgba(255, 159, 64, 0.7)'
                        ],
                        borderColor: [
                            'rgba(54, 162, 235, 1)',
                            'rgba(75, 192, 192, 1)',
                            'rgba(255, 206, 86, 1)',
                            'rgba(255, 99, 132, 1)',
                            'rgba(153, 102, 255, 1)',
                            'rgba(255, 159, 64, 1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'top',
                        },
                        title: {
                            display: true,
                            text: 'Inventory by Location'
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>
