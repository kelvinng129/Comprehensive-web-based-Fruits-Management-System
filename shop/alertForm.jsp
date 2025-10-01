<%-- 
    Document   : alertForm
    Created on : 2025年4月19日, 下午12:12:29
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
    <title>${alert != null ? 'Edit' : 'Create'} Inventory Alert - Fruit Management System</title>
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
        .alert-type-box {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            background-color: #f8f9fa;
        }
        .alert-type-box:hover {
            background-color: #e9ecef;
            cursor: pointer;
        }
        .alert-type-box.selected {
            border-color: #0d6efd;
            background-color: #cfe2ff;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/shopHeader.jsp" />
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>${alert != null ? 'Edit' : 'Create'} Inventory Alert</h1>
            <div>
                <a href="${pageContext.request.contextPath}/shop/inventory?action=listAlerts" class="btn btn-outline-secondary me-2">
                    <i class="fa fa-list me-1"></i> All Alerts
                </a>
                <a href="${pageContext.request.contextPath}/shop/inventory" class="btn btn-secondary">
                    <i class="fa fa-arrow-left me-1"></i> Dashboard
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
            <div class="col-md-7">
                <div class="card form-card">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0"><i class="fa fa-bell me-2"></i> ${alert != null ? 'Edit' : 'Create'} Alert</h4>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/shop/inventory" method="post">
                            <input type="hidden" name="action" value="${alert != null ? 'updateAlert' : 'createAlert'}">
                            <c:if test="${alert != null}">
                                <input type="hidden" name="alertId" value="${alert.alertId}">
                            </c:if>
                            
                            <div class="mb-3">
                                <label for="alertName" class="form-label">Alert Name</label>
                                <input type="text" class="form-control" id="alertName" name="alertName" 
                                       value="${alert != null ? alert.alertName : ''}" required>
                                <div class="form-text">A descriptive name for this alert.</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="fruitId" class="form-label">Fruit</label>
                                <select class="form-select" id="fruitId" name="fruitId">
                                    <option value="all" ${alert != null && alert.fruitId == 0 ? 'selected' : ''}>All Fruits</option>
                                    <c:forEach var="fruit" items="${fruits}">
                                        <option value="${fruit.fruitId}" ${alert != null && alert.fruitId == fruit.fruitId ? 'selected' : ''}>
                                            ${fruit.name}
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="form-text">Select a specific fruit or "All Fruits" to apply this alert globally.</div>
                            </div>
                            
                            <div class="mb-4">
                                <label class="form-label">Alert Type</label>
                                <div class="row">
                                    <div class="col-md-4 mb-2">
                                        <div class="alert-type-box ${alert != null && alert.alertType == 'lowStock' ? 'selected' : ''}" data-alert-type="lowStock">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="alertType" id="lowStockAlert" 
                                                       value="lowStock" ${alert != null && alert.alertType == 'lowStock' ? 'checked' : ''} required>
                                                <label class="form-check-label" for="lowStockAlert">
                                                    <i class="fa fa-triangle-exclamation text-warning me-2"></i> Low Stock
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4 mb-2">
                                        <div class="alert-type-box ${alert != null && alert.alertType == 'expirySoon' ? 'selected' : ''}" data-alert-type="expirySoon">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="alertType" id="expiryAlert" 
                                                       value="expirySoon" ${alert != null && alert.alertType == 'expirySoon' ? 'checked' : ''} required>
                                                <label class="form-check-label" for="expiryAlert">
                                                    <i class="fa fa-calendar-xmark text-danger me-2"></i> Expiry Soon
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4 mb-2">
                                        <div class="alert-type-box ${alert != null && alert.alertType == 'highStock' ? 'selected' : ''}" data-alert-type="highStock">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="alertType" id="highStockAlert" 
                                                       value="highStock" ${alert != null && alert.alertType == 'highStock' ? 'checked' : ''} required>
                                                <label class="form-check-label" for="highStockAlert">
                                                    <i class="fa fa-chart-line text-success me-2"></i> High Stock
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Alert Threshold Settings - shown/hidden based on alert type -->
                            <div id="thresholdSettings">
                                <div id="lowStockSettings" class="alert-settings" style="display: none;">
                                    <div class="mb-3">
                                        <label for="lowStockThreshold" class="form-label">Low Stock Threshold</label>
                                        <div class="input-group">
                                            <input type="number" class="form-control" id="lowStockThreshold" name="threshold" 
                                                   value="${alert != null && alert.alertType == 'lowStock' ? alert.threshold : '5'}" min="1">
                                            <span class="input-group-text">units</span>
                                        </div>
                                        <div class="form-text">Alert will trigger when stock falls at or below this level.</div>
                                    </div>
                                </div>
                                
                                <div id="expirySettings" class="alert-settings" style="display: none;">
                                    <div class="mb-3">
                                        <label for="expiryThreshold" class="form-label">Expiry Warning Threshold</label>
                                        <div class="input-group">
                                            <input type="number" class="form-control" id="expiryThreshold" name="threshold" 
                                                   value="${alert != null && alert.alertType == 'expirySoon' ? alert.threshold : '7'}" min="1">
                                            <span class="input-group-text">days</span>
                                        </div>
                                        <div class="form-text">Alert will trigger when items are within this many days of expiry.</div>
                                    </div>
                                </div>
                                
                                <div id="highStockSettings" class="alert-settings" style="display: none;">
                                    <div class="mb-3">
                                        <label for="highStockThreshold" class="form-label">High Stock Threshold</label>
                                        <div class="input-group">
                                            <input type="number" class="form-control" id="highStockThreshold" name="threshold" 
                                                   value="${alert != null && alert.alertType == 'highStock' ? alert.threshold : '100'}" min="1">
                                            <span class="input-group-text">units</span>
                                        </div>
                                        <div class="form-text">Alert will trigger when stock rises above this level.</div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="alertMessage" class="form-label">Alert Message</label>
                                <textarea class="form-control" id="alertMessage" name="alertMessage" rows="3" required>${alert != null ? alert.alertMessage : ''}</textarea>
                                <div class="form-text">The message to display when this alert is triggered.</div>
                            </div>
                            
                            <div class="mb-4">
                                <label class="form-label">Alert Status</label>
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" role="switch" id="alertEnabled" name="enabled" 
                                           ${alert == null || (alert != null && alert.enabled) ? 'checked' : ''}>
                                    <label class="form-check-label" for="alertEnabled">Enable this alert</label>
                                </div>
                            </div>
                            
                            <div class="text-end">
                                <a href="${pageContext.request.contextPath}/shop/inventory?action=listAlerts" class="btn btn-secondary me-2">Cancel</a>
                                <button type="submit" class="btn btn-primary">
                                    ${alert != null ? 'Update' : 'Create'} Alert
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            
            <div class="col-md-5">
                <div class="card form-card">
                    <div class="card-header bg-info text-white">
                        <h4 class="mb-0"><i class="fa fa-circle-info me-2"></i> Alert Information</h4>
                    </div>
                    <div class="card-body">
                        <div class="mb-4">
                            <h5><i class="fa fa-triangle-exclamation text-warning me-2"></i> Low Stock Alerts</h5>
                            <p>Low stock alerts help you maintain adequate inventory levels by notifying you when stock falls below a specified threshold.</p>
                            <ul>
                                <li>Prevents stockouts</li>
                                <li>Ensures you can fulfill customer orders</li>
                                <li>Helps plan reordering in advance</li>
                            </ul>
                        </div>
                        
                        <div class="mb-4">
                            <h5><i class="fa fa-calendar-xmark text-danger me-2"></i> Expiry Alerts</h5>
                            <p>Expiry alerts notify you when items are approaching their expiration date, helping to reduce wastage.</p>
                            <ul>
                                <li>Identifies items nearing expiry</li>
                                <li>Helps prioritize older stock for sale or use</li>
                                <li>Reduces financial losses from expired inventory</li>
                            </ul>
                        </div>
                        
                        <div class="mb-4">
                            <h5><i class="fa fa-chart-line text-success me-2"></i> High Stock Alerts</h5>
                            <p>High stock alerts help prevent overstock situations that can lead to storage problems or excessive capital tied up in inventory.</p>
                            <ul>
                                <li>Prevents overordering</li>
                                <li>Optimizes storage space</li>
                                <li>Reduces risk of wastage for perishable items</li>
                            </ul>
                        </div>
                        
                        <div class="alert alert-warning">
                            <div class="d-flex">
                                <div class="me-3">
                                    <i class="fa fa-lightbulb fa-2x"></i>
                                </div>
                                <div>
                                    <h5 class="alert-heading">Tips for Effective Alerts</h5>
                                    <ul class="mb-0">
                                        <li>Set appropriate thresholds based on usage patterns</li>
                                        <li>Create specific alerts for high-value or critical items</li>
                                        <li>Use clear, actionable alert messages</li>
                                        <li>Review and adjust alert settings periodically</li>
                                    </ul>
                                </div>
                            </div>
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
            const alertTypeBoxes = document.querySelectorAll('.alert-type-box');
            const alertSettings = document.querySelectorAll('.alert-settings');
            const alertTypeRadios = document.querySelectorAll('input[name="alertType"]');
            
            // Click anywhere in the box to select radio button
            alertTypeBoxes.forEach(box => {
                box.addEventListener('click', function() {
                    const alertType = this.getAttribute('data-alert-type');
                    const radio = document.querySelector(`input[value="${alertType}"]`);
                    radio.checked = true;
                    
                    // Add selected class to clicked box, remove from others
                    alertTypeBoxes.forEach(b => b.classList.remove('selected'));
                    this.classList.add('selected');
                    
                    // Show appropriate settings section
                    alertSettings.forEach(setting => setting.style.display = 'none');
                    document.getElementById(`${alertType}Settings`).style.display = 'block';
                });
            });
            
            // Radio button change handler
            alertTypeRadios.forEach(radio => {
                radio.addEventListener('change', function() {
                    if (this.checked) {
                        const alertType = this.value;
                        
                        // Add selected class to parent box
                        alertTypeBoxes.forEach(b => b.classList.remove('selected'));
                        this.closest('.alert-type-box').classList.add('selected');
                        
                        // Show appropriate settings section
                        alertSettings.forEach(setting => setting.style.display = 'none');
                        document.getElementById(`${alertType}Settings`).style.display = 'block';
                    }
                });
            });
            
            // Initialize settings based on selected alert type
            const selectedRadio = document.querySelector('input[name="alertType"]:checked');
            if (selectedRadio) {
                const alertType = selectedRadio.value;
                alertSettings.forEach(setting => setting.style.display = 'none');
                document.getElementById(`${alertType}Settings`).style.display = 'block';
            } else if (alertTypeRadios.length > 0) {
                // Select first by default if none selected
                alertTypeRadios[0].checked = true;
                alertTypeRadios[0].closest('.alert-type-box').classList.add('selected');
                alertSettings.forEach(setting => setting.style.display = 'none');
                document.getElementById(`${alertTypeRadios[0].value}Settings`).style.display = 'block';
            }
            
            // Form validation
            document.querySelector('form').addEventListener('submit', function(event) {
                const alertName = document.getElementById('alertName').value.trim();
                const alertMessage = document.getElementById('alertMessage').value.trim();
                
                if (alertName === '') {
                    alert('Please enter an alert name.');
                    event.preventDefault();
                    return;
                }
                
                if (alertMessage === '') {
                    alert('Please enter an alert message.');
                    event.preventDefault();
                    return;
                }
                
                const selectedRadio = document.querySelector('input[name="alertType"]:checked');
                if (!selectedRadio) {
                    alert('Please select an alert type.');
                    event.preventDefault();
                    return;
                }
                
                const alertType = selectedRadio.value;
                let thresholdInput;
                
                switch (alertType) {
                    case 'lowStock':
                        thresholdInput = document.getElementById('lowStockThreshold');
                        break;
                    case 'expirySoon':
                        thresholdInput = document.getElementById('expiryThreshold');
                        break;
                    case 'highStock':
                        thresholdInput = document.getElementById('highStockThreshold');
                        break;
                }
                
                if (!thresholdInput.value || parseInt(thresholdInput.value) < 1) {
                    alert('Please enter a valid threshold value (minimum 1).');
                    event.preventDefault();
                    return;
                }
            });
        });
    </script>
</body>
</html>