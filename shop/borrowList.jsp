<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="../include/header.jsp">
    <jsp:param name="title" value="${viewType == 'lending' ? 'Lending Requests' : 'Borrowing Requests'}" />
    <jsp:param name="pageCss" value="borrowing" />
</jsp:include>

<jsp:include page="/include/pageHeader.jsp">
    <jsp:param name="pageTitle" value="${viewType == 'lending' ? 'Lending Requests' : 'Borrowing Requests'}" />
    <jsp:param name="description" value="${viewType == 'lending' ? 'Manage requests from other shops that want to borrow fruits from you' : 'Manage your requests to borrow fruits from other shops'}" />
    <jsp:param name="showButton" value="${viewType != 'lending'}" />
    <jsp:param name="buttonUrl" value="${pageContext.request.contextPath}/borrowing?action=showCreateForm" />
    <jsp:param name="buttonIcon" value="fa-plus" />
    <jsp:param name="buttonText" value="Create New Borrow Request" />
</jsp:include>

<div class="container">
    <div class="section">
        <%@ include file="/include/message.jsp" %>
        
        <div class="tabs mb-4">
            <ul class="nav nav-tabs">
                <li class="nav-item">
                    <a class="nav-link ${viewType != 'lending' ? 'active' : ''}" href="${pageContext.request.contextPath}/borrowing?action=list">
                        <i class="fas fa-hand-holding mr-1"></i> My Borrow Requests
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${viewType == 'lending' ? 'active' : ''}" href="${pageContext.request.contextPath}/borrowing?action=listLending">
                        <i class="fas fa-share-square mr-1"></i> Lending Requests
                    </a>
                </li>
            </ul>
        </div>
        
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Filter Requests</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>Status</label>
                            <select class="form-control" id="statusFilter" onchange="filterByStatus(this.value)">
                                <option value="all" ${selectedStatus == null ? 'selected' : ''}>All Statuses</option>
                                <option value="pending" ${selectedStatus == 'pending' ? 'selected' : ''}>Pending</option>
                                <option value="approved" ${selectedStatus == 'approved' ? 'selected' : ''}>Approved</option>
                                <option value="rejected" ${selectedStatus == 'rejected' ? 'selected' : ''}>Rejected</option>
                                <option value="borrowed" ${selectedStatus == 'borrowed' ? 'selected' : ''}>Borrowed</option>
                                <option value="returned" ${selectedStatus == 'returned' ? 'selected' : ''}>Returned</option>
                                <option value="overdue" ${selectedStatus == 'overdue' ? 'selected' : ''}>Overdue</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>Search</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="searchInput" placeholder="Search requests...">
                                <div class="input-group-append">
                                    <button class="btn btn-primary" type="button" onclick="searchRequests()">
                                        <i class="fas fa-search"></i> Search
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">${viewType == 'lending' ? 'Lending Request List' : 'Borrowing Request List'}</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover" id="borrowingTable">
                        <thead class="bg-light">
                            <tr>
                                <th>ID</th>
                                <c:if test="${viewType == 'lending'}">
                                    <th>Requesting Shop</th>
                                </c:if>
                                <c:if test="${viewType != 'lending'}">
                                    <th>Lending Shop</th>
                                </c:if>
                                <th>Request Date</th>
                                <th>Return Date</th>
                                <th>Status</th>
                                <th>Total Items</th>
                                <th class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="request" items="${borrowRequests}">
                                <tr class="${request.isOverdue() ? 'table-danger' : ''}">
                                    <td>${request.borrowId}</td>
                                    <c:if test="${viewType == 'lending'}">
                                        <td>${request.requestingShopName}</td>
                                    </c:if>
                                    <c:if test="${viewType != 'lending'}">
                                        <td>${request.lendingShopName}</td>
                                    </c:if>
                                    <td><fmt:formatDate value="${request.requestDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                    <td><fmt:formatDate value="${request.returnDate}" pattern="yyyy-MM-dd" /></td>
                                    <td>
                                        <span class="badge 
                                            ${request.status == 'pending' ? 'badge-warning' : 
                                              request.status == 'approved' ? 'badge-success' : 
                                              request.status == 'rejected' ? 'badge-danger' : 
                                              request.status == 'borrowed' ? 'badge-primary' :
                                              request.status == 'overdue' ? 'badge-danger' :
                                              'badge-info'}">
                                            ${request.formattedStatus}
                                        </span>
                                    </td>
                                    <td>${request.totalItems}</td>
                                    <td class="text-center">
                                        <div class="btn-group btn-group-sm">
                                            <a href="${pageContext.request.contextPath}/borrowing?action=view&id=${request.borrowId}" class="btn btn-info" data-tooltip="View Details">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            
                                            <c:if test="${viewType != 'lending' && request.status == 'pending'}">
                                                <button type="button" class="btn btn-danger" onclick="confirmCancel(${request.borrowId})" data-tooltip="Cancel">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </c:if>
                                            
                                            <c:if test="${viewType != 'lending' && (request.status == 'borrowed' || request.status == 'overdue')}">
                                                <a href="${pageContext.request.contextPath}/borrowing?action=showReturnForm&id=${request.borrowId}" class="btn btn-success" data-tooltip="Return Items">
                                                    <i class="fas fa-undo"></i>
                                                </a>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                
                <c:if test="${empty borrowRequests}">
                    <div class="text-center py-5">
                        <i class="fas fa-exchange-alt fa-3x text-muted mb-3"></i>
                        <h5 class="text-muted">No ${viewType == 'lending' ? 'lending' : 'borrowing'} requests found</h5>
                        <c:if test="${viewType != 'lending'}">
                            <p>Create a new borrow request to get started.</p>
                            <a href="${pageContext.request.contextPath}/borrowing?action=showCreateForm" class="btn btn-primary">Create Borrow Request</a>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script>
function filterByStatus(status) {
    window.location.href = "${pageContext.request.contextPath}/borrowing?action=filterByStatus&status=" + status + "&viewType=${viewType}";
}

function searchRequests() {
    var input = document.getElementById("searchInput");
    var filter = input.value.toUpperCase();
    var table = document.getElementById("borrowingTable");
    var tr = table.getElementsByTagName("tr");
    
    for (var i = 1; i < tr.length; i++) {
        var found = false;
        var td = tr[i].getElementsByTagName("td");
        
        for (var j = 0; j < td.length - 1; j++) { // Skip the actions column
            var cell = td[j];
            if (cell) {
                var content = cell.textContent || cell.innerText;
                if (content.toUpperCase().indexOf(filter) > -1) {
                    found = true;
                    break;
                }
            }
        }
        
        tr[i].style.display = found ? "" : "none";
    }
}

function confirmCancel(borrowId) {
    confirmAction("Are you sure you want to cancel this borrow request?", function() {
        window.location.href = "${pageContext.request.contextPath}/borrowing?action=cancel&id=" + borrowId;
    });
}
</script>

<jsp:include page="/include/footer.jsp">
    <jsp:param name="pageJs" value="borrowing" />
</jsp:include>