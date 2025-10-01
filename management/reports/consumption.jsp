<%-- 
    Document   : consumption
    Created on : 2025年4月20日, 上午9:43:34
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
    <title>Consumption Reports</title>
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
                                    <h1 class="m-0">Consumption Reports</h1>
                                </div>
                                <div class="col-sm-6">
                                    <ol class="breadcrumb float-sm-end">
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/management/dashboard">Home</a></li>
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/management/reports/dashboard">Analytics</a></li>
                                        <li class="breadcrumb-item active">Consumption</li>
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
                                            <h3 class="card-title">Generate Consumption Report</h3>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/management/reports/consumption" method="post">
                                            <input type="hidden" name="action" value="generateConsumptionReport">
                                            <div class="card-body">
                                                <div class="row">
                                                    <div class="col-md-3">
                                                        <div class="form-group">
                                                            <label for="locationType">Location Type</label>
                                                            <select class="form-select" id="locationType" name="locationType" required>
                                                                <option value="shop" ${locationType == 'shop' ? 'selected' : ''}>Shop</option>
                                                                <option value="city" ${locationType == 'city' ? 'selected' : ''}>City</option>
                                                                <option value="country" ${locationType == 'country' ? 'selected' : ''}>Country</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3">
                                                        <div class="form-group">
                                                            <label for="locationId">Location</label>
                                                            <select class="form-select" id="locationId" name="locationId" required>
                                                                <option value="">-- Select Location --</option>
                                                                <c:forEach var="location" items="${locations}">
                                                                    <option value="${location.locationID}" 
                                                                            data-type="${location.locationType}"
                                                                            ${locationId == location.locationID ? 'selected' : ''}>
                                                                        ${location.locationName}
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3">
                                                        <div class="form-group">
                                                            <label for="startDate">Start Date</label>
                                                            <input type="date" class="form-control" id="startDate" name="startDate" 
                                                                   value="${startDate}" required>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3">
                                                        <div class="form-group">
                                                            <label for="endDate">End Date</label>
                                                            <input type="date" class="form-control" id="endDate" name="endDate" 
                                                                   value="${endDate}" required>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="card-footer">
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="fas fa-chart-pie"></i> Generate Report
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
                                                <h2>Fruit Consumption Report</h2>
                                                <p>
                                                    <strong>Location:</strong> ${report.locationName} (${report.locationFilter})
                                                    <br>
                                                    <strong>Period:</strong> ${startDate} to ${endDate}
                                                    <br>
                                                    <strong>Season:</strong> ${report.season}
                                                    <br>
                                                    <strong>Generated on:</strong> <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd HH:mm:ss" />
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="card card-info">
                                                <div class="card-header">
                                                    <h3 class="card-title">Summary</h3>
                                                </div>
                                                <div class="card-body">
                                                    <div class="info-box">
                                                        <span class="info-box-icon bg-primary"><i class="fas fa-apple-alt"></i></span>
                                                        <div class="info-box-content">
                                                            <span class="info-box-text">Total Fruit Types</span>
                                                            <span class="info-box-number">${report.totalFruits}</span>
                                                        </div>
                                                    </div>
                                                    <div class="info-box">
                                                        <span class="info-box-icon bg-success"><i class="fas fa-shopping-basket"></i></span>
                                                        <div class="info-box-content">
                                                            <span class="info-box-text">Total Quantity</span>
                                                            <span class="info-box-number">${report.totalQuantity}</span>
                                                        </div>
                                                    </div>
                                                    <div class="info-box">
                                                        <span class="info-box-icon bg-warning"><i class="fas fa-chart-line"></i></span>
                                                        <div class="info-box-content">
                                                            <span class="info-box-text">Daily Average</span>
                                                            <span class="info-box-number">${report.averageDailyConsumption}</span>
                                                        </div>
                                                    </div>
                                                    <div class="info-box">
                                                        <span class="info-box-icon bg-danger"><i class="fas fa-percentage"></i></span>
                                                        <div class="info-box-content">
                                                            <span class="info-box-text">Growth Rate</span>
                                                            <span class="info-box-number">
                                                                ${report.growthRate}%
                                                                <c:if test="${report.growthRate > 0}">
                                                                    <i class="fas fa-arrow-up"></i>
                                                                </c:if>
                                                                <c:if test="${report.growthRate < 0}">
                                                                    <i class="fas fa-arrow-down"></i>
                                                                </c:if>
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-8">
                                            <div class="card card-success">
                                                <div class="card-header">
                                                    <h3 class="card-title">Consumption by Fruit</h3>
                                                </div>
                                                <div class="card-body">
                                                    <div class="chart-container">
                                                        <canvas id="fruitConsumptionChart" height="240"></canvas>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="card card-warning">
                                                <div class="card-header">
                                                    <h3 class="card-title">Daily Consumption Trend</h3>
                                                </div>
                                                <div class="card-body">
                                                    <div class="chart-container">
                                                        <canvas id="dailyConsumptionChart" height="200"></canvas>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="card card-danger">
                                                <div class="card-header">
                                                    <h3 class="card-title">Most/Least Consumed</h3>
                                                </div>
                                                <div class="card-body">
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="info-box bg-success">
                                                                <span class="info-box-icon"><i class="fas fa-thumbs-up"></i></span>
                                                                <div class="info-box-content">
                                                                    <span class="info-box-text">Most Consumed</span>
                                                                    <span class="info-box-number">${report.mostConsumedFruit}</span>
                                                                    <div class="progress">
                                                                        <div class="progress-bar" style="width: 100%"></div>
                                                                    </div>
                                                                    <span class="progress-description">
                                                                        ${report.mostConsumedQuantity} units
                                                                    </span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="info-box bg-warning">
                                                                <span class="info-box-icon"><i class="fas fa-thumbs-down"></i></span>
                                                                <div class="info-box-content">
                                                                    <span class="info-box-text">Least Consumed</span>
                                                                    <span class="info-box-number">${report.leastConsumedFruit}</span>
                                                                    <div class="progress">
                                                                        <div class="progress-bar" style="width: 100%"></div>
                                                                    </div>
                                                                    <span class="progress-description">
                                                                        ${report.leastConsumedQuantity} units
                                                                    </span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-6">
                                            <div class="card">
                                                <div class="card-header">
                                                    <h3 class="card-title">Percentage by Fruit</h3>
                                                </div>
                                                <div class="card-body">
                                                    <div class="chart-container">
                                                        <canvas id="percentageChart" height="200"></canvas>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="card">
                                                <div class="card-header">
                                                    <h3 class="card-title">Detailed Consumption Data</h3>
                                                </div>
                                                <div class="card-body table-responsive p-0">
                                                    <table class="table table-hover text-nowrap">
                                                        <thead>
                                                            <tr>
                                                                <th>Fruit</th>
                                                                <th>Quantity</th>
                                                                <th>Percentage</th>
                                                                <th>Daily Average</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="entry" items="${report.fruitConsumption}">
                                                                <tr>
                                                                    <td>${entry.key}</td>
                                                                    <td>${entry.value}</td>
                                                                    <td>
                                                                        <div class="progress progress-xs">
                                                                            <div class="progress-bar bg-primary" style="width: ${report.percentageByFruit[entry.key]}%"></div>
                                                                        </div>
                                                                        <span class="badge bg-primary">${report.percentageByFruit[entry.key]}%</span>
                                                                    </td>
                                                                    <td>
                                                                        <fmt:formatNumber value="${entry.value / 30.0}" maxFractionDigits="2" />
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
            const locationTypeSelect = document.getElementById('locationType');
            const locationIdSelect = document.getElementById('locationId');
            
            locationTypeSelect.addEventListener('change', function() {
                const selectedType = this.value;
                
                // Hide all options first
                Array.from(locationIdSelect.options).forEach(option => {
                    if (option.value === '') {
                        return;
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
                locationIdSelect.value = '';
            });
            
            // Trigger the change event to initialize
            locationTypeSelect.dispatchEvent(new Event('change'));
            
            // Set default dates if not already set
            const startDateInput = document.getElementById('startDate');
            const endDateInput = document.getElementById('endDate');
            
            if (!startDateInput.value) {
                const today = new Date();
                const oneMonthAgo = new Date();
                oneMonthAgo.setMonth(today.getMonth() - 1);
                
                startDateInput.value = oneMonthAgo.toISOString().split('T')[0];
                endDateInput.value = today.toISOString().split('T')[0];
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
                // 1. Fruit Consumption Chart
                const fruitLabels = [];
                const fruitData = [];
                const bgColors = [
                    'rgba(54, 162, 235, 0.7)',
                    'rgba(255, 99, 132, 0.7)',
                    'rgba(255, 206, 86, 0.7)',
                    'rgba(75, 192, 192, 0.7)',
                    'rgba(153, 102, 255, 0.7)',
                    'rgba(255, 159, 64, 0.7)',
                    'rgba(199, 199, 199, 0.7)'
                ];
                
                <c:forEach var="entry" items="${report.fruitConsumption}" varStatus="status">
                    fruitLabels.push('${entry.key}');
                    fruitData.push(${entry.value});
                </c:forEach>
                
                const fruitCtx = document.getElementById('fruitConsumptionChart').getContext('2d');
                const fruitChart = new Chart(fruitCtx, {
                    type: 'bar',
                    data: {
                        labels: fruitLabels,
                        datasets: [{
                            label: 'Consumption Quantity',
                            data: fruitData,
                            backgroundColor: bgColors.slice(0, fruitLabels.length),
                            borderWidth: 1
                        }]
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
                            }
                        }
                    }
                });
                
                // 2. Daily Consumption Chart
                const dateLabels = [];
                const dateData = [];
                
                <c:forEach var="entry" items="${report.consumptionByDay}">
                    dateLabels.push('${entry.key}');
                    dateData.push(${entry.value});
                </c:forEach>
                
                const dailyCtx = document.getElementById('dailyConsumptionChart').getContext('2d');
                const dailyChart = new Chart(dailyCtx, {
                    type: 'line',
                    data: {
                        labels: dateLabels,
                        datasets: [{
                            label: 'Daily Consumption',
                            data: dateData,
                            fill: false,
                            borderColor: 'rgb(75, 192, 192)',
                            tension: 0.1
                        }]
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
                            }
                        }
                    }
                });
                
                // 3. Percentage Chart
                const percentCtx = document.getElementById('percentageChart').getContext('2d');
                const percentChart = new Chart(percentCtx, {
                    type: 'pie',
                    data: {
                        labels: fruitLabels,
                        datasets: [{
                            data: [
                                <c:forEach var="entry" items="${report.percentageByFruit}" varStatus="status">
                                    ${entry.value}${!status.last ? ',' : ''}
                                </c:forEach>
                            ],
                            backgroundColor: bgColors.slice(0, fruitLabels.length)
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false
                    }
                });
            </c:if>
        });
    </script>
</body>
</html>
