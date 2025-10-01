<%-- 
    Document   : inventoryDetail
    Created on : 2025年4月19日, 下午3:15:37
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
    <title>Inventory Details - ${inventory.fruitName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <style>
        .detail-card {
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .inventory-status {
            font-size: 1.2rem;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: bold;
        }
        .detail-label {
            font-weight: 600;
            color: #6c757d;
        }
        .log-item {
            border-left: 3px solid #dee2e6;
            padding-left: 15px;
            margin-bottom: 15px;
            position: relative;
        }
        .log-item:before {
            content: '';
            position: absolute;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background-color: #dee2e6;
            left: -7px;
            top: 10px;
        }
        .chart-container {
            height: 250px;
            position: relative;
        }
    </style>
</head>
<body>
    <jsp:include page="../include/header.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Inventory Details: ${inventory.fruitName}</h1>
            <div>
                <a href="${pageContext.request.contextPath}/warehouse/inventory" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Inventory
                </a>
                <a href="${pageContext.request.contextPath}/warehouse/transfer?action=new&inventoryId=${inventory.id}" class="btn btn-primary">
                    <i class="fas fa-exchange-alt"></i> Transfer
                </a>
            </div>
        </div>
        
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
        
        <div class="row">
            <!-- Inventory Details -->
            <div class="col-md-8">
                <div class="card detail-card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i> Inventory Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <div class="d-flex align-items-center mb-3">
                                    <i class="fas fa-apple-alt fa-3x text-${inventory.stockStatusColor} me-3"></i>
                                    <div>
                                        <h3 class="mb-0">${inventory.fruitName}</h3>
                                        <p class="text-muted mb-0">Inventory ID: ${inventory.id}</p>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <span class="detail-label">Current Quantity:</span>
                                    <span class="h4 ms-2">${inventory.quantity} units</span>
                                </div>
                                
                                <div class="mb-3">
                                    <span class="detail-label">Status:</span>
                                    <span class="badge bg-${inventory.stockStatusColor} ms-2 p-2">
                                        ${inventory.stockStatus}
                                    </span>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="card bg-light">
                                    <div class="card-body">
                                        <h5 class="card-title">Stock Levels</h5>
                                        <div class="mb-3">
                                            <span class="detail-label">Minimum Stock Level:</span>
                                            <span>${inventory.minStockLevel} units</span>
                                        </div>
                                        <div class="mb-3">
                                            <span class="detail-label">Maximum Stock Level:</span>
                                            <span>${inventory.maxStockLevel} units</span>
                                        </div>
                                        <div class="mb-3">
                                            <span class="detail-label">Utilization:</span>
                                            <span><fmt:formatNumber value="${inventory.utilizationPercentage}" pattern="#0.0" />%</span>
                                        </div>
                                        <div class="progress">
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
                            </div>
                        </div>
                        
                        <hr>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <h5>Location Information</h5>
                                <div class="mb-3">
                                    <span class="detail-label">Warehouse:</span>
                                    <span>${inventory.locationCode}</span>
                                </div>
                                <div class="mb-3">
                                    <span class="detail-label">Section:</span>
                                    <span>${inventory.warehouseSection}</span>
                                </div>
                                <div class="mb-3">
                                    <span class="detail-label">Shelf Number:</span>
                                    <span>${inventory.shelfNumber}</span>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <h5>Last Update Information</h5>
                                <div class="mb-3">
                                    <span class="detail-label">Last Updated:</span>
                                    <span><fmt:formatDate value="${inventory.lastUpdated}" pattern="yyyy-MM-dd HH:mm" /></span>
                                </div>
                                <div class="mb-3">
                                    <span class="detail-label">Updated By:</span>
                                    <span>${inventory.lastUpdatedByName}</span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="d-flex justify-content-end mt-3">
                            <a href="${pageContext.request.contextPath}/warehouse/inventory?action=showAdjustForm&id=${inventory.id}" class="btn btn-outline-primary me-2">
                                <i class="fas fa-edit"></i> Adjust Stock
                            </a>
                            <button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#settingsModal">
                                <i class="fas fa-cog"></i> Settings
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Activity History -->
                <div class="card detail-card">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0"><i class="fas fa-history me-2"></i> Activity History</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty logs}">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Date</th>
                                                <th>Activity</th>
                                                <th>Quantity Change</th>
                                                <th>Performed By</th>
                                                <th>Notes</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="log" items="${logs}">
                                                <tr>
                                                    <td><fmt:formatDate value="${log.activityDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                                    <td>
                                                        <span class="badge bg-${log.activityTypeColor}">${log.activityTypeDisplay}</span>
                                                    </td>
                                                    <td class="text-${log.quantityChangeColor}">
                                                        <c:if test="${not empty log.quantityChangeDisplay}">
                                                            ${log.quantityChangeDisplay}
                                                        </c:if>
                                                    </td>
                                                    <td>${log.performedByName}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty log.notes}">
                                                                ${log.notes}
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
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i> No activity history found.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <!-- Sidebar -->
            <div class="col-md-4">
                <!-- Quick Actions -->
                <div class="card detail-card mb-4">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="fas fa-bolt me-2"></i> Quick Actions</h5>
                    </div>
                    <div class="card-body">
                        <div class="list-group">
                            <a href="${pageContext.request.contextPath}/warehouse/inventory?action=showAdjustForm&id=${inventory.id}" class="list-group-item list-group-item-action">
                                <i class="fas fa-plus-minus me-2"></i> Adjust Stock Level
                            </a>
                            <a href="${pageContext.request.contextPath}/warehouse/transfer?action=new&inventoryId=${inventory.id}" class="list-group-item list-group-item-action">
                                <i class="fas fa-exchange-alt me-2"></i> Create Transfer
                            </a>
                            <a href="#" class="list-group-item list-group-item-action" data-bs-toggle="modal" data-bs-target="#moveItemModal">
                                <i class="fas fa-map-marker-alt me-2"></i> Change Location
                            </a>
                            <a href="${pageContext.request.contextPath}/fruit?action=view&id=${inventory.fruitId}" class="list-group-item list-group-item-action">
                                <i class="fas fa-info-circle me-2"></i> View Fruit Details
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Stock Level Recommendations -->
                <div class="card detail-card mb-4">
                    <div class="card-header bg-warning text-dark">
                        <h5 class="mb-0"><i class="fas fa-lightbulb me-2"></i> Recommendations</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${inventory.stockStatus == 'LOW'}">
                                <div class="alert alert-danger">
                                    <h6><i class="fas fa-exclamation-triangle me-2"></i> Low Stock Alert</h6>
                                    <p>Current stock is below the minimum threshold of ${inventory.minStockLevel} units.</p>
                                    <p class="mb-0">Recommended Action: Request a transfer from another location or create a purchase order.</p>
                                </div>
                            </c:when>
                            <c:when test="${inventory.stockStatus == 'HIGH'}">
                                <div class="alert alert-warning">
                                    <h6><i class="fas fa-exclamation-circle me-2"></i> Overstock Alert</h6>
                                    <p>Current stock exceeds the maximum threshold of ${inventory.maxStockLevel} units.</p>
                                    <p class="mb-0">Recommended Action: Transfer excess stock to shops or other warehouses.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-success">
                                    <h6><i class="fas fa-check-circle me-2"></i> Stock Level Optimal</h6>
                                    <p>Current stock is within the optimal range.</p>
                                    <p class="mb-0">No immediate action needed.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        
                        <h6 class="mt-3">Optimal Order Quantity</h6>
                        <p>
                            Based on current usage patterns, the optimal order quantity is approximately:
                            <strong>${(inventory.maxStockLevel - inventory.minStockLevel) / 2}</strong> units.
                        </p>
                    </div>
                </div>
                
                <!-- Related Transfers -->
                <div class="card detail-card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-exchange-alt me-2"></i> Related Transfers</h5>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i> Related transfers will be displayed here.
                        </div>
                        <div class="text-center mt-2">
                            <a href="${pageContext.request.contextPath}/warehouse/transfer?action=list&fruitId=${inventory.fruitId}" class="btn btn-outline-primary">
                                View All Transfers
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Settings Modal -->
    <div class="modal fade" id="settingsModal" tabindex="-1" aria-labelledby="settingsModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="settingsModalLabel">Inventory Settings</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/warehouse/inventory" method="post">
                    <input type="hidden" name="action" value="updateSettings">
                    <input type="hidden" name="inventoryId" value="${inventory.id}">
                    
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="minStockLevel" class="form-label">Minimum Stock Level</label>
                            <input type="number" class="form-control" id="minStockLevel" name="minStockLevel" value="${inventory.minStockLevel}" required>
                        </div>
                        <div class="mb-3">
                            <label for="maxStockLevel" class="form-label">Maximum Stock Level</label>
                            <input type="number" class="form-control" id="maxStockLevel" name="maxStockLevel" value="${inventory.maxStockLevel}" required>
                        </div>
                        <div class="mb-3">
                            <label for="warehouseSection" class="form-label">Warehouse Section</label>
                            <input type="text" class="form-control" id="warehouseSection" name="warehouseSection" value="${inventory.warehouseSection}" required>
                        </div>
                        <div class="mb-3">
                            <label for="shelfNumber" class="form-label">Shelf Number</label>
                            <input type="text" class="form-control" id="shelfNumber" name="shelfNumber" value="${inventory.shelfNumber}" required>
                        </div>
                        <div class="mb-3">
                            <label for="notes" class="form-label">Notes</label>
                            <textarea class="form-control" id="notes" name="notes" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Move Item Modal -->
    <div class="modal fade" id="moveItemModal" tabindex="-1" aria-labelledby="moveItemModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="moveItemModalLabel">Change Item Location</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/warehouse/inventory" method="post">
                    <input type="hidden" name="action" value="updateSettings">
                    <input type="hidden" name="inventoryId" value="${inventory.id}">
                    
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="warehouseLocation" class="form-label">Warehouse Location</label>
                            <select class="form-select" id="warehouseLocation" name="locationCode">
                                <option value="MAIN" ${inventory.locationCode == 'MAIN' ? 'selected' : ''}>Main Warehouse</option>
                                <option value="EAST" ${inventory.locationCode == 'EAST' ? 'selected' : ''}>East Warehouse</option>
                                <option value="WEST" ${inventory.locationCode == 'WEST' ? 'selected' : ''}>West Warehouse</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="newWarehouseSection" class="form-label">Section</label>
                            <input type="text" class="form-control" id="newWarehouseSection" name="warehouseSection" value="${inventory.warehouseSection}">
                        </div>
                        <div class="mb-3">
                            <label for="newShelfNumber" class="form-label">Shelf Number</label>
                            <input type="text" class="form-control" id="newShelfNumber" name="shelfNumber" value="${inventory.shelfNumber}">
                        </div>
                        <div class="mb-3">
                            <label for="moveNotes" class="form-label">Notes</label>
                            <textarea class="form-control" id="moveNotes" name="notes" rows="3">Location change</textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update Location</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <jsp:include page="../include/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>