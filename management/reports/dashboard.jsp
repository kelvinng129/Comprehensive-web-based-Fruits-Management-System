<%-- 
    Document   : dashboard
    Created on : 2025年4月20日, 上午9:43:05
    Author     : kelvin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analytics Dashboard</title>
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
                                    <h1 class="m-0">Analytics Dashboard</h1>
                                </div>
                                <div class="col-sm-6">
                                    <ol class="breadcrumb float-sm-end">
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/management/dashboard">Home</a></li>
                                        <li class="breadcrumb-item active">Analytics</li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="content">
                        <div class="container-fluid">
                            <div class="row">
                                <div class="col-lg-3 col-6">
                                    <div class="small-box bg-info">
                                        <div class="inner">
                                            <h3>Consumption</h3>
                                            <p>Analyze fruit usage patterns</p>
                                        </div>
                                        <div class="icon">
                                            <i class="fas fa-chart-line"></i>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/management/reports/consumption" class="small-box-footer">
                                            Generate Report <i class="fas fa-arrow-circle-right"></i>
                                        </a>
                                    </div>
                                </div>
                                
                                <div class="col-lg-3 col-6">
                                    <div class="small-box bg-success">
                                        <div class="inner">
                                            <h3>Reservations</h3>
                                            <p>View reservation summaries</p>
                                        </div>
                                        <div class="icon">
                                            <i class="fas fa-calendar-check"></i>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/management/reports/reservations" class="small-box-footer">
                                            Generate Report <i class="fas fa-arrow-circle-right"></i>
                                        </a>
                                    </div>
                                </div>
                                
                                <div class="col-lg-3 col-6">
                                    <div class="small-box bg-warning">
                                        <div class="inner">
                                            <h3>Forecasting</h3>
                                            <p>Predict future needs</p>
                                        </div>
                                        <div class="icon">
                                            <i class="fas fa-brain"></i>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/management/reports/forecast" class="small-box-footer">
                                            Generate Report <i class="fas fa-arrow-circle-right"></i>
                                        </a>
                                    </div>
                                </div>
                                
                                <div class="col-lg-3 col-6">
                                    <div class="small-box bg-danger">
                                        <div class="inner">
                                            <h3>SKU Delivery</h3>
                                            <p>Optimize delivery timelines</p>
                                        </div>
                                        <div class="icon">
                                            <i class="fas fa-truck-fast"></i>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/management/reports/forecast" class="small-box-footer">
                                            Analyze Timelines <i class="fas fa-arrow-circle-right"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title">
                                                <i class="fas fa-chart-pie me-1"></i>
                                                Quick Overview
                                            </h3>
                                        </div>
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-8">
                                                    <div class="chart-responsive">
                                                        <canvas id="pieChart" height="200"></canvas>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <ul class="chart-legend clearfix">
                                                        <li><i class="fas fa-circle text-danger"></i> Japan</li>
                                                        <li><i class="fas fa-circle text-success"></i> USA</li>
                                                        <li><i class="fas fa-circle text-warning"></i> Hong Kong</li>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card-footer bg-light p-0">
                                            <ul class="nav nav-pills flex-column">
                                                <li class="nav-item">
                                                    <a href="${pageContext.request.contextPath}/management/reports/consumption" class="nav-link">
                                                        View Consumption Details
                                                        <i class="fas fa-arrow-right float-end mt-1"></i>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title">
                                                <i class="fas fa-list-ul me-1"></i>
                                                Recent Reports
                                            </h3>
                                        </div>
                                        <div class="card-body p-0">
                                            <ul class="products-list product-list-in-card px-3 py-2">
                                                <li class="item">
                                                    <div class="product-info">
                                                        <a href="javascript:void(0)" class="product-title">
                                                            Japan Consumption Report
                                                            <span class="badge bg-info float-end">Today</span>
                                                        </a>
                                                        <span class="product-description">
                                                            Monthly fruit consumption analysis for all Japan locations
                                                        </span>
                                                    </div>
                                                </li>
                                                <li class="item">
                                                    <div class="product-info">
                                                        <a href="javascript:void(0)" class="product-title">
                                                            USA Q2 Reservations
                                                            <span class="badge bg-success float-end">Yesterday</span>
                                                        </a>
                                                        <span class="product-description">
                                                            Reservation fulfillment rates for Q2 in USA locations
                                                        </span>
                                                    </div>
                                                </li>
                                                <li class="item">
                                                    <div class="product-info">
                                                        <a href="javascript:void(0)" class="product-title">
                                                            Hong Kong Forecast
                                                            <span class="badge bg-warning float-end">2 days ago</span>
                                                        </a>
                                                        <span class="product-description">
                                                            3-month forecast for Hong Kong bakeries
                                                        </span>
                                                    </div>
                                                </li>
                                                <li class="item">
                                                    <div class="product-info">
                                                        <a href="javascript:void(0)" class="product-title">
                                                            Annual SKU Analysis
                                                            <span class="badge bg-danger float-end">1 week ago</span>
                                                        </a>
                                                        <span class="product-description">
                                                            Yearly SKU delivery optimization across all regions
                                                        </span>
                                                    </div>
                                                </li>
                                            </ul>
                                        </div>
                                        <div class="card-footer bg-light text-center">
                                            <a href="javascript:void(0)" class="text-sm">View All Reports</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title">
                                                <i class="fas fa-chart-bar me-1"></i>
                                                Year-to-Date Consumption Trends
                                            </h3>
                                        </div>
                                        <div class="card-body">
                                            <div class="chart">
                                                <canvas id="barChart" style="min-height: 250px; height: 250px; max-height: 250px; max-width: 100%;"></canvas>
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
    
    <jsp:include page="../includes/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const pieCtx = document.getElementById('pieChart').getContext('2d');
            const pieChart = new Chart(pieCtx, {
                type: 'pie',
                data: {
                    labels: ['Japan', 'USA', 'Hong Kong'],
                    datasets: [{
                        data: [45, 30, 25],
                        backgroundColor: ['#dc3545', '#28a745', '#ffc107']
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    }
                }
            });

            const barCtx = document.getElementById('barChart').getContext('2d');
            const barChart = new Chart(barCtx, {
                type: 'bar',
                data: {
                    labels: ['January', 'February', 'March', 'April', 'May', 'June'],
                    datasets: [
                        {
                            label: 'Japan',
                            data: [10, 15, 12, 14, 17, 16],
                            backgroundColor: 'rgba(220, 53, 69, 0.7)'
                        },
                        {
                            label: 'USA',
                            data: [8, 9, 10, 12, 13, 15],
                            backgroundColor: 'rgba(40, 167, 69, 0.7)'
                        },
                        {
                            label: 'Hong Kong',
                            data: [5, 6, 7, 8, 9, 10],
                            backgroundColor: 'rgba(255, 193, 7, 0.7)'
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
                                text: 'Quantity (thousands)'
                            }
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>>
