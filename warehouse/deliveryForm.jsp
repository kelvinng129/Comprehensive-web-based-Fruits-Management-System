<%-- 
    Document   : deliveryForm
    Created on : 2025年4月20日, 上午5:02:06
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
        <title>${isEdit ? 'Edit' : 'New'} Delivery - Warehouse Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
        <style>
            .required-field::after {
                content: "*";
                color: red;
                margin-left: 4px;
            }
            .card-item {
                transition: all 0.2s;
            }
            .card-item:hover {
                background-color: #f8f9fa;
            }
            #itemsContainer {
                max-height: 400px;
                overflow-y: auto;
            }
        </style>
    </head>
    <body>
        <jsp:include page="../include/header.jsp" />

        <div class="container mt-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1>${isEdit ? 'Edit' : 'New'} Delivery</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/warehouse/delivery/list">Deliveries</a></li>
                            <li class="breadcrumb-item active">${isEdit ? 'Edit' : 'New'} Delivery</li>
                        </ol>
                    </nav>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/warehouse/delivery" method="post" id="deliveryForm">
                <input type="hidden" name="action" value="${isEdit ? 'updateDelivery' : 'createDelivery'}">
                <c:if test="${isEdit}">
                    <input type="hidden" name="deliveryId" value="${delivery.deliveryId}">
                </c:if>

                <div class="row">
                    <div class="col-md-8">
                        <!-- Delivery Information -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <h5 class="mb-0">Delivery Information</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="sourceLocationId" class="form-label required-field">Source Location</label>
                                        <select class="form-select" id="sourceLocationId" name="sourceLocationId" required>
                                            <option value="" disabled selected>-- Select Source Location --</option>
                                            <c:forEach var="location" items="${locations}">
                                                <option value="${location.locationId}" 
                                                        ${(isEdit && delivery.sourceLocationId == location.locationId) || 
                                                          (!isEdit && currentUserLocationId == location.locationId) ? 'selected' : ''}>
                                                            ${location.locationName}
                                                        </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="destinationLocationId" class="form-label required-field">Destination Location</label>
                                            <select class="form-select" id="destinationLocationId" name="destinationLocationId" required>
                                                <option value="" disabled selected>-- Select Destination Location --</option>
                                                <c:forEach var="location" items="${locations}">
                                                    <option value="${location.locationId}" 
                                                            ${isEdit && delivery.destinationLocationId == location.locationId ? 'selected' : ''}>
                                                        ${location.locationName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="deliveryType" class="form-label required-field">Delivery Type</label>
                                            <select class="form-select" id="deliveryType" name="deliveryType" required>
                                                <option value="" disabled selected>-- Select Delivery Type --</option>
                                                <option value="SOURCE_TO_CENTRAL" ${isEdit && delivery.deliveryType == 'SOURCE_TO_CENTRAL' ? 'selected' : ''}>
                                                    Source to Central Warehouse
                                                </option>
                                                <option value="CENTRAL_TO_SHOP" ${isEdit && delivery.deliveryType == 'CENTRAL_TO_SHOP' ? 'selected' : ''}>
                                                    Central Warehouse to Shop
                                                </option>
                                                <option value="SHOP_TO_SHOP" ${isEdit && delivery.deliveryType == 'SHOP_TO_SHOP' ? 'selected' : ''}>
                                                    Shop to Shop
                                                </option>
                                            </select>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="estimatedDeliveryDate" class="form-label">Estimated Delivery Date</label>
                                            <input type="date" class="form-control" id="estimatedDeliveryDate" name="estimatedDeliveryDate" 
                                                   value="${isEdit && not empty delivery.estimatedDeliveryDate ? delivery.estimatedDeliveryDate : ''}">
                                        </div>

                                        <c:if test="${not empty requestId}">
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Request ID</label>
                                                <input type="text" class="form-control" value="${requestId}" readonly>
                                                <input type="hidden" name="requestId" value="${requestId}">
                                            </div>
                                        </c:if>

                                        <div class="col-12 mb-3">
                                            <label for="notes" class="form-label">Notes</label>
                                            <textarea class="form-control" id="notes" name="notes" rows="3">${isEdit ? delivery.notes : ''}</textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Delivery Items -->
                            <div class="card mb-4">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">Delivery Items</h5>
                                    <button type="button" class="btn btn-sm btn-primary" id="addItemBtn">
                                        <i class="fas fa-plus-circle me-1"></i> Add Item
                                    </button>
                                </div>
                                <div class="card-body">
                                    <div id="itemsContainer">
                                        <c:choose>
                                            <c:when test="${isEdit && not empty items}">
                                                <c:forEach var="item" items="${items}" varStatus="status">
                                                    <div class="card card-item mb-3">
                                                        <div class="card-body">
                                                            <div class="row">
                                                                <div class="col-md-6 mb-3">
                                                                    <label class="form-label required-field">Fruit</label>
                                                                    <select class="form-select" name="fruitId" required>
                                                                        <c:forEach var="fruit" items="${fruits}">
                                                                            <option value="${fruit.fruitId}" 
                                                                                    ${item.fruitId == fruit.fruitId ? 'selected' : ''}>
                                                                                ${fruit.fruitName}
                                                                            </option>
                                                                        </c:forEach>
                                                                    </select>
                                                                    <input type="hidden" name="itemId" value="${item.itemId}">
                                                                </div>
                                                                <div class="col-md-6 mb-3">
                                                                    <label class="form-label required-field">Quantity</label>
                                                                    <input type="number" class="form-control" name="quantity" 
                                                                           min="1" value="${item.quantity}" required>
                                                                </div>
                                                                <div class="col-md-6 mb-3">
                                                                    <label class="form-label">Unit Price</label>
                                                                    <input type="number" class="form-control" name="unitPrice" 
                                                                           step="0.01" min="0" value="${item.unitPrice}">
                                                                </div>
                                                                <div class="col-md-6 mb-3">
                                                                    <label class="form-label">Notes</label>
                                                                    <input type="text" class="form-control" name="itemNotes" 
                                                                           value="${item.notes}">
                                                                </div>
                                                            </div>
                                                            <div class="text-end">
                                                                <button type="button" class="btn btn-sm btn-outline-danger remove-item-btn">
                                                                    <i class="fas fa-trash-alt me-1"></i> Remove
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="text-center py-4" id="noItemsMessage">
                                                    <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                                                    <h5>No Items Added</h5>
                                                    <p class="text-muted">Click "Add Item" to start adding fruits to this delivery.</p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Item Template (hidden) -->
                                    <template id="itemTemplate">
                                        <div class="card card-item mb-3">
                                            <div class="card-body">
                                                <div class="row">
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label required-field">Fruit</label>
                                                        <select class="form-select" name="newFruitId" required>
                                                            <option value="" disabled selected>-- Select Fruit --</option>
                                                            <c:forEach var="fruit" items="${fruits}">
                                                                <option value="${fruit.fruitId}">${fruit.fruitName}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label required-field">Quantity</label>
                                                        <input type="number" class="form-control" name="newQuantity" 
                                                               min="1" value="1" required>
                                                    </div>
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Unit Price</label>
                                                        <input type="number" class="form-control" name="newUnitPrice" 
                                                               step="0.01" min="0">
                                                    </div>
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Notes</label>
                                                        <input type="text" class="form-control" name="newItemNotes">
                                                    </div>
                                                </div>
                                                <div class="text-end">
                                                    <button type="button" class="btn btn-sm btn-outline-danger remove-item-btn">
                                                        <i class="fas fa-trash-alt me-1"></i> Remove
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </template>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <!-- Action Panel -->
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h5 class="mb-0">Actions</h5>
                                </div>
                                <div class="card-body">
                                    <p class="text-muted">
                                        ${isEdit ? 'Edit your delivery details and click Save to update the delivery.' : 
                                          'Fill in the delivery details and add items before creating the delivery.'}
                                    </p>

                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-${isEdit ? 'save' : 'plus-circle'} me-1"></i> 
                                            ${isEdit ? 'Save Changes' : 'Create Delivery'}
                                        </button>
                                        <a href="${pageContext.request.contextPath}/warehouse/delivery/list" class="btn btn-outline-secondary">
                                            <i class="fas fa-times-circle me-1"></i> Cancel
                                        </a>
                                    </div>

                                    <c:if test="${isEdit}">
                                        <hr>
                                        <div class="d-grid">
                                            <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteDeliveryModal">
                                                <i class="fas fa-trash-alt me-1"></i> Delete Delivery
                                            </button>
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <!-- Validation Messages -->
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">Validation</h5>
                                </div>
                                <div class="card-body">
                                    <div class="alert alert-info">
                                        <i class="fas fa-info-circle me-2"></i>
                                        Fields marked with <span class="text-danger">*</span> are required.
                                    </div>
                                    <div id="validationMessages"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Delete Delivery Modal -->
            <c:if test="${isEdit}">
                <div class="modal fade" id="deleteDeliveryModal" tabindex="-1" aria-labelledby="deleteDeliveryModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <form action="${pageContext.request.contextPath}/warehouse/delivery" method="post">
                                <input type="hidden" name="action" value="deleteDelivery">
                                <input type="hidden" name="deliveryId" value="${delivery.deliveryId}">

                                <div class="modal-header">
                                    <h5 class="modal-title" id="deleteDeliveryModalLabel">Delete Delivery</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="alert alert-danger">
                                        <i class="fas fa-exclamation-triangle me-2"></i>
                                        Are you sure you want to delete this delivery? This action cannot be undone.
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                                    <button type="submit" class="btn btn-danger">
                                        <i class="fas fa-trash-alt me-1"></i> Delete Delivery
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </c:if>

            <jsp:include page="../include/footer.jsp" />
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const itemsContainer = document.getElementById('itemsContainer');
                    const itemTemplate = document.getElementById('itemTemplate');
                    const addItemBtn = document.getElementById('addItemBtn');
                    const noItemsMessage = document.getElementById('noItemsMessage');

                    // Add item button click handler
                    addItemBtn.addEventListener('click', function () {
                        // Clone template and add to container
                        const newItem = document.importNode(itemTemplate.content, true);
                        itemsContainer.appendChild(newItem);

                        // Hide "no items" message if it exists
                        if (noItemsMessage) {
                            noItemsMessage.style.display = 'none';
                        }

                        // Add event listener to remove button
                        const removeBtn = itemsContainer.lastElementChild.querySelector('.remove-item-btn');
                        removeBtn.addEventListener('click', removeItem);
                    });

                    // Add event listeners to existing remove buttons
                    document.querySelectorAll('.remove-item-btn').forEach(btn => {
                        btn.addEventListener('click', removeItem);
                    });

                    // Remove item function
                    function removeItem() {
                        this.closest('.card-item').remove();

                        // Show "no items" message if no items left
                        if (itemsContainer.querySelectorAll('.card-item').length === 0 && noItemsMessage) {
                            noItemsMessage.style.display = 'block';
                        }
                    }

                    // Form validation
                    const deliveryForm = document.getElementById('deliveryForm');
                    deliveryForm.addEventListener('submit', function (event) {
                        // Check if at least one item exists
                        if (itemsContainer.querySelectorAll('.card-item').length === 0) {
                            event.preventDefault();
                            const validationMessages = document.getElementById('validationMessages');
                            validationMessages.innerHTML = '<div class="alert alert-danger"><i class="fas fa-exclamation-circle me-2"></i>Please add at least one item to the delivery.</div>';
                            validationMessages.scrollIntoView({behavior: 'smooth'});
                        }
                    });

                    // Prevent selecting same location for source and destination
                    const sourceLocation = document.getElementById('sourceLocationId');
                    const destinationLocation = document.getElementById('destinationLocationId');

                    sourceLocation.addEventListener('change', checkLocations);
                    destinationLocation.addEventListener('change', checkLocations);

                    function checkLocations() {
                        const sourceValue = sourceLocation.value;
                        const destValue = destinationLocation.value;

                        if (sourceValue && destValue && sourceValue === destValue) {
                            alert('Source and destination locations cannot be the same.');
                            destinationLocation.value = '';
                        }
                    }
                });
            </script>
        </body>
    </html>