<%-- 
    Document   : sku_forecast
    Created on : 2025年4月20日, 上午8:11:39
    Author     : kelvin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>SKU Delivery Forecast - FruitCart Management</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
        <script src="https://kit.fontawesome.com/c5fe5e7547.js" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            .forecast-card {
                transition: transform 0.2s;
            }

            .forecast-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            }

            .stat-card {
                border-radius: 10px;
                border: none;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
                margin-bottom: 20px;
                height: 100%;
            }

            .stat-icon {
                font-size: 2.5rem;
                opacity: 0.8;
            }

            .stat-value {
                font-size: 2rem;
                font-weight: 700;
            }

            .stat-label {
                font-size: 0.9rem;
                color: #6c757d;
            }

            .filter-form {
                background-color: #f8f9fa;
                border-radius: 10px;
                padding: 20px;
                margin-bottom: 20px;
            }

            .schedule-timeline {
                position: relative;
                padding-left: 45px;
            }

            .timeline-item {
                position: relative;
                padding-bottom: 20px;
            }

            .timeline-item:before {
                content: '';
                position: absolute;
                left: -30px;
                top: 0;
                height: 100%;
                width: 2px;
                background-color: #dee2e6;
            }

            .timeline-item:last-child:before {
                height: 0;
            }

            .timeline-point {
                position: absolute;
                left: -36px;
                top: 0;
                width: 14px;
                height: 14px;
                border-radius: 50%;
                background-color: #0d6efd;
                border: 2px solid white;
            }

            .timeline-item:last-child .timeline-point {
                background-color: #198754;
            }
        </style>
    </head>
    <body>
        <div class="dashboard-container">
            <%@ include file="../includes/sidebar.jsp" %>

            <div class="dashboard-content">
                <%@ include file="../includes/header.jsp" %>

                <div class="container-fluid mt-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2>
                            <i class="fas fa-truck-loading me-2"></i> SKU Delivery Forecast
                        </h2>
                    </div>

                    <div class="card filter-form">
                        <form action="${pageContext.request.contextPath}/management/forecast/generate" method="get">
                            <div class="row">
                                <div class="col-md-3">
                                    <div class="mb-3">
                                        <label for="countryId" class="form-label">Target Country</label>
                                        <select class="form-select" id="countryId" name="countryId" required>
                                            <option value="">Select Country</option>
                                            <c:forEach var="country" items="${countries}">
                                                <option value="${country.countryID}" ${country.countryID == selectedCountryId ? 'selected' : ''}>
                                                    ${country.countryName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="mb-3">
                                        <label for="fruitId" class="form-label">Fruit</label>
                                        <select class="form-select" id="fruitId" name="fruitId">
                                            <option value="0" ${selectedFruitId == 0 ? 'selected' : ''}>All Fruits</option>
                                            <c:forEach var="fruit" items="${fruits}">
                                                <option value="${fruit.fruitId}" ${fruit.fruitId == selectedFruitId ? 'selected' : ''}>
                                                    ${fruit.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="mb-3">
                                        <label for="periodDays" class="form-label">Forecast Period (Days)</label>
                                        <select class="form-select" id="periodDays" name="periodDays">
                                            <option value="30" ${selectedPeriodDays == 30 ? 'selected' : ''}>30 Days</option>
                                            <option value="60" ${selectedPeriodDays == 60 ? 'selected' : ''}>60 Days</option>
                                            <option value="90" ${selectedPeriodDays == 90 ? 'selected' : ''}>90 Days</option>
                                            <option value="180" ${selectedPeriodDays == 180 ? 'selected' : ''}>180 Days</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-3 d-flex align-items-end">
                                    <button type="submit" class="btn btn-primary w-100">
                                        <i class="fas fa-calculator me-2"></i> Generate Forecast
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>

                    <c:if test="${empty forecasts}">
                        <div class="card p-5 mb-4 text-center">
                            <div class="py-5">
                                <i class="fas fa-chart-line text-muted" style="font-size: 4rem;"></i>
                                <h3 class="mt-4">No Forecast Data</h3>
                                <p class="text-muted">
                                    Please select a country and generate a forecast to see SKU delivery optimization.
                                </p>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${not empty forecasts}">
                        <!-- Overall Summary Stats -->
                        <div class="row mb-4">
                            <div class="col-md-3">
                                <div class="card stat-card bg-primary text-white">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <div class="stat-label">Total Forecasted Need</div>
                                                <div class="stat-value">
                                                    <c:set var="totalNeed" value="0" />
                                                    <c:forEach var="forecast" items="${forecasts}">
                                                        <c:set var="totalNeed" value="${totalNeed + forecast.forecastedNeed}" />
                                                    </c:forEach>
                                                    <fmt:formatNumber value="${totalNeed}" pattern="#,###" />
                                                </div>
                                            </div>
                                            <div class="stat-icon">
                                                <i class="fas fa-shopping-basket"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card stat-card bg-success text-white">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <div class="stat-label">Optimized Deliveries</div>
                                                <div class="stat-value">
                                                    <c:set var="totalDeliveries" value="0" />
                                                    <c:forEach var="forecast" items="${forecasts}">
                                                        <c:set var="totalDeliveries" value="${totalDeliveries + forecast.scheduledDeliveries}" />
                                                    </c:forEach>
                                                    <fmt:formatNumber value="${totalDeliveries}" pattern="#,###" />
                                                </div>
                                            </div>
                                            <div class="stat-icon">
                                                <i class="fas fa-truck"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card stat-card bg-info text-white">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <div class="stat-label">Total Savings</div>
                                                <div class="stat-value">
                                                    <c:set var="totalSavings" value="0" />
                                                    <c:forEach var="forecast" items="${forecasts}">
                                                        <c:set var="totalSavings" value="${totalSavings + forecast.estimatedSavings}" />
                                                    </c:forEach>
                                                    $<fmt:formatNumber value="${totalSavings}" pattern="#,###" />
                                                </div>
                                            </div>
                                            <div class="stat-icon">
                                                <i class="fas fa-dollar-sign"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card stat-card bg-warning text-white">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <div class="stat-label">Avg Delivery Time</div>
                                                <div class="stat-value">
                                                    <c:set var="totalTime" value="0" />
                                                    <c:set var="count" value="0" />
                                                    <c:forEach var="forecast" items="${forecasts}">
                                                        <c:set var="totalTime" value="${totalTime + forecast.avgDeliveryTime}" />
                                                        <c:set var="count" value="${count + 1}" />
                                                    </c:forEach>
                                                    <fmt:formatNumber value="${totalTime / count}" pattern="#.# days" />
                                                </div>
                                            </div>
                                            <div class="stat-icon">
                                                <i class="fas fa-clock"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Consumption Trend Chart -->
                        <div class="card mb-4">
                            <div class="card-header bg-white">
                                <h5 class="mb-0">Historical Consumption Trends</h5>
                            </div>
                            <div class="card-body">
                                <div style="height: 300px;">
                                    <canvas id="consumptionChart"></canvas>
                                </div>
                            </div>
                        </div>

                        <!-- Detailed Forecast Cards -->
                        <h4 class="mb-3">SKU Optimization by Fruit</h4>
                        <div class="row">
                            <c:forEach var="forecast" items="${forecasts}">
                                <div class="col-md-6 mb-4">
                                    <div class="card forecast-card">
                                        <div class="card-header bg-white">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <h5 class="mb-0">${forecast.fruitName}</h5>
                                                <span class="badge bg-primary">
                                                    <fmt:formatNumber value="${forecast.avgDailyConsumption}" pattern="#.##"/> units/day
                                                </span>
                                            </div>
                                        </div>
                                        <div class="card-body">
                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <h6 class="text-muted">Optimal Batch Size</h6>
                                                        <p class="fs-4 fw-bold">
                                                            ${forecast.optimalBatchSize} units
                                                        </p>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <h6 class="text-muted">Delivery Frequency</h6>
                                                        <p class="fs-4 fw-bold">
                                                            Every ${forecast.deliveryFrequency} days
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <h6 class="text-muted">Total Forecasted Need</h6>
                                                        <p class="fs-5">
                                                            ${forecast.forecastedNeed} units over ${forecast.forecastPeriod} days
                                                        </p>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <h6 class="text-muted">Scheduled Deliveries</h6>
                                                        <p class="fs-5">
                                                            ${forecast.scheduledDeliveries} deliveries
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="alert alert-success">
                                                <div class="d-flex align-items-center">
                                                    <div class="me-3 fs-3">
                                                        <i class="fas fa-dollar-sign"></i>
                                                    </div>
                                                    <div>
                                                        <p class="mb-0">Estimated savings with SKU optimization:</p>
                                                        <p class="fw-bold mb-0 fs-4">$<fmt:formatNumber value="${forecast.estimatedSavings}" pattern="#,###.##"/></p>
                                                    </div>
                                                </div>
                                            </div>

                                            <h6 class="mt-4">Delivery Schedule Timeline</h6>
                                            <div class="schedule-timeline mt-3">
                                                <c:forEach var="i" begin="1" end="${forecast.scheduledDeliveries > 3 ? 3 : forecast.scheduledDeliveries}">
                                                    <div class="timeline-item">
                                                        <div class="timeline-point"></div>
                                                        <div class="timeline-content">
                                                            <p class="mb-0 fw-bold">Delivery #${i}: Day ${(i-1) * forecast.deliveryFrequency + 1}</p>
                                                            <p class="text-muted mb-0">
                                                                ${forecast.optimalBatchSize} units of ${forecast.fruitName}
                                                            </p>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                                <c:if test="${forecast.scheduledDeliveries > 3}">
                                                    <div class="timeline-item">
                                                        <div class="timeline-point"></div>
                                                        <div class="timeline-content">
                                                            <p class="mb-0 fw-bold text-success">+ ${forecast.scheduledDeliveries - 3} more deliveries following the same pattern</p>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>

        <c:if test="${not empty consumptionTrends}">
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    // Process the data for the chart
                    const periods = [];
                    const datasets = {};

                <c:forEach var="item" items="${consumptionTrends}">
                if (!periods.includes('${item.period}')) {
                    periods.push('${item.period}');
                    }

                if (!datasets['${item.fruitName}']) {
                    datasets['${item.fruitName}'] = {
                        label: '${item.fruitName}',
                            data: [],
                            borderColor: getRandomColor(),
                            backgroundColor: 'rgba(0, 0, 0, 0.1)',
                            fill: false,
                            tension: 0.4
                        };
                    }
                </c:forEach>

                    periods.sort();

                    for (const fruitName in datasets) {
                        datasets[fruitName].data = new Array(periods.length).fill(0);
                    }

                <c:forEach var="item" items="${consumptionTrends}">
                const periodIndex = periods.indexOf('${item.period}');
                datasets['${item.fruitName}'].data[periodIndex] = ${item.quantity};
                </c:forEach>

                    const ctx = document.getElementById('consumptionChart').getContext('2d');
                    const chart = new Chart(ctx, {
                        type: 'line',
                        data: {
                            labels: periods,
                            datasets: Object.values(datasets)
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            interaction: {
                                mode: 'index',
                                intersect: false
                            },
                            plugins: {
                                title: {
                                    display: true,
                                    text: 'Monthly Consumption Trends'
                                },
                                tooltip: {
                                    mode: 'index',
                                    intersect: false
                                }
                            },
                            scales: {
                                y: {
                                    title: {
                                        display: true,
                                        text: 'Consumption (Units)'
                                    },
                                    beginAtZero: true
                                },
                                x: {
                                    title: {
                                        display: true,
                                        text: 'Month'
                                    }
                                }
                            }
                        }
                    });

                    function getRandomColor() {
                        const colors = [
                            '#4285F4', '#DB4437', '#F4B400', '#0F9D58',
                            '#9C27B0', '#3F51B5', '#795548', '#607D8B',
                            '#FF5722', '#FF9800', '#00BCD4', '#009688'
                        ];
                        const colorIndex = Math.floor(Math.random() * colors.length);
                        return colors[colorIndex];
                    }
                });
            </script>
        </c:if>
    </body>
</html>