<%-- 
    Document   : categoryForm.jsp
    Created on : 2025年4月19日, 上午4:53:18
    Author     : kelvin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty category ? 'Add New Category' : 'Edit Category'} - AIB System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
</head>
<body>
    <jsp:include page="../include/navbar.jsp" />
    
    <div class="container mt-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="category">Categories</a></li>
                <li class="breadcrumb-item active" aria-current="page">${empty category ? 'Add New Category' : 'Edit Category'}</li>
            </ol>
        </nav>
        
        <div class="card">
            <div class="card-header">
                <h4>${empty category ? 'Add New Category' : 'Edit Category'}</h4>
            </div>
            <div class="card-body">
                <form action="category" method="post">
                    <input type="hidden" name="action" value="${empty category ? 'add' : 'update'}">
                    <c:if test="${not empty category}">
                        <input type="hidden" name="categoryId" value="${category.categoryId}">
                    </c:if>
                    
                    <div class="mb-3">
                        <label for="name" class="form-label">Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="name" name="name" value="${category.name}" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="3">${category.description}</textarea>
                    </div>
                    
                    <c:if test="${not empty category}">
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="isActive" name="isActive" value="true" ${category.active ? 'checked' : ''}>
                                <label class="form-check-label" for="isActive">
                                    Active
                                </label>
                            </div>
                        </div>
                    </c:if>
                    
                    <div class="mt-4">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-save"></i> ${empty category ? 'Add Category' : 'Update Category'}
                        </button>
                        <a href="category" class="btn btn-secondary">
                            <i class="bi bi-x-circle"></i> Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <jsp:include page="../include/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>