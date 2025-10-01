<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Batch - Fruit Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .form-card {
            box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            border: none;
        }
        .form-card .card-header {
            border-radius: 10px 10px 0 0;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/shopHeader.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Add New Batch</h1>
            <a href="${pageContext.request.contextPath}/shop/inventory" class="btn btn-secondary">
                <i class="fa fa-arrow-left me-2"></i> Back to Dashboard
            </a>
        </div>
        
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
        
        <div class="row">
            <div class="col-md-7">
                <div class="card form-card">
                    <div class="card-header bg-success text-white">
                        <h4 class="mb-0"><i class="fa fa-box me-2"></i> New Batch Form</h4>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/shop/inventory" method="post">
                            <input type="hidden" name="action" value="createBatch">
                            
                            <div class="mb-3">
                                <label for="batchId" class="form-label">Batch ID</label>
                                <div class="input-group">
                                    <input type="text" class="form-control" id="batchId" name="batchId" value="${generatedBatchId}" required>
                                    <button type="button" class="btn btn-outline-secondary" id="generateBatchId">
                                        <i class="fa fa-arrows-rotate me-1"></i> Generate
                                    </button>
                                </div>
                                <div class="form-text">A unique identifier for this batch. You can use the generated ID or create your own.</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="fruitId" class="form-label">Fruit</label>
                                <select class="form-select" id="fruitId" name="fruitId" required>
                                    <option value="">Select a fruit...</option>
                                    <c:forEach var="fruit" items="${fruits}">
                                        <option value="${fruit.fruitId}">${fruit.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label for="quantity" class="form-label">Quantity</label>
                                <input type="number" class="form-control" id="quantity" name="quantity" min="1" required>
                                <div class="form-text">Enter the number of units in this batch.</div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="receivedDate" class="form-label">Received Date</label>
                                    <input type="date" class="form-control" id="receivedDate" name="receivedDate" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="expiryDate" class="form-label">Expiry Date</label>
                                    <input type="date" class="form-control" id="expiryDate" name="expiryDate">
                                    <div class="form-text">Optional if the fruit doesn't have a specific expiry date.</div>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="supplierInfo" class="form-label">Supplier Information</label>
                                <input type="text" class="form-control" id="supplierInfo" name="supplierInfo" placeholder="Enter supplier name or reference">
                            </div>
                            
                            <div class="mb-3">
                                <label for="storageConditions" class="form-label">Storage Conditions</label>
                                <input type="text" class="form-control" id="storageConditions" name="storageConditions" placeholder="E.g., Room temperature, Refrigerated, etc.">
                            </div>
                            
                            <div class="mb-3">
                                <label for="notes" class="form-label">Notes</label>
                                <textarea class="form-control" id="notes" name="notes" rows="3" placeholder="Enter any additional details about this batch"></textarea>
                            </div>
                            
                            <div class="alert alert-info">
                                <i class="fa fa-info-circle me-2"></i>
                                Adding a new batch will automatically increase the inventory quantity for the selected fruit.
                            </div>
                            
                            <div class="text-end">
                                <a href="${pageContext.request.contextPath}/shop/inventory" class="btn btn-secondary me-2">Cancel</a>
                                <button type="submit" class="btn btn-success">Add Batch</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            
            <div class="col-md-5">
                <div class="card form-card">
                    <div class="card-header bg-info text-white">
                        <h4 class="mb-0"><i class="fa fa-circle-info me-2"></i> Batch Management Guide</h4>
                    </div>
                    <div class="card-body">
                        <div class="mb-4">
                            <h5><i class="fa fa-tag text-success me-2"></i> What is a Batch?</h5>
                            <p>A batch represents a group of the same fruit received at the same time, typically from the same source. Tracking batches helps with:</p>
                            <ul>
                                <li>Expiry date management</li>
                                <li>Quality control</li>
                                <li>Supplier tracking</li>
                                <li>Inventory rotation</li>
                            </ul>
                        </div>
                        
                        <div class="mb-4">
                            <h5><i class="fa fa-list-check text-primary me-2"></i> Batch Information</h5>
                            <p>When adding a new batch, consider including:</p>
                            <ul>
                                <li><strong>Batch ID:</strong> A unique identifier</li>
                                <li><strong>Received Date:</strong> When the batch arrived</li>
                                <li><strong>Expiry Date:</strong> When the batch expires</li>
                                <li><strong>Supplier Info:</strong> Source of the batch</li>
                                <li><strong>Storage Conditions:</strong> How to properly store it</li>
                                <li><strong>Notes:</strong> Quality observations, lot numbers, etc.</li>
                            </ul>
                        </div>
                        
                        <div class="alert alert-warning">
                            <div class="d-flex">
                                <div class="me-3">
                                    <i class="fa fa-triangle-exclamation fa-2x"></i>
                                </div>
                                <div>
                                    <h5 class="alert-heading">Best Practices</h5>
                                    <ul class="mb-0">
                                        <li>Always use FIFO (First In, First Out) for inventory rotation</li>
                                        <li>Regularly check expiry dates</li>
                                        <li>Store batches with similar expiry dates together</li>
                                        <li>Record any quality issues in the notes section</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Quick Links -->
                <div class="card form-card mt-4">
                    <div class="card-header bg-secondary text-white">
                        <h4 class="mb-0"><i class="fa fa-link me-2"></i> Quick Links</h4>
                    </div>
                    <div class="card-body">
                        <div class="list-group">
                            <a href="${pageContext.request.contextPath}/shop/inventory?action=listBatches" class="list-group-item list-group-item-action">
                                <i class="fa fa-boxes-stacked me-2"></i> View All Batches
                            </a>
                            <a href="${pageContext.request.contextPath}/shop/inventory?action=list" class="list-group-item list-group-item-action">
                                <i class="fa fa-warehouse me-2"></i> View Current Inventory
                            </a>
                            <a href="${pageContext.request.contextPath}/shop/inventory?action=showWastageForm" class="list-group-item list-group-item-action">
                                <i class="fa fa-trash-can me-2"></i> Record Wastage
                            </a>
                            <a href="${pageContext.request.contextPath}/shop/inventory?action=transactions" class="list-group-item list-group-item-action">
                                <i class="fa fa-clock-rotate-left me-2"></i> View Transactions
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Set default received date to today
            const today = new Date();
            const formattedDate = today.toISOString().split('T')[0];
            document.getElementById('receivedDate').value = formattedDate;
            
            // Function to generate a random batch ID
            function generateBatchId() {
                const prefix = 'BATCH';
                const timestamp = Date.now().toString().slice(-6);
                const random = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
                return `${prefix}-${timestamp}${random}`;
            }
            
            // Generate button click handler
            document.getElementById('generateBatchId').addEventListener('click', function() {
                document.getElementById('batchId').value = generateBatchId();
            });
            
            // Validate expiry date is after received date
            const receivedDateInput = document.getElementById('receivedDate');
            const expiryDateInput = document.getElementById('expiryDate');
            
            function validateDates() {
                const receivedDate = new Date(receivedDateInput.value);
                const expiryDate = new Date(expiryDateInput.value);
                
                if (expiryDate < receivedDate) {
                    expiryDateInput.setCustomValidity('Expiry date must be after the received date');
                } else {
                    expiryDateInput.setCustomValidity('');
                }
            }
            
            receivedDateInput.addEventListener('change', validateDates);
            expiryDateInput.addEventListener('change', validateDates);
            
            // Form validation
            document.querySelector('form').addEventListener('submit', function(event) {
                if (expiryDateInput.value) {
                    validateDates();
                    
                    // Check if expiry date is too far in the future (more than 2 years)
                    const receivedDate = new Date(receivedDateInput.value);
                    const expiryDate = new Date(expiryDateInput.value);
                    const twoYearsFromNow = new Date();
                    twoYearsFromNow.setFullYear(twoYearsFromNow.getFullYear() + 2);
                    
                    if (expiryDate > twoYearsFromNow) {
                        if (!confirm('The expiry date is more than 2 years from now. Is this correct?')) {
                            event.preventDefault();
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>