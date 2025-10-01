<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="../include/header.jsp">
    <jsp:param name="title" value="Create Borrow Request" />
    <jsp:param name="pageCss" value="borrowing" />
</jsp:include>

<jsp:include page="../include/pageHeader.jsp">
    <jsp:param name="pageTitle" value="Create New Borrow Request" />
    <jsp:param name="description" value="Borrow fruits from other shops" />
    <jsp:param name="showBreadcrumb" value="true" />
    <jsp:param name="breadcrumbParent" value="Borrowing" />
    <jsp:param name="breadcrumbParentUrl" value="borrowing?action=list" />
    <jsp:param name="breadcrumbActive" value="Create Borrow Request" />
</jsp:include>

<div class="container">
    <div class="section">
        <%@ include file="../include/message.jsp" %>
        
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">Borrow Request Details</h5>
            </div>
            <div class="card-body">
                <form id="borrowForm" action="${pageContext.request.contextPath}/borrowing" method="post" class="needs-validation" novalidate>
                    <input type="hidden" name="action" value="create">
                    
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="lendingShopId">Lending Shop <span class="text-danger">*</span></label>
                            <select class="form-control" id="lendingShopId" name="lendingShopId" required onchange="loadShopInventory()">
                                <option value="">Select Shop</option>
                                <c:forEach var="shop" items="${shops}">
                                    <option value="${shop.locationID}">${shop.locationName} (${shop.city}, ${shop.country})</option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">
                                Please select a shop to borrow from.
                            </div>
                        </div>
                        
                        <div class="form-group col-md-6">
                            <label for="returnDate">Return Date <span class="text-danger">*</span></label>
                            <input type="date" class="form-control" id="returnDate" name="returnDate" required min="${java.time.LocalDate.now().plusDays(1)}">
                            <div class="invalid-feedback">
                                Please select a valid return date (must be future date).
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="notes">Notes</label>
                        <textarea class="form-control" id="notes" name="notes" rows="3" placeholder="Any special instructions or requirements"></textarea>
                    </div>
                    
                    <hr class="my-4">
                    
                    <div id="shopInventorySection" class="d-none">
                        <h5 class="mb-3">Available Fruits to Borrow</h5>
                        
                        <div class="table-responsive">
                            <table class="table table-bordered" id="itemsTable">
                                <thead class="bg-light">
                                    <tr>
                                        <th>Fruit</th>
                                        <th>Available Quantity</th>
                                        <th>Borrow Quantity</th>
                                        <th class="text-center" style="width: 80px;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="shopInventory">
                                    <tr>
                                        <td colspan="4" class="text-center">Please select a shop first to see available fruits</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        
                        <div class="selected-items mt-4 mb-4">
                            <h5 class="mb-3">Selected Items to Borrow</h5>
                            <div class="table-responsive">
                                <table class="table table-bordered" id="selectedItemsTable">
                                    <thead class="bg-light">
                                        <tr>
                                            <th>Fruit</th>
                                            <th>Quantity</th>
                                            <th class="text-center" style="width: 80px;">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="selectedItems">
                                        <tr id="no-items-row">
                                            <td colspan="3" class="text-center">No items selected yet</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-actions mt-4 text-right">
                        <a href="${pageContext.request.contextPath}/borrowing?action=list" class="btn btn-secondary mr-2">Cancel</a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save mr-1"></i> Create Borrow Request
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
let selectedFruits = {};

function loadShopInventory() {
    const shopId = document.getElementById('lendingShopId').value;
    
    if (!shopId) {
        document.getElementById('shopInventorySection').classList.add('d-none');
        return;
    }
    
    document.getElementById('shopInventorySection').classList.remove('d-none');
    
    // AJAX request to get shop inventory
    fetch('${pageContext.request.contextPath}/inventory?action=getShopInventory&shopId=' + shopId)
        .then(response => response.json())
        .then(data => {
            const inventoryTable = document.getElementById('shopInventory');
            
            if (data.length === 0) {
                inventoryTable.innerHTML = '<tr><td colspan="4" class="text-center">No fruits available in this shop</td></tr>';
                return;
            }
            
            let tableHtml = '';
            
            data.forEach(item => {
                tableHtml += `
                    <tr>
                        <td>${item.fruitName}</td>
                        <td>${item.quantity}</td>
                        <td>
                            <input type="number" class="form-control form-control-sm borrow-quantity" 
                                   min="1" max="${item.quantity}" value="1" 
                                   data-fruit-id="${item.fruitId}" 
                                   data-fruit-name="${item.fruitName}">
                        </td>
                        <td class="text-center">
                            <button type="button" class="btn btn-primary btn-sm" onclick="addToSelection(${item.fruitId}, '${item.fruitName}')">
                                <i class="fas fa-plus"></i>
                            </button>
                        </td>
                    </tr>
                `;
            });
            
            inventoryTable.innerHTML = tableHtml;
        })
        .catch(error => {
            console.error('Error loading shop inventory:', error);
            document.getElementById('shopInventory').innerHTML = '<tr><td colspan="4" class="text-center text-danger">Error loading inventory data</td></tr>';
        });
}

function addToSelection(fruitId, fruitName) {
    const quantityInput = document.querySelector(`.borrow-quantity[data-fruit-id="${fruitId}"]`);
    const quantity = parseInt(quantityInput.value);
    
    if (isNaN(quantity) || quantity <= 0 || quantity > parseInt(quantityInput.getAttribute('max'))) {
        alert('Please enter a valid quantity between 1 and ' + quantityInput.getAttribute('max'));
        return;
    }
    
    // If this fruit is already selected, update the quantity
    if (selectedFruits[fruitId]) {
        selectedFruits[fruitId].quantity += quantity;
    } else {
        selectedFruits[fruitId] = {
            id: fruitId,
            name: fruitName,
            quantity: quantity
        };
    }
    
    updateSelectedItemsTable();
}

function removeFromSelection(fruitId) {
    delete selectedFruits[fruitId];
    updateSelectedItemsTable();
}

function updateSelectedItemsTable() {
    const selectedItemsTable = document.getElementById('selectedItems');
    const noItemsRow = document.getElementById('no-items-row');
    
    if (Object.keys(selectedFruits).length === 0) {
        noItemsRow.style.display = '';
        return;
    }
    
    noItemsRow.style.display = 'none';
    
    let tableHtml = '';
    
    for (const fruitId in selectedFruits) {
        const fruit = selectedFruits[fruitId];
        
        tableHtml += `
            <tr>
                <td>${fruit.name}</td>
                <td>
                    <input type="hidden" name="fruitId" value="${fruit.id}">
                    <input type="number" class="form-control" name="quantity" value="${fruit.quantity}" readonly>
                </td>
                <td class="text-center">
                    <button type="button" class="btn btn-danger btn-sm" onclick="removeFromSelection(${fruit.id})">
                        <i class="fas fa-trash"></i>
                    </button>
                </td>
            </tr>
        `;
    }
    
    selectedItemsTable.innerHTML = tableHtml + noItemsRow.outerHTML;
}

// Validate form on submit
document.getElementById('borrowForm').addEventListener('submit', function(event) {
    if (Object.keys(selectedFruits).length === 0) {
        event.preventDefault();
        alert('Please select at least one item to borrow');
        return false;
    }
});
</script>

<jsp:include page="../include/footer.jsp">
    <jsp:param name="pageJs" value="borrowing" />
</jsp:include>