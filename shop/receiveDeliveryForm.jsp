<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Receive Delivery - Fruit Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .form-card {
            box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.1);
            border-radius: 15px;
            border: none;
        }
        .form-card .card-header {
            border-radius: 15px 15px 0 0;
        }
        .detail-section {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .detail-label {
            font-weight: 600;
            color: #6c757d;
        }
        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 50rem;
            font-weight: bold;
        }
        .item-card {
            border-radius: 10px;
            margin-bottom: 15px;
            background-color: #f8f9fa;
            transition: all 0.3s;
        }
        .item-card:hover {
            background-color: #e9ecef;
        }
        .received-count {
            width: 80px;
        }
        .validation-message {
            display: none;
            font-size: 0.9rem;
        }
        .quality-star {
            cursor: pointer;
            font-size: 1.5rem;
            color: #dee2e6;
        }
        .quality-star.active {
            color: #ffc107;
        }
        .quality-options {
            display: flex;
            justify-content: space-between;
        }
        .quality-option {
            text-align: center;
        }
    </style>
</head>
<body>
    <jsp:include page="../include/shopHeader.jsp" />
    
    <div class="container mt-4 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Receive Delivery</h1>
            <div>
                <a href="${pageContext.request.contextPath}/shop/reservation?action=viewReservation&id=${reservation.reservationId}" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-2"></i> Back to Reservation
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
        
        <form action="${pageContext.request.contextPath}/shop/inventory" method="post" id="receiveForm">
            <input type="hidden" name="action" value="processDeliveryReceipt">
            <input type="hidden" name="reservationId" value="${reservation.reservationId}">
            
            <div class="row">
                <!-- Left Column - Form Fields -->
                <div class="col-lg-8">
                    <div class="card form-card mb-4">
                        <div class="card-header bg-primary text-white py-3">
                            <h4 class="mb-0"><i class="fas fa-truck-loading me-2"></i> Delivery Information</h4>
                        </div>
                        <div class="card-body">
                            <div class="detail-section">
                                <div class="row mb-4">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <div class="detail-label">Reservation ID</div>
                                            <div>#${reservation.reservationId}</div>
                                        </div>
                                        <div class="mb-3">
                                            <div class="detail-label">Reservation Date</div>
                                            <div><fmt:formatDate value="${reservation.reservationDate}" pattern="yyyy-MM-dd" /></div>
                                        </div>
                                        <div class="mb-3">
                                            <div class="detail-label">Source Warehouse</div>
                                            <div>${reservation.sourceWarehouseName} (${reservation.sourceWarehouseCity}, ${reservation.sourceWarehouseCountry})</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <div class="detail-label">Status</div>
                                            <div>
                                                <span class="status-badge bg-${reservation.statusColor}">
                                                    ${reservation.formattedStatus}
                                                </span>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <div class="detail-label">Tracking Number</div>
                                            <div>
                                                <c:choose>
                                                    <c:when test="${not empty reservation.trackingNumber}">
                                                        ${reservation.trackingNumber}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Not available</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <div class="detail-label">Expected Delivery Date</div>
                                            <div>
                                                <c:choose>
                                                    <c:when test="${not empty reservation.expectedDeliveryDate}">
                                                        <fmt:formatDate value="${reservation.expectedDeliveryDate}" pattern="yyyy-MM-dd" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Not specified</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Receipt Info -->
                            <h5 class="mb-3">Receipt Information</h5>
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="receiveDate" class="form-label">Receipt Date</label>
                                        <input type="date" class="form-control" id="receiveDate" name="receiveDate" 
                                               value="${today}" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="receivedBy" class="form-label">Received By</label>
                                        <input type="text" class="form-control" id="receivedBy" name="receivedBy" 
                                               value="${user.firstName} ${user.lastName}" required readonly>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row mb-4">
                                <div class="col-md-12">
                                    <div class="mb-3">
                                        <label for="deliveryCondition" class="form-label">Delivery Condition</label>
                                        <select class="form-select" id="deliveryCondition" name="deliveryCondition" required>
                                            <option value="">Select condition...</option>
                                            <option value="excellent">Excellent - No issues</option>
                                            <option value="good">Good - Minor issues</option>
                                            <option value="fair">Fair - Some issues</option>
                                            <option value="poor">Poor - Significant issues</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row mb-4">
                                <div class="col-md-12">
                                    <label class="form-label mb-3">Overall Quality Assessment</label>
                                    <div class="quality-rating text-center mb-2">
                                        <span class="quality-star" data-rating="1"><i class="fas fa-star"></i></span>
                                        <span class="quality-star" data-rating="2"><i class="fas fa-star"></i></span>
                                        <span class="quality-star" data-rating="3"><i class="fas fa-star"></i></span>
                                        <span class="quality-star" data-rating="4"><i class="fas fa-star"></i></span>
                                        <span class="quality-star" data-rating="5"><i class="fas fa-star"></i></span>
                                        <input type="hidden" id="qualityRating" name="qualityRating" value="0">
                                    </div>
                                    <div class="quality-options small text-muted">
                                        <div class="quality-option">Poor</div>
                                        <div class="quality-option">Fair</div>
                                        <div class="quality-option">Average</div>
                                        <div class="quality-option">Good</div>
                                        <div class="quality-option">Excellent</div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="mb-0">
                                        <label for="notes" class="form-label">Notes</label>
                                        <textarea class="form-control" id="notes" name="notes" rows="3" 
                                                  placeholder="Enter any notes about the delivery..."></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Items Section -->
                    <div class="card form-card mb-4">
                        <div class="card-header bg-success text-white py-3">
                            <h4 class="mb-0"><i class="fas fa-clipboard-check me-2"></i> Receive Items</h4>
                        </div>
                        <div class="card-body">
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle me-2"></i> For each item, enter the quantity actually received. If there are any discrepancies, please note them in the comments.
                            </div>
                            
                            <div id="itemsContainer">
                                <c:forEach var="item" items="${reservationItems}" varStatus="status">
                                    <div class="item-card p-3">
                                        <div class="row mb-2">
                                            <div class="col-md-6">
                                                <div class="detail-label">Fruit</div>
                                                <div class="fs-5">${item.fruitName}</div>
                                                <input type="hidden" name="items[${status.index}].fruitId" value="${item.fruitId}">
                                                <input type="hidden" name="items[${status.index}].fruitName" value="${item.fruitName}">
                                            </div>
                                            <div class="col-md-3">
                                                <div class="detail-label">Expected Quantity</div>
                                                <div>${item.quantity}</div>
                                                <input type="hidden" name="items[${status.index}].expectedQuantity" value="${item.quantity}">
                                            </div>
                                            <div class="col-md-3">
                                                <div class="detail-label">Status</div>
                                                <div>
                                                    <c:choose>
                                                        <c:when test="${item.status == 'fulfilled'}">
                                                            <span class="badge bg-success">Fulfilled</span>
                                                        </c:when>
                                                        <c:when test="${item.status == 'partial'}">
                                                            <span class="badge bg-warning text-dark">Partial</span>
                                                        </c:when>
                                                        <c:when test="${item.status == 'cancelled'}">
                                                            <span class="badge bg-danger">Cancelled</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">Pending</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-md-4">
                                                <label for="receivedQuantity${status.index}" class="form-label">Received Quantity</label>
                                                <div class="input-group">
                                                    <input type="number" class="form-control received-count" 
                                                           id="receivedQuantity${status.index}" 
                                                           name="items[${status.index}].receivedQuantity" 
                                                           value="${item.quantity}" min="0" required
                                                           onchange="validateQuantity(${status.index})">
                                                    <span class="input-group-text">units</span>
                                                    <div class="validation-message text-danger" id="quantityValidation${status.index}">
                                                        <i class="fas fa-exclamation-circle me-1"></i> Quantity does not match expected
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="col-md-4">
                                                <label for="condition${status.index}" class="form-label">Condition</label>
                                                <select class="form-select" id="condition${status.index}" name="items[${status.index}].condition">
                                                    <option value="excellent">Excellent</option>
                                                    <option value="good" selected>Good</option>
                                                    <option value="fair">Fair</option>
                                                    <option value="poor">Poor</option>
                                                </select>
                                            </div>
                                            
                                            <div class="col-md-4">
                                                <label for="expiryDate${status.index}" class="form-label">Expiry Date</label>
                                                <input type="date" class="form-control" id="expiryDate${status.index}" 
                                                       name="items[${status.index}].expiryDate">
                                            </div>
                                        </div>
                                        
                                        <div class="row mt-3">
                                            <div class="col-12">
                                                <label for="itemNotes${status.index}" class="form-label">Item Notes</label>
                                                <input type="text" class="form-control" id="itemNotes${status.index}" 
                                                       name="items[${status.index}].notes" 
                                                       placeholder="Any specific issues or comments about this item...">
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-between">
                        <a href="${pageContext.request.contextPath}/shop/reservation?action=viewReservation&id=${reservation.reservationId}" class="btn btn-outline-secondary btn-lg">
                            <i class="fas fa-times me-2"></i> Cancel
                        </a>
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fas fa-save me-2"></i> Complete Receipt
                        </button>
                    </div>
                </div>
                
                <!-- Right Column - Info and Summary -->
                <div class="col-lg-4">
                    <!-- Receipt Summary -->
                    <div class="card form-card mb-4">
                        <div class="card-header bg-info text-white py-3">
                            <h4 class="mb-0"><i class="fas fa-clipboard-list me-2"></i> Receipt Summary</h4>
                        </div>
                        <div class="card-body">
                            <div id="summaryContainer">
                                <div class="d-flex justify-content-between mb-3">
                                    <span class="fw-bold">Total Items:</span>
                                    <span>${reservationItems.size()}</span>
                                </div>
                                <div class="d-flex justify-content-between mb-3">
                                    <span class="fw-bold">Expected Units:</span>
                                    <span id="totalExpectedCount">
                                        <c:set var="totalExpected" value="0" />
                                        <c:forEach var="item" items="${reservationItems}">
                                            <c:set var="totalExpected" value="${totalExpected + item.quantity}" />
                                        </c:forEach>
                                        ${totalExpected}
                                    </span>
                                </div>
                                <div class="d-flex justify-content-between mb-3">
                                    <span class="fw-bold">Received Units:</span>
                                    <span id="totalReceivedCount">${totalExpected}</span>
                                </div>
                                
                                <hr>
                                
                                <div id="discrepancyAlert" class="alert alert-warning" style="display: none;">
                                    <i class="fas fa-exclamation-triangle me-2"></i> There are discrepancies between expected and received quantities. Please check and add notes if necessary.
                                </div>
                                
                                <div class="mb-3">
                                    <span class="fw-bold d-block mb-2">Receipt Status:</span>
                                    <select class="form-select" id="receiptStatus" name="receiptStatus">
                                        <option value="complete">Complete - All items received</option>
                                        <option value="partial">Partial - Some items missing</option>
                                        <option value="issues">Received with issues</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Information Card -->
                    <div class="card form-card mb-4">
                        <div class="card-header bg-secondary text-white py-3">
                            <h4 class="mb-0"><i class="fas fa-info-circle me-2"></i> Receipt Information</h4>
                        </div>
                        <div class="card-body">
                            <div class="detail-section">
                                <h5><i class="fas fa-truck text-primary me-2"></i> Delivery Process</h5>
                                <p>Once you receive the shipment, verify the contents and update the inventory accordingly. Any discrepancies should be noted for future reference.</p>
                            </div>
                            
                            <div class="detail-section">
                                <h5><i class="fas fa-clipboard-check text-success me-2"></i> Receipt Process</h5>
                                <ul class="mb-0">
                                    <li>Count all items and compare to the expected quantities</li>
                                    <li>Check the condition of all received items</li>
                                    <li>Document any damages or discrepancies</li>
                                    <li>Verify expiry dates and enter them in the system</li>
                                    <li>Complete the receipt to update inventory</li>
                                </ul>
                            </div>
                            
                            <div class="detail-section mb-0">
                                <h5><i class="fas fa-exclamation-triangle text-warning me-2"></i> Important Notes</h5>
                                <p class="mb-0">If any items are damaged or missing, select the appropriate receipt status and provide detailed notes to help with follow-up actions.</p>
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
    <script>
        $(document).ready(function() {
            // Auto-dismiss alerts after 5 seconds
            setTimeout(function() {
                $('.alert-dismissible').alert('close');
            }, 5000);
            
            // Initialize quality rating
            $('.quality-star').click(function() {
                const rating = $(this).data('rating');
                $('#qualityRating').val(rating);
                $('.quality-star').removeClass('active');
                $('.quality-star').each(function() {
                    if ($(this).data('rating') <= rating) {
                        $(this).addClass('active');
                    }
                });
            });
            
            // Setup change listeners for received quantities
            $('.received-count').change(function() {
                updateTotalCounts();
            });
            
            // Form submission validation
            $('#receiveForm').submit(function(e) {
                if (!validateForm()) {
                    e.preventDefault();
                }
            });
        });
        
        function validateQuantity(index) {
            const expectedQuantity = parseInt($(`input[name="items[${index}].expectedQuantity"]`).val());
            const receivedQuantity = parseInt($(`#receivedQuantity${index}`).val());
            
            if (receivedQuantity !== expectedQuantity) {
                $(`#quantityValidation${index}`).css('display', 'block');
                // Automatically update receipt status if there's a discrepancy
                if (receivedQuantity < expectedQuantity) {
                    $('#receiptStatus').val('partial');
                } else {
                    $('#receiptStatus').val('issues');
                }
                $('#discrepancyAlert').show();
            } else {
                $(`#quantityValidation${index}`).css('display', 'none');
                // Check if there are any other discrepancies
                checkAllDiscrepancies();
            }
        }
        
        function checkAllDiscrepancies() {
            let hasDiscrepancies = false;
            const itemCount = ${reservationItems.size()};
            
            for (let i = 0; i < itemCount; i++) {
                const expectedQuantity = parseInt($(`input[name="items[${i}].expectedQuantity"]`).val());
                const receivedQuantity = parseInt($(`#receivedQuantity${i}`).val());
                
                if (receivedQuantity !== expectedQuantity) {
                    hasDiscrepancies = true;
                    break;
                }
            }
            
            if (hasDiscrepancies) {
                $('#discrepancyAlert').show();
            } else {
                $('#discrepancyAlert').hide();
                $('#receiptStatus').val('complete');
            }
        }
        
        function updateTotalCounts() {
            let totalReceived = 0;
            const itemCount = ${reservationItems.size()};
            
            for (let i = 0; i < itemCount; i++) {
                const receivedQuantity = parseInt($(`#receivedQuantity${i}`).val()) || 0;
                totalReceived += receivedQuantity;
            }
            
            $('#totalReceivedCount').text(totalReceived);
            checkAllDiscrepancies();
        }
        
        function validateForm() {
            // Check if quality rating is selected
            const qualityRating = parseInt($('#qualityRating').val());
            if (qualityRating === 0) {
                alert('Please provide a quality rating.');
                return false;
            }
            
            // Check if delivery condition is selected
            const deliveryCondition = $('#deliveryCondition').val();
            if (!deliveryCondition) {
                alert('Please select a delivery condition.');
                return false;
            }
            
            // Validate all received quantities
            const itemCount = ${reservationItems.size()};
            for (let i = 0; i < itemCount; i++) {
                const receivedQuantity = $(`#receivedQuantity${i}`).val();
                if (receivedQuantity === '' || receivedQuantity === null) {
                    alert('Please enter received quantity for all items.');
                    return false;
                }
                
                // If there's a discrepancy, make sure there are notes
                const expectedQuantity = parseInt($(`input[name="items[${i}].expectedQuantity"]`).val());
                if (parseInt(receivedQuantity) !== expectedQuantity) {
                    const itemNotes = $(`#itemNotes${i}`).val().trim();
                    if (itemNotes === '') {
                        const fruitName = $(`input[name="items[${i}].fruitName"]`).val();
                        alert(`Please add notes explaining the quantity discrepancy for ${fruitName}.`);
                        $(`#itemNotes${i}`).focus();
                        return false;
                    }
                }
            }
            
            return true;
        }
    </script>
</body>
</html>