<%-- 
    Document   : select_location
    Created on : 2025年4月20日, 上午14:23:34
    Author     : kelvin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Location Configurations - FruitCart Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/config.css">
    <script src="https://kit.fontawesome.com/c5fe5e7547.js" crossorigin="anonymous"></script>
</head>
<body>
    <div class="dashboard-container">
        <%@ include file="../includes/sidebar.jsp" %>
        
        <div class="dashboard-content">
            <%@ include file="../includes/header.jsp" %>
            
            <div class="container mt-4">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/management/config/">Configurations</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Select Location</li>
                    </ol>
                </nav>
                
                <div class="card">
                    <div class="card-header bg-white">
                        <h5 class="mb-0">Select Location for Configuration Settings</h5>
                    </div>
                    <div class="card-body">
                        <p class="text-muted mb-4">
                            Select a location to view and manage location-specific configuration settings. 
                            Location-specific settings override global settings for the selected location.
                        </p>
                        
                        <div class="row">
                            <c:forEach var="location" items="${locations}">
                                <div class="col-md-4 mb-3">
                                    <div class="card location-card h-100">
                                        <div class="card-body">
                                            <h5 class="card-title">
                                                <i class="fas fa-building me-2"></i>
                                                ${location.locationName}
                                            </h5>
                                            <p class="card-text text-muted">${location.address}</p>
                                        </div>
                                        <div class="card-footer bg-white">
                                            <a href="${pageContext.request.contextPath}/management/config/location?locationId=${location.locationID}" 
                                               class="btn btn-outline-primary w-100">
                                               <i class="fas fa-cog me-2"></i> Manage Configuration
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            
                            <c:if test="${empty locations}">
                                <div class="col-12">
                                    <div class="empty-state">
                                        <i class="fas fa-building empty-state-icon"></i>
                                        <h4>No locations found</h4>
                                        <p class="text-muted">
                                            There are no locations available in the system.
                                        </p>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                        
                        <div class="mt-4">
                            <a href="${pageContext.request.contextPath}/management/config/" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Back to All Configurations
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
