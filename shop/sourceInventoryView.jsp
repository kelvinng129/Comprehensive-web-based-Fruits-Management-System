<%-- 
    Document   : sourceInventoryView
    Created on : 2025年4月19日, 下午12:57:55
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
    <title>Source Warehouse Inventory - Fruit Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
    <style>
        .list-card {
            box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.1);
            border-radius: 15px;
            border: none;
        }
        .list-card .card-header {
            border-radius: 15px 15px 0 0;
        }
        .source-card {
            border-radius: 15px;
            margin-bottom: 20px;
            transition: transform 0.3s;
            cursor: pointer;
        }
        .source-card:hover {
            transform: translateY(-5px);
            box-shadow: 0px 10px 20px rgba(0, 0, 0, 0.1);
        }
        .source-card.active {
            border: 2px solid #0d6efd;
        }
        .table-responsive {
            border-radius: 10px;
            overflow: hidden;
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
        .dashboard-filters {
            background-color: #f8f9fa;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.05);
        }
        .info-card {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/shopHeader.jsp" />
    
    <div class="container-fluid mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Source Warehouse Inventory</h1>
            <div>
                <a href="${pageContext.request.contextPath}/shop/reservation?action=showReservationForm" class="btn btn-primary me-2">
                    <i class="fas fa-plus-circle me-1"></i> Create Reservation
                </a>
                <a href="${pageContext.request.contextPath}/shop/reservation" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-1"></i> Dashboard
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
        
        <!-- Source Warehouses Selection -->
        <div class="mb-4">
            <h4 class="mb-3">Select Source Warehouse</h4>
            <div class="row" id="warehousesContainer">
                <c:forEach var="warehouse" items="${sourceWarehouses}" varStatus="status">
                    <div class="col-md-4 col-xl-3">
                        <div class="card source-card ${selectedWarehouseId == warehouse.warehouseId ? 'active' : ''}">
                            <div class="card-body" onclick="selectWarehouse(${warehouse.warehouseId})">
                                <h5 class="card-title">${warehouse.name}</h5>
                                <h6 class="card-subtitle mb-2 text-muted">${warehouse.city}, ${warehouse.country}</h6>
                                <p class="card-text small">${warehouse.description}</p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="badge bg-primary">${warehouse.fruitCount} fruit types</span>
                                    <c:if test="${selectedWarehouseId == warehouse.warehouseId}">
                                        <i class="fas fa-check-circle text-primary"></i>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
        
        <!-- Filters Section -->
        <div class="dashboard-filters mb-4">
            <form action="${pageContext.request.contextPath}/shop/reservation" method="get" id="filterForm">
                <input type="hidden" name="action" value="viewSourceInventory">
                <input type="hidden" name="sourceId" id="sourceIdInput" value="${selectedWarehouseId}">
                <div class="row align-items-end">
                    <div class="col-md-3 mb-3 mb-md-0">
                        <label for="categoryFilter" class="form-label">Filter by Category</label>
                        <select class="form-select" id="categoryFilter" name="category">
                            <option value="">All Categories</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category}" ${param.category == category ? 'selected' : ''}>
                                    ${category}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3 mb-3 mb-md-0">
                        <label for="availabilityFilter" class="form-label">Filter by Availability</label>
                        <select class="form-select" id="availabilityFilter" name="availability">
                            <option value="">All Availability</option>
                            <option value="high" ${param.availability == 'high' ? 'selected' : ''}>High Availability</option>
                            <option value="medium" ${param.availability == 'medium' ? 'selected' : ''}>Medium Availability</option>
                            <option value="low" ${param.availability == 'low' ? 'selected' : ''}>Low Availability</option>
                        </select>
                    </div>
                    <div class="col-md-4 mb-3 mb-md-0">
                        <label for="searchFilter" class="form-label">Search</label>
                        <input type="text" class="form-control" id="searchFilter" name="search" value="${param.search}" placeholder="Search by name...">
                    </div>
                    <div class="col-md-2 mb-3 mb-md-0 d-grid">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-filter me-1"></i> Apply Filters
                        </button>
                    </div>
                </div>
            </form>
        </div>
        
        <div class="row">
            <!-- Main Content Column -->
            <div class="col-lg-9">
                <!-- Inventory Table -->
                <div class="card list-card">
                    <div class="card-header bg-light">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <i class="fas fa-warehouse me-2"></i> 
                                <c:forEach var="warehouse" items="${sourceWarehouses}">
                                    <c:if test="${warehouse.warehouseId == selectedWarehouseId}">
                                        ${warehouse.name} Inventory
                                    </c:if>
                                </c:forEach>
                            </h5>
                            <c:if test="${not empty param.category || not empty param.availability || not empty param.search}">
                                <a href="${pageContext.request.contextPath}/shop/reservation?action=viewSourceInventory&sourceId=${selectedWarehouseId}" class="btn btn-sm btn-outline-secondary">
                                    <i class="fas fa-times me-1"></i> Clear Filters
                                </a>
                            </c:if>
                        </div>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty inventory}">
                                <div class="table-responsive">
                                    <table id="inventoryTable" class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Fruit</th>
                                                <th>Category</th>
                                                <th>Current Stock</th>
                                                <th>Availability</th>
                                                <th>Reserved</th>
                                                <th>Next Harvest</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${inventory}">
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <c:if test="${not empty item.imagePath}">
                                                                <img src="${pageContext.request.contextPath}${item.imagePath}" alt="${item.fruitName}" class="me-2" style="width: 32px; height: 32px; object-fit: cover; border-radius: 4px;">
                                                            </c:if>
                                                            <span>${item.fruitName}</span>
                                                        </div>
                                                    </td>
                                                    <td>${item.category}</td>
                                                    <td>
                                                        <span class="fw-bold">${item.currentStock}</span> units
                                                    </td>
                                                    <td>
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
                                                    </td>
                                                    <td>${item.reservedQuantity} units</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty item.nextHarvestDate}">
                                                                <fmt:formatDate value="${item.nextHarvestDate}" pattern="yyyy-MM-dd" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">N/A</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/shop/reservation?action=showReservationForm&sourceId=${selectedWarehouseId}&fruitId=${item.fruitId}" class="btn btn-sm btn-outline-primary">
                                                            <i class="fas fa-calendar-plus"></i> Reserve
                                                        </a>
                                                        <button type="button" class="btn btn-sm btn-outline-info" 
                                                                onclick="showFruitDetails(${item.fruitId}, '${item.fruitName}', '${item.category}', ${item.currentStock}, '${item.availabilityStatus}', ${item.reservedQuantity})">
                                                            <i class="fas fa-info-circle"></i>
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="fas fa-box-open fa-4x mb-3 text-muted"></i>
                                    <h4 class="text-muted">No inventory data available</h4>
                                    <p class="text-muted">Please select a different warehouse or try again later.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <!-- Sidebar Column -->
            <div class="col-lg-3">
                <!-- Summary Card -->
                <div class="card list-card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-chart-pie me-2"></i> Summary</h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <h6>Total Fruit Types</h6>
                            <h3>${inventory.size()}</h3>
                        </div>
                        <div class="mb-3">
                            <h6>Availability</h6>
                            <div class="d-flex justify-content-between mb-2">
                                <span><span class="availability-indicator high"></span> High</span>
                                <span>${highAvailabilityCount} items</span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span><span class="availability-indicator medium"></span> Medium</span>
                                <span>${mediumAvailabilityCount} items</span>
                            </div>
                            <div class="d-flex justify-content-between">
                                <span><span class="availability-indicator low"></span> Low</span>
                                <span>${lowAvailabilityCount} items</span>
                            </div>
                        </div>
                        <div>
                            <h6>Most Reserved</h6>
                            <ol class="ps-3">
                                <c:forEach var="topItem" items="${topReservedItems}" varStatus="status">
                                    <li>${topItem.fruitName} (${topItem.reservedQuantity} units)</li>
                                </c:forEach>
                            </ol>
                        </div>
                    </div>
                </div>
                
                <!-- Information Card -->
                <div class="card list-card mb-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i> Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="info-card">
                            <h6><i class="fas fa-shipping-fast text-primary me-2"></i> Shipping Times</h6>
                            <p class="small mb-0">Typical shipping time from source warehouse to your local shop is 5-10 business days depending on location and customs procedures.</p>
                        </div>
                        <div class="info-card">
                            <h6><i class="fas fa-exclamation-triangle text-warning me-2"></i> Availability Notes</h6>
                            <p class="small mb-0">Inventory levels are updated daily. Low availability items may have limited quantities for reservation.</p>
                        </div>
                        <div class="info-card mb-0">
                            <h6><i class="fas fa-calendar-alt text-success me-2"></i> Reservation Window</h6>
                            <p class="small mb-0">You can reserve fruits up to 14 days in advance. This helps ensure timely delivery and efficient logistics planning.</p>
                        </div>
                    </div>
                </div>
                
                <!-- Quick Actions -->
                <div class="card list-card">
                    <div class="card-header bg-secondary text-white">
                        <h5 class="mb-0"><i class="fas fa-bolt me-2"></i> Quick Actions</h5>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/shop/reservation?action=showReservationForm" class="btn btn-outline-primary">
                                <i class="fas fa-calendar-plus me-2"></i> Create Reservation
                            </a>
                            <a href="${pageContext.request.contextPath}/shop/reservation?action=viewMyReservations" class="btn btn-outline-info">
                                <i class="fas fa-clipboard-list me-2"></i> My Reservations
                            </a>
                            <a href="${pageContext.request.contextPath}/shop/inventory?action=list" class="btn btn-outline-success">
                                <i class="fas fa-boxes me-2"></i> My Shop Inventory
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Fruit Details Modal -->
    <div class="modal fade" id="fruitDetailsModal" tabindex="-1" aria-labelledby="fruitDetailsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="fruitDetailsModalLabel">Fruit Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <div class="detail-label">Fruit Name</div>
                                <div id="modalFruitName">-</div>
                            </div>
                            <div class="mb-3">
                                <div class="detail-label">Category</div>
                                <div id="modalCategory">-</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <div class="detail-label">Current Stock</div>
                                <div id="modalCurrentStock">-</div>
                            </div>
                            <div class="mb-3">
                                <div class="detail-label">Availability</div>
                                <div id="modalAvailability">-</div>
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="detail-label">Reserved Quantity</div>
                        <div id="modalReserved">-</div>
                    </div>
                    <div class="mb-3">
                        <div class="detail-label">Description</div>
                        <div id="modalDescription">
                            Information about this fruit is currently being updated.
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <a href="#" class="btn btn-primary" id="reserveButton">
                        <i class="fas fa-calendar-plus me-1"></i> Reserve This Fruit
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#inventoryTable').DataTable({
                "pageLength": 10,
                "language": {
                    "emptyTable": "No inventory data available"
                }
            });
            
            // Auto-dismiss alerts after 5 seconds
            setTimeout(function() {
                $('.alert').alert('close');
            }, 5000);
            
            // Auto-submit form when filters change
            $('#categoryFilter, #availabilityFilter').change(function() {
                $('#filterForm').submit();
            });
        });
        
        function selectWarehouse(warehouseId) {
            // Update hidden input value
            document.getElementById('sourceIdInput').value = warehouseId;
            
            // Submit the form
            document.getElementById('filterForm').submit();
        }
        
        function showFruitDetails(fruitId, fruitName, category, currentStock, availabilityStatus, reservedQuantity) {
            // Set modal content
            document.getElementById('modalFruitName').textContent = fruitName;
            document.getElementById('modalCategory').textContent = category;
            document.getElementById('modalCurrentStock').textContent = currentStock + ' units';
            
            let availabilityHtml = '';
            if (availabilityStatus === 'high') {
                availabilityHtml = '<span class="availability-indicator high"></span> High';
            } else if (availabilityStatus === 'medium') {
                availabilityHtml = '<span class="availability-indicator medium"></span> Medium';
            } else if (availabilityStatus === 'low') {
                availabilityHtml = '<span class="availability-indicator low"></span> Low';
            } else {
                availabilityHtml = 'Unknown';
            }
            document.getElementById('modalAvailability').innerHTML = availabilityHtml;
            
            document.getElementById('modalReserved').textContent = reservedQuantity + ' units';
            
            // Update reserve button link
            document.getElementById('reserveButton').href = '${pageContext.request.contextPath}/shop/reservation?action=showReservationForm&sourceId=${selectedWarehouseId}&fruitId=' + fruitId;
            
            // Show the modal
            var modal = new bootstrap.Modal(document.getElementById('fruitDetailsModal'));
            modal.show();
        }
    </script>
</body>
</html>