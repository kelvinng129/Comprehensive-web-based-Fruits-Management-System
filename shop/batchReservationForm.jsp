<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Batch Reservation - Fruit Management System</title>
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
        .category-card {
            cursor: pointer;
            transition: all 0.3s;
            border-radius: 10px;
        }
        .category-card:hover {
            transform: translateY(-3px);
            box-shadow: 0px 6px 12px rgba(0, 0, 0, 0.1);
        }
        .category-card.selected {
            border: 2px solid #198754;
            background-color: #e7f5ef;
        }
        .fruit-item {
            padding: 10px;
            margin-bottom: 10px;
            background-color: #f8f9fa;
            border-radius: 10px;
            position: relative;
        }
        .fruit-item:hover {
            background-color: #e9ecef;
        }
        .availability-indicator {
            width: 12px;
            height: 12px;
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
        .quantity-input {
            width: 80px;
        }
        .dates-valid {
            color: #198754;
            font-size: 0.9rem;
        }
        .dates-invalid {
            color: #dc3545;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
   <jsp:include page="../include/pageHeader.jsp" />
    
    <div class="container mt-4 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Batch Reservation</h1>
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
        
        <form action="${pageContext.request.contextPath}/shop/reservation" method="post" id="batchReservationForm">
            <input type="hidden" name="action" value="createBatchReservation">
            
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
                                           value="${today}" required>
                                    <div class="form-text">Today's date when the reservation is made.</div>
                                </div>
                                <div class="col-md-6">
                                    <label for="expectedDeliveryDate" class="form-label">Expected Delivery Date</label>
                                    <input type="date" class="form-control" id="expectedDeliveryDate" name="expectedDeliveryDate" 
                                           required>
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
                                            <div class="card source-card">
                                                <div class="card-body">
                                                    <div class="form-check">
                                                        <input class="form-check-input source-radio" type="radio" name="sourceWarehouseId" 
                                                               id="source${source.warehouseId}" value="${source.warehouseId}" required>
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
                                <textarea class="form-control" id="notes" name="notes" rows="3"></textarea>
                                <div class="form-text">Any special handling or delivery instructions.</div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Category Selection -->
                    <div class="card form-card mb-4">
                        <div class="card-header bg-success text-white py-3">
                            <h4 class="mb-0"><i class="fas fa-tags me-2"></i> Fruit Categories</h4>
                        </div>
                        <div class="card-body">
                            <p class="mb-3">Select the fruit categories you want to include in this batch reservation.</p>
                            
                            <div class="row" id="categoriesContainer">
                                <c:forEach var="category" items="${fruitCategories}">
                                    <div class="col-md-4 col-sm-6 mb-3">
                                        <div class="card category-card" data-category="${category}">
                                            <div class="card-body text-center">
                                                <c:choose>
                                                    <c:when test="${category == 'Berry'}">
                                                        <i class="fas fa-apple-alt fa-2x mb-2 text-danger"></i>
                                                    </c:when>
                                                    <c:when test="${category == 'Citrus'}">
                                                        <i class="fas fa-lemon fa-2x mb-2 text-warning"></i>
                                                    </c:when>
                                                    <c:when test="${category == 'Tropical'}">
                                                        <i class="fas fa-seedling fa-2x mb-2 text-success"></i>
                                                    </c:when>
                                                    <c:when test="${category == 'Stone Fruit'}">
                                                        <i class="fas fa-apple-alt fa-2x mb-2 text-danger"></i>
                                                    </c:when>
                                                    <c:when test="${category == 'Melons'}">
                                                        <i class="fas fa-circle fa-2x mb-2 text-success"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-leaf fa-2x mb-2 text-primary"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                                <h5 class="mb-0">${category}</h5>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                            
                            <div class="selected-categories mt-3" id="selectedCategoriesDisplay">
                                <p class="text-muted">No categories selected.</p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Fruits Selection -->
                    <div class="card form-card mb-4">
                        <div class="card-header bg-info text-white py-3">
                            <h4 class="mb-0"><i class="fas fa-shopping-basket me-2"></i> Select Fruits</h4>
                        </div>
                        <div class="card-body">
                            <div id="fruitSelectionMessage" class="alert alert-info">
                                Please select a source warehouse and at least one fruit category to see available fruits.
                            </div>
                            
                            <div id="fruitsContainer" style="display: none;">
                                <!-- Fruits will be loaded here dynamically -->
                            </div>
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-between">
                        <a href="${pageContext.request.contextPath}/shop/reservation" class="btn btn-outline-secondary btn-lg">
                            <i class="fas fa-times me-2"></i> Cancel
                        </a>
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fas fa-save me-2"></i> Submit Batch Reservation
                        </button>
                    </div>
                </div>
                
                <!-- Right Column - Info and Summary -->
                <div class="col-lg-4">
                    <!-- Reservation Summary -->
                    <div class="card form-card mb-4">
                        <div class="card-header bg-primary text-white py-3">
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
                    
                    <!-- Batch Reservation Benefits -->
                    <div class="card form-card mb-4">
                        <div class="card-header bg-success text-white py-3">
                            <h4 class="mb-0"><i class="fas fa-star me-2"></i> Batch Reservation Benefits</h4>
                        </div>
                        <div class="card-body">
                            <div class="info-card mb-3">
                                <h5><i class="fas fa-boxes text-primary me-2"></i> Efficient Ordering</h5>
                                <p>Reserve multiple fruit types in a single transaction, simplifying your ordering process.</p>
                            </div>
                            
                            <div class="info-card mb-3">
                                <h5><i class="fas fa-shipping-fast text-success me-2"></i> Combined Shipping</h5>
                                <p>All fruits are shipped together, reducing logistics complexity and delivery times.</p>
                            </div>
                            
                            <div class="info-card">
                                <h5><i class="fas fa-percentage text-warning me-2"></i> Volume Efficiency</h5>
                                <p>Batch reservations may qualify for priority processing at source warehouses.</p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Information Card -->
                    <div class="card form-card">
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
                </div>
            </div>
        </form>
    </div>
    
    <jsp:include page="../include/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script>
        let selectedCategories = [];
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
            availabilityData = JSON.parse('${availabilityJson}');
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
                checkSelections();
            });
            
            // Category selection
            $(".category-card").click(function() {
                const category = $(this).data('category');
                
                if ($(this).hasClass('selected')) {
                    // Deselect
                    $(this).removeClass('selected');
                    selectedCategories = selectedCategories.filter(c => c !== category);
                } else {
                    // Select
                    $(this).addClass('selected');
                    selectedCategories.push(category);
                }
                
                updateSelectedCategoriesDisplay();
                checkSelections();
            });
            
            // Initial validation and summary update
            validateDates();
            updateSummary();
            
            // Form submission validation
            $("#batchReservationForm").submit(function(e) {
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
        
        function updateSelectedCategoriesDisplay() {
            const display = $("#selectedCategoriesDisplay");
            
            if (selectedCategories.length === 0) {
                display.html('<p class="text-muted">No categories selected.</p>');
            } else {
                let html = '<div class="d-flex flex-wrap gap-2">';
                for (let i = 0; i < selectedCategories.length; i++) {
                    html += '<span class="badge bg-success">' + selectedCategories[i] + '</span>';
                }
                html += '</div>';
                display.html(html);
            }
        }
        
        function checkSelections() {
            const sourceWarehouseId = $('input[name="sourceWarehouseId"]:checked').val();
            
            if (sourceWarehouseId && selectedCategories.length > 0) {
                // Load fruits based on selected warehouse and categories
                loadFruits(sourceWarehouseId, selectedCategories);
            } else {
                $("#fruitSelectionMessage").show();
                $("#fruitsContainer").hide();
            }
        }
        
        function loadFruits(sourceWarehouseId, categories) {
            // Extract fruit data from the server
            var fruitList = [];
            
            <c:forEach var="fruit" items="${fruits}" varStatus="status">
                fruitList.push({
                    id: ${fruit.fruitId},
                    name: "${fruit.name}",
                    category: "${fruit.category}"
                });
            </c:forEach>
            
            const fruitsContainer = $("#fruitsContainer");
            fruitsContainer.empty();
            
            // Filter and display fruits
            let fruitsFound = false;
            
            for (let i = 0; i < fruitList.length; i++) {
                const fruit = fruitList[i];
                if (selectedCategories.includes(fruit.category)) {
                    fruitsFound = true;
                    
                    const fruitId = fruit.id;
                    const fruitName = fruit.name;
                    const fruitCategory = fruit.category;
                    const availabilityKey = sourceWarehouseId + "_" + fruitId;
                    let availabilityHTML = '';
                    let availabilityStatus = 'unknown';
                    let availableQuantity = 0;
                    
                    if (availabilityData[availabilityKey]) {
                        availableQuantity = availabilityData[availabilityKey].available || 0;
                        availabilityStatus = getAvailabilityStatus(availableQuantity, 1);
                        
                        if (availabilityStatus === 'high') {
                            availabilityHTML = '<span class="availability-indicator high"></span> High';
                        } else if (availabilityStatus === 'medium') {
                            availabilityHTML = '<span class="availability-indicator medium"></span> Medium';
                        } else {
                            availabilityHTML = '<span class="availability-indicator low"></span> Low';
                        }
                        
                        if (availableQuantity > 0) {
                            availabilityHTML += ' (' + availableQuantity + ' units)';
                        }
                    } else {
                        availabilityHTML = '<span class="text-muted">Unknown</span>';
                    }
                    
                    let fruitItemHtml = 
                        '<div class="fruit-item">' +
                        '    <div class="row align-items-center">' +
                        '        <div class="col-md-5">' +
                        '            <div class="form-check">' +
                        '                <input class="form-check-input fruit-checkbox" type="checkbox"' +
                        '                       id="fruit-' + fruitId + '" name="selectedFruits" value="' + fruitId + '"' +
                        '                       onchange="updateItemQuantity(' + fruitId + ', \'' + fruitName + '\')">' +
                        '                <label class="form-check-label" for="fruit-' + fruitId + '">' +
                        '                    <span class="fw-bold">' + fruitName + '</span>' +
                        '                    <div class="small text-muted">' + fruitCategory + '</div>' +
                        '                </label>' +
                        '            </div>' +
                        '        </div>' +
                        '        <div class="col-md-3">' +
                        '            <div>Availability: ' + availabilityHTML + '</div>' +
                        '        </div>' +
                        '        <div class="col-md-4">' +
                        '            <div class="input-group">' +
                        '                <span class="input-group-text">Qty</span>' +
                        '                <input type="number" class="form-control quantity-input" id="quantity-' + fruitId + '"' +
                        '                       name="quantity-' + fruitId + '" value="1" min="1" max="' + (availableQuantity || 100) + '"' +
                        (availabilityStatus === 'low' ? ' disabled' : '') +
                        '                       onchange="updateSummary()">' +
                        '            </div>' +
                        '        </div>' +
                        '    </div>' +
                        '</div>';
                    
                    fruitsContainer.append(fruitItemHtml);
                }
            }
            
            if (fruitsFound) {
                $("#fruitSelectionMessage").hide();
                fruitsContainer.show();
            } else {
                $("#fruitSelectionMessage").html('<div class="alert alert-warning">No fruits found in the selected categories at this warehouse.</div>');
                $("#fruitSelectionMessage").show();
                fruitsContainer.hide();
            }
        }
        
        function updateItemQuantity(fruitId, fruitName) {
            const checkbox = $("#fruit-" + fruitId);
            const quantityInput = $("#quantity-" + fruitId);
            
            if (checkbox.is(':checked')) {
                quantityInput.prop('disabled', false);
            } else {
                quantityInput.prop('disabled', true);
            }
            
            updateSummary();
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
                $("#selectedSource").text(sourceData[sourceId].name + ', ' + sourceData[sourceId].country);
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
            
            $('.fruit-checkbox:checked').each(function() {
                const fruitId = $(this).val();
                const fruitName = $(this).closest('.form-check').find('label').text().trim();
                const quantity = parseInt($("#quantity-" + fruitId).val()) || 0;
                
                items.push({ name: fruitName, quantity: quantity });
                totalItems += quantity;
            });
            
            $("#totalItemsCount").text(totalItems);
            
            if (items.length > 0) {
                let itemsHtml = '<ul class="list-group">';
                for (let i = 0; i < items.length; i++) {
                    itemsHtml += '<li class="list-group-item d-flex justify-content-between align-items-center">' +
                        items[i].name +
                        '<span class="badge bg-primary rounded-pill">' + items[i].quantity + '</span>' +
                        '</li>';
                }
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
            
            // Validate fruit categories
            if (selectedCategories.length === 0) {
                alert("Please select at least one fruit category.");
                return false;
            }
            
            // Validate items (at least one selected)
            const selectedFruits = $('.fruit-checkbox:checked').length;
            if (selectedFruits === 0) {
                alert("Please select at least one fruit.");
                return false;
            }
            
            // Add hidden input for categories
            for (let i = 0; i < selectedCategories.length; i++) {
                $('<input>').attr({
                    type: 'hidden',
                    name: 'categories[' + i + ']',
                    value: selectedCategories[i]
                }).appendTo('#batchReservationForm');
            }
            
            return true;
        }
    </script>
</body>
</html>