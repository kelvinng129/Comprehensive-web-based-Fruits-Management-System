<%-- 
    Document   : alertDetail
    Created on : 2025年4月19日, 下午12:12:41
    Author     : kelvin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Alert Details - Fruit Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .detail-card {
            box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            border: none;
        }
        .detail-card .card-header {
            border-radius: 10px 10px 0 0;
        }
        .alert-info-section {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .detail-label {
            font-weight: 600;
            color: #6c757d;
        }
        .alert-status {
            display: inline-block;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: bold;
        }
        .log-item {
            border-left: 3px solid #dee2e6;
            padding-left: 15px;
            margin-bottom: 15px;
            position: relative;
        }
        .log-item:before {
            content: '';
            position: absolute;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background-color: #0d6efd;
            left: -7px;
            top: 10px;
        }
        .log-item.resolved:before {
            background-color: #198754;
        }
        .log-item.pending:before {
            background-color: #ffc107;
        }
        .table-responsive {
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.05);
        }
    </style>
</head>
<body>
    <jsp:include page="../include/header.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Alert Details</h1>
            <div>
                <a href="${pageContext.request.contextPath}/shop/inventory?action=listAlerts" class="btn btn-outline-secondary me-2">
                    <i class="fa fa-list me-1"></i> All Alerts
                </a>
                <a href="${pageContext.request.contextPath}/shop/inventory" class="btn btn-secondary">
                    <i class="fa fa-arrow-left me-1"></i> Dashboard
                </a>
            </div>
        </div>
        
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
        
        <div class="row">
            <div class="col-md-8">
                <div class="card detail-card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0"><i class="fa fa-bell me-2"></i> Alert Information</h4>
                    </div>
                    <div class="card-body">
                        <div class="alert-info-section">
                            <div class="row mb-4">
                                <div class="col-md-8">
                                    <h3>${alert.alertName}</h3>
                                    <div class="mb-3">
                                        <span class="detail-label">Alert ID:</span>
                                        <span>${alert.alertId}</span>
                                    </div>
                                    <div class="mb-3">
                                        <span class="detail-label">Created By:</span>
                                        <span>${alert.createdByName}</span>
                                    </div>
                                    <div class="mb-3">
                                        <span class="detail-label">Created Date:</span>
                                        <span><fmt:formatDate value="${alert.createdDate}" pattern="yyyy-MM-dd HH:mm" /></span>
                                    </div>
                                    <div class="mb-3">
                                        <span class="detail-label">Last Updated:</span>
                                        <span><fmt:formatDate value="${alert.lastUpdated}" pattern="yyyy-MM-dd HH:mm" /></span>
                                    </div>
                                </div>
                                <div class="col-md-4 text-center">
                                    <div class="mb-3">
                                        <span class="alert-status ${alert.enabled ? 'bg-success text-white' : 'bg-danger text-white'}">
                                            ${alert.enabled ? 'Enabled' : 'Disabled'}
                                        </span>
                                    </div>
                                    <div class="mb-3">
                                        <c:choose>
                                            <c:when test="${alert.alertType == 'lowStock'}">
                                                <i class="fa fa-triangle-exclamation fa-3x text-warning"></i>
                                                <p class="mt-2"><strong>Low Stock Alert</strong></p>
                                            </c:when>
                                            <c:when test="${alert.alertType == 'expirySoon'}">
                                                <i class="fa fa-calendar-xmark fa-3x text-danger"></i>
                                                <p class="mt-2"><strong>Expiry Alert</strong></p>
                                            </c:when>
                                            <c:when test="${alert.alertType == 'highStock'}">
                                                <i class="fa fa-chart-line fa-3x text-success"></i>
                                                <p class="mt-2"><strong>High Stock Alert</strong></p>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fa fa-bell fa-3x text-primary"></i>
                                                <p class="mt-2"><strong>Custom Alert</strong></p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                            
                            <h5>Alert Configuration</h5>
                            <hr>
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <span class="detail-label">Applied To:</span>
                                        <span>
                                            <c:choose>
                                                <c:when test="${alert.fruitId == 0}">
                                                    <span class="badge bg-info">All Fruits</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-primary">${alert.fruitName}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="mb-3">
                                        <span class="detail-label">Alert Type:</span>
                                        <span>
                                            <c:choose>
                                                <c:when test="${alert.alertType == 'lowStock'}">
                                                    <span class="badge bg-warning text-dark">Low Stock</span>
                                                </c:when>
                                                <c:when test="${alert.alertType == 'expirySoon'}">
                                                    <span class="badge bg-danger">Expiry Soon</span>
                                                </c:when>
                                                <c:when test="${alert.alertType == 'highStock'}">
                                                    <span class="badge bg-success">High Stock</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">Other</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <span class="detail-label">Threshold:</span>
                                        <span>
                                            <c:choose>
                                                <c:when test="${alert.alertType == 'lowStock'}">
                                                    <span class="badge bg-secondary">${alert.threshold} units or less</span>
                                                </c:when>
                                                <c:when test="${alert.alertType == 'expirySoon'}">
                                                    <span class="badge bg-secondary">${alert.threshold} days or less</span>
                                                </c:when>
                                                <c:when test="${alert.alertType == 'highStock'}">
                                                    <span class="badge bg-secondary">${alert.threshold} units or more</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">${alert.threshold}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="mb-3">
                                        <span class="detail-label">Last Triggered:</span>
                                        <span>
                                            <c:choose>
                                                <c:when test="${not empty alert.lastTriggered}">
                                                    <fmt:formatDate value="${alert.lastTriggered}" pattern="yyyy-MM-dd HH:mm" />
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Never triggered</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            
                            <h5>Alert Message</h5>
                            <hr>
                            <div class="p-3 bg-white rounded">
                                <p class="mb-0">${alert.alertMessage}</p>
                            </div>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="d-flex justify-content-end gap-2">
                            <a href="${pageContext.request.contextPath}/shop/inventory?action=editAlert&id=${alert.alertId}" class="btn btn-outline-primary">
                                <i class="fa fa-edit me-1"></i> Edit Alert
                            </a>
                            <form action="${pageContext.request.contextPath}/shop/inventory" method="post" class="d-inline">
                                <input type="hidden" name="action" value="${alert.enabled ? 'disableAlert' : 'enableAlert'}">
                                <input type="hidden" name="alertId" value="${alert.alertId}">
                                <button type="submit" class="btn btn-outline-${alert.enabled ? 'warning' : 'success'}">
                                    <i class="fa fa-${alert.enabled ? 'pause' : 'play'} me-1"></i> ${alert.enabled ? 'Disable' : 'Enable'} Alert
                                </button>
                            </form>
                            <form action="${pageContext.request.contextPath}/shop/inventory" method="post" class="d-inline">
                                <input type="hidden" name="action" value="deleteAlert">
                                <input type="hidden" name="alertId" value="${alert.alertId}">
                                <button type="submit" class="btn btn-outline-danger" onclick="return confirm('Are you sure you want to delete this alert?');">
                                    <i class="fa fa-trash-can me-1"></i> Delete Alert
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
                
                <!-- Alert Logs -->
                <div class="card detail-card">
                    <div class="card-header bg-info text-white">
                        <h4 class="mb-0"><i class="fa fa-history me-2"></i> Alert History</h4>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty alertLogs}">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Triggered Date</th>
                                                <th>Triggered For</th>
                                                <th>Status</th>
                                                <th>Resolved By</th>
                                                <th>Resolved Date</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="log" items="${alertLogs}">
                                                <tr>
                                                    <td><fmt:formatDate value="${log.triggeredDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                                    <td>${log.fruitName != null ? log.fruitName : 'All Fruits'}</td>
                                                    <td>
                                                        <span class="badge bg-${log.statusColor}">${log.formattedStatus}</span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${log.resolvedBy > 0}">
                                                                ${log.resolvedByName}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">-</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty log.resolvedDate}">
                                                                <fmt:formatDate value="${log.resolvedDate}" pattern="yyyy-MM-dd HH:mm" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">-</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:if test="${log.status == 'triggered' || log.status == 'acknowledged'}">
                                                            <form action="${pageContext.request.contextPath}/shop/inventory" method="post" class="d-inline">
                                                                <input type="hidden" name="action" value="resolveAlert">
                                                                <input type="hidden" name="logId" value="${log.logId}">
                                                                <button type="submit" class="btn btn-sm btn-outline-success">
                                                                    <i class="fa fa-check"></i> Resolve
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                        <c:if test="${log.status == 'triggered'}">
                                                            <form action="${pageContext.request.contextPath}/shop/inventory" method="post" class="d-inline">
                                                                <input type="hidden" name="action" value="acknowledgeAlert">
                                                                <input type="hidden" name="logId" value="${log.logId}">
                                                                <button type="submit" class="btn btn-sm btn-outline-primary">
                                                                    <i class="fa fa-eye"></i> Acknowledge
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info">
                                    <i class="fa fa-info-circle me-2"></i> No alert history found.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <!-- Alert Statistics -->
                <div class="card detail-card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0"><i class="fa fa-chart-simple me-2"></i> Alert Statistics</h4>
                    </div>
                    <div class="card-body">
                        <div class="text-center mb-4">
                            <h5>Alert Triggers</h5>
                            <h1 class="display-4">
                                <c:choose>
                                    <c:when test="${not empty alertLogs}">
                                        ${alertLogs.size()}
                                    </c:when>
                                    <c:otherwise>
                                        0
                                    </c:otherwise>
                                </c:choose>
                            </h1>
                            <p class="text-muted">Total times this alert has been triggered</p>
                        </div>
                        
                        <div class="row text-center mb-4">
                            <div class="col-6">
                                <h5>
                                    <jsp:useBean id="resolvedCount" class="java.lang.Integer"  />
                                    <c:forEach var="log" items="${alertLogs}">
                                        <c:if test="${log.status == 'resolved'}">
                                            <jsp:setProperty name="resolvedCount" property="value" value="${resolvedCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${resolvedCount}
                                </h5>
                                <p class="text-success">Resolved</p>
                            </div>
                            <div class="col-6">
                                <h5>
                                    <jsp:useBean id="pendingCount" class="java.lang.Integer" />
                                    <c:forEach var="log" items="${alertLogs}">
                                        <c:if test="${log.status == 'triggered' || log.status == 'acknowledged'}">
                                            <jsp:setProperty name="pendingCount" property="value" value="${pendingCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${pendingCount}
                                </h5>
                                <p class="text-warning">Pending</p>
                            </div>
                        </div>
                        
                        <c:if test="${not empty alertLogs}">
                            <div class="mb-4">
                                <h5 class="text-center mb-3">Response Time</h5>
                                <c:set var="totalTime" value="0" />
                                <c:set var="resolvedLogsCount" value="0" />
                                
                                <c:forEach var="log" items="${alertLogs}">
                                    <c:if test="${log.status == 'resolved' && not empty log.triggeredDate && not empty log.resolvedDate}">
                                        <c:set var="timeDiff" value="${(log.resolvedDate.time - log.triggeredDate.time) / (1000 * 60)}" />
                                        <c:set var="totalTime" value="${totalTime + timeDiff}" />
                                        <c:set var="resolvedLogsCount" value="${resolvedLogsCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                
                                <c:if test="${resolvedLogsCount > 0}">
                                    <c:set var="avgTime" value="${totalTime / resolvedLogsCount}" />
                                    <div class="text-center">
                                        <h1 class="display-6"><fmt:formatNumber value="${avgTime}" pattern="#,##0" /></h1>
                                        <p class="text-muted">Average minutes to resolve</p>
                                    </div>
                                </c:if>
                            </div>
                        </c:if>
                        
                        <div class="text-center mt-4">
                            <a href="${pageContext.request.contextPath}/shop/inventory?action=listAlertLogs&alertId=${alert.alertId}" class="btn btn-outline-primary">
                                <i class="fa fa-history me-1"></i> View Full History
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Related Resources -->
                <div class="card detail-card mb-4">
                    <div class="card-header bg-secondary text-white">
                        <h4 class="mb-0"><i class="fa fa-link me-2"></i> Related Resources</h4>
                    </div>
                    <div class="card-body">
                        <div class="list-group">
                            <a href="${pageContext.request.contextPath}/shop/inventory?action=listAlerts" class="list-group-item list-group-item-action">
                                <i class="fa fa-bell me-2"></i> All Alerts
                            </a>
                            <a href="${pageContext.request.contextPath}/shop/inventory?action=listAlertLogs" class="list-group-item list-group-item-action">
                                <i class="fa fa-history me-2"></i> Alert History
                            </a>
                            <a href="${pageContext.request.contextPath}/shop/inventory?action=showAlertForm" class="list-group-item list-group-item-action">
                                <i class="fa fa-plus-circle me-2"></i> Create New Alert
                            </a>
                            <c:if test="${alert.fruitId > 0}">
                                <a href="${pageContext.request.contextPath}/shop/inventory?action=showAdjustForm&fruitId=${alert.fruitId}" class="list-group-item list-group-item-action">
                                    <i class="fa fa-edit me-2"></i> Adjust ${alert.fruitName} Inventory
                                </a>
                            </c:if>
                        </div>
                    </div>
                </div>
                
                <!-- Alert Management Tips -->
                <div class="card detail-card">
                    <div class="card-header bg-info text-white">
                        <h4 class="mb-0"><i class="fa fa-lightbulb me-2"></i> Alert Management Tips</h4>
                    </div>
                    <div class="card-body">
                        <ul class="mb-0">
                            <li class="mb-2">Regularly review and update alert thresholds</li>
                            <li class="mb-2">Address triggered alerts promptly</li>
                            <li class="mb-2">Use specific alert messages that suggest actions</li>
                            <li class="mb-2">Create custom alerts for high-value items</li>
                            <li>Monitor alert frequency to identify recurring issues</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../include/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>