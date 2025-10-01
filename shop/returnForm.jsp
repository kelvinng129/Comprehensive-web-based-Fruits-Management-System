<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="../include/header.jsp">
    <jsp:param name="title" value="Return Borrowed Items" />
    <jsp:param name="pageCss" value="borrowing" />
</jsp:include>

<jsp:include page="../include/pageHeader.jsp">
    <jsp:param name="pageTitle" value="Return Borrowed Items" />
    <jsp:param name="description" value="Return items borrowed from other shops" />
    <jsp:param name="showBreadcrumb" value="true" />
    <jsp:param name="breadcrumbParent" value="Borrowing" />
    <jsp:param name="breadcrumbParentUrl" value="borrowing?action=list" />
    <jsp:param name="breadcrumbActive" value="Return Items" />
</jsp:include>

<div class="container">
    <div class="section">
        <%@ include file="../include/message.jsp" %>
        
        <div class="card mb-4">
            <div class="card-header">
                <h5 class="mb-0">Borrow Request Details</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <p><strong>Request ID:</strong> #${borrowRequest.borrowId}</p>
                        <p><strong>Requesting Shop:</strong> ${borrowRequest.requestingShopName}</p>
                        <p><strong>Lending Shop:</strong> ${borrowRequest.lendingShopName}</p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Request Date:</strong> <fmt:formatDate value="${borrowRequest.requestDate}" pattern="yyyy-MM-dd HH:mm" /></p>
                        <p><strong>Return Date:</strong> <fmt:formatDate value="${borrowRequest.returnDate}" pattern="yyyy-MM-dd" /></p>
                        <p><strong>Status:</strong> 
                            <span class="badge 
                                ${borrowRequest.status == 'borrowed' ? 'badge-primary' : 'badge-danger'}">
                                ${borrowRequest.formattedStatus}
                            </span>
                        </p>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">Return Items</h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/borrowing" method="post">
                    <input type="hidden" name="action" value="returnItems">
                    <input type="hidden" name="borrowId" value="${borrowRequest.borrowId}">
                    
                    <div class="table-responsive">
                        <table class="table table-bordered">
                            <thead class="bg-light">
                                <tr>
                                    <th>Fruit</th>
                                    <th class="text-center">Total Borrowed</th>
                                    <th class="text-center">Already Returned</th>
                                    <th class="text-center">Remaining</th>
                                    <th class="text-center">Return Quantity</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${borrowRequest.items}">
                                    <c:if test="${item.remainingQuantity > 0}">
                                        <tr>
                                            <td>${item.fruitName}</td>
                                            <td class="text-center">${item.quantity}</td>
                                            <td class="text-center">${item.returnedQuantity}</td>
                                            <td class="text-center">${item.remainingQuantity}</td>
                                            <td>
                                                <input type="hidden" name="itemId" value="${item.borrowItemId}">
                                                <input type="number" class="form-control" name="returnQuantity" 
                                                       min="0" max="${item.remainingQuantity}" value="${item.remainingQuantity}">
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    
                    <div class="alert alert-info mt-3">
                        <i class="fas fa-info-circle mr-2"></i> 
                        Enter the quantity of each item you are returning now. You can return items partially if needed.
                    </div>
                    
                    <div class="form-actions mt-4 text-right">
                        <a href="${pageContext.request.contextPath}/borrowing?action=view&id=${borrowRequest.borrowId}" class="btn btn-secondary mr-2">Cancel</a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-undo mr-1"></i> Return Items
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../include/footer.jsp">
    <jsp:param name="pageJs" value="borrowing" />
</jsp:include>