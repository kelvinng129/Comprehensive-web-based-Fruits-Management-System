<%-- 
    Document   : create
    Created on : 2025年4月20日, 上午13:41:54
    Author     : kelvin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Configuration - FruitCart Management</title>
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
                        <li class="breadcrumb-item active" aria-current="page">Create Configuration</li>
                    </ol>
                </nav>
                
                <div class="card">
                    <div class="card-header bg-white">
                        <h5 class="mb-0">Create New Configuration</h5>
                    </div>
                    <div class="card-body">
                        <form method="post" action="${pageContext.request.contextPath}/management/config/" class="config-form">
                            <input type="hidden" name="action" value="create">
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="configKey" class="form-label">Config Key <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="configKey" name="configKey" required pattern="[a-zA-Z0-9._]+"
                                           placeholder="e.g., system.feature.enabled">
                                    <div class="form-text">Use dot notation for hierarchical keys (e.g., category.feature.setting)</div>
                                </div>
                                <div class="col-md-6">
                                    <label for="displayName" class="form-label">Display Name <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="displayName" name="displayName" required
                                           placeholder="e.g., Feature Enabled">
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="configType" class="form-label">Value Type <span class="text-danger">*</span></label>
                                    <select class="form-select" id="configType" name="configType" required onchange="updateValueField()">
                                        <option value="string">String</option>
                                        <option value="int">Integer</option>
                                        <option value="boolean">Boolean</option>
                                        <option value="double">Decimal</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="category" class="form-label">Category <span class="text-danger">*</span></label>
                                    <select class="form-select" id="category" name="category" required>
                                        <option value="system">System</option>
                                        <option value="email">Email</option>
                                        <option value="business">Business Rules</option>
                                        <option value="ui">User Interface</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="mb-3" id="valueContainer">
                                <label for="configValue" class="form-label">Value <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="configValue" name="configValue" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="description" class="form-label">Description</label>
                                <textarea class="form-control" id="description" name="description" rows="3"
                                          placeholder="Describe what this configuration controls..."></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label for="locationId" class="form-label">Location (Optional)</label>
                                <select class="form-select" id="locationId" name="locationId">
                                    <option value="">Global Setting (All Locations)</option>
                                    <c:forEach var="location" items="${locations}">
                                        <option value="${location.locationID}" 
                                                ${preselectedLocationId == location.locationID ? 'selected' : ''}>
                                            ${location.locationName}
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="form-text">If selected, this setting will only apply to the specific location</div>
                            </div>
                            
                            <div class="mb-3 form-check">
                                <input type="checkbox" class="form-check-input" id="isActive" name="isActive" checked>
                                <label class="form-check-label" for="isActive">Active</label>
                            </div>
                            
                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Save Configuration
                                </button>
                                <a href="${pageContext.request.contextPath}/management/config/" class="btn btn-secondary">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    <script>
        function updateValueField() {
            const configType = document.getElementById('configType').value;
            const valueContainer = document.getElementById('valueContainer');
            
            let html = '<label for="configValue" class="form-label">Value <span class="text-danger">*</span></label>';
            
            if (configType === 'boolean') {
                html += `
                    <select class="form-select" id="configValue" name="configValue" required>
                        <option value="true">True</option>
                        <option value="false">False</option>
                    </select>`;
            } else if (configType === 'int') {
                html += '<input type="number" step="1" class="form-control" id="configValue" name="configValue" required>';
            } else if (configType === 'double') {
                html += '<input type="number" step="0.01" class="form-control" id="configValue" name="configValue" required>';
            } else {
                html += '<input type="text" class="form-control" id="configValue" name="configValue" required>';
            }
            
            valueContainer.innerHTML = html;
        }
    </script>
</body>
</html>