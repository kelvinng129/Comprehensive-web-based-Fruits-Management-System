<%-- 
    Document   : configForm
    Created on : 2025年4月20日, 上午2:04:46
    Author     : kelvin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Edit' : 'New'} Workflow Configuration - Warehouse Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <style>
        .required-field::after {
            content: "*";
            color: red;
            margin-left: 4px;
        }
    </style>
</head>
<body>
    <jsp:include page="../include/header.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1>${isEdit ? 'Edit' : 'New'} Workflow Configuration</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/warehouse/approvals/list">Approvals</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/warehouse/approvals/config">Workflow Configurations</a></li>
                        <li class="breadcrumb-item active" aria-current="page">${isEdit ? 'Edit' : 'New'} Configuration</li>
                    </ol>
                </nav>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-cog me-2"></i> ${isEdit ? 'Edit' : 'Create'} Configuration</h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/warehouse/approvals" method="post">
                            <input type="hidden" name="action" value="saveConfig">
                            
                            <c:if test="${isEdit}">
                                <input type="hidden" name="configId" value="${config.configId}">
                            </c:if>
                            
                            <!-- Configuration Name -->
                            <div class="mb-3">
                                <label for="name" class="form-label required-field">Configuration Name</label>
                                <input type="text" class="form-control" id="name" name="name" 
                                       value="${isEdit ? config.name : ''}" required>
                            </div>
                            
                            <!-- Request Type -->
                            <div class="mb-3">
                                <label for="requestTypeId" class="form-label required-field">Request Type</label>
                                <select class="form-select" id="requestTypeId" name="requestTypeId" required>
                                    <option value="" disabled selected>-- Select Request Type --</option>
                                    <c:forEach var="type" items="${requestTypes}">
                                        <option value="${type.typeId}" 
                                                ${(isEdit && config.requestTypeId == type.typeId) ? 'selected' : ''}>
                                            ${type.typeName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            
                            <!-- Description -->
                            <div class="mb-3">
                                <label for="description" class="form-label">Description</label>
                                <textarea class="form-control" id="description" name="description" rows="3">${isEdit ? config.description : ''}</textarea>
                            </div>
                            
                            <!-- Approval Steps -->
                            <div class="mb-3">
                                <label for="approvalSteps" class="form-label required-field">Approval Steps</label>
                                <input type="number" class="form-control" id="approvalSteps" name="approvalSteps" 
                                       min="1" max="5" value="${isEdit ? config.approvalSteps : '1'}" required>
                                <div class="form-text">Number of approval steps required for this workflow.</div>
                            </div>
                            
                            <!-- Auto Assign To -->
                            <div class="mb-3">
                                <label for="autoAssignTo" class="form-label">Auto-Assign To</label>
                                <select class="form-select" id="autoAssignTo" name="autoAssignTo">
                                    <option value="">-- No Auto-Assignment --</option>
                                    <c:forEach var="approver" items="${approvers}">
                                        <option value="${approver.userID}" 
                                                ${(isEdit && config.autoAssignTo == approver.userID) ? 'selected' : ''}>
                                            ${approver.fullName}
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="form-text">User to automatically assign requests to.</div>
                            </div>
                            
                            <!-- Notification Emails -->
                            <div class="mb-3">
                                <label for="notificationEmails" class="form-label">Notification Emails</label>
                                <input type="text" class="form-control" id="notificationEmails" name="notificationEmails" 
                                       value="${isEdit ? config.notificationEmails : ''}">
                                <div class="form-text">Comma-separated list of email addresses to notify.</div>
                            </div>
                            
                            <!-- Is Active -->
                            <div class="mb-4 form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="isActive" name="isActive" 
                                       ${(isEdit && config.active) || !isEdit ? 'checked' : ''}>
                                <label class="form-check-label" for="isActive">Active</label>
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="${pageContext.request.contextPath}/warehouse/approvals/config" class="btn btn-outline-secondary me-md-2">
                                    Cancel
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-1"></i> Save Configuration
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <!-- Help Panel -->
                <div class="card mb-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i> Configuration Help</h5>
                    </div>
                    <div class="card-body">
                        <h6>Configuration Settings</h6>
                        <ul class="small">
                            <li><strong>Name:</strong> A descriptive name for this workflow</li>
                            <li><strong>Request Type:</strong> The type of request this workflow applies to</li>
                            <li><strong>Approval Steps:</strong> Number of approvals required</li>
                            <li><strong>Auto-Assign:</strong> User to automatically assign requests to</li>
                            <li><strong>Notifications:</strong> Emails to notify about new requests</li>
                            <li><strong>Active:</strong> Whether this workflow is currently active</li>
                        </ul>
                        
                        <div class="alert alert-warning mt-3 small">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Fields marked with <span class="text-danger">*</span> are required.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../include/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>