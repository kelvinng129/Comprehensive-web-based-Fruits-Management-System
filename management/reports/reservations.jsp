<%-- 
    Document   : reservations
    Created on : 2025年4月20日, 上午9:55:48
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
    <title>Reservation Needs Reports</title>
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
                                    <h1 class="m-0">Reservation Needs Reports</h1>
                                </div>
                                <div class="col-sm-6">
                                    <ol class="breadcrumb float-sm-end">
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/management/dashboard">Home</a></li>
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/management/reports/dashboard">Analytics</a></li>
                                        <li class="breadcrumb-item active">Reservations</li>
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
                                            <h3 class="card-title">Generate Reservation Summary</h3>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/management/reports/reservations" method="post">
                                            <input type="hidden" name="action" value="generateReservationSummary">
                                            <div class="card-body">
                                                <div class="row">
                                                    <div class="col-md-3">
                                                        <div class="form-group">
                                                            <label for="summaryType">Summary Type</label>
                                                            <select class="form-select" id="summaryType" name="summaryType" required>
                                                                <option value="shop" ${summaryType == 'shop' ? 'selected' : ''}>Shop</option>
                                                                <option value="city" ${summaryType == 'city' ? 'selected' : ''}>City</option>
                                                                <option value="country" ${summaryType == 'country' ? 'selected' : ''}>Country</option>
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
                                                    <i class="fas fa-chart-pie"></i> Generate Summary
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
                                                <h2>Reservation Needs Summary</h2>
                                                <p>
                                                    <strong>Location:</strong> ${summary.locationName} (${summary.summaryType})
                                                    <br>
                                                    <strong>Period:</strong> ${startDate} to ${endDate}
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
                                                        <span class="info-box-icon bg-primary"><i class="fas fa-list-alt"></i></span>
                                                        <div class="info-box-content">
                                                            <span class="info-box-text">Total Reservations</span>
                                                            <span class="info-box-number">${summary.totalReservations}</span>
                                                        </div>
                                                    </div>
                                                    <div class="info-box">
                                                        <span class="info-box-icon bg-success"><i class="fas fa-shopping-basket"></i></span>
                                                        <div class="info-box-content">
                                                            <span class="info-box-text">Total Quantity</span>
                                                            <span class="info-box-number">${summary.totalQuantity}</span>
                                                        </div>
                                                    </div>
                                                    <div class="info-box">
                                                        <span class="info-box-icon bg-warning"><i class="fas fa-percentage"></i></span>
                                                        <div class="info-box-content">
                                                            <span class="info-box-text">Fulfillment Rate</span>
                                                            <span class="info-box-number">${summary.fulfillmentRate}%</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-8">
                                            <div class="card card-success">
                                                <div class="card-header">
                                                    <h3 class="card-title">Reservation Status</h3>
                                                </div>
                                                <div class="card-body">
                                                    <div class="chart-container">
                                                        <canvas id="reservationStatusChart" height="240"></canvas>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="card card-warning">
                                                <div class="card-header">
                                                    <h3 class="card-title">Fruit Distribution</h3>
                                                </div>
                                                <div class="card-body">
                                                    <div class="chart-container">
                                                        <canvas id="fruitDistributionChart" height="200"></canvas>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-6">
                                            <div class="card card-danger">
                                                <div class="card-header">
                                                    <h3 class="card-title">Time Distribution</h3>
                                                </div>
                                                <div class="card-body">
                                                    <div class="chart-container">
                                                        <canvas id="timeDistributionChart" height="200"></canvas>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="card">
                                                <div class="card-header">
                                                    <h3 class="card-title">Detailed Reservation Data</h3>
                                                </div>
                                                <div class="card-body table-responsive p-0">
                                                    <table class="table table-hover text-nowrap">
                                                        <thead>
                                                            <tr>
                                                                <th>Fruit</th>
                                                                <th>Quantity</th>
                                                                <th>Percentage</th>
                                                                <th>Status</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="entry" items="${summary.fruitDistribution}">
                                                                <tr>
                                                                    <td>${entry.key}</td>
                                                                    <td>${entry.value}</td>
                                                                    <td>
                                                                        <div class="progress progress-xs">
                                                                            <div class="progress-bar bg-primary" style="width: ${(entry.value * 100) / summary.totalQuantity}%"></div>
                                                                        </div>
                                                                        <span class="badge bg-primary">
                                                                            <fmt:formatNumber value="${(entry.value * 100) / summary.totalQuantity}" maxFractionDigits="1" />%
                                                                        </span>
                                                                    </td>
                                                                    <td>
                                                                        <span class="badge bg-success">
                                                                            <fmt:formatNumber value="${summary.fulfillmentRate}" maxFractionDigits="1" />% Fulfilled
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
                                    
                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="card">
                                                <div class="card-header">
                                                    <h3 class="card-title">Aggregated Reservation Needs</h3>
                                                    <div class="card-tools">
                                                        <button type="button" class="btn btn-tool" data-card-widget="collapse">
                                                            <i class="fas fa-minus"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                                <div class="card-body">
                                                    <p class="text-center">
                                                        <strong>Total Needs Forecast</strong>
                                                    </p>
                                                    
                                                    <div class="progress-group">
                                                        <c:forEach var="entry" items="${summary.fruitDistribution}">
                                                            <span class="progress-text">${entry.key}</span>
                                                            <span class="float-end"><b>${entry.value}</b>/100</span>
                                                            <div class="progress progress-sm">
                                                                <div class="progress-bar bg-primary" style="width: ${entry.value > 100 ? 100 : entry.value}%"></div>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                    
                                                    <p>
                                                        <strong>Recommended Action:</strong> Based on this analysis, plan for procurement of 
                                                        <c:forEach var="entry" items="${summary.fruitDistribution}" varStatus="status">
                                                            ${entry.value} units of ${entry.key}${status.last ? '' : ', '}
                                                        </c:forEach>
                                                        for optimal fulfillment of reservation needs.
                                                    </p>
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
            const summaryTypeSelect = document.getElementById('summaryType');
            const locationIdSelect = document.getElementById('locationId');
            
            summaryTypeSelect.addEventListener('change', function() {
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
                
                locationIdSelect.value = '';
            });
            
            // Trigger the change event to initialize
            summaryTypeSelect.dispatchEvent(new Event('change'));
            
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
                    
                    // Re-initialize the event listeners and charts
                    location.reload();
                });
            }
            
            <c:if test="${reportGenerated}">
                const statusCtx = document.getElementById('reservationStatusChart').getContext('2d');
                const statusChart = new Chart(statusCtx, {
                    type: 'doughnut',
                    data: {
                        labels: ['Pending', 'Approved', 'Rejected', 'Delivered'],
                        datasets: [{
                            data: [
                                ${summary.pendingReservations},
                                ${summary.approvedReservations},
                                ${summary.rejectedReservations},
                                ${summary.deliveredReservations}
                            ],
                            backgroundColor: [
                                'rgba(255, 193, 7, 0.7)', // Pending - warning
                                'rgba(23, 162, 184, 0.7)', // Approved - info
                                'rgba(220, 53, 69, 0.7)',  // Rejected - danger
                                'rgba(40, 167, 69, 0.7)'   // Delivered - success
                            ],
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false
                    }
                });
                
                // 2. Fruit Distribution Chart
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
                
                <c:forEach var="entry" items="${summary.fruitDistribution}" varStatus="status">
                    fruitLabels.push('${entry.key}');
                    fruitData.push(${entry.value});
                </c:forEach>
                
                const fruitCtx = document.getElementById('fruitDistributionChart').getContext('2d');
                const fruitChart = new Chart(fruitCtx, {
                    type: 'pie',
                    data: {
                        labels: fruitLabels,
                        datasets: [{
                            data: fruitData,
                            backgroundColor: bgColors.slice(0, fruitLabels.length),
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false
                    }
                });
                
                // 3. Time Distribution Chart
                const timeLabels = [];
                const timeData = [];
                
                <c:forEach var="entry" items="${summary.timeDistribution}" varStatus="status">
                    timeLabels.push('${entry.key}');
                    timeData.push(${entry.value});
                </c:forEach>
                
                const timeCtx = document.getElementById('timeDistributionChart').getContext('2d');
                const timeChart = new Chart(timeCtx, {
                    type: 'bar',
                    data: {
                        labels: timeLabels,
                        datasets: [{
                            label: 'Quantity',
                            data: timeData,
                            backgroundColor: 'rgba(220, 53, 69, 0.7)',
                            borderColor: 'rgba(220, 53, 69, 1)',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true
                            }
                        }
                    }
                });
            </c:if>
        });
    </script>
</body>
</html>