<%-- 
    Document   : nventoryForm.jsp
    Created on : 2025年4月19日, 上午4:53:33
    Author     : kelvin
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Inventory - AIB System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
</head>
<body>
    <jsp:include page="../include/navbar.jsp" />
    
    <div class="container mt-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="inventory">Inventory</a></li>
                <li class="breadcrumb-item active" aria-current="page">Update Inventory</li>
            </ol>
        </nav>
        
        <div class="card">
            <div class="card-header">
                <h4>Update Inventory</h4>
            </div>
            <div class="card-body">
                <form action="inventory" method="post">
                    <input type="hidden" name="action" value="update">
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="fruitId" class="form-label">Fruit <span class="text-danger">*</span></label>
                            <select class="form-select" id="fruitId" name="fruitId" required ${not empty inventory ? 'disabled' : ''}>
                                <option value="" selected disabled>Select a fruit</option>
                                <c:forEach items="${fruits}" var="fruit">
                                    <option value="${fruit.fruitId}" ${inventory.fruitId == fruit.fruitId ? 'selected' : ''}>
                                        ${fruit.name}
                                    </option>
                                </c:forEach>
                            </select>
                            <c:if test="${not empty inventory}">
                                <input type="hidden" name="fruitId" value="${inventory.fruitId}">
                            </c:if>
                        </div>
                        <div class="col-md-6">
                            <label for="locationId" class="form-label">Location <span class="text-danger">*</span></label>
                            <select class="form-select" id="locationId" name="locationId" required ${not empty inventory ? 'disabled' : ''}>
                                <option value="" selected disabled>Select a location</option>
                                <c:forEach items="${locations}" var="location">
                                    <option value="${location.locationId}" ${inventory.locationId == location.locationId ? 'selected' : ''}>
                                        ${location.locationName}
                                    </option>
                                </c:forEach>
                            </select>
                            <c:if test="${not empty inventory}">
                                <input type="hidden" name="locationId" value="${inventory.locationId}">
                            </c:if>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="quantity" class="form-label">Quantity <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="quantity" name="quantity" 
                               value="${inventory.quantity}" min="0" required>
                    </div>
                    
                    <div class="mt-4">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-save"></i> Update Inventory
                        </button>
                        <a href="inventory" class="btn btn-secondary">
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