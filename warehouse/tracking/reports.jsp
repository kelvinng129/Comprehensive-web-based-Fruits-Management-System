<%-- 
    Document   : reports
    Created on : 2025年4月20日, 上午8:07:43
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
    <title>Movement Reports</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/tracking.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <jsp:include page="../includes/header.jsp" />
    
    <div class="container mt-4">
        <h1 class="mb-4">Movement Reports</h1>
        
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="card-title mb-0">Generate Report</h5>
                        <div>
                            <a href="${pageContext.request.contextPath}/warehouse/tracking/dashboard" class="btn btn-light btn-sm">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                            <a href="${pageContext.request.contextPath}/warehouse/tracking/movements" class="btn btn-light btn-sm ms-2">
                                <i class="fas fa-exchange-alt"></i> All Movements
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/warehouse/tracking/reports" method="post">
                            <input type="hidden" name="action" value="generateReport">
                            
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <label for="reportType" class="form-label">Report Type:</label>
                                    <select class="form-select" id="reportType" name="reportType" required>
                                        <option value="movement_summary" ${reportType == 'movement_summary' ? 'selected' : ''}>Movement Summary</option>
                                        <option value="inventory_distribution" ${reportType == 'inventory_distribution' ? 'selected' : ''}>Inventory Distribution</option>
                                        <option value="location_activity" ${reportType == 'location_activity' ? 'selected' : ''}>Location Activity</option>
                                        <option value="fruit_flow" ${reportType == 'fruit_flow' ? 'selected' : ''}>Fruit Flow Analysis</option>
                                    </select>
                                </div>
                                
                                <div class="col-md-4">
                                    <label for="startDate" class="form-label">Start Date:</label>
                                    <input type="date" class="form-control" id="startDate" name="startDate" value="${startDate}" required>
                                </div>
                                
                                <div class="col-md-4">
                                    <label for="endDate" class="form-label">End Date:</label>
                                    <input type="date" class="form-control" id="endDate" name="endDate" value="${endDate}" required>
                                </div>
                            </div>
                            
                            <div class="text-center">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-chart-line"></i> Generate Report
                                </button>
                                <button type="button" id="printReport" class="btn btn-success ms-2">
                                    <i class="fas fa-print"></i> Print Report
                                </button>
                                <a href="${pageContext.request.contextPath}/warehouse/tracking/reports" class="btn btn-secondary ms-2">
                                    <i class="fas fa-times"></i> Clear
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        <c:if test="${reportGenerated}">
            <div id="reportContent">
                <div class="row mb-4">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header bg-success text-white">
                                <h5 class="card-title mb-0">
                                    ${reportType == 'movement_summary' ? 'Movement Summary Report' : 
                                      reportType == 'inventory_distribution' ? 'Inventory Distribution Report' : 
                                      reportType == 'location_activity' ? 'Location Activity Report' : 
                                      'Fruit Flow Analysis Report'}
                                </h5>
                                <small>Period: ${startDate} to ${endDate}</small>
                            </div>
                            <div class="card-body">
                                <div class="report-header text-center mb-4">
                                    <h2>
                                        ${reportType == 'movement_summary' ? 'Movement Summary Report' : 
                                          reportType == 'inventory_distribution' ? 'Inventory Distribution Report' : 
                                          reportType == 'location_activity' ? 'Location Activity Report' : 
                                          'Fruit Flow Analysis Report'}
                                    </h2>
                                    <p>Report Period: <strong>${startDate}</strong> to <strong>${endDate}</strong></p>
                                    <p>Generated on: <strong><fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd HH:mm:ss" /></strong></p>
                                </div>
                                
                                <c:if test="${reportType == 'movement_summary' || reportType == 'fruit_flow'}">
                                    <div class="row mb-4">
                                        <div class="col-md-6">
                                            <canvas id="movementByTypeChart" width="100%" height="300"></canvas>
                                        </div>
                                        <div class="col-md-6">
                                            <canvas id="movementByStatusChart" width="100%" height="300"></canvas>
                                        </div>
                                    </div>
                                    
                                    <div class="table-responsive">
                                        <table class="table table-striped table-bordered">
                                            <thead>
                                                <tr>
                                                    <th>Movement Type</th>
                                                    <th>Total Records</th>
                                                    <th>Total Quantity</th>
                                                    <th>Success Rate</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>Delivery</td>
                                                    <td>${deliveryCount}</td>
                                                    <td>${deliveryQuantity}</td>
                                                    <td>${deliverySuccessRate}%</td>
                                                </tr>
                                                <tr>
                                                    <td>Transfer</td>
                                                    <td>${transferCount}</td>
                                                    <td>${transferQuantity}</td>
                                                    <td>${transferSuccessRate}%</td>
                                                </tr>
                                                <tr>
                                                    <td>Return</td>
                                                    <td>${returnCount}</td>
                                                    <td>${returnQuantity}</td>
                                                    <td>${returnSuccessRate}%</td>
                                                </tr>
                                            </tbody>
                                            <tfoot>
                                                <tr class="table-active">
                                                    <th>Total</th>
                                                    <th>${totalCount}</th>
                                                    <th>${totalQuantity}</th>
                                                    <th>${overallSuccessRate}%</th>
                                                </tr>
                                            </tfoot>
                                        </table>
                                    </div>
                                </c:if>
                                
                                <c:if test="${reportType == 'inventory_distribution' || reportType == 'location_activity'}">
                                    <div class="row mb-4">
                                        <div class="col-md-12">
                                            <canvas id="inventoryDistributionChart" width="100%" height="300"></canvas>
                                        </div>
                                    </div>
                                    
                                    <div class="table-responsive">
                                        <table class="table table-striped table-bordered">
                                            <thead>
                                                <tr>
                                                    <th>Location</th>
                                                    <th>Total Fruit Types</th>
                                                    <th>Total Quantity</th>
                                                    <th>Most Stocked Fruit</th>
                                                    <th>Least Stocked Fruit</th>
                                                    <th>Inbound Movements</th>
                                                    <th>Outbound Movements</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="summary" items="${inventorySummaries}">
                                                    <tr>
                                                        <td>${summary.locationName}</td>
                                                        <td>${summary.totalFruitTypes}</td>
                                                        <td>${summary.totalQuantity}</td>
                                                        <td>
                                                            <c:if test="${summary.mostStockedFruit != null}">
                                                                ${summary.mostStockedFruit} (${summary.mostStockedQuantity})
                                                            </c:if>
                                                            <c:if test="${summary.mostStockedFruit == null}">
                                                                N/A
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:if test="${summary.leastStockedFruit != null}">
                                                                ${summary.leastStockedFruit} (${summary.leastStockedQuantity})
                                                            </c:if>
                                                            <c:if test="${summary.leastStockedFruit == null}">
                                                                N/A
                                                            </c:if>
                                                        </td>
                                                        <td>${inboundCount[summary.locationId]}</td>
                                                        <td>${outboundCount[summary.locationId]}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header bg-info text-white">
                                <h5 class="card-title mb-0">Movement Details</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered">
                                        <thead>
                                            <tr>
                                                <th>Date</th>
                                                <th>Fruit</th>
                                                <th>From</th>
                                                <th>To</th>
                                                <th>Quantity</th>
                                                <th>Type</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="movement" items="${movements}">
                                                <tr>
                                                    <td><fmt:formatDate value="${movement.movementDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                                    <td>${movement.fruitName}</td>
                                                    <td>${movement.sourceLocationName}</td>
                                                    <td>${movement.destinationLocationName}</td>
                                                    <td>${movement.quantity}</td>
                                                    <td>${movement.movementType}</td>
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
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Set default dates if empty
            if (!document.getElementById('startDate').value) {
                const today = new Date();
                const oneMonthAgo = new Date();
                oneMonthAgo.setMonth(today.getMonth() - 1);
                
                document.getElementById('startDate').value = oneMonthAgo.toISOString().split('T')[0];
                document.getElementById('endDate').value = today.toISOString().split('T')[0];
            }
            
            // Print functionality
            document.getElementById('printReport').addEventListener('click', function() {
                if (document.getElementById('reportContent')) {
                    const printContents = document.getElementById('reportContent').innerHTML;
                    const originalContents = document.body.innerHTML;
                    
                    document.body.innerHTML = `
                        <div class="container mt-4">
                            ${printContents}
                        </div>
                    `;
                    
                    window.print();
                    document.body.innerHTML = originalContents;
                    location.reload();
                } else {
                    alert('Please generate a report first before printing.');
                }
            });
            
            <c:if test="${reportGenerated}">
                // Create charts for the reports
                if ('${reportType}' === 'movement_summary' || '${reportType}' === 'fruit_flow') {
                    // Movement by Type Chart
                    const typeCtx = document.getElementById('movementByTypeChart').getContext('2d');
                    new Chart(typeCtx, {
                        type: 'pie',
                        data: {
                            labels: ['Delivery', 'Transfer', 'Return'],
                            datasets: [{
                                data: [${deliveryCount}, ${transferCount}, ${returnCount}],
                                backgroundColor: [
                                    'rgba(255, 99, 132, 0.7)',
                                    'rgba(54, 162, 235, 0.7)',
                                    'rgba(255, 206, 86, 0.7)'
                                ],
                                borderWidth: 1
                            }]
                        },
                        options: {
                            responsive: true,
                            plugins: {
                                legend: {
                                    position: 'bottom',
                                },
                                title: {
                                    display: true,
                                    text: 'Movements by Type'
                                }
                            }
                        }
                    });
                    
                    // Movement by Status Chart
                    const statusCtx = document.getElementById('movementByStatusChart').getContext('2d');
                    new Chart(statusCtx, {
                        type: 'pie',
                        data: {
                            labels: ['DELIVERED', 'IN_TRANSIT', 'PENDING', 'CANCELLED'],
                            datasets: [{
                                data: [${deliveredCount}, ${inTransitCount}, ${pendingCount}, ${cancelledCount}],
                                backgroundColor: [
                                    'rgba(40, 167, 69, 0.7)',  // Success/Delivered
                                    'rgba(0, 123, 255, 0.7)',  // Primary/In Transit
                                    'rgba(255, 193, 7, 0.7)',  // Warning/Pending
                                    'rgba(108, 117, 125, 0.7)' // Secondary/Cancelled
                                ],
                                borderWidth: 1
                            }]
                        },
                        options: {
                            responsive: true,
                            plugins: {
                                legend: {
                                    position: 'bottom',
                                },
                                title: {
                                    display: true,
                                    text: 'Movements by Status'
                                }
                            }
                        }
                    });
                }
                
                if ('${reportType}' === 'inventory_distribution' || '${reportType}' === 'location_activity') {
                    // Inventory Distribution Chart
                    const inventoryCtx = document.getElementById('inventoryDistributionChart').getContext('2d');
                    new Chart(inventoryCtx, {
                        type: 'bar',
                        data: {
                            labels: [
                                <c:forEach var="summary" items="${inventorySummaries}" varStatus="status">
                                    '${summary.locationName}'${!status.last ? ',' : ''}
                                </c:forEach>
                            ],
                            datasets: [{
                                label: 'Total Inventory',
                                data: [
                                    <c:forEach var="summary" items="${inventorySummaries}" varStatus="status">
                                        ${summary.totalQuantity}${!status.last ? ',' : ''}
                                    </c:forEach>
                                ],
                                backgroundColor: 'rgba(54, 162, 235, 0.7)',
                                borderColor: 'rgba(54, 162, 235, 1)',
                                borderWidth: 1
                            }]
                        },
                        options: {
                            responsive: true,
                            plugins: {
                                legend: {
                                    display: false
                                },
                                title: {
                                    display: true,
                                    text: 'Inventory Distribution by Location'
                                }
                            },
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    title: {
                                        display: true,
                                        text: 'Quantity'
                                    }
                                }
                            }
                        }
                    });
                }
            </c:if>
        });
    </script>
</body>
</html>