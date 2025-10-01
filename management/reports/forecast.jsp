<%-- 
    Document   : forecast
    Created on : 2025年4月20日, 上午10:01:02
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
    <title>Forecast Reports</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reporting.css">
</head>
<body>
    <jsp:include page="../includes/header.jsp" />
    
    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-md-2">
                <jsp:include page="../includes/sidebar.jsp" />
            </div>
            
            <div class="col-md-10">
                <div class="content-wrapper">
                    <div class="content-header">
                        <div class="container-fluid">
                            <div class="row mb-2">
                                <div class="col-sm-6">
                                    <h1 class="m-0">Forecast Reports</h1>
                                </div>
                                <div class="col-sm-6">
                                    <ol class="breadcrumb float-sm-end">
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/management/dashboard">Home</a></li>
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/management/reports/dashboard">Analytics</a></li>
                                        <li class="breadcrumb-item active">Forecast</li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="content">
                        <div class="container-fluid">
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="card card-primary">
                                        <div class="card-header">
                                            <h3 class="card-title">Generate Forecast Report</h3>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/management/reports/forecast" method="post">
                                            <input type="hidden" name="action" value="generateForecastReport">
                                            <div class="card-body">
                                                <div class="row">
                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label for="reportName">Report Name</label>
                                                            <input type="text" class="form-control" id="reportName" name="reportName" 
                                                                   value="${reportName}" placeholder="e.g. Q3 Seasonal Forecast" required>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label for="forecastPeriod">Forecast Period</label>
                                                            <select class="form-select" id="forecastPeriod" name="forecastPeriod" required>
                                                                <option value="weekly" ${forecastPeriod == 'weekly' ? 'selected' : ''}>Weekly</option>
                                                                <option value="monthly" ${forecastPeriod == 'monthly' ? 'selected' : ''}>Monthly</option>
                                                                <option value="quarterly" ${forecastPeriod == 'quarterly' ? 'selected' : ''}>Quarterly</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label for="forecastType">Forecast Type</label>
                                                            <select class="form-select" id="forecastType" name="forecastType" required>
                                                                <option value="consumption" ${forecastType == 'consumption' ? 'selected' : ''}>Consumption</option>
                                                                <option value="reservation" ${forecastType == 'reservation' ? 'selected' : ''}>Reservation</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <div class="row mt-3">
                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label for="targetLocation">Target Location Type</label>
                                                            <select class="form-select" id="targetLocation" name="targetLocation" required>
                                                                <option value="shop" ${targetLocation == 'shop' ? 'selected' : ''}>Shop</option>
                                                                <option value="city" ${targetLocation == 'city' ? 'selected' : ''}>City</option>
                                                                <option value="country" ${targetLocation == 'country' ? 'selected' : ''}>Country</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label for="targetLocationId">Location</label>
                                                            <select class="form-select" id="targetLocationId" name="targetLocationId" required>
                                                                <option value="">-- Select Location --</option>
                                                                <c:forEach var="location" items="${locations}">
                                                                    <option value="${location.locationID}" 
                                                                            data-type="${location.locationType}"
                                                                            ${targetLocationId == location.locationID ? 'selected' : ''}>
                                                                        ${location.locationName}
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <div class="row mt-3">
                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label for="startDate">Forecast Start Date</label>
                                                            <input type="date" class="form-control" id="startDate" name="startDate" 
                                                                   value="${startDate}" required>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label for="endDate">Forecast End Date</label>
                                                            <input type="date" class="form-control" id="endDate" name="endDate" 
                                                                   value="${endDate}" required>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="card-footer">
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="fas fa-chart-line"></i> Generate Forecast
                                                </button>
                                                <button type="reset" class="btn btn-secondary">
                                                    <i class="fas fa-times"></i> Reset
                                                </button>
                                                <c:if test="${reportGenerated}">
                                                    <button type="button" id="printReportBtn" class="btn btn-success float-end">
                                                        <i class="fas fa-print"></i> Print Report
                                                    </button>
                                                </c:if>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            
                            <c:if test="${reportGenerated}">
                                <div id="reportContent">
                                    <div class="row">
                                        <div class="col-md-12 mb-3">
                                            <div class="report-header">
                                                <h2>${report.reportName} Forecast</h2>
                                                <p>
                                                    <strong>Location:</strong> ${report.targetLocationName} (${report.targetLocation})
                                                    <br>
                                                    <strong>Period:</strong> ${startDate} to ${endDate} (${report.forecastPeriod})
                                                    <br>
                                                    <strong>Type:</strong> ${report.forecastType} Forecast
                                                    <br>
                                                    <strong>Generated on:</strong> <fmt:formatDate value="${report.generatedDate}" pattern="yyyy-MM-dd HH:mm:ss" />
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="card card-primary">
                                                <div class="card-header">
                                                    <h3 class="card-title">Forecast Summary</h3>
                                                </div>
                                                <div class="card-body">
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="info-box">
                                                                <span class="info-box-icon bg-info"><i class="fas fa-laptop"></i></span>
                                                                <div class="info-box-content">
                                                                    <span class="info-box-text">Forecast Model</span>
                                                                    <span class="info-box-number">${report.forecastModel}</span>
                                                                </div>
                                                            </div>
                                                            <div class="info-box">
                                                                <span class="info-box-icon bg-warning"><i class="fas fa-percent"></i></span>
                                                                <div class="info-box-content">
                                                                    <span class="info-box-text">Confidence Level</span>
                                                                    <span class="info-box-number">${report.confidenceLevel * 100}%</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="info-box">
                                                                <span class="info-box-icon bg-success"><i class="fas fa-truck-fast"></i></span>
                                                                <div class="info-box-content">
                                                                    <span class="info-box-text">Average SKU Delivery Time</span>
                                                                    <span class="info-box-number">${report.averageSkuDeliveryTime} days</span>
                                                                </div>
                                                            </div>
                                                            <div class="info-box">
                                                                <span class="info-box-icon bg-danger"><i class="fas fa-calendar-alt"></i></span>
                                                                <div class="info-box-content">
                                                                    <span class="info-box-text">Forecast Range</span>
                                                                    <span class="info-box-number">${report.forecastData.values().iterator().next().size()} periods</span>
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
                                            <div class="card card-success">
                                                <div class="card-header">
                                                    <h3 class="card-title">Forecast Trends</h3>
                                                </div>
                                                <div class="card-body">
                                                    <div class="chart-container">
                                                        <canvas id="forecastChart" height="300"></canvas>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="card card-warning">
                                                <div class="card-header">
                                                    <h3 class="card-title">SKU Delivery Timeline</h3>
                                                </div>
                                                <div class="card-body">
                                                    <div class="chart-container">
                                                        <canvas id="skuDeliveryChart" height="240"></canvas>
                                                    </div>
                                                    <div class="sku-delivery-info mt-3">
                                                        <p class="text-center mb-2"><strong>SKU Delivery Analysis</strong></p>
                                                        <p>
                                                            The average delivery time across all SKUs is <strong>${report.averageSkuDeliveryTime} days</strong>.
                                                            <c:if test="${report.averageSkuDeliveryTime <= 1.5}">
                                                                This excellent delivery time meets the 1 SKU delivery goal.
                                                            </c:if>
                                                            <c:if test="${report.averageSkuDeliveryTime > 1.5 && report.averageSkuDeliveryTime <= 3}">
                                                                This good delivery time is close to the 1 SKU delivery goal.
                                                            </c:if>
                                                            <c:if test="${report.averageSkuDeliveryTime > 3}">
                                                                This delivery time needs improvement to reach the 1 SKU delivery goal.
                                                            </c:if>
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="card card-danger">
                                                <div class="card-header">
                                                    <h3 class="card-title">Optimization Recommendations</h3>
                                                </div>
                                                <div class="card-body">
                                                    <h5>Recommended Actions:</h5>
                                                    <ul class="timeline">
                                                        <li>
                                                            <i class="fas fa-calendar bg-primary"></i>
                                                            <div class="timeline-item">
                                                                <h3 class="timeline-header">Schedule Optimization</h3>
                                                                <div class="timeline-body">
                                                                    Schedule deliveries during off-peak times to reduce transit delays.
                                                                </div>
                                                            </div>
                                                        </li>
                                                        <li>
                                                            <i class="fas fa-boxes bg-success"></i>
                                                            <div class="timeline-item">
                                                                <h3 class="timeline-header">Batch Processing</h3>
                                                                <div class="timeline-body">
                                                                    Group similar fruit deliveries to optimize handling and processing.
                                                                </div>
                                                            </div>
                                                        </li>
                                                        <li>
                                                            <i class="fas fa-route bg-warning"></i>
                                                            <div class="timeline-item">
                                                                <h3 class="timeline-header">Route Planning</h3>
                                                                <div class="timeline-body">
                                                                    Optimize delivery routes to minimize transit time between warehouses.
                                                                </div>
                                                            </div>
                                                        </li>
                                                        <li>
                                                            <i class="fas fa-truck bg-danger"></i>
                                                            <div class="timeline-item">
                                                                <h3 class="timeline-header">Transport Selection</h3>
                                                                <div class="timeline-body">
                                                                    Choose faster shipping methods for perishable fruits.
                                                                </div>
                                                            </div>
                                                        </li>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="card">
                                                <div class="card-header">
                                                    <h3 class="card-title">Detailed Forecast Data</h3>
                                                </div>
                                                <div class="card-body table-responsive p-0">
                                                    <table class="table table-hover text-nowrap">
                                                        <thead>
                                                            <tr>
                                                                <th>Fruit</th>
                                                                <th>SKU Delivery Time</th>
                                                                <c:forEach var="entry" items="${report.forecastData.values().iterator().next()}">
                                                                    <th>${entry.period}</th>
                                                                </c:forEach>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="fruitEntry" items="${report.forecastData}">
                                                                <tr>
                                                                    <td>${fruitEntry.key}</td>
                                                                    <td>
                                                                        <span class="badge ${report.skuDeliveryTimelines[fruitEntry.key] <= 1.5 ? 'bg-success' : report.skuDeliveryTimelines[fruitEntry.key] <= 3 ? 'bg-warning' : 'bg-danger'}">
                                                                            ${report.skuDeliveryTimelines[fruitEntry.key]} days
                                                                        </span>
                                                                    </td>
                                                                    <c:forEach var="point" items="${fruitEntry.value}">
                                                                        <td>
                                                                            ${Math.round(point.value)}
                                                                            <span class="small text-muted">
                                                                                (${Math.round(point.lowerBound)}-${Math.round(point.upperBound)})
                                                                            </span>
                                                                        </td>
                                                                    </c:forEach>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Filter locations by type
            const targetLocationSelect = document.getElementById('targetLocation');
            const targetLocationIdSelect = document.getElementById('targetLocationId');
            
            targetLocationSelect.addEventListener('change', function() {
                const selectedType = this.value;
                
                // Hide all options first
                Array.from(targetLocationIdSelect.options).forEach(option => {
                    if (option.value === '') {
                        return; // Skip the default option
                    }
                    
                    const optionType = option.getAttribute('data-type');
                    
                    if (selectedType === 'shop' && optionType === 'shop') {
                        option.style.display = '';
                    } else if (selectedType === 'city' && (optionType === 'shop' || optionType === 'warehouse')) {
                        option.style.display = '';
                    } else if (selectedType === 'country') {
                        option.style.display = '';
                    } else {
                        option.style.display = 'none';
                    }
                });
                
                // Reset selection
                targetLocationIdSelect.value = '';
            });
            
            // Trigger the change event to initialize
            targetLocationSelect.dispatchEvent(new Event('change'));
            
            // Set default dates if not already set
            const startDateInput = document.getElementById('startDate');
            const endDateInput = document.getElementById('endDate');
            
            if (!startDateInput.value) {
                const today = new Date();
                const twoMonthsLater = new Date();
                twoMonthsLater.setMonth(today.getMonth() + 2);
                
                startDateInput.value = new Date(today.getTime() + (24 * 60 * 60 * 1000)).toISOString().split('T')[0]; // Tomorrow
                endDateInput.value = twoMonthsLater.toISOString().split('T')[0];
            }
            
            // Print functionality
            const printReportBtn = document.getElementById('printReportBtn');
            if (printReportBtn) {
                printReportBtn.addEventListener('click', function() {
                    const reportContent = document.getElementById('reportContent');
                    const originalBody = document.body.innerHTML;
                    
                    document.body.innerHTML = reportContent.innerHTML;
                    window.print();
                    document.body.innerHTML = originalBody;
                    location.reload();
                });
            }
            
            <c:if test="${reportGenerated}">
                const fruitColors = {
                    <c:forEach var="entry" items="${report.forecastData}" varStatus="status">
                        '${entry.key}': 'rgba(${status.index * 40 % 255}, ${190 - status.index * 30}, ${100 + status.index * 20}, 0.7)'${!status.last ? ',' : ''}
                    </c:forEach>
                };
                
                const forecastPeriods = [];
                <c:if test="${not empty report.forecastData}">
                    <c:forEach var="point" items="${report.forecastData.values().iterator().next()}">
                        forecastPeriods.push('${point.period}');
                    </c:forEach>
                </c:if>
                
                const datasets = [];
                <c:forEach var="entry" items="${report.forecastData}">
                    datasets.push({
                        label: '${entry.key}',
                        data: [
                            <c:forEach var="point" items="${entry.value}" varStatus="status">
                                ${Math.round(point.value)}${!status.last ? ',' : ''}
                            </c:forEach>
                        ],
                        backgroundColor: fruitColors['${entry.key}'],
                        borderColor: fruitColors['${entry.key}'].replace('0.7', '1'),
                        borderWidth: 2,
                        fill: false,
                        tension: 0.4
                    });
                </c:forEach>
                
                const forecastCtx = document.getElementById('forecastChart').getContext('2d');
                const forecastChart = new Chart(forecastCtx, {
                    type: 'line',
                    data: {
                        labels: forecastPeriods,
                        datasets: datasets
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
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
                                    text: 'Period'
                                }
                            }
                        }
                    }
                });
                
                // SKU Delivery Time Chart
                const skuLabels = [];
                const skuData = [];
                const benchmarkData = [];
                
                <c:forEach var="entry" items="${report.skuDeliveryTimelines}">
                    skuLabels.push('${entry.key}');
                    skuData.push(${entry.value});
                    benchmarkData.push(1); // The 1 SKU delivery benchmark
                </c:forEach>
                
                const skuCtx = document.getElementById('skuDeliveryChart').getContext('2d');
                const skuChart = new Chart(skuCtx, {
                    type: 'bar',
                    data: {
                        labels: skuLabels,
                        datasets: [
                            {
                                label: 'Current Delivery Time (days)',
                                data: skuData,
                                backgroundColor: 'rgba(54, 162, 235, 0.7)',
                                borderColor: 'rgba(54, 162, 235, 1)',
                                borderWidth: 1
                            },
                            {
                                label: '1 SKU Benchmark',
                                data: benchmarkData,
                                backgroundColor: 'rgba(255, 99, 132, 0.2)',
                                borderColor: 'rgba(255, 99, 132, 1)',
                                borderWidth: 2,
                                type: 'line'
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                title: {
                                    display: true,
                                    text: 'Days'
                                }
                            }
                        }
                    }
                });
            </c:if>
        });
    </script>
</body>
</html>
