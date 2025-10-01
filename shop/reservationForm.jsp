<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${reservation != null ? 'Edit' : 'Create'} Reservation - Fruit Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <style>
        .form-card {
            box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.1);
            border-radius: 15px;
            border: none;
        }
        .form-card .card-header {
            border-radius: 15px 15px 0 0;
        }
        .info-card {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
        }
        .source-card {
            cursor: pointer;
            transition: all 0.3s;
            border-radius: 10px;
        }
        .source-card:hover {
            transform: translateY(-5px);
            box-shadow: 0px 6px 12px rgba(0, 0, 0, 0.1);
        }
        .source-card.selected {
            border: 2px solid #0d6efd;
            background-color: #e7f1ff;
        }
        .item-card {
            border-radius: 10px;
            margin-bottom: 10px;
            background-color: #f8f9fa;
            position: relative;
        }
        .remove-item {
            position: absolute;
            top: 10px;
            right: 10px;
            cursor: pointer;
            color: #dc3545;
        }
        .item-card:hover {
            background-color: #e9ecef;
        }
        #sourcesContainer {
            max-height: 400px;
            overflow-y: auto;
        }
        .dates-valid {
            color: #198754;
            font-size: 0.9rem;
        }
        .dates-invalid {
            color: #dc3545;
            font-size: 0.9rem;
        }
        .availability-indicator {
            width: 15px;
            height: 15px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 5px;
        }
        .high {
            background-color: #198754;
        }
        .medium {
            background-color: #ffc107;
        }
        .low {
            background-color: #dc3545;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/shopHeader.jsp" />
    
    <div class="container mt-4 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>${reservation != null ? 'Edit' : 'Create'} Reservation</h1>
            <div>
                <a href="${pageContext.request.contextPath}/shop/reservation" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-2"></i> Back to Dashboard
                </a>
            </div>
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
        
        <form action="${pageContext.request.contextPath}/shop/reservation" method="post" id="reservationForm">
            <input type="hidden" name="action" value="${reservation != null ? 'updateReservation' : 'createReservation'}">
            <c:if test="${reservation != null}">
                <input type="hidden" name="reservationId" value="${reservation.reservationId}">
            </c:if>
            
            <div class="row">
                <!-- Left Column - Form Fields -->
                <div class="col-lg-8">
                    <div class="card form-card mb-4">
                        <div class="card-header bg-primary text-white py-3">
                            <h4 class="mb-0"><i class="fas fa-calendar-alt me-2"></i> Reservation Details</h4>
                        </div>
                        <div class="card-body">
                            <!-- Date Selection -->
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <label for="reservationDate" class="form-label">Reservation Date</label>
                                    <input type="date" class="form-control" id="reservationDate" name="reservationDate" 
                                           value="${reservation != null ? reservation.reservationDate : today}" required>
                                    <div class="form-text">Today's date when the reservation is made.</div>
                                </div>
                                <div class="col-md-6">
                                    <label for="expectedDeliveryDate" class="form-label">Expected Delivery Date</label>
                                    <input type="date" class="form-control" id="expectedDeliveryDate" name="expectedDeliveryDate" 
                                           value="${reservation != null ? reservation.expectedDeliveryDate : ''}" required>
                                    <div class="form-text">When you expect to receive the fruits (within next 14 days).</div>
                                    <div id="dateValidationMessage"></div>
                                </div>
                            </div>
                            
                            <!-- Source Selection -->
                            <div class="mb-4">
                                <label class="form-label">Select Source Warehouse</label>
                                <div class="row" id="sourcesContainer">
                                    <c:forEach var="source" items="${sourceWarehouses}">
                                        <div class="col-md-6 mb-3">
                                            <div class="card source-card ${reservation != null && reservation.sourceWarehouseId == source.warehouseId ? 'selected' : ''}">
                                                <div class="card-body">
                                                    <div class="form-check">
                                                        <input class="form-check-input source-radio" type="radio" name="sourceWarehouseId" 
                                                               id="source${source.warehouseId}" value="${source.warehouseId}"
                                                               ${reservation != null && reservation.sourceWarehouseId == source.warehouseId ? 'checked' : ''} required>
                                                        <label class="form-check-label w-100" for="source${source.warehouseId}">
                                                            <h5 class="mb-1">${source.name}</h5>
                                                            <p class="mb-1"><i class="fas fa-map-marker-alt me-1"></i> ${source.city}, ${source.country}</p>
                                                            <p class="mb-0 small text-muted">${source.description}</p>
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                                <div class="form-text">Select the warehouse from which you want to reserve fruits.</div>
                            </div>
                            
                            <!-- Special Instructions -->
                            <div class="mb-4">
                                <label for="notes" class="form-label">Special Instructions (Optional)</label>
                                <textarea class="form-control" id="notes" name="notes" rows="3">${reservation != null ? reservation.notes : ''}</textarea>
                                <div class="form-text">Any special handling or delivery instructions.</div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Items Section -->
                    <div class="card form-card mb-4">
                        <div class="card-header bg-success text-white py-3">
                            <h4 class="mb-0"><i class="fas fa-shopping-basket me-2"></i> Reservation Items</h4>
                        </div>
                        <div class="card-body">
                            <div id="itemsContainer">
                                <c:choose>
                                    <c:when test="${reservation != null && not empty reservationItems}">
                                        <c:forEach var="item" items="${reservationItems}" varStatus="status">
                                            <div class="item-card p-3" id="item-${status.index}">
                                                <span class="remove-item" onclick="removeItem(${status.index})"><i class="fas fa-times-circle"></i></span>
                                                <div class="row">
                                                    <div class="col-md-5 mb-3">
                                                        <label class="form-label">Fruit</label>
                                                        <select class="form-select item-fruit" name="items[${status.index}].fruitId" required>
                                                            <option value="">Select a fruit</option>
                                                            <c:forEach var="fruit" items="${fruits}">
                                                                <option value="${fruit.fruitId}" ${item.fruitId == fruit.fruitId ? 'selected' : ''}>
                                                                    ${fruit.name}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                    <div class="col-md-3 mb-3">
                                                        <label class="form-label">Quantity</label>
                                                        <input type="number" class="form-control item-quantity" name="items[${status.index}].quantity" 
                                                               value="${item.quantity}" min="1" required>
                                                    </div>
                                                    <div class="col-md-4 mb-3">
                                                        <label class="form-label">Availability</label>
                                                        <div class="form-control bg-light availability-display">
                                                            <c:choose>
                                                                <c:when test="${item.availabilityStatus == 'high'}">
                                                                    <span class="availability-indicator high"></span> High
                                                                </c:when>
                                                                <c:when test="${item.availabilityStatus == 'medium'}">
                                                                    <span class="availability-indicator medium"></span> Medium
                                                                </c:when>
                                                                <c:when test="${item.availabilityStatus == 'low'}">
                                                                    <span class="availability-indicator low"></span> Low
                                                                </c:when>
                                                                <c:otherwise>
                                                                    Unknown
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-12">
                                                        <label class="form-label">Notes (Optional)</label>
                                                        <input type="text" class="form-control" name="items[${status.index}].notes" 
                                                               value="${item.notes}" placeholder="Any specific requirements">
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="item-card p-3" id="item-0">
                                            <span class="remove-item" onclick="removeItem(0)"><i class="fas fa-times-circle"></i></span>
                                            <div class="row">
                                                <div class="col-md-5 mb-3">
                                                    <label class="form-label">Fruit</label>
                                                    <select class="form-select item-fruit" name="items[0].fruitId" required>
                                                        <option value="">Select a fruit</option>
                                                        <c:forEach var="fruit" items="${fruits}">
                                                            <option value="${fruit.fruitId}">${fruit.name}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="col-md-3 mb-3">
                                                    <label class="form-label">Quantity</label>
                                                    <input type="number" class="form-control item-quantity" name="items[0].quantity" 
                                                           value="1" min="1" required>
                                                </div>
                                                <div class="col-md-4 mb-3">
                                                    <label class="form-label">Availability</label>
                                                    <div class="form-control bg-light availability-display">
                                                        Please select a fruit
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-12">
                                                    <label class="form-label">Notes (Optional)</label>
                                                    <input type="text" class="form-control" name="items[0].notes" 
                                                           placeholder="Any specific requirements">
                                                </div>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <div class="d-grid gap-2 mt-3">
                                <button type="button" class="btn btn-outline-primary" id="addItemBtn">
                                    <i class="fas fa-plus-circle me-2"></i> Add Another Item
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-between">
                        <a href="${pageContext.request.contextPath}/shop/reservation" class="btn btn-outline-secondary btn-lg">
                            <i class="fas fa-times me-2"></i> Cancel
                        </a>
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fas fa-save me-2"></i> ${reservation != null ? 'Update' : 'Submit'} Reservation
                        </button>
                    </div>
                </div>
                
                <!-- Right Column - Info and Summary -->
                <div class="col-lg-4">
                    <!-- Reservation Summary -->
                    <div class="card form-card mb-4">
                        <div class="card-header bg-info text-white py-3">
                            <h4 class="mb-0"><i class="fas fa-clipboard-list me-2"></i> Reservation Summary</h4>
                        </div>
                        <div class="card-body">
                            <div id="summaryContainer">
                                <div class="d-flex justify-content-between mb-3">
                                    <span class="fw-bold">Total Items:</span>
                                    <span id="totalItemsCount">0</span>
                                </div>
                                <div class="d-flex justify-content-between mb-3">
                                    <span class="fw-bold">Source Warehouse:</span>
                                    <span id="selectedSource">Not selected</span>
                                </div>
                                <div class="d-flex justify-content-between mb-3">
                                    <span class="fw-bold">Expected Delivery:</span>
                                    <span id="deliveryDateDisplay">Not set</span>
                                </div>
                                
                                <hr>
                                
                                <div id="itemsSummary">
                                    <div class="text-center text-muted py-3">
                                        Add items to see summary
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Information Card -->
                    <div class="card form-card mb-4">
                        <div class="card-header bg-secondary text-white py-3">
                            <h4 class="mb-0"><i class="fas fa-info-circle me-2"></i> Reservation Information</h4>
                        </div>
                        <div class="card-body">
                            <div class="info-card mb-3">
                                <h5><i class="fas fa-calendar-day text-primary me-2"></i> Delivery Timeline</h5>
                                <p>Reservations can be made for delivery within the next 14 days. The system will collect all reservations and coordinate with warehouses to ensure timely delivery.</p>
                            </div>
                            
                            <div class="info-card mb-3">
                                <h5><i class="fas fa-truck text-success me-2"></i> Delivery Process</h5>
                                <p>After approval, fruits will be shipped from the source warehouse to your country's central warehouse, then to your local shop.</p>
                            </div>
                            
                            <div class="info-card">
                                <h5><i class="fas fa-exclamation-triangle text-warning me-2"></i> Important Notes</h5>
                                <ul class="mb-0">
                                    <li>Reservations are subject to availability</li>
                                    <li>Pending reservations can be modified or canceled</li>
                                    <li>Contact warehouse staff for urgent requests</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Availability Legend -->
                    <div class="card form-card">
                        <div class="card-header bg-light py-3">
                            <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i> Availability Legend</h5>
                        </div>
                        <div class="card-body">
                            <div class="d-flex align-items-center mb-2">
                                <span class="availability-indicator high me-2"></span>
                                <span>High: Sufficient quantities available</span>
                            </div>
                            <div class="d-flex align-items-center mb-2">
                                <span class="availability-indicator medium me-2"></span>
                                <span>Medium: Limited quantities available</span>
                            </div>
                            <div class="d-flex align-items-center">
                                <span class="availability-indicator low me-2"></span>
                                <span>Low: Very limited or unavailable</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script>
        let itemIndex = ${reservation != null && not empty reservationItems ? reservationItems.size() : 1};
        const sourceData = {};
        let availabilityData = {};
        
        <c:forEach var="source" items="${sourceWarehouses}">
            sourceData[${source.warehouseId}] = {
                name: "${source.name}",
                city: "${source.city}",
                country: "${source.country}"
            };
        </c:forEach>
        
        <c:if test="${not empty availabilityJson}">
            availabilityData = ${availabilityJson};
        </c:if>
        
        $(document).ready(function() {
            // Initialize date pickers
            const today = new Date();
            const maxDate = new Date();
            maxDate.setDate(today.getDate() + 14);
            
            $("#expectedDeliveryDate").flatpickr({
                minDate: "today",
                maxDate: maxDate,
                onChange: validateDates
            });
            
            // Source warehouse selection
            $(".source-card").click(function() {
                $(this).find('input[type="radio"]').prop('checked', true);
                $(".source-card").removeClass("selected");
                $(this).addClass("selected");
                updateSummary();
            });
            
            // Add item button
            $("#addItemBtn").click(function() {
                addNewItem();
            });
            
            // Initial validation and summary update
            validateDates();
            updateSummary();
            
            // Setup change listeners on existing items
            setupItemChangeListeners();
            
            // Form submission validation
            $("#reservationForm").submit(function(e) {
                if (!validateForm()) {
                    e.preventDefault();
                }
            });
        });
        
        function validateDates() {
            const reservationDate = new Date($("#reservationDate").val());
            const deliveryDate = new Date($("#expectedDeliveryDate").val());
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            
            const maxDate = new Date();
            maxDate.setDate(today.getDate() + 14);
            
            const messageElement = $("#dateValidationMessage");
            
            if (deliveryDate < today) {
                messageElement.html('<div class="dates-invalid mt-2"><i class="fas fa-times-circle me-1"></i> Delivery date cannot be in the past</div>');
                return false;
            } else if (deliveryDate > maxDate) {
                messageElement.html('<div class="dates-invalid mt-2"><i class="fas fa-times-circle me-1"></i> Delivery date cannot be more than 14 days in the future</div>');
                return false;
            } else {
                messageElement.html('<div class="dates-valid mt-2"><i class="fas fa-check-circle me-1"></i> Delivery date is valid</div>');
                updateSummary();
                return true;
            }
        }
        
        function addNewItem() {
            const newItem = `
                <div class="item-card p-3" id="item-${itemIndex}">
                    <span class="remove-item" onclick="removeItem(${itemIndex})"><i class="fas fa-times-circle"></i></span>
                    <div class="row">
                        <div class="col-md-5 mb-3">
                            <label class="form-label">Fruit</label>
                            <select class="form-select item-fruit" name="items[${itemIndex}].fruitId" required>
                                <option value="">Select a fruit</option>
                                <c:forEach var="fruit" items="${fruits}">
                                    <option value="${fruit.fruitId}">${fruit.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3 mb-3">
                            <label class="form-label">Quantity</label>
                            <input type="number" class="form-control item-quantity" name="items[${itemIndex}].quantity" 
                                   value="1" min="1" required>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Availability</label>
                            <div class="form-control bg-light availability-display">
                                Please select a fruit
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <label class="form-label">Notes (Optional)</label>
                            <input type="text" class="form-control" name="items[${itemIndex}].notes" 
                                   placeholder="Any specific requirements">
                        </div>
                    </div>
                </div>
            `;
            
            $("#itemsContainer").append(newItem);
            setupItemChangeListeners(itemIndex);
            itemIndex++;
            updateSummary();
        }
        
        function removeItem(index) {
            if ($("#itemsContainer .item-card").length > 1) {
                $(`#item-${index}`).remove();
                updateSummary();
            } else {
                alert("At least one item is required for a reservation.");
            }
        }
        
        function setupItemChangeListeners(specificIndex = null) {
            const selector = specificIndex !== null ? 
                `#item-${specificIndex} .item-fruit, #item-${specificIndex} .item-quantity` : 
                ".item-fruit, .item-quantity";
                
            $(selector).change(function() {
                updateItemAvailability($(this).closest('.item-card'));
                updateSummary();
            });
            
            if (specificIndex === null) {
                // Initial update for all items
                $(".item-card").each(function() {
                    updateItemAvailability($(this));
                });
            } else {
                // For a newly added item
                updateItemAvailability($(`#item-${specificIndex}`));
            }
        }
        
        function updateItemAvailability(itemCard) {
            const fruitSelect = itemCard.find('.item-fruit');
            const quantityInput = itemCard.find('.item-quantity');
            const availabilityDisplay = itemCard.find('.availability-display');
            
            const fruitId = fruitSelect.val();
            const quantity = parseInt(quantityInput.val()) || 0;
            const sourceId = $('input[name="sourceWarehouseId"]:checked').val();
            
            if (!fruitId || !sourceId) {
                availabilityDisplay.html('Please select a fruit and source');
                return;
            }
            
            // Check availability from our data
            const key = `${sourceId}_${fruitId}`;
            if (availabilityData[key]) {
                const available = availabilityData[key].available || 0;
                const status = getAvailabilityStatus(available, quantity);
                
                let html = '';
                if (status === 'high') {
                    html = '<span class="availability-indicator high"></span> High';
                } else if (status === 'medium') {
                    html = '<span class="availability-indicator medium"></span> Medium';
                } else {
                    html = '<span class="availability-indicator low"></span> Low';
                }
                
                if (available > 0) {
                    html += ` (${available} available)`;
                }
                
                availabilityDisplay.html(html);
            } else {
                availabilityDisplay.html('<span class="availability-indicator low"></span> Unknown availability');
            }
        }
        
        function getAvailabilityStatus(available, requested) {
            if (available <= 0) return 'low';
            if (available >= requested * 2) return 'high';
            if (available >= requested) return 'medium';
            return 'low';
        }
        
        function updateSummary() {
            // Update source information
            const sourceId = $('input[name="sourceWarehouseId"]:checked').val();
            if (sourceId && sourceData[sourceId]) {
                $("#selectedSource").text(`${sourceData[sourceId].name}, ${sourceData[sourceId].country}`);
            } else {
                $("#selectedSource").text("Not selected");
            }
            
            // Update delivery date
            const deliveryDate = $("#expectedDeliveryDate").val();
            if (deliveryDate) {
                const formattedDate = new Date(deliveryDate).toLocaleDateString('en-US', {
                    year: 'numeric',
                    month: 'short',
                    day: 'numeric'
                });
                $("#deliveryDateDisplay").text(formattedDate);
            } else {
                $("#deliveryDateDisplay").text("Not set");
            }
            
            // Update items summary
            const items = [];
            let totalItems = 0;
            
            $(".item-card").each(function() {
                const fruitSelect = $(this).find('.item-fruit');
                const quantity = parseInt($(this).find('.item-quantity').val()) || 0;
                
                if (fruitSelect.val()) {
                    const fruitName = fruitSelect.find('option:selected').text();
                    items.push({ name: fruitName, quantity: quantity });
                    totalItems += quantity;
                }
            });
            
            $("#totalItemsCount").text(totalItems);
            
            if (items.length > 0) {
                let itemsHtml = '<ul class="list-group">';
                items.forEach(item => {
                    itemsHtml += `<li class="list-group-item d-flex justify-content-between align-items-center">
                        ${item.name}
                        <span class="badge bg-primary rounded-pill">${item.quantity}</span>
                    </li>`;
                });
                itemsHtml += '</ul>';
                $("#itemsSummary").html(itemsHtml);
            } else {
                $("#itemsSummary").html('<div class="text-center text-muted py-3">Add items to see summary</div>');
            }
        }
        
        function validateForm() {
            // Validate dates
            if (!validateDates()) {
                alert("Please select a valid delivery date.");
                return false;
            }
            
            // Validate source warehouse
            const sourceId = $('input[name="sourceWarehouseId"]:checked').val();
            if (!sourceId) {
                alert("Please select a source warehouse.");
                return false;
            }
            
            // Validate items (at least one with fruit and quantity)
            let hasValidItems = false;
            $(".item-card").each(function() {
                const fruitId = $(this).find('.item-fruit').val();
                const quantity = parseInt($(this).find('.item-quantity').val()) || 0;
                
                if (fruitId && quantity > 0) {
                    hasValidItems = true;
                }
            });
            
            if (!hasValidItems) {
                alert("Please add at least one item with a valid fruit and quantity.");
                return false;
            }
            
            return true;
        }
    </script>
</body>
</html>