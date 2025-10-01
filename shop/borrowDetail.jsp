<%-- 
    Document   : borrowDetail
    Created on : 2025年4月19日, 上午10:44:09
    Author     : kelvin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="ict.bean.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    int currentShopId = currentUser != null ? currentUser.getLocationID() : 0;
    boolean isRequester = currentUser != null && request.getAttribute("borrowRequest") != null && 
                         ((ict.bean.BorrowRequest)request.getAttribute("borrowRequest")).getRequestingShopId() == currentUser.getLocationID();
    boolean isLender = currentUser != null && request.getAttribute("borrowRequest") != null && 
                      ((ict.bean.BorrowRequest)request.getAttribute("borrowRequest")).getLendingShopId() == currentUser.getLocationID();
%>

<jsp:include page="../include/pageHeader.jsp">
    <jsp:param name="title" value="Borrow Request Details" />
    <jsp:param name="pageCss" value="borrowing" />
</jsp:include>

<jsp:include page="../include/pageHeader.jsp">
    <jsp:param name="pageTitle" value="Borrow Request #${borrowRequest.borrowId}" />
    <jsp:param name="description" value="View and manage borrow request details" />
    <jsp:param name="showBreadcrumb" value="true" />
    <jsp:param name="breadcrumbParent" value="Borrowing" />
    <jsp:param name="breadcrumbParentUrl" value="borrowing?action=list" />
    <jsp:param name="breadcrumbActive" value="Request #${borrowRequest.borrowId}" />
</jsp:include>

