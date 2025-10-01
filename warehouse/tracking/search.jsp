<%-- 
    Document   : search
    Created on : 2025年4月20日, 上午7:42:16
    Author     : kelvin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Advanced Search</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/tracking.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
</head>
<body>
    <jsp:include page="../includes/header.jsp" />
    
    <div class="container mt-4">
        <h1 class="mb-4">Advanced Search</h1>
        
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="card-title mb-0">Search Filters</h5>
                        <div>
                            <a href="${pageContext.request.contextPath}/warehouse/tracking/dashboard" class="btn btn-light btn-sm">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                            <a href="${pageContext.request.contextPath}/warehouse/tracking/movements" class="btn btn-light btn-sm ms-2">
                                <i class="fas fa-exchange-alt"></i> All Movements
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/warehouse/tracking/search" method="post">
                            <input type="hidden" name="action" value="searchMovements">
                            
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <div class="form-check mb-2">
                                        <input class="form-check-input" type="radio" name="searchType" id="dateSearch" value="date" ${searchType == 'date' || empty searchType ? 'checked' : ''}>
                                        <label class="form-check-label" for="dateSearch">
                                            Search by Date Range
                                        </label>
                                    </div>
                                    <div class="date-filter">
                                        <div class="mb-2">
                                            <label for="startDate" class="form-label">Start Date:</label>
                                            <input type="date" class="form-control" id="startDate" name="startDate" value="${startDate}">
                                        </div>
                                        <div>
                                            <label for="endDate" class="form-label">End Date:</label>
                                            <input type="date" class="form-control" id="endDate" name="endDate" value="${endDate}">
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-md-4">
                                    <div class="form-check mb-2">
                                        <input class="form-check-input" type="radio" name="searchType" id="fruitSearch" value="fruit" ${searchType == 'fruit' ? 'checked' : ''}>
                                        <label class="form-check-label" for="fruitSearch">
                                            Search by Fruit
                                        </label>
                                    </div>
                                    <div class="fruit-filter">
                                        <label for="fruitId" class="form-label">Select Fruit:</label>
                                        <select class="form-select" id="fruitId" name="fruitId">
                                            <option value="">-- Select Fruit --</option>
                                            <c:forEach var="fruit" items="${fruits}">
                                                <option value="${fruit.fruitId}" ${selectedFruitId == fruit.fruitId ? 'selected' : ''}>${fruit.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="col-md-4">
                                    <div class="form-check mb-2">
                                        <input class="form-check-input" type="radio" name="searchType" id="locationSearch" value="location" ${searchType == 'location' ? 'checked' : ''}>
                                        <label class="form-check-label" for="locationSearch">
                                            Search by Location
                                        </label>
                                    </div>
                                    <div class="location-filter">
                                        <label for="locationId" class="form-label">Select Location:</label>
                                        <select class="form-select" id="locationId" name="locationId">
                                            <option value="">-- Select Location --</option>
                                            <c:forEach var="location" items="${locations}">
                                                <option value="${location.locationID}" ${selectedLocationId == location.locationID ? 'selected' : ''}>${location.locationName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="text-center">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i> Search
                                </button>
                                <a href="${pageContext.request.contextPath}/warehouse/tracking/search" class="btn btn-secondary ms-2">
                                    <i class="fas fa-times"></i> Clear
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        <c:if test="${searchPerformed}">
            <div class="row">
                <div class="col-md-12">
                    <div class="card">
                        <div class="card-header bg-success text-white">
                            <h5 class="card-title mb-0">Search Results</h5>
                        </div>
                        <div class="card-body">
                            <c:if test="${empty movements}">
                                <div class="alert alert-info">
                                    No movements found matching your search criteria.
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty movements}">
                                <div class="table-responsive">
                                    <table id="resultsTable" class="table table-striped table-hover">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Date</th>
                                                <th>Fruit</th>
                                                <th>From</th>
                                                <th>To</th>
                                                <th>Quantity</th>
                                                <th>Type</th>
                                                <th>Status</th>
                                                <th>Created By</th>
                                                <th>Tracking #</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="movement" items="${movements}">
                                                <tr>
                                                    <td>${movement.recordId}</td>
                                                    <td><fmt:formatDate value="${movement.movementDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                                    <td>${movement.fruitName}</td>
                                                    <td>${movement.sourceLocationName}</td>
                                                    <td>${movement.destinationLocationName}</td>
                                                    <td>${movement.quantity}</td>
                                                    <td>${movement.movementType}</td>
                                                    <td>
                                                        <span class="badge ${movement.status == 'DELIVERED' ? 'bg-success' : 
                                                                              movement.status == 'IN_TRANSIT' ? 'bg-primary' : 
                                                                              movement.status == 'PENDING' ? 'bg-warning' : 'bg-secondary'}">
                                                            ${movement.status}
                                                        </span>
                                                    </td>
                                                    <td>${movement.createdByName}</td>
                                                    <td>${movement.trackingNumber}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Initialize DataTable if results exist
            if (document.getElementById('resultsTable')) {
                $('#resultsTable').DataTable({
                    order: [[1, 'desc']], // Sort by date descending
                    pageLength: 25
                });
            }
            
            // Form validation and UI enhancements
            $('input[name="searchType"]').change(function() {
                const searchType = $(this).val();
                
                // Disable/enable appropriate fields based on search type
                if (searchType === 'date') {
                    $('#startDate, #endDate').prop('disabled', false);
                    $('#fruitId, #locationId').prop('disabled', true);
                } else if (searchType === 'fruit') {
                    $('#fruitId').prop('disabled', false);
                    $('#startDate, #endDate, #locationId').prop('disabled', true);
                } else if (searchType === 'location') {
                    $('#locationId').prop('disabled', false);
                    $('#startDate, #endDate, #fruitId').prop('disabled', true);
                }
            });
            
            // Trigger the change event to initialize form state
            $('input[name="searchType"]:checked').change();
            
            // Set default dates if empty
            if (!$('#startDate').val()) {
                const today = new Date();
                const oneMonthAgo = new Date();
                oneMonthAgo.setMonth(today.getMonth() - 1);
                
                $('#startDate').val(oneMonthAgo.toISOString().split('T')[0]);
                $('#endDate').val(today.toISOString().split('T')[0]);
            }
        });
    </script>
</body>
</html>
