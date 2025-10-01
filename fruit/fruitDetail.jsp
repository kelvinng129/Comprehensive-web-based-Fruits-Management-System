<%-- 
    Document   : fruitDetail.jsp
    Created on : 2025年4月19日, 上午4:51:58
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
    <title>${fruit.name} - AIB System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
    <style>
        .fruit-image {
            max-height: 400px;
            object-fit: contain;
        }
    </style>
</head>
<body>
    <jsp:include page="../include/navbar.jsp" />
    
    <div class="container mt-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="fruit">Fruits</a></li>
                <li class="breadcrumb-item active" aria-current="page">${fruit.name}</li>
            </ol>
        </nav>
        
        <div class="row">
            <div class="col-md-5">
                <c:choose>
                    <c:when test="${not empty fruit.imagePath}">
                        <img src="${fruit.imagePath}" class="img-fluid rounded fruit-image" alt="${fruit.name}">
                    </c:when>
                    <c:otherwise>
                        <div class="bg-light d-flex justify-content-center align-items-center rounded" style="height: 400px;">
                            <i class="bi bi-image text-secondary" style="font-size: 8rem;"></i>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="col-md-7">
                <h2>${fruit.name}</h2>
                <p>
                    <span class="badge bg-info">${fruit.categoryName}</span>
                    <c:if test="${fruit.active}">
                        <span class="badge bg-success">Active</span>
                    </c:if>
                    <c:if test="${not fruit.active}">
                        <span class="badge bg-danger">Inactive</span>
                    </c:if>
                </p>
                
                <div class="mb-3">
                    <h4 class="text-primary">$${fruit.price} ${fruit.unit}</h4>
                </div>
                
                <div class="mb-3">
                    <h5>Description</h5>
                    <p>${fruit.description}</p>
                </div>
                
                <div class="mb-3">
                    <h5>Details</h5>
                    <table class="table table-striped">
                        <tbody>
                            <tr>
                                <th style="width: 40%">ID</th>
                                <td>${fruit.fruitId}</td>
                            </tr>
                            <tr>
                                <th>Category</th>
                                <td>${fruit.categoryName}</td>
                            </tr>
                            <tr>
                                <th>Created At</th>
                                <td><fmt:formatDate value="${fruit.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                            </tr>
                            <tr>
                                <th>Last Updated</th>
                                <td><fmt:formatDate value="${fruit.updatedAt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                
                <div class="mt-4">
                    <a href="inventory?action=listByFruit&fruitId=${fruit.fruitId}" class="btn btn-info">
                        <i class="bi bi-boxes"></i> View Inventory
                    </a>
                    <a href="fruit?action=showEditForm&id=${fruit.fruitId}" class="btn btn-primary">
                        <i class="bi bi-pencil"></i> Edit Fruit
                    </a>
                    <a href="#" onclick="confirmDelete(${fruit.fruitId}, '${fruit.name}')" class="btn btn-danger">
                        <i class="bi bi-trash"></i> Delete
                    </a>
                    <a href="fruit" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Back to List
                    </a>
                </div>
            </div>
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
                    Are you sure you want to delete this fruit?
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
        function confirmDelete(fruitId, fruitName) {
            document.getElementById('deleteModalBody').innerText = 'Are you sure you want to delete "' + fruitName + '"?';
            document.getElementById('deleteLink').href = 'fruit?action=delete&id=' + fruitId;
            var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            deleteModal.show();
        }
    </script>
</body>
</html>