<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cancel Reservation - Fruit Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .cancel-card {
            box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.1);
            border-radius: 15px;
            border: none;
            max-width: 650px;
            margin: 0 auto;
        }
        .cancel-card .card-header {
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
        .warning-icon {
            font-size: 4rem;
            color: #dc3545;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/shopHeader.jsp" />
    
    <div class="container mt-4 mb-5">
        <div class="text-center mb-4">
            <h1>Cancel Reservation</h1>
        </div>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        
        <div class="card cancel-card">
            <div class="card-header bg-danger text-white py-3">
                <h4 class="mb-0 text-center"><i class="fas fa-exclamation-triangle me-2"></i> Confirm Cancellation</h4>
            </div>
            <div class="card-body">
                <div class="text-center mb-4">
                    <i class="fas fa-times-circle warning-icon mb-3"></i>
                    <h4>Are you sure you want to cancel this reservation?</h4>
                    <p class="text-muted">This action cannot be undone. The warehouse will be notified of the cancellation.</p>
                </div>
                
                <div class="detail-section">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <div class="detail-label">Reservation ID</div>
                                <div>#${reservation.reservationId}</div>
                            </div>
                            <div class="mb-3">
                                <div class="detail-label">Created By</div>
                                <div>${reservation.createdByName}</div>
                            </div>
                            <div class="mb-3">
                                <div class="detail-label">Source Warehouse</div>
                                <div>${reservation.sourceWarehouseName}</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <div class="detail-label">Reservation Date</div>
                                <div><fmt:formatDate value="${reservation.reservationDate}" pattern="yyyy-MM-dd" /></div>
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
                            <div class="mb-3">
                                <div class="detail-label">Items</div>
                                <div>${reservation.itemCount} items</div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <form action="${pageContext.request.contextPath}/shop/reservation" method="post">
                    <input type="hidden" name="action" value="confirmCancelReservation">
                    <input type="hidden" name="reservationId" value="${reservation.reservationId}">
                    
                    <div class="mb-4">
                        <label for="cancellationReason" class="form-label">Cancellation Reason (Required)</label>
                        <select class="form-select mb-3" id="cancellationReason" name="cancellationReason" required>
                            <option value="">Select a reason...</option>
                            <option value="No longer needed">No longer needed</option>
                            <option value="Ordered by mistake">Ordered by mistake</option>
                            <option value="Sourcing elsewhere">Sourcing elsewhere</option>
                            <option value="Delivery date too late">Delivery date too late</option>
                            <option value="Changing quantity requirements">Changing quantity requirements</option>
                            <option value="Other">Other (please specify)</option>
                        </select>
                        
                        <div id="otherReasonContainer" style="display: none;">
                            <label for="otherReason" class="form-label">Specify Reason</label>
                            <input type="text" class="form-control" id="otherReason" name="otherReason" placeholder="Please specify the reason...">
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label for="cancellationNotes" class="form-label">Additional Notes (Optional)</label>
                        <textarea class="form-control" id="cancellationNotes" name="cancellationNotes" rows="3" placeholder="Any additional information about this cancellation..."></textarea>
                    </div>
                    
                    <div class="d-flex justify-content-between">
                        <a href="${pageContext.request.contextPath}/shop/reservation?action=viewReservation&id=${reservation.reservationId}" class="btn btn-outline-secondary btn-lg">
                            <i class="fas fa-arrow-left me-2"></i> Go Back
                        </a>
                        <button type="submit" class="btn btn-danger btn-lg">
                            <i class="fas fa-times-circle me-2"></i> Cancel Reservation
                        </button>
                    </div>
                </form>
            </div>
        </div>
        
        <div class="text-center mt-4">
            <a href="${pageContext.request.contextPath}/shop/reservation" class="btn btn-link">
                <i class="fas fa-home me-1"></i> Return to Reservation Dashboard
            </a>
        </div>
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
            
            // Show/hide other reason input based on selection
            $('#cancellationReason').change(function() {
                if ($(this).val() === 'Other') {
                    $('#otherReasonContainer').slideDown();
                    $('#otherReason').attr('required', true);
                } else {
                    $('#otherReasonContainer').slideUp();
                    $('#otherReason').attr('required', false);
                }
            });
            
            // Form submission validation
            $('form').submit(function(e) {
                const reason = $('#cancellationReason').val();
                if (!reason) {
                    alert('Please select a cancellation reason.');
                    e.preventDefault();
                    return;
                }
                
                if (reason === 'Other' && !$('#otherReason').val().trim()) {
                    alert('Please specify the cancellation reason.');
                    $('#otherReason').focus();
                    e.preventDefault();
                    return;
                }
                
                return confirm('Are you absolutely sure you want to cancel this reservation? This action cannot be undone.');
            });
        });
    </script>
</body>
</html>