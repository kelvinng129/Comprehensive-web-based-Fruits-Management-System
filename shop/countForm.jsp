<%-- 
    Document   : countForm
    Created on : 2025年4月19日, 下午12:11:34
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
    <title>Start Inventory Count - Fruit Management System</title>
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
        .info-card {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .count-steps {
            counter-reset: step-counter;
            list-style-type: none;
            padding-left: 0;
        }
        .count-steps li {
            position: relative;
            padding-left: 50px;
            margin-bottom: 20px;
        }
        .count-steps li::before {
            content: counter(step-counter);
            counter-increment: step-counter;
            position: absolute;
            left: 0;
            top: 50%;
            transform: translateY(-50%);
            background-color: #0d6efd;
            color: white;
            font-weight: bold;
            font-size: 14px;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            line-height: 30px;
            text-align: center;
        }
    </style>
</head>
<body>
    <jsp:include page="/includes/shopHeader.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Start Inventory Count</h1>
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
                <div class="card form-card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0"><i class="fa fa-clipboard-check me-2"></i> Start New Inventory Count</h4>
                    </div>
                    <div class="card-body">
                        <!-- Current Inventory Summary -->
                        <div class="info-card">
                            <h5 class="mb-3">Current Inventory Summary</h5>
                            <div class="table-responsive">
                                <table class="table table-sm table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Fruit</th>
                                            <th class="text-end">System Quantity</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${inventory}" varStatus="status">
                                            <tr>
                                                <td>${item.fruitName}</td>
                                                <td class="text-end">
                                                    <c:choose>
                                                        <c:when test="${item.quantity <= 0}">
                                                            <span class="badge bg-danger">${item.quantity}</span>
                                                        </c:when>
                                                        <c:when test="${item.quantity <= 5}">
                                                            <span class="badge bg-warning text-dark">${item.quantity}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-success">${item.quantity}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                    <tfoot class="table-light">
                                        <tr>
                                            <th>Total Items</th>
                                            <th class="text-end">
                                                <jsp:useBean id="totalQuantity" class="java.lang.Integer" />
                                               
                                                <c:forEach var="item" items="${inventory}">
                                                    <jsp:setProperty name="totalQuantity" property="value" value="${totalQuantity + item.quantity}" />
                                                </c:forEach>
                                                ${totalQuantity}
                                            </th>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                            <div class="alert alert-info mt-3 mb-0">
                                <i class="fa fa-info-circle me-2"></i> 
                                Starting a new inventory count will create a list of all current fruits to count. You'll be able to enter the actual quantities on the next screen.
                            </div>
                        </div>
                        
                        <!-- Count Form -->
                        <form action="${pageContext.request.contextPath}/shop/inventory" method="post">
                            <input type="hidden" name="action" value="startCount">
                            
                            <div class="mb-3">
                                <label for="notes" class="form-label">Count Notes (Optional)</label>
                                <textarea class="form-control" id="notes" name="notes" rows="3" placeholder="Enter any notes or instructions for this inventory count"></textarea>
                                <div class="form-text">These notes will be visible to anyone who views this count session.</div>
                            </div>
                            
                            <div class="alert alert-warning">
                                <div class="d-flex">
                                    <div class="me-3">
                                        <i class="fa fa-triangle-exclamation fa-2x"></i>
                                    </div>
                                    <div>
                                        <h5 class="alert-heading">Important!</h5>
                                        <p class="mb-0">Once you start the count process, you'll need to go through all items and enter the actual physical quantities. Make sure you have time to complete this process.</p>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="text-end">
                                <a href="${pageContext.request.contextPath}/shop/inventory" class="btn btn-secondary me-2">Cancel</a>
                                <button type="submit" class="btn btn-primary">Start Inventory Count</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            
            <div class="col-md-5">
                <div class="card form-card">
                    <div class="card-header bg-info text-white">
                        <h4 class="mb-0"><i class="fa fa-circle-info me-2"></i> Inventory Count Guide</h4>
                    </div>
                    <div class="card-body">
                        <h5 class="mb-3">How to Perform an Inventory Count</h5>
                        
                        <ol class="count-steps">
                            <li>
                                <h6>Prepare the Area</h6>
                                <p>Ensure all items are properly organized to avoid counting errors.</p>
                            </li>
                            <li>
                                <h6>Start the Count</h6>
                                <p>Click "Start Inventory Count" to begin the process.</p>
                            </li>
                            <li>
                                <h6>Count Physical Items</h6>
                                <p>Go through each fruit type and count the actual quantity in stock.</p>
                            </li>
                            <li>
                                <h6>Enter Quantities</h6>
                                <p>Record the physical quantities in the system.</p>
                            </li>
                            <li>
                                <h6>Review Discrepancies</h6>
                                <p>Check the differences between expected and actual quantities.</p>
                            </li>
                            <li>
                                <h6>Complete the Count</h6>
                                <p>Finalize the count to apply any adjustments to inventory.</p>
                            </li>
                        </ol>
                        
                        <div class="alert alert-success mt-4">
                            <div class="d-flex">
                                <div class="me-3">
                                    <i class="fa fa-lightbulb fa-2x"></i>
                                </div>
                                <div>
                                    <h5 class="alert-heading">Best Practices</h5>
                                    <ul class="mb-0">
                                        <li>Perform counts during quiet periods</li>
                                        <li>Have two people count independently for accuracy</li>
                                        <li>Investigate discrepancies right away</li>
                                        <li>Perform regular counts to maintain accuracy</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="card form-card mt-4">
                    <div class="card-header bg-secondary text-white">
                        <h4 class="mb-0"><i class="fa fa-clock-rotate-left me-2"></i> Recent Counts</h4>
                    </div>
                    <div class="card-body">
                        <a href="${pageContext.request.contextPath}/shop/inventory?action=listCounts" class="btn btn-outline-primary mb-3">
                            <i class="fa fa-list me-1"></i> View All Counts
                        </a>
                        
                        <div class="alert alert-secondary">
                            <i class="fa fa-info-circle me-2"></i>
                            Regular inventory counts help identify discrepancies and maintain accurate stock levels.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>