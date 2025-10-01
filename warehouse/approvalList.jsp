<%-- 
    Document   : approvalList
    Created on : 2025年4月20日, 上午12:57:44
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
    <title>${pageTitle} - Warehouse Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <style>
        .filter-badge {
            padding: 6px 12px;
            border-radius: 20px;
            margin-right: 10px;
            font-weight: 500;
            transition: all 0.2s;
        }
        .filter-badge:hover {
            opacity: 0.9;
        }
        .request-card {
            transition: transform 0.2s;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            margin-bottom: 15px;
        }
        .request-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .priority-indicator {
            width: 5px;
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            border-top-left-radius: 8px;
            border-bottom-left-radius: 8px;
        }
        .request-card.overdue {
            border-color: #dc3545;
        }
        .status-badge {
            font-size: 0.8rem;
            padding: 0.25rem 0.5rem;
        }
        .empty-state {
            text-align: center;
            padding: 50px 20px;
            color: #6c757d;
        }
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.3;
        }
    </style>
</head>
<body>
    <jsp:include page="../include/header.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1>${pageTitle}</h1>
                <p class="text-muted">Manage approval workflows and process approval requests</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/warehouse/approvals/new" class="btn btn-primary">
                    <i class="fas fa-plus-circle"></i> New Request
                </a>
                <a href="${pageContext.request.contextPath}/warehouse/approvals/config" class="btn btn-outline-secondary ms-2">
                    <i class="fas fa-cog"></i> Workflow Settings
                </a>
            </div>
        </div>
        
        <!-- Filters -->
        <div class="mb-4">
            <a href="${pageContext.request.contextPath}/warehouse/approvals/list" class="filter-badge ${empty filterActive ? 'bg-primary text-white' : 'bg-light'}">
                <i class="fas fa-list"></i> All Requests
            </a>
            <a href="${pageContext.request.contextPath}/warehouse/approvals/pending" class="filter-badge ${filterActive == 'pending' ? 'bg-warning text-dark' : 'bg-light'}">
                <i class="fas fa-clock"></i> Pending
            </a>
            <a href="${pageContext.request.contextPath}/warehouse/approvals/myRequests" class="filter-badge ${filterActive == 'myRequests' ? 'bg-info text-white' : 'bg-light'}">
                <i class="fas fa-user"></i> My Requests
            </a>
        </div>
        
        <!-- Request List -->
        <c:choose>
            <c:when test="${not empty requests}">
                <div class="row">
                    <c:forEach var="request" items="${requests}">
                        <div class="col-md-6">
                            <div class="card request-card position-relative ${request.isDueDateOverdue() ? 'overdue' : ''}">
                                <div class="priority-indicator bg-${request.priorityColor}"></div>
                                <div class="card-body ps-4">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <h5 class="card-title mb-0">
                                            <a href="${pageContext.request.contextPath}/warehouse/approvals/details?id=${request.requestId}" class="text-decoration-none">
                                                ${request.title}
                                            </a>
                                        </h5>
                                        <span class="badge bg-${request.statusColor} status-badge">${request.statusDisplay}</span>
                                    </div>
                                    
                                    <p class="card-text text-muted small mb-2">
                                        <strong>Type:</strong> ${request.requestTypeName} &nbsp;|&nbsp;
                                        <strong>Priority:</strong> <span class="text-${request.priorityColor}">${request.priority}</span>
                                    </p>
                                    
                                    <p class="card-text small mb-2">
                                        <c:choose>
                                            <c:when test="${request.description.length() > 100}">
                                                ${request.description.substring(0, 100)}...
                                            </c:when>
                                            <c:otherwise>
                                                ${request.description}
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    
                                    <div class="d-flex justify-content-between align-items-center mt-3">
                                        <div class="text-muted small">
                                            <span><i class="fas fa-user me-1"></i> ${request.requestedByName}</span>
                                            <span class="ms-3"><i class="fas fa-calendar me-1"></i> ${request.formattedRequestedDate}</span>
                                        </div>
                                        
                                        <div>
                                            <c:if test="${request.status == 'PENDING' && (currentUser.role == 'warehouse_staff' || currentUser.role == 'senior_management')}">
                                                <a href="${pageContext.request.contextPath}/warehouse/approvals/details?id=${request.requestId}" class="btn btn-sm btn-outline-primary">Review</a>
                                            </c:if>
                                            
                                            <c:if test="${request.status == 'PENDING' && request.requestedBy == currentUser.userID}">
                                                <a href="${pageContext.request.contextPath}/warehouse/approvals/edit?id=${request.requestId}" class="btn btn-sm btn-outline-secondary">Edit</a>
                                            </c:if>
                                        </div>
                                    </div>
                                    
                                    <c:if test="${request.isDueDateOverdue()}">
                                        <div class="mt-2">
                                            <span class="badge bg-danger text-white">
                                                <i class="fas fa-exclamation-circle me-1"></i> Overdue: Due ${request.formattedDueDate}
                                            </span>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-clipboard-list"></i>
                    <h3>No requests found</h3>
                    <p>There are no approval requests matching your criteria.</p>
                    <a href="${pageContext.request.contextPath}/warehouse/approvals/new" class="btn btn-primary mt-3">
                        <i class="fas fa-plus-circle"></i> Create New Request
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <jsp:include page="../include/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
