<%-- 
    Document   : fruitForm.jsp
    Created on : 2025年4月19日, 上午4:52:42
    Author     : kelvin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty fruit ? 'Add New Fruit' : 'Edit Fruit'} - AIB System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
</head>
<body>
    <jsp:include page="../include/navbar.jsp" />
    
    <div class="container mt-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="fruit">Fruits</a></li>
                <li class="breadcrumb-item active" aria-current="page">${empty fruit ? 'Add New Fruit' : 'Edit Fruit'}</li>
            </ol>
        </nav>
        
        <div class="card">
            <div class="card-header">
                <h4>${empty fruit ? 'Add New Fruit' : 'Edit Fruit'}</h4>
            </div>
            <div class="card-body">
                <form action="fruit" method="post">
                    <input type="hidden" name="action" value="${empty fruit ? 'add' : 'update'}">
                    <c:if test="${not empty fruit}">
                        <input type="hidden" name="fruitId" value="${fruit.fruitId}">
                    </c:if>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="name" class="form-label">Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="name" name="name" value="${fruit.name}" required>
                        </div>
                        <div class="col-md-6">
                            <label for="categoryId" class="form-label">Category <span class="text-danger">*</span></label>
                            <select class="form-select" id="categoryId" name="categoryId" required>
                                <option value="" selected disabled>Select a category</option>
                                <c:forEach items="${categories}" var="category">
                                    <option value="${category.categoryId}" ${fruit.categoryId == category.categoryId ? 'selected' : ''}>
                                        ${category.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="price" class="form-label">Price <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text">$</span>
                                <input type="number" class="form-control" id="price" name="price" value="${fruit.price}" min="0.01" step="0.01" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label for="unit" class="form-label">Unit <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="unit" name="unit" value="${fruit.unit}" 
                                   placeholder="e.g., per kg, per piece" required>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="4">${fruit.description}</textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label for="imagePath" class="form-label">Image URL</label>
                        <input type="text" class="form-control" id="imagePath" name="imagePath" value="${fruit.imagePath}">
                        <div class="form-text">Enter the URL of an image for this fruit.</div>
                    </div>
                    
                    <c:if test="${not empty fruit}">
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="isActive" name="isActive" value="true" ${fruit.active ? 'checked' : ''}>
                                <label class="form-check-label" for="isActive">
                                    Active
                                </label>
                            </div>
                        </div>
                    </c:if>
                    
                    <div class="mt-4">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-save"></i> ${empty fruit ? 'Add Fruit' : 'Update Fruit'}
                        </button>
                        <a href="fruit" class="btn btn-secondary">
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