<%-- 
    Document   : movements
    Created on : 2025年4月20日, 上午6:58:04
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
    <title>Movement History</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/tracking.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
</head>
<body>
    <jsp:include page="../includes/header.jsp" />
    
    <div class="container mt-4">
        <h1 class="mb-4">Movement History</h1>
        
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="card-title mb-0">Fruit Movement Records</h5>
                        <div>
                            <a href="${pageContext.request.contextPath}/warehouse/tracking/dashboard" class="btn btn-light btn-sm">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                            <a href="${pageContext.request.contextPath}/warehouse/tracking/search" class="btn btn-light btn-sm ms-2">
                                <i class="fas fa-search"></i> Advanced Search
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table id="movementsTable" class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Date</th>
                                        <th>Fruit</th>
                                        <th>From</th>
                                        <th>To</th>
                                        <th>Quantity</th>
                                        <th>Type</th>
                                        <th>Status</th>
                                        <th>Created By</th>
                                        <th>Tracking #</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="movement" items="${movements}">
                                        <tr>
                                            <td>${movement.recordId}</td>
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
                                            <td>${movement.createdByName}</td>
                                            <td>${movement.trackingNumber}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5 class="card-title mb-0">Movements by Fruit</h5>
                    </div>
                    <div class="card-body">
                        <canvas id="fruitChart" width="100%" height="300"></canvas>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5 class="card-title mb-0">Movements by Status</h5>
                    </div>
                    <div class="card-body">
                        <canvas id="statusChart" width="100%" height="300"></canvas>
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
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <script>
        $(document).ready(function() {
            $('#movementsTable').DataTable({
                order: [[1, 'desc']], // Sort by date descending
                pageLength: 25,
                language: {
                    search: "Filter records:"
                }
            });
            
            // Calculate data for charts
            const fruitData = {};
            const statusData = {};
            
            <c:forEach var="movement" items="${movements}">
                // Count movements by fruit
                if (fruitData['${movement.fruitName}']) {
                    fruitData['${movement.fruitName}'] += 1;
                } else {
                    fruitData['${movement.fruitName}'] = 1;
                }
                
                // Count movements by status
                if (statusData['${movement.status}']) {
                    statusData['${movement.status}'] += 1;
                } else {
                    statusData['${movement.status}'] = 1;
                }
            </c:forEach>
            
            // Create fruit movements chart
            const fruitLabels = Object.keys(fruitData);
            const fruitCounts = Object.values(fruitData);
            
            const fruitCtx = document.getElementById('fruitChart').getContext('2d');
            new Chart(fruitCtx, {
                type: 'pie',
                data: {
                    labels: fruitLabels,
                    datasets: [{
                        data: fruitCounts,
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.7)',
                            'rgba(54, 162, 235, 0.7)',
                            'rgba(255, 206, 86, 0.7)',
                            'rgba(75, 192, 192, 0.7)',
                            'rgba(153, 102, 255, 0.7)',
                            'rgba(255, 159, 64, 0.7)',
                            'rgba(199, 199, 199, 0.7)',
                            'rgba(83, 102, 255, 0.7)',
                            'rgba(40, 159, 64, 0.7)',
                            'rgba(210, 99, 132, 0.7)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'right',
                        },
                        title: {
                            display: true,
                            text: 'Movements by Fruit Type'
                        }
                    }
                }
            });
            
            // Create status chart
            const statusLabels = Object.keys(statusData);
            const statusCounts = Object.values(statusData);
            
            const statusCtx = document.getElementById('statusChart').getContext('2d');
            new Chart(statusCtx, {
                type: 'doughnut',
                data: {
                    labels: statusLabels,
                    datasets: [{
                        data: statusCounts,
                        backgroundColor: [
                            'rgba(40, 167, 69, 0.7)',  // Success/Delivered
                            'rgba(0, 123, 255, 0.7)',  // Primary/In Transit
                            'rgba(255, 193, 7, 0.7)',  // Warning/Pending
                            'rgba(108, 117, 125, 0.7)' // Secondary/Others
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'right',
                        },
                        title: {
                            display: true,
                            text: 'Movements by Status'
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>