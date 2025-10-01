<%-- 
    Document   : list
    Created on : 2025年4月20日, 上午11:15:16
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
    <title>User Management</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user-management.css">
</head>
<body>
    <jsp:include page="../includes/header.jsp" />
    
    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-md-2">
                <jsp:include page="../includes/sidebar.jsp" />
            </div>
            
            <div class="col-md-10">
                <div class="content-wrapper">
                    <div class="content-header">
                        <div class="container-fluid">
                            <div class="row mb-2">
                                <div class="col-sm-6">
                                    <h1 class="m-0">User Management</h1>
                                </div>
                                <div class="col-sm-6">
                                    <ol class="breadcrumb float-sm-end">
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/management/dashboard">Home</a></li>
                                        <li class="breadcrumb-item active">User Management</li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="content">
                        <div class="container-fluid">
                            <!-- Alert Messages -->
                            <c:if test="${not empty sessionScope.successMessage}">
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    ${sessionScope.successMessage}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                                <% session.removeAttribute("successMessage"); %>
                            </c:if>
                            
                            <c:if test="${not empty sessionScope.errorMessage}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    ${sessionScope.errorMessage}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                                <% session.removeAttribute("errorMessage"); %>
                            </c:if>
                            
                            <!-- Role & Status Overview -->
                            <div class="row">
                                <div class="col-md-3">
                                    <div class="small-box bg-info">
                                        <div class="inner">
                                            <h3>${totalUsers}</h3>
                                            <p>Total Users</p>
                                        </div>
                                        <div class="icon">
                                            <i class="fas fa-users"></i>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-md-3">
                                    <div class="small-box bg-success">
                                        <div class="inner">
                                            <h3>${roleCount['shop_staff'] != null ? roleCount['shop_staff'] : 0}</h3>
                                            <p>Shop Staff</p>
                                        </div>
                                        <div class="icon">
                                            <i class="fas fa-store"></i>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-md-3">
                                    <div class="small-box bg-warning">
                                        <div class="inner">
                                            <h3>${roleCount['warehouse_staff'] != null ? roleCount['warehouse_staff'] : 0}</h3>
                                            <p>Warehouse Staff</p>
                                        </div>
                                        <div class="icon">
                                            <i class="fas fa-warehouse"></i>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-md-3">
                                    <div class="small-box bg-danger">
                                        <div class="inner">
                                            <h3>${roleCount['senior_management'] != null ? roleCount['senior_management'] : 0}</h3>
                                            <p>Senior Management</p>
                                        </div>
                                        <div class="icon">
                                            <i class="fas fa-crown"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Filter & Actions -->
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <div class="card">
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-8">
                                                    <form action="${pageContext.request.contextPath}/management/users" method="get" class="form-inline">
                                                        <div class="row">
                                                            <div class="col-md-4">
                                                                <div class="input-group">
                                                                    <input type="text" class="form-control" placeholder="Search users..." name="search" value="${searchTerm}">
                                                                    <button class="btn btn-outline-secondary" type="submit">
                                                                        <i class="fas fa-search"></i>
                                                                    </button>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-3">
                                                                <select class="form-select" name="role" onchange="this.form.submit()">
                                                                    <option value="all" ${selectedRole == null || selectedRole == 'all' ? 'selected' : ''}>All Roles</option>
                                                                    <option value="shop_staff" ${selectedRole == 'shop_staff' ? 'selected' : ''}>Shop Staff</option>
                                                                    <option value="warehouse_staff" ${selectedRole == 'warehouse_staff' ? 'selected' : ''}>Warehouse Staff</option>
                                                                    <option value="senior_management" ${selectedRole == 'senior_management' ? 'selected' : ''}>Senior Management</option>
                                                                </select>
                                                            </div>
                                                            <div class="col-md-3">
                                                                <select class="form-select" name="status" onchange="this.form.submit()">
                                                                    <option value="all" ${selectedStatus == null || selectedStatus == 'all' ? 'selected' : ''}>All Status</option>
                                                                    <option value="active" ${selectedStatus == 'active' ? 'selected' : ''}>Active</option>
                                                                    <option value="inactive" ${selectedStatus == 'inactive' ? 'selected' : ''}>Inactive</option>
                                                                </select>
                                                            </div>
                                                            <div class="col-md-2">
                                                                <button type="submit" class="btn btn-primary">
                                                                    <i class="fas fa-filter"></i> Filter
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </form>
                                                </div>
                                                <div class="col-md-4 text-end">
                                                    <a href="${pageContext.request.contextPath}/management/users/create" class="btn btn-success">
                                                        <i class="fas fa-user-plus"></i> Add New User
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/management/users/dashboard" class="btn btn-info">
                                                        <i class="fas fa-chart-bar"></i> Dashboard
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Users Table -->
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title">
                                                <i class="fas fa-users me-1"></i>
                                                User Accounts
                                            </h3>
                                            <div class="card-tools">
                                                <span class="badge bg-primary">${totalUsers} users</span>
                                            </div>
                                        </div>
                                        <div class="card-body table-responsive p-0">
                                            <table class="table table-hover text-nowrap">
                                                <thead>
                                                    <tr>
                                                        <th>#</th>
                                                        <th>Username</th>
                                                        <th>Full Name</th>
                                                        <th>Email</th>
                                                        <th>Role</th>
                                                        <th>Location</th>
                                                        <th>Status</th>
                                                        <th>Last Login</th>
                                                        <th>Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="user" items="${users}" varStatus="loop">
                                                        <tr>
                                                            <td>${(currentPage - 1) * 10 + loop.index + 1}</td>
                                                            <td>${user.username}</td>
                                                            <td>${user.fullName}</td>
                                                            <td>${user.email}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${user.role eq 'shop_staff'}">
                                                                        <span class="badge bg-success">Shop Staff</span>
                                                                    </c:when>
                                                                    <c:when test="${user.role eq 'warehouse_staff'}">
                                                                        <span class="badge bg-warning">Warehouse Staff</span>
                                                                    </c:when>
                                                                    <c:when test="${user.role eq 'senior_management'}">
                                                                        <span class="badge bg-danger">Senior Management</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-secondary">${user.role}</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>${locationMap[user.locationID]}</td>
                                                            <td>
                                                                <div class="form-check form-switch">
                                                                    <input class="form-check-input status-toggle" type="checkbox" 
                                                                           data-user-id="${user.userID}" 
                                                                           ${user.status eq 'active' ? 'checked' : ''}>
                                                                    <label class="form-check-label ${user.status eq 'active' ? 'text-success' : 'text-danger'}">
                                                                        ${user.status eq 'active' ? 'Active' : 'Inactive'}
                                                                    </label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${user.lastLogin != null}">
                                                                        <fmt:formatDate value="${user.lastLogin}" pattern="yyyy-MM-dd HH:mm" />
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="text-muted">Never</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <div class="btn-group">
                                                                    <a href="${pageContext.request.contextPath}/management/users/view?id=${user.userID}" 
                                                                       class="btn btn-info btn-sm" title="View">
                                                                        <i class="fas fa-eye"></i>
                                                                    </a>
                                                                    <a href="${pageContext.request.contextPath}/management/users/edit?id=${user.userID}" 
                                                                       class="btn btn-primary btn-sm" title="Edit">
                                                                        <i class="fas fa-edit"></i>
                                                                    </a>
                                                                    <button type="button" class="btn btn-danger btn-sm delete-user" 
                                                                            data-user-id="${user.userID}" 
                                                                            data-user-name="${user.fullName}" 
                                                                            ${user.userID == sessionScope.user.userID ? 'disabled' : ''} 
                                                                            title="Delete">
                                                                        <i class="fas fa-trash"></i>
                                                                    </button>
                                                                    <button type="button" class="btn btn-warning btn-sm change-role" 
                                                                            data-user-id="${user.userID}" 
                                                                            data-user-name="${user.fullName}"
                                                                            data-current-role="${user.role}"
                                                                            ${user.userID == sessionScope.user.userID ? 'disabled' : ''} 
                                                                            title="Change Role">
                                                                        <i class="fas fa-user-tag"></i>
                                                                    </button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                    
                                                    <c:if test="${empty users}">
                                                        <tr>
                                                            <td colspan="9" class="text-center">No users found</td>
                                                        </tr>
                                                    </c:if>
                                                </tbody>
                                            </table>
                                        </div>
                                        
                                        <!-- Pagination -->
                                        <c:if test="${totalPages > 1}">
                                            <div class="card-footer clearfix">
                                                <ul class="pagination pagination-sm m-0 float-end">
                                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/management/users?page=1&search=${searchTerm}&role=${selectedRole}&status=${selectedStatus}">
                                                            <i class="fas fa-angle-double-left"></i>
                                                        </a>
                                                    </li>
                                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/management/users?page=${currentPage - 1}&search=${searchTerm}&role=${selectedRole}&status=${selectedStatus}">
                                                            <i class="fas fa-angle-left"></i>
                                                        </a>
                                                    </li>
                                                    
                                                    <c:forEach begin="${Math.max(1, currentPage - 2)}" end="${Math.min(totalPages, currentPage + 2)}" var="i">
                                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                            <a class="page-link" href="${pageContext.request.contextPath}/management/users?page=${i}&search=${searchTerm}&role=${selectedRole}&status=${selectedStatus}">${i}</a>
                                                        </li>
                                                    </c:forEach>
                                                    
                                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/management/users?page=${currentPage + 1}&search=${searchTerm}&role=${selectedRole}&status=${selectedStatus}">
                                                            <i class="fas fa-angle-right"></i>
                                                        </a>
                                                    </li>
                                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/management/users?page=${totalPages}&search=${searchTerm}&role=${selectedRole}&status=${selectedStatus}">
                                                            <i class="fas fa-angle-double-right"></i>
                                                        </a>
                                                    </li>
                                                </ul>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Confirm Deletion</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete user <span id="deleteUserName"></span>?</p>
                    <p class="text-danger">This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <a href="#" id="confirmDelete" class="btn btn-danger">Delete</a>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Change Role Modal -->
    <div class="modal fade" id="roleModal" tabindex="-1" aria-labelledby="roleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="roleModalLabel">Change User Role</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Change role for user <span id="roleUserName"></span>:</p>
                    <form id="roleForm">
                        <input type="hidden" id="roleUserId" name="userId" value="">
                        <div class="form-group">
                            <label for="roleSelect">Select Role:</label>
                            <select class="form-select" id="roleSelect" name="role">
                                <option value="shop_staff">Shop Staff</option>
                                <option value="warehouse_staff">Warehouse Staff</option>
                                <option value="senior_management">Senior Management</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" id="confirmRoleChange" class="btn btn-primary">Save Changes</button>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            // Delete user confirmation
            $('.delete-user').click(function() {
                const userId = $(this).data('user-id');
                const userName = $(this).data('user-name');
                
                $('#deleteUserName').text(userName);
                $('#confirmDelete').attr('href', '${pageContext.request.contextPath}/management/users/delete?id=' + userId);
                
                var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
                deleteModal.show();
            });
            
            // Change role modal
            $('.change-role').click(function() {
                const userId = $(this).data('user-id');
                const userName = $(this).data('user-name');
                const currentRole = $(this).data('current-role');
                
                $('#roleUserName').text(userName);
                $('#roleUserId').val(userId);
                $('#roleSelect').val(currentRole);
                
                var roleModal = new bootstrap.Modal(document.getElementById('roleModal'));
                roleModal.show();
            });
            
            // Handle role change confirmation
            $('#confirmRoleChange').click(function() {
                const userId = $('#roleUserId').val();
                const role = $('#roleSelect').val();
                
                $.ajax({
                    url: '${pageContext.request.contextPath}/management/users',
                    type: 'POST',
                    data: {
                        action: 'updateRole',
                        userId: userId,
                        role: role
                    },
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            // Close modal and reload page
                            var roleModal = bootstrap.Modal.getInstance(document.getElementById('roleModal'));
                            roleModal.hide();
                            
                            // Show success alert and reload
                            alert(response.message);
                            location.reload();
                        } else {
                            alert(response.message);
                        }
                    },
                    error: function() {
                        alert('An error occurred while updating the role');
                    }
                });
            });
            
            // Status toggle switch
            $('.status-toggle').change(function() {
                const userId = $(this).data('user-id');
                const isChecked = $(this).is(':checked');
                const status = isChecked ? 'active' : 'inactive';
                const label = $(this).siblings('label');
                
                $.ajax({
                    url: '${pageContext.request.contextPath}/management/users',
                    type: 'POST',
                    data: {
                        action: 'updateStatus',
                        userId: userId,
                        status: status
                    },
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            // Update label
                            label.text(isChecked ? 'Active' : 'Inactive');
                            label.removeClass(isChecked ? 'text-danger' : 'text-success');
                            label.addClass(isChecked ? 'text-success' : 'text-danger');
                        } else {
                            alert(response.message);
                            // Revert the toggle if failed
                            $(this).prop('checked', !isChecked);
                            location.reload();
                        }
                    },
                    error: function() {
                        alert('An error occurred while updating the status');
                        // Revert the toggle if failed
                        $(this).prop('checked', !isChecked);
                        location.reload();
                    }
                });
            });
        });
    </script>
</body>
</html>