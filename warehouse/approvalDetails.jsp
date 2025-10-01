<%-- 
    Document   : approvalDetails
    Created on : 2025年4月20日, 上午12:58:07
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
    <title>Approval Request Details - Warehouse Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <style>
        .request-header {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        .priority-indicator {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 5px;
        }
        .request-meta {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #dee2e6;
        }
        .meta-item {
            margin-right: 20px;
            color: #6c757d;
        }
        .description-box {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .activity-timeline {
            position: relative;
            padding-left: 30px;
        }
        .activity-timeline::before {
            content: '';
            position: absolute;
            top: 0;
            bottom: 0;
            left: 15px;
            width: 2px;
            background-color: #dee2e6;
        }
        .timeline-item {
            position: relative;
            padding-bottom: 20px;
        }
        .timeline-item:last-child {
            padding-bottom: 0;
        }
        .timeline-icon {
            position: absolute;
            left: -30px;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background-color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 2px solid #dee2e6;
            z-index: 1;
        }
        .timeline-content {
            background-color: #fff;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        .action-button {
            min-width: 120px;
        }
        .comment-form {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #dee2e6;
        }
    </style>
</head>
<body>
    <jsp:include page="../include/header.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1>Approval Request</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/warehouse/approvals/list">Approvals</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Request #${approvalRequest.requestId}</li>
                    </ol>
                </nav>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/warehouse/approvals/list" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left"></i> Back to List
                </a>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-8">
                <!-- Request Details -->
                <div class="request-header">
                    <div class="d-flex justify-content-between align-items-start">
                        <h2 class="mb-0">${approvalRequest.title}</h2>
                        <span class="badge bg-${approvalRequest.statusColor} fs-6">${approvalRequest.statusDisplay}</span>
                    </div>
                    
                    <div class="d-flex align-items-center mt-2">
                        <span class="text-muted me-3">${approvalRequest.requestTypeName}</span>
                        <span>
                            <span class="priority-indicator bg-${approvalRequest.priorityColor}"></span>
                            ${approvalRequest.priority} Priority
                        </span>
                        
                        <c:if test="${approvalRequest.isDueDateOverdue()}">
                            <span class="badge bg-danger ms-3">OVERDUE</span>
                        </c:if>
                    </div>
                    
                    <div class="request-meta d-flex flex-wrap">
                        <span class="meta-item">
                            <i class="fas fa-user me-1"></i> Requested by: ${approvalRequest.requestedByName}
                        </span>
                        <span class="meta-item">
                            <i class="fas fa-calendar me-1"></i> Requested: ${approvalRequest.formattedRequestedDate}
                        </span>
                        <span class="meta-item">
                            <i class="fas fa-calendar-check me-1"></i> Due: ${approvalRequest.formattedDueDate}
                        </span>
                        
                        <c:if test="${approvalRequest.isAssigned()}">
                            <span class="meta-item">
                                <i class="fas fa-user-check me-1"></i> Assigned to: ${approvalRequest.assignedToName}
                            </span>
                        </c:if>
                        
                        <c:if test="${approvalRequest.isResolved()}">
                            <span class="meta-item">
                                <i class="fas fa-check-circle me-1"></i> Resolved by: ${approvalRequest.resolvedByName}
                            </span>
                            <span class="meta-item">
                                <i class="fas fa-clock me-1"></i> Resolved: ${approvalRequest.formattedResolvedDate}
                            </span>
                        </c:if>
                    </div>
                </div>
                
                <!-- Description -->
                <div class="description-box">
                    <h5><i class="fas fa-align-left me-2"></i> Description</h5>
                    <p class="mb-0">${approvalRequest.description}</p>
                </div>
                
                <!-- Related Entity Info (if applicable) -->
                <c:if test="${not empty approvalRequest.relatedEntityType}">
                    <div class="card mb-4">
                        <div class="card-header bg-light">
                            <h5 class="mb-0"><i class="fas fa-link me-2"></i> Related Information</h5>
                        </div>
                        <div class="card-body">
                            <p class="mb-2">
                                <strong>Type:</strong> ${approvalRequest.relatedEntityType}
                            </p>
                            <p class="mb-0">
                                <strong>ID:</strong> ${approvalRequest.relatedEntityId}
                            </p>
                            
                            <c:if test="${approvalRequest.relatedEntityType == 'TRANSFER' && not empty approvalRequest.relatedEntityId}">
                                <div class="mt-3">
                                    <a href="${pageContext.request.contextPath}/warehouse/transfer?action=details&id=${approvalRequest.relatedEntityId}" class="btn btn-sm btn-outline-primary">
                                        <i class="fas fa-external-link-alt me-1"></i> View Transfer Details
                                    </a>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:if>
                
                <!-- Activity Timeline -->
                <div class="card">
                    <div class="card-header bg-light">
                        <h5 class="mb-0"><i class="fas fa-history me-2"></i> Activity Timeline</h5>
                    </div>
                    <div class="card-body">
                        <div class="activity-timeline">
                            <c:forEach var="action" items="${actions}">
                                <div class="timeline-item">
                                    <div class="timeline-icon bg-${action.actionTypeColor}">
                                        <c:choose>
                                            <c:when test="${action.actionType == 'APPROVE'}">
                                                <i class="fas fa-check text-white small"></i>
                                            </c:when>
                                            <c:when test="${action.actionType == 'REJECT'}">
                                                <i class="fas fa-times text-white small"></i>
                                            </c:when>
                                            <c:when test="${action.actionType == 'ASSIGN' || action.actionType == 'REASSIGN'}">
                                                <i class="fas fa-user-check text-white small"></i>
                                            </c:when>
                                            <c:when test="${action.actionType == 'ESCALATE'}">
                                                <i class="fas fa-arrow-up text-white small"></i>
                                            </c:when>
                                            <c:when test="${action.actionType == 'CANCEL'}">
                                                <i class="fas fa-ban text-white small"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-comment text-white small"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    
                                    <div class="timeline-content">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <strong>${action.actionTypeDisplay}</strong>
                                            <small class="text-muted">${action.formattedActionDate}</small>
                                        </div>
                                        <p class="mb-1">${action.comments}</p>
                                        <small class="text-muted">by ${action.performedByName}</small>
                                    </div>
                                </div>
                            </c:forEach>
                            
                            <c:if test="${empty actions}">
                                <div class="text-center text-muted py-4">
                                    <i class="fas fa-info-circle me-2"></i> No activity recorded yet
                                </div>
                            </c:if>
                        </div>
                        
                        <!-- Comment Form -->
                        <div class="comment-form">
                            <h6><i class="fas fa-comment me-2"></i> Add Comment</h6>
                            <form action="${pageContext.request.contextPath}/warehouse/approvals" method="post">
                                <input type="hidden" name="action" value="addComment">
                                <input type="hidden" name="requestId" value="${approvalRequest.requestId}">
                                
                                <div class="mb-3">
                                    <textarea class="form-control" name="comments" rows="3" placeholder="Enter your comment here..." required></textarea>
                                </div>
                                
                                <button type="submit" class="btn btn-outline-primary">
                                    <i class="fas fa-paper-plane me-1"></i> Submit Comment
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <!-- Action Panel -->
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-cogs me-2"></i> Actions</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${approvalRequest.status == 'PENDING'}">
                                <!-- Actions for pending requests -->
                                <c:if test="${currentUser.role == 'warehouse_staff' || currentUser.role == 'senior_management'}">
                                    <!-- Approval/Reject Form -->
                                    <div class="mb-4">
                                        <div class="d-grid gap-2">
                                            <button type="button" class="btn btn-success action-button" data-bs-toggle="modal" data-bs-target="#approveModal">
                                                <i class="fas fa-check me-1"></i> Approve
                                            </button>
                                            <button type="button" class="btn btn-danger action-button" data-bs-toggle="modal" data-bs-target="#rejectModal">
                                                <i class="fas fa-times me-1"></i> Reject
                                            </button>
                                        </div>
                                    </div>
                                </c:if>
                                
                                <!-- Assignment -->
                                <div class="mb-3">
                                    <h6 class="mb-2">Assign Request</h6>
                                    <a href="${pageContext.request.contextPath}/warehouse/approvals/assignForm?id=${approvalRequest.requestId}" class="btn btn-outline-primary btn-sm w-100">
                                        <i class="fas fa-user-check me-1"></i> ${approvalRequest.isAssigned() ? 'Reassign' : 'Assign'}
                                    </a>
                                </div>
                                
                                <!-- Edit Button (for request creator) -->
                                <c:if test="${approvalRequest.requestedBy == currentUser.userID}">
                                    <div class="mb-3">
                                        <h6 class="mb-2">Modify Request</h6>
                                        <a href="${pageContext.request.contextPath}/warehouse/approvals/edit?id=${approvalRequest.requestId}" class="btn btn-outline-secondary btn-sm w-100">
                                            <i class="fas fa-edit me-1"></i> Edit Request
                                        </a>
                                    </div>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <!-- Info for resolved requests -->
                                <div class="alert alert-${approvalRequest.statusColor} mb-3">
                                    <i class="fas fa-info-circle me-2"></i> This request has been ${approvalRequest.statusDisplay.toLowerCase()}
                                </div>
                            </c:otherwise>
                        </c:choose>
                        
                        <!-- Additional Actions -->
                        <hr>
                        <h6 class="mb-2">Other Actions</h6>
                        <div class="list-group">
                            <a href="${pageContext.request.contextPath}/warehouse/approvals/list" class="list-group-item list-group-item-action">
                                <i class="fas fa-list me-2"></i> View All Requests
                            </a>
                            <a href="${pageContext.request.contextPath}/warehouse/approvals/new" class="list-group-item list-group-item-action">
                                <i class="fas fa-plus-circle me-2"></i> Create New Request
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Notes Panel -->
                <div class="card">
                    <div class="card-header bg-light">
                        <h5 class="mb-0"><i class="fas fa-sticky-note me-2"></i> Notes</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty approvalRequest.notes}">
                                <p class="mb-0">${approvalRequest.notes}</p>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted mb-0">No additional notes for this request.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Approve Modal -->
    <div class="modal fade" id="approveModal" tabindex="-1" aria-labelledby="approveModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/warehouse/approvals" method="post">
                    <input type="hidden" name="action" value="approve">
                    <input type="hidden" name="requestId" value="${approvalRequest.requestId}">
                    
                    <div class="modal-header bg-success text-white">
                        <h5 class="modal-title" id="approveModalLabel">Approve Request</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to approve this request?</p>
                        <div class="mb-3">
                            <label for="approveComments" class="form-label">Comments (Optional)</label>
                            <textarea class="form-control" id="approveComments" name="comments" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success">Approve</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Reject Modal -->
    <div class="modal fade" id="rejectModal" tabindex="-1" aria-labelledby="rejectModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/warehouse/approvals" method="post">
                    <input type="hidden" name="action" value="reject">
                    <input type="hidden" name="requestId" value="${approvalRequest.requestId}">
                    
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title" id="rejectModalLabel">Reject Request</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to reject this request?</p>
                        <div class="mb-3">
                            <label for="rejectComments" class="form-label">Reason for Rejection <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="rejectComments" name="comments" rows="3" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">Reject</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <jsp:include page="../include/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>