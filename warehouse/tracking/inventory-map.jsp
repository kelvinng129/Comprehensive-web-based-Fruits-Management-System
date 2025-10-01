<%-- 
    Document   : inventory-map
    Created on : 2025年4月20日, 上午7:23:28
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
    <title>Inventory Distribution Map</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/tracking.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <jsp:include page="../includes/header.jsp" />
    
    <div class="container mt-4">
        <h1 class="mb-4">Inventory Distribution Map</h1>
        
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="card-title mb-0">Inventory Distribution</h5>
                        <div>
                            <a href="${pageContext.request.contextPath}/warehouse/tracking/dashboard" class="btn btn-light btn-sm">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                            <a href="${pageContext.request.contextPath}/warehouse/tracking/movements" class="btn btn-light btn-sm ms-2">
                                <i class="fas fa-exchange-alt"></i> Movements
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="map-container">
                            <div class="row mb-4">
                                <div class="col-md-12">
                                    <canvas id="inventoryBarChart" width="100%" height="200"></canvas>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="world-map">
                                        <!-- Visual representation of the global inventory distribution -->
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="card bg-light">
                                                    <div class="card-header bg-success text-white">
                                                        Japan Region
                                                    </div>
                                                    <div class="card-body">
                                                        <div class="location-map" id="japanMap">
                                                            <!-- We'll visualize Japan locations here -->
                                                            <div class="d-flex justify-content-center">
                                                                <canvas id="japanChart" width="300" height="200"></canvas>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="col-md-4">
                                                <div class="card bg-light">
                                                    <div class="card-header bg-primary text-white">
                                                        USA Region
                                                    </div>
                                                    <div class="card-body">
                                                        <div class="location-map" id="usaMap">
                                                            <!-- We'll visualize USA locations here -->
                                                            <div class="d-flex justify-content-center">
                                                                <canvas id="usaChart" width="300" height="200"></canvas>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="col-md-4">
                                                <div class="card bg-light">
                                                    <div class="card-header bg-warning text-dark">
                                                        Hong Kong Region
                                                    </div>
                                                    <div class="card-body">
                                                        <div class="location-map" id="hkMap">
                                                            <!-- We'll visualize Hong Kong locations here -->
                                                            <div class="d-flex justify-content-center">
                                                                <canvas id="hkChart" width="300" height="200"></canvas>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5 class="card-title mb-0">Location Inventory Details</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Location</th>
                                        <th>Type</th>
                                        <th>Total Fruits</th>
                                        <th>Total Quantity</th>
                                        <th>Most Stocked</th>
                                        <th>Least Stocked</th>
                                        <th>Last Receipt</th>
                                        <th>Last Shipment</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="summary" items="${inventorySummaries}">
                                        <tr>
                                            <td>${summary.locationName}</td>
                                            <td>
                                                <span class="badge ${summary.locationType == 'central_warehouse' ? 'bg-primary' : 
                                                                      summary.locationType == 'source_warehouse' ? 'bg-success' : 'bg-info'}">
                                                    ${summary.locationType}
                                                </span>
                                            </td>
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
                                            <td>
                                                <c:if test="${summary.lastReceiptDate != null}">
                                                    <fmt:formatDate value="${summary.lastReceiptDate}" pattern="yyyy-MM-dd" />
                                                </c:if>
                                                <c:if test="${summary.lastReceiptDate == null}">
                                                    Never
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${summary.lastShipmentDate != null}">
                                                    <fmt:formatDate value="${summary.lastShipmentDate}" pattern="yyyy-MM-dd" />
                                                </c:if>
                                                <c:if test="${summary.lastShipmentDate == null}">
                                                    Never
                                                </c:if>
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
    
    <jsp:include page="../includes/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Prepare data for charts
            const locationLabels = [];
            const inventoryData = [];
            
            // Data for regional charts
            const japanLocations = [];
            const japanData = [];
            const usaLocations = [];
            const usaData = [];
            const hkLocations = [];
            const hkData = [];
            
            <c:forEach var="summary" items="${inventorySummaries}">
                locationLabels.push('${summary.locationName}');
                inventoryData.push(${summary.totalQuantity});
                
                // Sort into regional data
                if ('${summary.locationName}'.includes('Japan') || '${summary.locationName}'.includes('Tokyo') || '${summary.locationName}'.includes('Osaka')) {
                    japanLocations.push('${summary.locationName}');
                    japanData.push(${summary.totalQuantity});
                } else if ('${summary.locationName}'.includes('USA') || '${summary.locationName}'.includes('New York') || '${summary.locationName}'.includes('Los Angeles')) {
                    usaLocations.push('${summary.locationName}');
                    usaData.push(${summary.totalQuantity});
                } else if ('${summary.locationName}'.includes('Hong Kong')) {
                    hkLocations.push('${summary.locationName}');
                    hkData.push(${summary.totalQuantity});
                }
            </c:forEach>
            
            // Create overall inventory bar chart
            const barCtx = document.getElementById('inventoryBarChart').getContext('2d');
            new Chart(barCtx, {
                type: 'bar',
                data: {
                    labels: locationLabels,
                    datasets: [{
                        label: 'Total Inventory Quantity',
                        data: inventoryData,
                        backgroundColor: [
                            'rgba(54, 162, 235, 0.7)',
                            'rgba(75, 192, 192, 0.7)',
                            'rgba(255, 206, 86, 0.7)',
                            'rgba(255, 99, 132, 0.7)',
                            'rgba(153, 102, 255, 0.7)',
                            'rgba(255, 159, 64, 0.7)'
                        ],
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
                            text: 'Inventory Distribution Across All Locations'
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Quantity'
                            }
                        },
                        x: {
                            title: {
                                display: true,
                                text: 'Location'
                            }
                        }
                    }
                }
            });
            
            // Create Japan region chart
            const japanCtx = document.getElementById('japanChart').getContext('2d');
            new Chart(japanCtx, {
                type: 'pie',
                data: {
                    labels: japanLocations,
                    datasets: [{
                        data: japanData,
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.7)',
                            'rgba(54, 162, 235, 0.7)',
                            'rgba(255, 206, 86, 0.7)',
                            'rgba(75, 192, 192, 0.7)'
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
                            text: 'Japan Region Inventory'
                        }
                    }
                }
            });
            
            // Create USA region chart
            const usaCtx = document.getElementById('usaChart').getContext('2d');
            new Chart(usaCtx, {
                type: 'pie',
                data: {
                    labels: usaLocations,
                    datasets: [{
                        data: usaData,
                        backgroundColor: [
                            'rgba(54, 162, 235, 0.7)',
                            'rgba(75, 192, 192, 0.7)',
                            'rgba(153, 102, 255, 0.7)',
                            'rgba(255, 159, 64, 0.7)'
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
                            text: 'USA Region Inventory'
                        }
                    }
                }
            });
            
            // Create Hong Kong region chart
            const hkCtx = document.getElementById('hkChart').getContext('2d');
            new Chart(hkCtx, {
                type: 'pie',
                data: {
                    labels: hkLocations,
                    datasets: [{
                        data: hkData,
                        backgroundColor: [
                            'rgba(255, 206, 86, 0.7)',
                            'rgba(255, 99, 132, 0.7)',
                            'rgba(54, 162, 235, 0.7)'
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
                            text: 'Hong Kong Region Inventory'
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>