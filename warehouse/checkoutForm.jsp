<%-- 
    Document   : checkoutForm
    Created on : 2025年4月20日, 上午5:03:36
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
    <title>Checkout - Warehouse Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <style>
        .required-field::after {
            content: "*";
            color: red;
            margin-left: 4px;
        }
        .fruit-item {
            cursor: pointer;
            transition: all 0.2s;
            border-radius: 10px;
        }
        .fruit-item:hover {
            background-color: #f8f9fa;
        }
        .fruit-item.selected {
            background-color: #e7f5ff;
            border: 1px solid #0d6efd;
        }
        .checkout-summary {
            border-left: 4px solid #0d6efd;
            background-color: #f8f9ff;
        }
    </style>
</head>
<body>
    <jsp:include page="../include/header.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1>Checkout</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/warehouse/delivery/list">Deliveries</a></li>
                        <li class="breadcrumb-item active">Checkout</li>
                    </ol>
                </nav>
            </div>
        </div>
        
        <form action="${pageContext.request.contextPath}/warehouse/delivery" method="post" id="checkoutForm">
            <input type="hidden" name="action" value="checkout">
            <input type="hidden" name="sourceLocationId" value="${sourceLocation.locationId}">
            
            <div class="row">
                <div class="col-md-8">
                    <!-- Location Information -->
                    <div class="card mb-4">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">Checkout Information</h5>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label">Source Location</label>
                                    <input type="text" class="form-control-plaintext" 
                                           value="${sourceLocation.locationName}" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label for="destinationLocationId" class="form-label required-field">Destination Location</label>
                                    <select class="form-select" id="destinationLocationId" name="destinationLocationId" required>
                                        <option value="" disabled selected>-- Select Destination --</option>
                                        <c:forEach var="location" items="${destinations}">
                                            <c:if test="${location.locationId != sourceLocation.locationId}">
                                                <option value="${location.locationId}">${location.locationName}</option>
                                            </c:if>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="deliveryType" class="form-label required-field">Delivery Type</label>
                                    <select class="form-select" id="deliveryType" name="deliveryType" required>
                                        <option value="" disabled selected>-- Select Type --</option>
                                        <option value="SOURCE_TO_CENTRAL">Source to Central Warehouse</option>
                                        <option value="CENTRAL_TO_SHOP">Central Warehouse to Shop</option>
                                        <option value="SHOP_TO_SHOP">Shop to Shop</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="estimatedDeliveryDate" class="form-label">Estimated Delivery Date</label>
                                    <input type="date" class="form-control" id="estimatedDeliveryDate" name="estimatedDeliveryDate">
                                </div>
                            </div>
                            
                            <c:if test="${not empty requestId}">
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i>
                                    This checkout is linked to approval request #${requestId}.
                                </div>
                                <input type="hidden" name="requestId" value="${requestId}">
                            </c:if>
                            
                            <c:if test="${not empty reservationId}">
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i>
                                    This checkout is linked to reservation #${reservationId}.
                                </div>
                                <input type="hidden" name="reservationId" value="${reservationId}">
                            </c:if>
                            
                            <div class="mb-3">
                                <label for="notes" class="form-label">Notes</label>
                                <textarea class="form-control" id="notes" name="notes" rows="2" 
                                          placeholder="Add any notes for this delivery"></textarea>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Available Fruits -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="mb-0">Available Fruits</h5>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <input type="text" class="form-control" id="fruitSearch" 
                                       placeholder="Search for fruits...">
                            </div>
                            
                            <div class="row" id="fruitsContainer">
                                <c:choose>
                                    <c:when test="${not empty fruits}">
                                        <c:forEach var="fruit" items="${fruits}">
                                            <div class="col-md-6 mb-3 fruit-item-container">
                                                <div class="card fruit-item" data-fruit-id="${fruit.fruitId}" 
                                                     data-fruit-name="${fruit.fruitName}" 
                                                     data-available="${fruit.quantity}">
                                                    <div class="card-body">
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <h6 class="mb-0">${fruit.fruitName}</h6>
                                                            <span class="badge bg-success">
                                                                Available: ${fruit.quantity}
                                                            </span>
                                                        </div>
                                                        <small class="text-muted">
                                                            Origin: ${fruit.sourceLocation}
                                                        </small>
                                                        
                                                        <div class="input-group mt-2 quantity-controls" style="display: none;">
                                                            <button type="button" class="btn btn-outline-primary btn-sm decrement-qty">
                                                                <i class="fas fa-minus"></i>
                                                            </button>
                                                            <input type="number" class="form-control form-control-sm qty-input" 
                                                                   min="1" max="${fruit.quantity}" value="1">
                                                            <button type="button" class="btn btn-outline-primary btn-sm increment-qty">
                                                                <i class="fas fa-plus"></i>
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="col-12">
                                            <div class="alert alert-warning">
                                                <i class="fas fa-exclamation-triangle me-2"></i>
                                                No fruits available for checkout from this location.
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-4">
                    <!-- Checkout Summary -->
                    <div class="card checkout-summary mb-4 sticky-top" style="top: 20px;">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">Checkout Summary</h5>
                        </div>
                        <div class="card-body">
                            <div id="selectedItemsContainer">
                                <div class="text-center py-4" id="noItemsMessage">
                                    <i class="fas fa-shopping-cart fa-3x text-muted mb-3"></i>
                                    <h5>No Items Selected</h5>
                                    <p class="text-muted">Click on fruits to add them to your checkout.</p>
                                </div>
                                <div id="selectedItemsList" style="display: none;"></div>
                            </div>
                            
                            <hr>
                            
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <span class="fw-bold">Total Items:</span>
                                <span id="totalItems">0</span>
                            </div>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary" id="checkoutBtn" disabled>
                                    <i class="fas fa-truck-loading me-1"></i> Complete Checkout
                                </button>
                                <a href="${pageContext.request.contextPath}/warehouse/delivery/list" class="btn btn-outline-secondary">
                                    <i class="fas fa-times-circle me-1"></i> Cancel
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Hidden inputs for selected items -->
            <div id="hiddenInputsContainer"></div>
        </form>
    </div>
    
    <jsp:include page="../include/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const fruitItems = document.querySelectorAll('.fruit-item');
            const fruitSearch = document.getElementById('fruitSearch');
            const selectedItemsList = document.getElementById('selectedItemsList');
            const noItemsMessage = document.getElementById('noItemsMessage');
            const totalItemsEl = document.getElementById('totalItems');
            const checkoutBtn = document.getElementById('checkoutBtn');
            const hiddenInputsContainer = document.getElementById('hiddenInputsContainer');
            
            let selectedItems = [];
            
            // Add click event to each fruit item
            fruitItems.forEach(item => {
                item.addEventListener('click', function() {
                    const fruitId = this.dataset.fruitId;
                    const fruitName = this.dataset.fruitName;
                    const available = parseInt(this.dataset.available);
                    
                    // Toggle selection
                    if (this.classList.contains('selected')) {
                        // Deselect
                        this.classList.remove('selected');
                        this.querySelector('.quantity-controls').style.display = 'none';
                        
                        // Remove from selected items
                        selectedItems = selectedItems.filter(item => item.id !== fruitId);
                    } else {
                        // Select
                        this.classList.add('selected');
                        this.querySelector('.quantity-controls').style.display = 'flex';
                        
                        // Add to selected items
                        selectedItems.push({
                            id: fruitId,
                            name: fruitName,
                            quantity: 1,
                            available: available
                        });
                    }
                    
                    updateSelectedItemsList();
                });
                
                // Quantity controls
                const decrementBtn = item.querySelector('.decrement-qty');
                const incrementBtn = item.querySelector('.increment-qty');
                const qtyInput = item.querySelector('.qty-input');
                
                decrementBtn.addEventListener('click', function(e) {
                    e.stopPropagation();
                    const currentVal = parseInt(qtyInput.value);
                    if (currentVal > 1) {
                        qtyInput.value = currentVal - 1;
                        updateItemQuantity(item.dataset.fruitId, currentVal - 1);
                    }
                });
                
                incrementBtn.addEventListener('click', function(e) {
                    e.stopPropagation();
                    const currentVal = parseInt(qtyInput.value);
                    const max = parseInt(qtyInput.max);
                    if (currentVal < max) {
                        qtyInput.value = currentVal + 1;
                        updateItemQuantity(item.dataset.fruitId, currentVal + 1);
                    }
                });
                
                qtyInput.addEventListener('change', function(e) {
                    e.stopPropagation();
                    let val = parseInt(this.value);
                    const max = parseInt(this.max);
                    
                    if (isNaN(val) || val < 1) {
                        val = 1;
                    } else if (val > max) {
                        val = max;
                    }
                    
                    this.value = val;
                    updateItemQuantity(item.dataset.fruitId, val);
                });
            });
            
            // Search functionality
            fruitSearch.addEventListener('input', function() {
                const searchTerm = this.value.toLowerCase();
                
                document.querySelectorAll('.fruit-item-container').forEach(container => {
                    const fruitName = container.querySelector('.fruit-item').dataset.fruitName.toLowerCase();
                    
                    if (fruitName.includes(searchTerm)) {
                        container.style.display = '';
                    } else {
                        container.style.display = 'none';
                    }
                });
            });
            
            // Update selected items list
            function updateSelectedItemsList() {
                if (selectedItems.length === 0) {
                    noItemsMessage.style.display = 'block';
                    selectedItemsList.style.display = 'none';
                    checkoutBtn.disabled = true;
                } else {
                    noItemsMessage.style.display = 'none';
                    selectedItemsList.style.display = 'block';
                    checkoutBtn.disabled = false;
                    
                    // Clear and rebuild list
                    selectedItemsList.innerHTML = '';
                    hiddenInputsContainer.innerHTML = '';
                    
                    selectedItems.forEach(item => {
                        const itemEl = document.createElement('div');
                        itemEl.className = 'mb-2';
                        itemEl.innerHTML = `
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="fw-bold">${item.name}</div>
                                    <small class="text-muted">Quantity: ${item.quantity}</small>
                                </div>
                                <button type="button" class="btn btn-sm btn-outline-danger remove-item" 
                                        data-fruit-id="${item.id}">
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>
                        `;
                        
                        selectedItemsList.appendChild(itemEl);
                        
                        // Add hidden inputs for form submission
                        const fruitIdInput = document.createElement('input');
                        fruitIdInput.type = 'hidden';
                        fruitIdInput.name = 'fruitId';
                        fruitIdInput.value = item.id;
                        
                        const quantityInput = document.createElement('input');
                        quantityInput.type = 'hidden';
                        quantityInput.name = 'quantity';
                        quantityInput.value = item.quantity;
                        
                        hiddenInputsContainer.appendChild(fruitIdInput);
                        hiddenInputsContainer.appendChild(quantityInput);
                    });
                    
                    // Add remove event listeners
                    document.querySelectorAll('.remove-item').forEach(btn => {
                        btn.addEventListener('click', function() {
                            const fruitId = this.dataset.fruitId;
                            
                            // Remove from selected items
                            selectedItems = selectedItems.filter(item => item.id !== fruitId);
                            
                            // Unselect the fruit item
                            const fruitItem = document.querySelector(`.fruit-item[data-fruit-id="${fruitId}"]`);
                            if (fruitItem) {
                                fruitItem.classList.remove('selected');
                                fruitItem.querySelector('.quantity-controls').style.display = 'none';
                            }
                            
                            updateSelectedItemsList();
                        });
                    });
                }
                
                // Update total items count
                totalItemsEl.textContent = selectedItems.length;
            }
            
            // Update item quantity
            function updateItemQuantity(fruitId, quantity) {
                const item = selectedItems.find(item => item.id === fruitId);
                if (item) {
                    item.quantity = quantity;
                    updateSelectedItemsList();
                }
            }
            
            // Form validation
            const checkoutForm = document.getElementById('checkoutForm');
            checkoutForm.addEventListener('submit', function(event) {
                const destinationLocationId = document.getElementById('destinationLocationId').value;
                const deliveryType = document.getElementById('deliveryType').value;
                
                if (!destinationLocationId || !deliveryType) {
                    event.preventDefault();
                    alert('Please select a destination location and delivery type.');
                    return;
                }
                
                if (selectedItems.length === 0) {
                    event.preventDefault();
                    alert('Please select at least one fruit to checkout.');
                    return;
                }
            });
        });
    </script>
</body>
</html>
