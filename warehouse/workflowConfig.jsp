<%-- 
    Document   : workflowConfig
    Created on : 2025年4月20日, 上午2:01:06
    Author     : kelvin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Workflow Configuration - Warehouse Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <style>
        .config-card {
            transition: transform 0.2s;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }
        .config-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .config-title {
            font-size: 1.1rem;
            font-weight: 600;
        }
        .status-indicator {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 8px;
        }
        .status-active {
            background-color: #198754;
        }
        .status-inactive {
            background-color: #6c757d;
        }
    </style>
</head>
<body>
    <jsp:include page="../include/header.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1>Workflow Configuration</h1>
                <p class="text-muted">Manage approval workflow settings and rules</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/warehouse/approvals/configForm" class="btn btn-primary">
                    <i class="fas fa-plus-circle"></i> New Configuration
                </a>
                <a href="${pageContext.request.contextPath}/warehouse/approvals/list" class="btn btn-outline-secondary ms-2">
                    <i class="fas fa-arrow-left"></i> Back to Approvals
                </a>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-9">
                <!-- Configurations List -->
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-cogs me-2"></i> Workflow Configurations</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty configs}">
                                <div class="row">
                                    <c:forEach var="config" items="${configs}">
                                        <div class="col-md-6">
                                            <div class="card config-card">
                                                <div class="card-body">
                                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                                        <span class="config-title">${config.name}</span>
                                                        <div>
                                                            <span class="status-indicator ${config.active ? 'status-active' : 'status-inactive'}"></span>
                                                            <span class="small">${config.active ? 'Active' : 'Inactive'}</span>
                                                        </div>
                                                    </div>
                                                    
                                                    <p class="text-muted small mb-3">${config.requestTypeName}</p>
                                                    
                                                    <div class="mb-2 small">
                                                        <strong>Approval Steps:</strong> ${config.approvalSteps}
                                                    </div>
                                                    
                                                    <div class="mb-2 small">
                                                        <strong>Auto-Assign:</strong> 
                                                        <c:choose>
                                                            <c:when test="${not empty config.autoAssignToName}">
                                                                ${config.autoAssignToName}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">Not set</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    
                                                    <div class="mb-3 small">
                                                        <strong>Created By:</strong> ${config.createdByName}
                                                        <br>
                                                        <strong>Last Updated:</strong> <fmt:formatDate value="${config.updatedAt}" pattern="yyyy-MM-dd HH:mm" />
                                                    </div>
                                                    
                                                    <div class="text-end">
                                                        <a href="${pageContext.request.contextPath}/warehouse/approvals/configForm?id=${config.configId}" class="btn btn-sm btn-outline-primary">
                                                            <i class="fas fa-edit me-1"></i> Edit
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="fas fa-cog fa-4x text-muted mb-3"></i>
                                    <h4>No Configurations Found</h4>
                                    <p class="text-muted">No workflow configurations have been created yet.</p>
                                    <a href="${pageContext.request.contextPath}/warehouse/approvals/configForm" class="btn btn-primary mt-2">
                                        <i class="fas fa-plus-circle me-1"></i> Create First Configuration
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3">
                <!-- Help Panel -->
                <div class="card mb-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i> About Workflows</h5>
                    </div>
                    <div class="card-body">
                        <p class="small">
                            Workflow configurations define how approval requests are processed in the system.
                        </p>
                        <h6>Key Settings:</h6>
                        <ul class="small">
                            <li><strong>Request Type:</strong> The type of request this workflow applies to</li>
                            <li><strong>Approval Steps:</strong> Number of approval steps required</li>
                            <li><strong>Auto-Assign:</strong> Staff member to automatically assign requests to</li>
                            <li><strong>Notifications:</strong> Email addresses for notifications</li>
                        </ul>
                    </div>
                </div>
                
                <!-- Quick Links -->
                <div class="card">
                    <div class="card-header bg-light">
                        <h5 class="mb-0"><i class="fas fa-link me-2"></i> Quick Links</h5>
                    </div>
                    <div class="card-body">
                        <div class="list-group">
                            <a href="${pageContext.request.contextPath}/warehouse/approvals/list" class="list-group-item list-group-item-action">
                                <i class="fas fa-clipboard-list me-2"></i> Approval Requests
                            </a>
                            <a href="${pageContext.request.contextPath}/warehouse/approvals/pending" class="list-group-item list-group-item-action">
                                <i class="fas fa-clock me-2"></i> Pending Approvals
                            </a>
                            <a href="${pageContext.request.contextPath}/warehouse/inventory" class="list-group-item list-group-item-action">
                                <i class="fas fa-warehouse me-2"></i> Warehouse Inventory
                            </a>
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