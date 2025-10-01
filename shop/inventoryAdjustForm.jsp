<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Adjust Inventory - Fruit Management System</title>
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
        .current-inventory {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .quantity-badge {
            font-size: 2rem;
            padding: 0.5rem 1rem;
        }
        .btn-circle {
            width: 35px;
            height: 35px;
            padding: 6px 0px;
            border-radius: 50%;
            text-align: center;
            font-size: 16px;
            line-height: 1.42857;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/shopHeader.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Adjust Inventory</h1>
            <a href="${pageContext.request.contextPath}/shop/inventory?action=list" class="btn btn-secondary">
                <i class="fa fa-arrow-left me-2"></i> Back to Inventory
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
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0"><i class="fa fa-edit me-2"></i> Inventory Adjustment Form</h4>
                    </div>
                    <div class="card-body">
                        <!-- Current Inventory Info -->
                        <div class="current-inventory">
                            <div class="row align-items-center">
                                <div class="col-md-6">
                                    <h5>Current Inventory</h5>
                                    <p class="mb-1"><strong>Fruit:</strong> ${fruit.name}</p>
                                    <p class="mb-1"><strong>Location:</strong> ${inventory.locationName}</p>
                                    <p class="mb-0"><strong>Last Updated:</strong> <fmt:formatDate value="${inventory.lastChecked}" pattern="yyyy-MM-dd HH:mm" /></p>
                                </div>
                                <div class="col-md-6 text-center">
                                    <p class="mb-1">Current Quantity</p>
                                    <span class="badge rounded-pill 
                                        <c:choose>
                                            <c:when test="${inventory.quantity <= 0}">bg-danger</c:when>
                                            <c:when test="${inventory.quantity <= 5}">bg-warning text-dark</c:when>
                                            <c:otherwise>bg-success</c:otherwise>
                                        </c:choose> quantity-badge">
                                        ${inventory.quantity}
                                    </span>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Adjustment Form -->
                        <form action="${pageContext.request.contextPath}/shop/inventory" method="post" id="adjustForm">
                            <input type="hidden" name="action" value="adjustInventory">
                            <input type="hidden" name="fruitId" value="${inventory.fruitId}">
                            <input type="hidden" name="inventoryId" value="${inventory.inventoryId}">
                            
                            <div class="mb-3">
                                <label for="adjustmentQuantity" class="form-label">Adjustment Quantity</label>
                                <div class="input-group">
                                    <button type="button" class="btn btn-outline-danger" id="decreaseQty">
                                        <i class="fa fa-minus"></i>
                                    </button>
                                    <input type="number" class="form-control text-center" id="adjustmentQuantity" name="adjustmentQuantity" required value="0">
                                    <button type="button" class="btn btn-outline-success" id="increaseQty">
                                        <i class="fa fa-plus"></i>
                                    </button>
                                </div>
                                <div class="form-text">Enter a positive number to add inventory or a negative number to reduce inventory.</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="reason" class="form-label">Reason for Adjustment</label>
                                <select class="form-select" id="reason" name="reason" required>
                                    <option value="">Select a reason...</option>
                                    <option value="New delivery">New delivery</option>
                                    <option value="Inventory count adjustment">Inventory count adjustment</option>
                                    <option value="Damaged goods">Damaged goods</option>
                                    <option value="Quality control">Quality control</option>
                                    <option value="Transfer">Transfer</option>
                                    <option value="Other">Other (please specify in notes)</option>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label for="notes" class="form-label">Notes</label>
                                <textarea class="form-control" id="notes" name="notes" rows="3" placeholder="Enter additional details about this adjustment"></textarea>
                            </div>
                            
                            <div class="alert alert-info d-flex align-items-center" role="alert">
                                <i class="fa fa-info-circle me-2"></i>
                                <div>
                                    <strong>New quantity will be:</strong> <span id="newQuantity">${inventory.quantity}</span>
                                </div>
                            </div>
                            
                            <div class="text-end">
                                <a href="${pageContext.request.contextPath}/shop/inventory?action=list" class="btn btn-secondary me-2">Cancel</a>
                                <button type="submit" class="btn btn-primary">Save Adjustment</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            
            <div class="col-md-5">
                <div class="card form-card">
                    <div class="card-header bg-info text-white">
                        <h4 class="mb-0"><i class="fa fa-lightbulb me-2"></i> Adjustment Tips</h4>
                    </div>
                    <div class="card-body">
                        <div class="mb-4">
                            <h5><i class="fa fa-plus-circle text-success me-2"></i> Adding Inventory</h5>
                            <p>Use a positive number when you're adding new inventory.</p>
                            <ul>
                                <li>New deliveries from suppliers</li>
                                <li>Transfers from other locations</li>
                                <li>Corrections after inventory count</li>
                            </ul>
                        </div>
                        
                        <div class="mb-4">
                            <h5><i class="fa fa-minus-circle text-danger me-2"></i> Reducing Inventory</h5>
                            <p>Use a negative number when you're reducing inventory.</p>
                            <ul>
                                <li>Removing damaged or spoiled items</li>
                                <li>Transfers to other locations</li>
                                <li>Corrections after inventory count</li>
                            </ul>
                        </div>
                        
                        <div class="mb-4">
                            <h5><i class="fa fa-file-lines text-primary me-2"></i> Notes Best Practices</h5>
                            <p>Always include detailed notes, especially for:</p>
                            <ul>
                                <li>Batch references for new deliveries</li>
                                <li>Condition details for damaged goods</li>
                                <li>Destination details for transfers</li>
                                <li>Any special circumstances</li>
                            </ul>
                        </div>
                        
                        <div class="alert alert-warning d-flex align-items-center" role="alert">
                            <i class="fa fa-triangle-exclamation me-2"></i>
                            <div>
                                Remember that all adjustments are logged for audit purposes. Always provide accurate information.
                            </div>
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
            const currentQuantity = ${inventory.quantity};
            const adjustmentInput = document.getElementById('adjustmentQuantity');
            const newQuantityDisplay = document.getElementById('newQuantity');
            const increaseBtn = document.getElementById('increaseQty');
            const decreaseBtn = document.getElementById('decreaseQty');
            
            function updateNewQuantity() {
                const adjustmentValue = parseInt(adjustmentInput.value) || 0;
                const newQuantity = currentQuantity + adjustmentValue;
                newQuantityDisplay.textContent = newQuantity;
                
                if (newQuantity < 0) {
                    newQuantityDisplay.classList.add('text-danger');
                    newQuantityDisplay.classList.remove('text-success');
                } else {
                    newQuantityDisplay.classList.remove('text-danger');
                    newQuantityDisplay.classList.add('text-success');
                }
            }
            
            adjustmentInput.addEventListener('input', updateNewQuantity);
            
            increaseBtn.addEventListener('click', function() {
                adjustmentInput.value = (parseInt(adjustmentInput.value) || 0) + 1;
                updateNewQuantity();
            });
            
            decreaseBtn.addEventListener('click', function() {
                adjustmentInput.value = (parseInt(adjustmentInput.value) || 0) - 1;
                updateNewQuantity();
            });
            
            // Initialize display
            updateNewQuantity();
            
            // Form validation
            document.getElementById('adjustForm').addEventListener('submit', function(event) {
                const adjustmentValue = parseInt(adjustmentInput.value) || 0;
                const newQuantity = currentQuantity + adjustmentValue;
                
                if (adjustmentValue === 0) {
                    event.preventDefault();
                    alert('Please enter a non-zero adjustment quantity.');
                    return;
                }
                
                if (newQuantity < 0) {
                    if (!confirm('Warning: This adjustment will result in a negative inventory. Do you want to continue?')) {
                        event.preventDefault();
                    }
                }
            });
        });
    </script>
</body>
</html>