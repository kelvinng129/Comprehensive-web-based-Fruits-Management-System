<%-- 
    Document   : approvalForm
    Created on : 2025年4月20日, 上午1:28:39
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
    <title>${isEdit ? 'Edit' : 'New'} Approval Request - Warehouse Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <style>
        .form-card {
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
        }
        .priority-selector {
            display: flex;
            flex-direction: row;
            margin-bottom: 1rem;
        }
        .priority-option {
            cursor: pointer;
            padding: 0.5rem 1rem;
            border: 1px solid #dee2e6;
            flex: 1;
            text-align: center;
            transition: all 0.2s;
        }
        .priority-option:first-child {
            border-top-left-radius: 4px;
            border-bottom-left-radius: 4px;
        }
        .priority-option:last-child {
            border-top-right-radius: 4px;
            border-bottom-right-radius: 4px;
        }
        .priority-option.selected {
            color: white;
            font-weight: bold;
        }
        .priority-option.low.selected {
            background-color: #0dcaf0;
            border-color: #0dcaf0;
        }
        .priority-option.medium.selected {
            background-color: #0d6efd;
            border-color: #0d6efd;
        }
        .priority-option.high.selected {
            background-color: #ffc107;
            border-color: #ffc107;
            color: #000;
        }
        .priority-option.urgent.selected {
            background-color: #dc3545;
            border-color: #dc3545;
        }
        .priority-option:hover:not(.selected) {
            background-color: #f8f9fa;
        }
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
                <h1>${isEdit ? 'Edit' : 'New'} Approval Request</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/warehouse/approvals/list">Approvals</a></li>
                        <li class="breadcrumb-item active" aria-current="page">${isEdit ? 'Edit Request' : 'New Request'}</li>
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
                <div class="card form-card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">
                            <i class="fas fa-${isEdit ? 'edit' : 'plus-circle'} me-2"></i> 
                            ${isEdit ? 'Edit' : 'Create'} Approval Request
                        </h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/warehouse/approvals" method="post">
                            <input type="hidden" name="action" value="${isEdit ? 'updateRequest' : 'createRequest'}">
                            
                            <c:if test="${isEdit}">
                                <input type="hidden" name="requestId" value="${approvalRequest.requestId}">
                            </c:if>
                            
                            <!-- Request Type -->
                            <div class="mb-3">
                                <label for="requestTypeId" class="form-label required-field">Request Type</label>
                                <select class="form-select" id="requestTypeId" name="requestTypeId" required ${isEdit ? 'disabled' : ''}>
                                    <option value="" disabled selected>-- Select Request Type --</option>
                                    <c:forEach var="type" items="${requestTypes}">
                                        <option value="${type.typeId}" 
                                                ${(isEdit && approvalRequest.requestTypeId == type.typeId) ? 'selected' : ''}>
                                            ${type.typeName}
                                        </option>
                                    </c:forEach>
                                </select>
                                <c:if test="${isEdit}">
                                    <input type="hidden" name="requestTypeId" value="${approvalRequest.requestTypeId}">
                                </c:if>
                            </div>
                            
                            <!-- Title -->
                            <div class="mb-3">
                                <label for="title" class="form-label required-field">Title</label>
                                <input type="text" class="form-control" id="title" name="title" 
                                       placeholder="Enter a concise title for the request" 
                                       value="${isEdit ? approvalRequest.title : ''}" required>
                            </div>
                            
                            <!-- Description -->
                            <div class="mb-3">
                                <label for="description" class="form-label required-field">Description</label>
                                <textarea class="form-control" id="description" name="description" 
                                          rows="4" placeholder="Provide details about the request" required>${isEdit ? approvalRequest.description : ''}</textarea>
                            </div>
                            
                            <!-- Priority -->
                            <div class="mb-3">
                                <label class="form-label required-field">Priority</label>
                                <div class="priority-selector">
                                    <div class="priority-option low ${(isEdit && approvalRequest.priority == 'LOW') ? 'selected' : ''}">
                                        <input type="radio" name="priority" value="LOW" id="priorityLow" class="visually-hidden"
                                               ${(isEdit && approvalRequest.priority == 'LOW') ? 'checked' : ''}>
                                        <label for="priorityLow">Low</label>
                                    </div>
                                    <div class="priority-option medium ${(isEdit && approvalRequest.priority == 'MEDIUM') || (!isEdit) ? 'selected' : ''}">
                                        <input type="radio" name="priority" value="MEDIUM" id="priorityMedium" class="visually-hidden"
                                               ${(isEdit && approvalRequest.priority == 'MEDIUM') || (!isEdit) ? 'checked' : ''}>
                                        <label for="priorityMedium">Medium</label>
                                    </div>
                                    <div class="priority-option high ${(isEdit && approvalRequest.priority == 'HIGH') ? 'selected' : ''}">
                                        <input type="radio" name="priority" value="HIGH" id="priorityHigh" class="visually-hidden"
                                               ${(isEdit && approvalRequest.priority == 'HIGH') ? 'checked' : ''}>
                                        <label for="priorityHigh">High</label>
                                    </div>
                                    <div class="priority-option urgent ${(isEdit && approvalRequest.priority == 'URGENT') ? 'selected' : ''}">
                                        <input type="radio" name="priority" value="URGENT" id="priorityUrgent" class="visually-hidden"
                                               ${(isEdit && approvalRequest.priority == 'URGENT') ? 'checked' : ''}>
                                        <label for="priorityUrgent">Urgent</label>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Due Date -->
                            <div class="mb-3">
                                <label for="dueDate" class="form-label">Due Date</label>
                                <input type="date" class="form-control" id="dueDate" name="dueDate"
                                       value="${isEdit && approvalRequest.dueDate != null ? approvalRequest.dueDate.toString().substring(0, 10) : ''}">
                                <div class="form-text">When this request needs to be resolved by.</div>
                            </div>
                            
                            <!-- Related Entity (if coming from another entity) -->
                            <c:if test="${not empty entityType || (isEdit && not empty approvalRequest.relatedEntityType)}">
                                <div class="mb-3">
                                    <label class="form-label">Related Item</label>
                                    <input type="text" class="form-control" readonly
                                           value="${not empty entityType ? entityType : approvalRequest.relatedEntityType} #${not empty transferId ? transferId : approvalRequest.relatedEntityId}">
                                    <input type="hidden" name="entityType" value="${not empty entityType ? entityType : approvalRequest.relatedEntityType}">
                                    <input type="hidden" name="entityId" value="${not empty transferId ? transferId : approvalRequest.relatedEntityId}">
                                </div>
                            </c:if>
                            
                            <!-- Assign To -->
                            <div class="mb-3">
                                <label for="assignTo" class="form-label">Assign To</label>
                                <select class="form-select" id="assignTo" name="assignTo">
                                    <option value="">-- Automatic Assignment --</option>
                                    <c:forEach var="approver" items="${approvers}">
                                        <option value="${approver.userID}"
                                                ${(isEdit && approvalRequest.assignedTo == approver.userID) ? 'selected' : ''}>
                                            ${approver.fullName}
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="form-text">Leave blank for automatic assignment based on workflow configuration.</div>
                            </div>
                            
                            <!-- Additional Notes -->
                            <div class="mb-3">
                                <label for="notes" class="form-label">Additional Notes</label>
                                <textarea class="form-control" id="notes" name="notes" rows="3">${isEdit ? approvalRequest.notes : ''}</textarea>
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="${pageContext.request.contextPath}/warehouse/approvals/list" class="btn btn-outline-secondary me-md-2">
                                    Cancel
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-${isEdit ? 'save' : 'paper-plane'} me-1"></i>
                                    ${isEdit ? 'Save Changes' : 'Submit Request'}
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
                        <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i> Request Guidelines</h5>
                    </div>
                    <div class="card-body">
                        <h6>Request Types</h6>
                        <ul class="small">
                            <li><strong>Inventory Transfer:</strong> Request approval to move inventory between locations</li>
                            <li><strong>Stock Adjustment:</strong> Request approval for significant inventory quantity adjustments</li>
                            <li><strong>Purchase Order:</strong> Request approval to purchase new inventory</li>
                            <li><strong>Wastage Write-Off:</strong> Request approval to write off damaged or expired inventory</li>
                            <li><strong>Threshold Change:</strong> Request approval to change inventory threshold levels</li>
                        </ul>
                        
                        <h6 class="mt-3">Priority Levels</h6>
                        <ul class="small">
                            <li><strong>Low:</strong> Standard request, can be processed within regular timeframes</li>
                            <li><strong>Medium:</strong> Normal priority, should be processed within 2-3 days</li>
                            <li><strong>High:</strong> Important request that needs prompt attention</li>
                            <li><strong>Urgent:</strong> Critical request requiring immediate action</li>
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
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const priorityOptions = document.querySelectorAll('.priority-option');
            
            priorityOptions.forEach(option => {
                option.addEventListener('click', function() {
                    // Remove selected class from all options
                    priorityOptions.forEach(opt => opt.classList.remove('selected'));
                    
                    // Add selected class to clicked option
                    this.classList.add('selected');
                    
                    // Check the hidden radio button
                    const radio = this.querySelector('input[type="radio"]');
                    radio.checked = true;
                });
            });
        });
    </script>
</body>
</html>
