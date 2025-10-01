<%-- 
    Document   : wastageForm
    Created on : 2025年4月19日, 下午12:11:54
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
    <title>Record Wastage - Fruit Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .form-card {
            box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            border: none;
        }
        .form-card .card-header {
            border-radius: 10px 10px 0 0;
        }
        .info-card {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/shopHeader.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Record Wastage</h1>
            <a href="${pageContext.request.contextPath}/shop/inventory" class="btn btn-secondary">
                <i class="fa fa-arrow-left me-2"></i> Back to Dashboard
            </a>
        </div>
        
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
        
        <div class="row">
            <div class="col-md-7">
                <div class="card form-card">
                    <div class="card-header bg-danger text-white">
                        <h4 class="mb-0"><i class="fa fa-trash-can me-2"></i> Wastage Form</h4>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/shop/inventory" method="post">
                            <input type="hidden" name="action" value="recordWastage">
                            
                            <div class="mb-3">
                                <label for="fruitId" class="form-label">Fruit</label>
                                <select class="form-select" id="fruitId" name="fruitId" required>
                                    <option value="">Select a fruit...</option>
                                    <c:forEach var="item" items="${inventory}">
                                        <option value="${item.fruitId}" data-quantity="${item.quantity}">${item.fruitName} (${item.quantity} in stock)</option>
                                    </c:forEach>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label for="quantity" class="form-label">Quantity</label>
                                <input type="number" class="form-control" id="quantity" name="quantity" min="1" required>
                                <div class="form-text">Enter the number of units to be recorded as wastage.</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="reason" class="form-label">Reason for Wastage</label>
                                <select class="form-select" id="reason" name="reason" required>
                                    <option value="">Select a reason...</option>
                                    <option value="Damaged">Damaged</option>
                                    <option value="Expired">Expired</option>
                                    <option value="Quality issues">Quality issues</option>
                                    <option value="Spoiled">Spoiled</option>
                                    <option value="Contaminated">Contaminated</option>
                                    <option value="Other">Other (please specify in notes)</option>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label for="batchId" class="form-label">Batch (Optional)</label>
                                <select class="form-select" id="batchId" name="batchId">
                                    <option value="none">Select a batch (optional)...</option>
                                    <c:forEach var="batch" items="${batches}">
                                        <option value="${batch.batchId}" data-fruit="${batch.fruitId}">${batch.batchId} - ${batch.fruitName} (${batch.quantity} units, Exp: <fmt:formatDate value="${batch.expiryDate}" pattern="yyyy-MM-dd" />)</option>
                                    </c:forEach>
                                </select>
                                <div class="form-text">If this wastage is related to a specific batch, please select it.</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="notes" class="form-label">Notes</label>
                                <textarea class="form-control" id="notes" name="notes" rows="3" placeholder="Enter any additional details about this wastage"></textarea>
                            </div>
                            
                            <div class="alert alert-warning" id="inventoryWarning" style="display: none;">
                                <i class="fa fa-triangle-exclamation me-2"></i>
                                <span id="warningMessage"></span>
                            </div>
                            
                            <div class="text-end">
                                <a href="${pageContext.request.contextPath}/shop/inventory" class="btn btn-secondary me-2">Cancel</a>
                                <button type="submit" class="btn btn-danger">Record Wastage</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            
            <div class="col-md-5">
                <div class="card form-card">
                    <div class="card-header bg-info text-white">
                        <h4 class="mb-0"><i class="fa fa-circle-info me-2"></i> Wastage Guidelines</h4>
                    </div>
                    <div class="card-body">
                        <div class="mb-4">
                            <h5><i class="fa fa-clipboard-check text-success me-2"></i> When to Record Wastage</h5>
                            <ul>
                                <li>Damaged items during storage or handling</li>
                                <li>Expired products that can no longer be sold</li>
                                <li>Items that fail quality checks</li>
                                <li>Products affected by temperature or humidity issues</li>
                                <li>Contaminated or spoiled items</li>
                            </ul>
                        </div>
                        
                        <div class="mb-4">
                            <h5><i class="fa fa-clipboard-list text-primary me-2"></i> Required Information</h5>
                            <ul>
                                <li><strong>Fruit:</strong> The type of fruit being wasted</li>
                                <li><strong>Quantity:</strong> Number of units being removed</li>
                                <li><strong>Reason:</strong> Why the items are being wasted</li>
                                <li><strong>Batch:</strong> Link to a specific batch (if applicable)</li>
                                <li><strong>Notes:</strong> Any additional details or observations</li>
                            </ul>
                        </div>
                        
                        <div class="alert alert-warning">
                            <div class="d-flex">
                                <div class="me-3">
                                    <i class="fa fa-triangle-exclamation fa-2x"></i>
                                </div>
                                <div>
                                    <h5 class="alert-heading">Important!</h5>
                                    <p class="mb-0">Recording wastage will reduce inventory quantities. This action cannot be undone. Make sure all information is accurate before submitting.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Quick Links -->
                <div class="card form-card mt-4">
                    <div class="card-header bg-secondary text-white">
                        <h4 class="mb-0"><i class="fa fa-link me-2"></i> Quick Links</h4>
                    </div>
                    <div class="card-body">
                        <div class="list-group">
                            <a href="${pageContext.request.contextPath}/shop/inventory?action=list" class="list-group-item list-group-item-action">
                                <i class="fa fa-boxes-stacked me-2"></i> View Inventory
                            </a>
                            <a href="${pageContext.request.contextPath}/shop/inventory?action=listWastage" class="list-group-item list-group-item-action">
                                <i class="fa fa-trash-can me-2"></i> View Wastage History
                            </a>
                            <a href="${pageContext.request.contextPath}/shop/inventory?action=listBatches" class="list-group-item list-group-item-action">
                                <i class="fa fa-box me-2"></i> View Batches
                            </a>
                            <a href="${pageContext.request.contextPath}/shop/inventory?action=transactions" class="list-group-item list-group-item-action">
                                <i class="fa fa-clock-rotate-left me-2"></i> View Transactions
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const fruitSelect = document.getElementById('fruitId');
            const quantityInput = document.getElementById('quantity');
            const batchSelect = document.getElementById('batchId');
            const warningDiv = document.getElementById('inventoryWarning');
            const warningMessage = document.getElementById('warningMessage');
            
            // Filter batches based on selected fruit
            fruitSelect.addEventListener('change', function() {
                const selectedFruitId = parseInt(this.value);
                
                // Reset batch dropdown
                batchSelect.value = 'none';
                
                // Show/hide batch options based on selected fruit
                const batchOptions = batchSelect.querySelectorAll('option');
                batchOptions.forEach(option => {
                    if (option.value === 'none') return;
                    
                    const batchFruitId = parseInt(option.getAttribute('data-fruit'));
                    if (batchFruitId === selectedFruitId) {
                        option.style.display = '';
                    } else {
                        option.style.display = 'none';
                    }
                });
            });
            
            // Validate quantity against inventory
            quantityInput.addEventListener('input', function() {
                validateQuantity();
            });
            
            fruitSelect.addEventListener('change', function() {
                validateQuantity();
            });
            
            function validateQuantity() {
                const selectedOption = fruitSelect.options[fruitSelect.selectedIndex];
                if (!selectedOption || selectedOption.value === '') {
                    warningDiv.style.display = 'none';
                    return;
                }
                
                const availableQuantity = parseInt(selectedOption.getAttribute('data-quantity'));
                const enteredQuantity = parseInt(quantityInput.value) || 0;
                
                if (enteredQuantity > availableQuantity) {
                    warningDiv.style.display = 'block';
                    warningMessage.textContent = `Warning: The quantity (${enteredQuantity}) exceeds the available stock (${availableQuantity}).`;
                } else if (enteredQuantity === 0) {
                    warningDiv.style.display = 'block';
                    warningMessage.textContent = 'Please enter a quantity greater than zero.';
                } else {
                    warningDiv.style.display = 'none';
                }
            }
            
            // Form validation
            document.querySelector('form').addEventListener('submit', function(event) {
                const selectedOption = fruitSelect.options[fruitSelect.selectedIndex];
                if (!selectedOption || selectedOption.value === '') {
                    return;
                }
                
                const availableQuantity = parseInt(selectedOption.getAttribute('data-quantity'));
                const enteredQuantity = parseInt(quantityInput.value) || 0;
                
                if (enteredQuantity > availableQuantity) {
                    if (!confirm(`The quantity (${enteredQuantity}) exceeds the available stock (${availableQuantity}). Do you want to continue?`)) {
                        event.preventDefault();
                    }
                } else if (enteredQuantity === 0) {
                    alert('Please enter a quantity greater than zero.');
                    event.preventDefault();
                }
            });
        });
    </script>
</body>
</html>