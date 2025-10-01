<%-- 
    Document   : adjustForm
    Created on : 2025年4月19日, 下午3:16:05
    Author     : kelvin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Adjust Inventory - ${inventory.fruitName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <style>
        .form-card {
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .adjustment-type-btn {
            border: 2px solid #dee2e6;
            border-radius: 8px;
            padding: 10px;
            margin-bottom: 15px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .adjustment-type-btn.active {
            border-color: #0d6efd;
            background-color: rgba(13, 110, 253, 0.1);
        }
        .adjustment-type-btn:hover:not(.active) {
            border-color: #adb5bd;
            background-color: #f8f9fa;
        }
        .adjustment-icon {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <jsp:include page="../include/header.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Adjust Inventory: ${inventory.fruitName}</h1>
            <a href="${pageContext.request.contextPath}/warehouse/inventory?action=details&id=${inventory.id}" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left"></i> Back to Details
            </a>
        </div>
        
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
        
        <div class="row">
            <div class="col-md-8">
                <div class="card form-card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-edit me-2"></i> Inventory Adjustment Form</h5>
                    </div>
                    <div class="card-body">
                        <form id="adjustForm" action="${pageContext.request.contextPath}/warehouse/inventory" method="post">
                            <input type="hidden" name="action" value="adjustQuantity">
                            <input type="hidden" name="inventoryId" value="${inventory.id}">
                            
                            <!-- Current Inventory Info -->
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Fruit Name</label>
                                        <input type="text" class="form-control" value="${inventory.fruitName}" readonly>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Current Quantity</label>
                                        <input type="text" class="form-control" value="${inventory.quantity}" readonly>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Adjustment Type -->
                            <div class="mb-4">
                                <label class="form-label">Adjustment Type</label>
                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="adjustment-type-btn active" data-type="add">
                                            <div class="d-flex align-items-center">
                                                <div class="adjustment-icon bg-success bg-opacity-10 text-success">
                                                    <i class="fas fa-plus"></i>
                                                </div>
                                                <div>
                                                    <strong>Add Stock</strong>
                                                    <p class="mb-0 small text-muted">Increase inventory</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="adjustment-type-btn" data-type="subtract">
                                            <div class="d-flex align-items-center">
                                                <div class="adjustment-icon bg-danger bg-opacity-10 text-danger">
                                                    <i class="fas fa-minus"></i>
                                                </div>
                                                <div>
                                                    <strong>Remove Stock</strong>
                                                    <p class="mb-0 small text-muted">Decrease inventory</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="adjustment-type-btn" data-type="set">
                                            <div class="d-flex align-items-center">
                                                <div class="adjustment-icon bg-primary bg-opacity-10 text-primary">
                                                    <i class="fas fa-equals"></i>
                                                </div>
                                                <div>
                                                    <strong>Set Exact</strong>
                                                    <p class="mb-0 small text-muted">Override current value</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Adjustment Quantity -->
                            <div class="mb-4">
                                <label for="adjustmentQuantity" class="form-label">Adjustment Quantity</label>
                                <input type="number" class="form-control" id="adjustmentQuantity" name="adjustmentQuantity" min="1" required>
                                <div class="form-text">
                                    Enter the quantity to <span id="adjustmentAction">add to</span> the current stock.
                                </div>
                            </div>
                            
                            <div class="mb-4">
                                <label for="newQuantity" class="form-label">New Quantity</label>
                                <input type="number" class="form-control" id="newQuantity" name="newQuantity" readonly>
                                <div class="form-text text-muted">
                                    This will be the new inventory level after adjustment.
                                </div>
                            </div>
                            
                            <!-- Adjustment Reason -->
                            <div class="mb-4">
                                <label for="notes" class="form-label">Reason for Adjustment</label>
                                <textarea class="form-control" id="notes" name="notes" rows="3" required></textarea>
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="${pageContext.request.contextPath}/warehouse/inventory?action=details&id=${inventory.id}" class="btn btn-outline-secondary me-md-2">Cancel</a>
                                <button type="submit" class="btn btn-primary">Save Adjustment</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <!-- Current Status Card -->
                <div class="card mb-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i> Current Status</h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <span class="fw-bold">Current Quantity:</span>
                            <span class="float-end">${inventory.quantity} units</span>
                        </div>
                        <div class="mb-3">
                            <span class="fw-bold">Minimum Stock Level:</span>
                            <span class="float-end">${inventory.minStockLevel} units</span>
                        </div>
                        <div class="mb-3">
                            <span class="fw-bold">Maximum Stock Level:</span>
                            <span class="float-end">${inventory.maxStockLevel} units</span>
                        </div>
                        <div class="mb-3">
                            <span class="fw-bold">Current Status:</span>
                            <span class="float-end">
                                <span class="badge bg-${inventory.stockStatusColor}">${inventory.stockStatus}</span>
                            </span>
                        </div>
                        <div class="mb-0">
                            <span class="fw-bold">Utilization:</span>
                            <span class="float-end"><fmt:formatNumber value="${inventory.utilizationPercentage}" pattern="#0.0" />%</span>
                        </div>
                        <div class="progress mt-2">
                            <div class="progress-bar bg-${inventory.stockStatusColor}" 
                                role="progressbar" 
                                style="width: ${inventory.utilizationPercentage}%"
                                aria-valuenow="${inventory.utilizationPercentage}" 
                                aria-valuemin="0" 
                                aria-valuemax="100">
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Tips Card -->
                <div class="card">
                    <div class="card-header bg-warning text-dark">
                        <h5 class="mb-0"><i class="fas fa-lightbulb me-2"></i> Adjustment Tips</h5>
                    </div>
                    <div class="card-body">
                        <ul class="mb-0">
                            <li class="mb-2">Always provide a clear reason for inventory adjustments</li>
                            <li class="mb-2">Use "Add Stock" when receiving new shipments</li>
                            <li class="mb-2">Use "Remove Stock" for damaged items or returns</li>
                            <li class="mb-2">Use "Set Exact" only after physical inventory counts</li>
                            <li>All adjustments are logged for audit purposes</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../include/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const currentQuantity = ${inventory.quantity};
            const adjustmentTypeButtons = document.querySelectorAll('.adjustment-type-btn');
            const adjustmentQuantityInput = document.getElementById('adjustmentQuantity');
            const newQuantityInput = document.getElementById('newQuantity');
            const adjustmentActionSpan = document.getElementById('adjustmentAction');
            let adjustmentType = 'add'; // Default
            
            // Initialize with default values
            adjustmentQuantityInput.value = "1";
            calculateNewQuantity();
            
            // Event listeners for adjustment type buttons
            adjustmentTypeButtons.forEach(button => {
                button.addEventListener('click', function() {
                    // Remove active class from all buttons
                    adjustmentTypeButtons.forEach(btn => btn.classList.remove('active'));
                    // Add active class to clicked button
                    this.classList.add('active');
                    
                    // Update adjustment type
                    adjustmentType = this.getAttribute('data-type');
                    
                    // Update action text
                    if (adjustmentType === 'add') {
                        adjustmentActionSpan.textContent = 'add to';
                    } else if (adjustmentType === 'subtract') {
                        adjustmentActionSpan.textContent = 'subtract from';
                    } else if (adjustmentType === 'set') {
                        adjustmentActionSpan.textContent = 'set as';
                    }
                    
                    // Recalculate new quantity
                    calculateNewQuantity();
                });
            });
            
            // Event listener for adjustment quantity input
            adjustmentQuantityInput.addEventListener('input', calculateNewQuantity);
            
            // Function to calculate new quantity
            function calculateNewQuantity() {
                const adjustmentQuantity = parseInt(adjustmentQuantityInput.value) || 0;
                let newQty = 0;
                
                if (adjustmentType === 'add') {
                    newQty = currentQuantity + adjustmentQuantity;
                } else if (adjustmentType === 'subtract') {
                    newQty = Math.max(0, currentQuantity - adjustmentQuantity);
                } else if (adjustmentType === 'set') {
                    newQty = adjustmentQuantity;
                }
                
                newQuantityInput.value = newQty;
            }
            
            // Form submission
            document.getElementById('adjustForm').addEventListener('submit', function(e) {
                // Make sure we're submitting the calculated new quantity, not the adjustment
                document.getElementById('newQuantity').removeAttribute('readonly');
            });
        });
    </script>
</body>
</html>