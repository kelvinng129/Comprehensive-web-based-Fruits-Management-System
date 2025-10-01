<%-- 
    Document   : list
    Created on : 2025年4月20日, 上午13:15:44
    Author     : kelvin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Configurations - FruitCart Management</title>
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
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>System Configurations</h2>
                    <a href="${pageContext.request.contextPath}/management/config/create" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Add New Configuration
                    </a>
                </div>
                
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${sessionScope.successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>
                
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${sessionScope.errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>
                
                <div class="card mb-4">
                    <div class="card-header bg-white">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">Configuration Settings</h5>
                            <div class="d-flex">
                                <div class="me-2">
                                    <form id="categoryFilterForm" method="get" action="${pageContext.request.contextPath}/management/config/">
                                        <select class="form-select" name="category" onchange="document.getElementById('categoryFilterForm').submit();">
                                            <option value="all" ${selectedCategory == 'all' ? 'selected' : ''}>All Categories</option>
                                            <option value="system" ${selectedCategory == 'system' ? 'selected' : ''}>System</option>
                                            <option value="email" ${selectedCategory == 'email' ? 'selected' : ''}>Email</option>
                                            <option value="business" ${selectedCategory == 'business' ? 'selected' : ''}>Business Rules</option>
                                            <option value="ui" ${selectedCategory == 'ui' ? 'selected' : ''}>User Interface</option>
                                        </select>
                                    </form>
                                </div>
                                <a href="${pageContext.request.contextPath}/management/config/location" class="btn btn-outline-secondary">
                                    <i class="fas fa-building"></i> Location Settings
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Key</th>
                                        <th>Value</th>
                                        <th>Type</th>
                                        <th>Category</th>
                                        <th>Status</th>
                                        <th width="120">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="config" items="${configs}">
                                        <tr>
                                            <td>${config.displayName}</td>
                                            <td><code>${config.configKey}</code></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${config.configType == 'boolean'}">
                                                        <span class="badge ${config.valueAsBoolean ? 'bg-success' : 'bg-danger'}">
                                                            ${config.valueAsBoolean ? 'True' : 'False'}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${config.configValue}
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><span class="badge bg-secondary">${config.configType}</span></td>
                                            <td>
                                                <span class="badge 
                                                    ${config.category == 'system' ? 'bg-primary' : 
                                                    config.category == 'email' ? 'bg-info' : 
                                                    config.category == 'business' ? 'bg-warning' : 
                                                    config.category == 'ui' ? 'bg-success' : 'bg-secondary'}">
                                                    ${config.category}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge ${config.active ? 'bg-success' : 'bg-danger'}">
                                                    ${config.active ? 'Active' : 'Inactive'}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="btn-group btn-group-sm">
                                                    <a href="${pageContext.request.contextPath}/management/config/view?id=${config.configID}" class="btn btn-outline-secondary">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/management/config/edit?id=${config.configID}" class="btn btn-outline-primary">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-outline-danger" 
                                                            onclick="confirmDelete(${config.configID}, '${config.displayName}')">
                                                        <i class="fas fa-trash-alt"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty configs}">
                                        <tr>
                                            <td colspan="7" class="text-center py-4">
                                                <div class="empty-state">
                                                    <i class="fas fa-cog empty-state-icon"></i>
                                                    <h4>No configurations found</h4>
                                                    <p class="text-muted">
                                                        ${selectedCategory != 'all' ? 'No configurations found in this category.' : 'No system configurations are available.'}
                                                    </p>
                                                    <a href="${pageContext.request.contextPath}/management/config/create" class="btn btn-primary">
                                                        <i class="fas fa-plus"></i> Add Configuration
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Confirm Deletion</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete the configuration "<span id="configName"></span>"?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/management/config/">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" id="configId" name="id" value="">
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete(id, name) {
            document.getElementById('configId').value = id;
            document.getElementById('configName').textContent = name;
            var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            deleteModal.show();
        }
    </script>
</body>
</html>