<div class="container">
    <div class="section">
        <%@ include file="../include/message.jsp" %>
        
        <div class="row">
            <div class="col-md-8">
                <div class="card mb-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Borrow Request Details</h5>
                        <span class="badge 
                            ${borrowRequest.status == 'pending' ? 'badge-warning' : 
                              borrowRequest.status == 'approved' ? 'badge-success' : 
                              borrowRequest.status == 'rejected' ? 'badge-danger' : 
                              borrowRequest.status == 'borrowed' ? 'badge-primary' :
                              borrowRequest.status == 'overdue' ? 'badge-danger' :
                              'badge-info'}">
                            ${borrowRequest.formattedStatus}
                        </span>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Requesting Shop:</strong> ${borrowRequest.requestingShopName}</p>
                                <p><strong>Lending Shop:</strong> ${borrowRequest.lendingShopName}</p>
                                <p><strong>Request Date:</strong> <fmt:formatDate value="${borrowRequest.requestDate}" pattern="yyyy-MM-dd HH:mm" /></p>
                                <p><strong>Return Date:</strong> <fmt:formatDate value="${borrowRequest.returnDate}" pattern="yyyy-MM-dd" /></p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Status:</strong> ${borrowRequest.formattedStatus}</p>
                                <p><strong>Requested By:</strong> ${borrowRequest.requestedByName}</p>
                                <c:if test="${borrowRequest.approvedByName != null}">
                                    <p><strong>Processed By:</strong> ${borrowRequest.approvedByName}</p>
                                    <p><strong>Processing Date:</strong> <fmt:formatDate value="${borrowRequest.approvalDate}" pattern="yyyy-MM-dd HH:mm" /></p>
                                </c:if>
                                <c:if test="${borrowRequest.returnedDate != null}">
                                    <p><strong>Returned Date:</strong> <fmt:formatDate value="${borrowRequest.returnedDate}" pattern="yyyy-MM-dd HH:mm" /></p>
                                </c:if>
                            </div>
                        </div>
                        
                        <c:if test="${not empty borrowRequest.notes}">
                            <div class="mt-3">
                                <h6>Notes:</h6>
                                <div class="p-3 bg-light rounded">
                                    ${borrowRequest.notes}
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Borrowed Items</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover">
                                <thead class="bg-light">
                                    <tr>
                                        <th>Item</th>
                                        <th>Fruit</th>
                                        <th class="text-center">Quantity</th>
                                        <th class="text-center">Returned</th>
                                        <th class="text-center">Remaining</th>
                                        <th class="text-center">Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${borrowRequest.items}" varStatus="status">
                                        <tr>
                                            <td>${status.index + 1}</td>
                                            <td>${item.fruitName}</td>
                                            <td class="text-center">${item.quantity}</td>
                                            <td class="text-center">${item.returnedQuantity}</td>
                                            <td class="text-center">${item.remainingQuantity}</td>
                                            <td class="text-center">
                                                <span class="badge 
                                                    ${item.status == 'pending' ? 'badge-warning' : 
                                                      item.status == 'borrowed' ? 'badge-primary' : 
                                                      item.status == 'returned' ? 'badge-success' : 
                                                      item.status == 'partial' ? 'badge-info' : 
                                                      'badge-secondary'}">
                                                    ${item.formattedStatus}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card sticky-top" style="top: 20px;">
                    <div class="card-header">
                        <h5 class="mb-0">Actions</h5>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/borrowing?action=list" class="btn btn-outline-secondary btn-block mb-3">
                                <i class="fas fa-arrow-left mr-1"></i> Back to List
                            </a>
                            
                            <% if (isLender && "pending".equals(((ict.bean.BorrowRequest)request.getAttribute("borrowRequest")).getStatus())) { %>
                            <form action="${pageContext.request.contextPath}/borrowing" method="post">
                                <input type="hidden" name="action" value="updateStatus">
                                <input type="hidden" name="borrowId" value="${borrowRequest.borrowId}">
                                <input type="hidden" name="status" value="approved">
                                
                                <button type="submit" class="btn btn-success btn-block mb-3">
                                    <i class="fas fa-check mr-1"></i> Approve Request
                                </button>
                            </form>
                            
                            <form action="${pageContext.request.contextPath}/borrowing" method="post">
                                <input type="hidden" name="action" value="updateStatus">
                                <input type="hidden" name="borrowId" value="${borrowRequest.borrowId}">
                                <input type="hidden" name="status" value="rejected">
                                
                                <button type="submit" class="btn btn-danger btn-block mb-3">
                                    <i class="fas fa-times mr-1"></i> Reject Request
                                </button>
                            </form>
                            <% } %>
                            
                            <% if (isRequester && "borrowed".equals(((ict.bean.BorrowRequest)request.getAttribute("borrowRequest")).getStatus()) || 
                                   isRequester && "overdue".equals(((ict.bean.BorrowRequest)request.getAttribute("borrowRequest")).getStatus())) { %>
                            <a href="${pageContext.request.contextPath}/borrowing?action=showReturnForm&id=${borrowRequest.borrowId}" class="btn btn-primary btn-block mb-3">
                                <i class="fas fa-undo mr-1"></i> Return Items
                            </a>
                            <% } %>
                            
                            <% if (isRequester && "pending".equals(((ict.bean.BorrowRequest)request.getAttribute("borrowRequest")).getStatus())) { %>
                            <button type="button" class="btn btn-outline-danger btn-block" onclick="confirmCancel(${borrowRequest.borrowId})">
                                <i class="fas fa-ban mr-1"></i> Cancel Request
                            </button>
                            <% } %>
                        </div>
                    </div>
                </div>
                
                <% if ("overdue".equals(((ict.bean.BorrowRequest)request.getAttribute("borrowRequest")).getStatus())) { %>
                <div class="card mt-4 border-danger">
                    <div class="card-header bg-danger text-white">
                        <h5 class="mb-0"><i class="fas fa-exclamation-circle mr-2"></i> Overdue Notice</h5>
                    </div>
                    <div class="card-body">
                        <p>This borrow request is <strong>overdue</strong>. The return date was <fmt:formatDate value="${borrowRequest.returnDate}" pattern="yyyy-MM-dd" />.</p>
                        <p>Please return the borrowed items as soon as possible to avoid penalties.</p>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script>
function confirmCancel(borrowId) {
    confirmAction("Are you sure you want to cancel this borrow request?", function() {
        window.location.href = "${pageContext.request.contextPath}/borrowing?action=cancel&id=" + borrowId;
    });
}
</script>

<jsp:include page="../include/footer.jsp">
    <jsp:param name="pageJs" value="borrowing" />
</jsp:include>