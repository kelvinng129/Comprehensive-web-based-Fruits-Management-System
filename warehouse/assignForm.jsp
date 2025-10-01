<%-- 
    Document   : assignForm
    Created on : 2025年4月20日, 上午1:00:45
    Author     : kelvin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assign Request - Warehouse Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>
    <jsp:include page="../include/header.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1>Assign Request</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/warehouse/approvals/list">Approvals</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/warehouse/approvals/details?id=${approvalRequest.requestId}">Request #${approvalRequest.requestId}</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Assign</li>
                    </ol>
                </nav>
            </div>
        </div>
        
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-user-check me-2"></i> Assign Request</h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-4">
                            <h6>Request: ${approvalRequest.title}</h6>
                            <p class="text-muted small mb-0">${approvalRequest.requestTypeName} - ${approvalRequest.priority} priority</p>
                        </div>
                        
                        <form action="${pageContext.request.contextPath}/warehouse/approvals" method="post">
                            <input type="hidden" name="action" value="assignRequest">
                            <input type="hidden" name="requestId" value="${approvalRequest.requestId}">
                            
                            <div class="mb-3">
                                <label for="assignTo" class="form-label">Assign To</label>
                                <select class="form-select" id="assignTo" name="assignTo" required>
                                    <option value="" disabled selected>-- Select Staff Member --</option>
                                    <c:forEach var="approver" items="${approvers}">
                                        <option value="${approver.userID}" 
                                                ${approvalRequest.assignedTo == approver.userID ? 'selected' : ''}>
                                            ${approver.fullName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label for="comments" class="form-label">Comments</label>
                                <textarea class="form-control" id="comments" name="comments" rows="3" 
                                          placeholder="Add any relevant notes about this assignment"></textarea>
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="${pageContext.request.contextPath}/warehouse/approvals/details?id=${approvalRequest.requestId}" class="btn btn-outline-secondary me-md-2">
                                    Cancel
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-user-check me-1"></i> Assign Request
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../include/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>