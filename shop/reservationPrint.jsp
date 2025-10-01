<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservation #${reservation.reservationId} - Print View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .print-container {
            background-color: white;
            max-width: 800px;
            margin: 20px auto;
            padding: 40px;
            box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
        }
        .print-header {
            padding-bottom: 20px;
            margin-bottom: 20px;
            border-bottom: 1px solid #dee2e6;
        }
        .company-logo {
            font-size: 24px;
            font-weight: bold;
        }
        .status-badge {
            font-size: 0.8rem;
            padding: 0.35rem 0.65rem;
            border-radius: 50rem;
        }
        .detail-label {
            font-weight: 600;
            color: #6c757d;
        }
        .print-footer {
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #dee2e6;
            font-size: 0.9rem;
            color: #6c757d;
        }
        .qr-code {
            width: 100px;
            height: 100px;
            background-color: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            color: #adb5bd;
            border-radius: 10px;
        }
        @media print {
            body {
                background-color: white;
            }
            .print-container {
                box-shadow: none;
                margin: 0;
                max-width: 100%;
            }
            .no-print {
                display: none !important;
            }
        }
    </style>
</head>
<body>
    <div class="no-print mb-4 text-center pt-3">
        <button class="btn btn-primary me-2" onclick="window.print()">
            <i class="fas fa-print me-1"></i> Print
        </button>
        <a href="${pageContext.request.contextPath}/shop/reservation?action=viewReservation&id=${reservation.reservationId}" class="btn btn-secondary">
            <i class="fas fa-arrow-left me-1"></i> Back to Reservation
        </a>
    </div>
    
    <div class="print-container">
        <!-- Header -->
        <div class="print-header d-flex justify-content-between align-items-start">
            <div>
                <div class="company-logo mb-2">Acer International Bakery</div>
                <div>Fruit Management System</div>
                <div class="small text-muted">www.acerbakery.com</div>
            </div>
            <div class="text-end">
                <div class="fs-4 mb-2">Reservation Receipt</div>
                <div class="mb-1"><strong>ID:</strong> #${reservation.reservationId}</div>
                <div class="mb-1">
                    <strong>Date:</strong> <fmt:formatDate value="${reservation.reservationDate}" pattern="yyyy-MM-dd" />
                </div>
                <div>
                    <span class="status-badge bg-${reservation.statusColor}">
                        ${reservation.formattedStatus}
                    </span>
                </div>
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="row mb-4">
            <!-- Source Information -->
            <div class="col-md-6 mb-4 mb-md-0">
                <h5 class="mb-3">Source</h5>
                <div class="mb-2">
                    <span class="detail-label d-block">Warehouse:</span>
                    ${reservation.sourceWarehouseName}
                </div>
                <div class="mb-2">
                    <span class="detail-label d-block">Location:</span>
                    ${reservation.sourceWarehouseCity}, ${reservation.sourceWarehouseCountry}
                </div>
                <c:if test="${not empty reservation.sourceWarehouseContact}">
                    <div>
                        <span class="detail-label d-block">Contact:</span>
                        ${reservation.sourceWarehouseContact}
                    </div>
                </c:if>
            </div>
            
            <!-- Destination Information -->
            <div class="col-md-6">
                <h5 class="mb-3">Destination</h5>
                <div class="mb-2">
                    <span class="detail-label d-block">Shop:</span>
                    ${reservation.shopName}
                </div>
                <div class="mb-2">
                    <span class="detail-label d-block">Location:</span>
                    ${reservation.shopCity}, ${reservation.shopCountry}
                </div>
                <c:if test="${not empty reservation.shopContact}">
                    <div>
                        <span class="detail-label d-block">Contact:</span>
                        ${reservation.shopContact}
                    </div>
                </c:if>
            </div>
        </div>
        
        <!-- Shipping Information -->
        <div class="row mb-4">
            <div class="col-12">
                <h5 class="mb-3">Shipping Information</h5>
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <span class="detail-label d-block">Expected Delivery:</span>
                        <c:choose>
                            <c:when test="${not empty reservation.expectedDeliveryDate}">
                                <fmt:formatDate value="${reservation.expectedDeliveryDate}" pattern="yyyy-MM-dd" />
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted">Not specified</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col-md-4 mb-3">
                        <span class="detail-label d-block">Actual Delivery:</span>
                        <c:choose>
                            <c:when test="${not empty reservation.deliveryDate}">
                                <fmt:formatDate value="${reservation.deliveryDate}" pattern="yyyy-MM-dd" />
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted">Not delivered yet</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col-md-4 mb-3">
                        <span class="detail-label d-block">Tracking Number:</span>
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
                <c:if test="${not empty reservation.shippingNotes}">
                    <div class="row">
                        <div class="col-12">
                            <span class="detail-label d-block">Shipping Notes:</span>
                            ${reservation.shippingNotes}
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
        
        <!-- Items Table -->
        <h5 class="mb-3">Reserved Items</h5>
        <div class="table-responsive mb-4">
            <table class="table table-bordered">
                <thead class="table-light">
                    <tr>
                        <th class="text-center" style="width: 60px;">No.</th>
                        <th>Fruit</th>
                        <th class="text-center">Quantity</th>
                        <th class="text-center">Status</th>
                        <th>Notes</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${reservationItems}" varStatus="status">
                        <tr>
                            <td class="text-center">${status.index + 1}</td>
                            <td>${item.fruitName}</td>
                            <td class="text-center">${item.quantity}</td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${item.status == 'fulfilled'}">
                                        <span class="badge bg-success">Fulfilled</span>
                                    </c:when>
                                    <c:when test="${item.status == 'partial'}">
                                        <span class="badge bg-warning text-dark">Partial (${item.fulfilledQuantity}/${item.quantity})</span>
                                    </c:when>
                                    <c:when test="${item.status == 'cancelled'}">
                                        <span class="badge bg-danger">Cancelled</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Pending</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty item.notes}">
                                        ${item.notes}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">-</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        
        <!-- Summary Section -->
        <div class="row mb-4">
            <div class="col-md-8">
                <c:if test="${not empty reservation.notes}">
                    <h5 class="mb-3">Special Instructions</h5>
                    <p>${reservation.notes}</p>
                </c:if>
                
                <c:if test="${not empty reservation.receiptNotes}">
                    <h5 class="mb-3">Receipt Notes</h5>
                    <p>${reservation.receiptNotes}</p>
                </c:if>
            </div>
            <div class="col-md-4 text-end">
                <div class="qr-code ms-auto">
                    <i class="fas fa-qrcode"></i>
                </div>
                <div class="small text-muted mt-2">
                    Scan to verify
                </div>
            </div>
        </div>
        
        <!-- Footer -->
        <div class="print-footer text-center">
            <div>Acer International Bakery - Fruit Management System</div>
            <div>This document was generated on <fmt:formatDate value="${now}" pattern="yyyy-MM-dd HH:mm:ss" /></div>
            <div>For questions, please contact support@acerbakery.com</div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>