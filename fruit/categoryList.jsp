<%-- 
    Document   : categoryList.jsp
    Created on : 2025年4月19日, 上午4:53:01
    Author     : kelvin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Category Management - AIB System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
</head>
<body>
    <jsp:include page="../include/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Category Management</h2>
            <a href="category?action=showAddForm" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i> Add New Category
            </a>
        </div>
        
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Description</th>
                                <th>Status</th>
                                <th>Created</th>
                                <th>Last Updated</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty categories}">
                                    <tr>
                                        <td colspan="7" class="text-center">No categories found</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${categories}" var="category">
                                        <tr>
                                            <td>${category.categoryId}</td>
                                            <td>${category.name}</td>
                                            <td>${category.description}</td>
                                            <td>
                                                <c:if test="${category.active}">
                                                    <span class="badge bg-success">Active</span>
                                                </c:if>
                                                <c:if test="${not category.active}">
                                                    <span class="badge bg-danger">Inactive</span>
                                                </c:if>
                                            </td>
                                            <td><fmt:formatDate value="${category.createdAt}" pattern="yyyy-MM-dd" /></td>
                                            <td><fmt:formatDate value="${category.updatedAt}" pattern="yyyy-MM-dd" /></td>
                                            <td>
                                                <div class="btn-group btn-group-sm" role="group">
                                                    <a href="category?action=showEditForm&id=${category.categoryId}" class="btn btn-outline-primary">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <a href="#" onclick="confirmDelete(${category.categoryId}, '${category.name}')" class="btn btn-outline-danger">
                                                        <i class="bi bi-trash"></i>
                                                    </a>
                                                    <a href="fruit?action=filterByCategory&categoryId=${category.categoryId}" class="btn btn-outline-info">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        
        <div class="mt-3">
            <a href="fruit" class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> Back to Fruits
            </a>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="deleteModalBody">
                    Are you sure you want to delete this category?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <a href="#" id="deleteLink" class="btn btn-danger">Delete</a>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../include/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete(categoryId, categoryName) {
            document.getElementById('deleteModalBody').innerText = 'Are you sure you want to delete the category "' + categoryName + '"?';
            document.getElementById('deleteLink').href = 'category?action=delete&id=' + categoryId;
            var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            deleteModal.show();
        }
    </script>
</body>
</html>