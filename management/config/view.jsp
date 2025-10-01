<%-- 
    Document   : view
    Created on : 2025年4月20日, 上午14:22:11
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
    <title>View Configuration - FruitCart Management</title>
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
                        <li class="breadcrumb-item active" aria-current="page">View Configuration</li>
                    </ol>
                </nav>
                
                <div class="card">
                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Configuration Details</h5>
                        <div>
                            <a href="${pageContext.request.contextPath}/management/config/edit?id=${config.configID}" class="btn btn-primary btn-sm">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="config-detail-item">
                                    <h6 class="text-muted">Display Name</h6>
                                    <p class="fs-5">${config.displayName}</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="config-detail-item">
                                    <h6 class="text-muted">Config Key</h6>
                                    <p><code class="fs-5">${config.configKey}</code></p>
                                </div>
                            </div>
                        </div>
                        
                        <hr>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="config-detail-item">
                                    <h6 class="text-muted">Value</h6>
                                    <c:choose>
                                        <c:when test="${config.configType == 'boolean'}">
                                            <span class="badge fs-6 ${config.valueAsBoolean ? 'bg-success' : 'bg-danger'}">
                                                ${config.valueAsBoolean ? 'True' : 'False'}
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="fs-5">${config.configValue}</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="config-detail-item">
                                    <h6 class="text-muted">Type</h6>
                                    <span class="badge bg-secondary fs-6">${config.configType}</span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row mt-3">
                            <div class="col-md-6">
                                <div class="config-detail-item">
                                    <h6 class="text-muted">Category</h6>
                                    <span class="badge fs-6
                                        ${config.category == 'system' ? 'bg-primary' : 
                                        config.category == 'email' ? 'bg-info' : 
                                        config.category == 'business' ? 'bg-warning' : 
                                        config.category == 'ui' ? 'bg-success' : 'bg-secondary'}">
                                        ${config.category}
                                    </span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="config-detail-item">
                                    <h6 class="text-muted">Status</h6>
                                    <span class="badge fs-6 ${config.active ? 'bg-success' : 'bg-danger'}">
                                        ${config.active ? 'Active' : 'Inactive'}
                                    </span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row mt-3">
                            <div class="col-md-6">
                                <div class="config-detail-item">
                                    <h6 class="text-muted">Location</h6>
                                    <p>
                                        <c:choose>
                                            <c:when test="${not empty location}">
                                                <span class="badge bg-info">${location.locationName}</span>
                                                <span class="text-muted">(Location-specific setting)</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Global</span>
                                                <span class="text-muted">(Applies to all locations)</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="config-detail-item">
                                    <h6 class="text-muted">Last Updated</h6>
                                    <p><fmt:formatDate value="${config.updatedAt}" pattern="MMM dd, yyyy HH:mm:ss" /></p>
                                </div>
                            </div>
                        </div>
                        
                        <c:if test="${not empty config.description}">
                            <div class="mt-4">
                                <h6 class="text-muted">Description</h6>
                                <div class="p-3 bg-light rounded">
                                    ${config.description}
                                </div>
                            </div>
                        </c:if>
                        
                        <div class="mt-4">
                            <a href="${pageContext.request.contextPath}/management/config/" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Back to Configurations
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