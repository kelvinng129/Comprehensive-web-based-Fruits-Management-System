<%-- 
    Document   : fruitList.jsp
    Created on : 2025年4月19日, 上午4:52:20
    Author     : kelvin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../include/header.jsp" %>

<jsp:include page="../include/pageHeader.jsp">
    <jsp:param name="pageTitle" value="Fruit Management" />
    <jsp:param name="description" value="View and manage all fruits in the system" />
    <jsp:param name="showButton" value="true" />
    <jsp:param name="buttonUrl" value="${pageContext.request.contextPath}/fruit?action=showAddForm" />
    <jsp:param name="buttonIcon" value="fa-plus" />
    <jsp:param name="buttonText" value="Add New Fruit" />
</jsp:include>

<div class="container">
    <div class="section">
        <%@ include file="../include/message.jsp" %>
        
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Filter Options</h5>
                <button class="btn btn-sm btn-link" type="button" data-toggle="collapse" data-target="#filterCollapse">
                    <i class="fas fa-filter"></i> Toggle Filters
                </button>
            </div>
            <div class="collapse show" id="filterCollapse">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Category</label>
                                <select class="form-control" id="categoryFilter" onchange="filterByCategory(this.value)">
                                    <option value="0">All Categories</option>
                                    <c:forEach var="category" items="${categories}">
                                        <option value="${category.categoryId}" ${selectedCategoryId == category.categoryId ? 'selected' : ''}>
                                            ${category.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-8">
                            <div class="form-group">
                                <label>Search</label>
                                <div class="input-group">
                                    <input type="text" class="form-control" id="searchInput" placeholder="Search by name, description..." value="${searchTerm}">
                                    <div class="input-group-append">
                                        <button class="btn btn-primary" type="button" onclick="searchFruits()">
                                            <i class="fas fa-search"></i> Search
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <jsp:include page="../include/dataTable.jsp">
            <jsp:param name="tableId" value="fruitsTable" />
            <jsp:param name="columns" value="ID,Image,Name,Category,Price,Status,Created Date" />
            <jsp:param name="showSearch" value="true" />
            <jsp:param name="showExport" value="true" />
            <jsp:param name="exportFilename" value="fruits_list" />
            <jsp:param name="showActions" value="true" />
            <jsp:param name="showPagination" value="true" />
            
            <jsp:body>
                <c:forEach var="fruit" items="${fruits}">
                    <tr>
                        <td>${fruit.fruitId}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty fruit.imagePath}">
                                    <img src="${pageContext.request.contextPath}/${fruit.imagePath}" alt="${fruit.name}" class="img-thumbnail" style="width: 50px; height: 50px; object-fit: cover;">
                                </c:when>
                                <c:otherwise>
                                    <div class="no-image-placeholder">
                                        <i class="fas fa-apple-alt"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${fruit.name}</td>
                        <td>${fruit.categoryName}</td>
                        <td>${fruit.price} ${fruit.unit}</td>
                        <td>
                            <span class="badge ${fruit.active ? 'badge-success' : 'badge-danger'}">
                                ${fruit.active ? 'Active' : 'Inactive'}
                            </span>
                        </td>
                        <td>${fruit.createdAt}</td>
                        <td class="text-center">
                            <div class="btn-group btn-group-sm">
                                <a href="${pageContext.request.contextPath}/fruit?action=view&id=${fruit.fruitId}" class="btn btn-info" data-tooltip="View Details">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/fruit?action=showEditForm&id=${fruit.fruitId}" class="btn btn-primary" data-tooltip="Edit">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <button type="button" class="btn btn-danger" onclick="confirmDelete(${fruit.fruitId})" data-tooltip="Delete">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </jsp:body>
        </jsp:include>
    </div>
</div>

<script>
function filterByCategory(categoryId) {
    window.location.href = "${pageContext.request.contextPath}/fruit?action=filterByCategory&categoryId=" + categoryId;
}

function searchFruits() {
    const searchTerm = document.getElementById('searchInput').value;
    window.location.href = "${pageContext.request.contextPath}/fruit?action=search&searchTerm=" + encodeURIComponent(searchTerm);
}

function confirmDelete(fruitId) {
    confirmAction("Are you sure you want to delete this fruit? This action cannot be undone.", function() {
        window.location.href = "${pageContext.request.contextPath}/fruit?action=delete&id=" + fruitId;
    });
}
</script>

<%@ include file="../include/footer.jsp" %>