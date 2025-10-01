<%-- 
    Document   : form
    Created on : 2025年4月20日, 上午11:21:28
    Author     : kelvin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${editMode ? 'Edit' : 'Create'} User</title>
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
                                    <h1 class="m-0">${editMode ? 'Edit' : 'Create'} User</h1>
                                </div>
                                <div class="col-sm-6">
                                    <ol class="breadcrumb float-sm-end">
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/management/dashboard">Home</a></li>
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/management/users">User Management</a></li>
                                        <li class="breadcrumb-item active">${editMode ? 'Edit' : 'Create'} User</li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="content">
                        <div class="container-fluid">
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title">
                                                <i class="fas fa-${editMode ? 'edit' : 'user-plus'} me-1"></i>
                                                ${editMode ? 'Edit' : 'Create'} User Account
                                            </h3>
                                        </div>
                                        
                                        <form action="${pageContext.request.contextPath}/management/users" method="post" id="userForm">
                                            <input type="hidden" name="action" value="${editMode ? 'update' : 'create'}">
                                            <c:if test="${editMode}">
                                                <input type="hidden" name="userId" value="${user.userID}">
                                            </c:if>
                                            
                                            <div class="card-body">
                                                <c:if test="${not empty errorMessage}">
                                                    <div class="alert alert-danger" role="alert">
                                                        ${errorMessage}
                                                    </div>
                                                </c:if>
                                                
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <div class="form-group mb-3">
                                                            <label for="username">Username</label>
                                                            <input type="text" class="form-control" id="username" name="username" 
                                                                   value="${user.username}" required>
                                                            <small class="form-text text-muted">Username must be unique</small>
                                                        </div>
                                                        
                                                        <div class="form-group mb-3">
                                                            <label for="password">Password</label>
                                                            <input type="password" class="form-control" id="password" name="password" 
                                                                   ${editMode ? '' : 'required'}>
                                                            <small class="form-text text-muted">
                                                                ${editMode ? 'Leave blank to keep current password' : 'Enter a secure password'}
                                                            </small>
                                                        </div>
                                                        
                                                        <div class="form-group mb-3">
                                                            <label for="confirmPassword">Confirm Password</label>
                                                            <input type="password" class="form-control" id="confirmPassword" 
                                                                   ${editMode ? '' : 'required'}>
                                                            <small id="passwordMatch" class="form-text"></small>
                                                        </div>
                                                        
                                                        <div class="form-group mb-3">
                                                            <label for="email">Email</label>
                                                            <input type="email" class="form-control" id="email" name="email" 
                                                                   value="${user.email}" required>
                                                            <small class="form-text text-muted">Email must be unique</small>
                                                        </div>
                                                    </div>
                                                    
                                                    <div class="col-md-6">
                                                        <div class="form-group mb-3">
                                                            <label for="fullName">Full Name</label>
                                                            <input type="text" class="form-control" id="fullName" name="fullName" 
                                                                   value="${user.fullName}" required>
                                                        </div>
                                                        
                                                        <div class="form-group mb-3">
                                                            <label for="phone">Phone</label>
                                                            <input type="text" class="form-control" id="phone" name="phone" 
                                                                   value="${user.phone}">
                                                        </div>
                                                        
                                                        <div class="form-group mb-3">
                                                            <label for="role">Role</label>
                                                            <select class="form-select" id="role" name="role" required>
                                                                <option value="">-- Select Role --</option>
                                                                <c:forEach var="roleEntry" items="${availableRoles}">
                                                                    <option value="${roleEntry.key}" ${user.role eq roleEntry.key ? 'selected' : ''}>
                                                                        ${roleEntry.value}
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                        
                                                        <div class="form-group mb-3">
                                                            <label for="locationId">Location</label>
                                                            <select class="form-select" id="locationId" name="locationId" required>
                                                                <option value="">-- Select Location --</option>
                                                                <c:forEach var="location" items="${locations}">
                                                                    <option value="${location.locationID}" ${user.locationID eq location.locationID ? 'selected' : ''}>
                                                                        ${location.locationName} - ${location.locationType} (${location.city}, ${location.country})
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                        
                                                        <div class="form-group mb-3">
                                                            <label for="status">Status</label>
                                                            <select class="form-select" id="status" name="status" required>
                                                                <option value="active" ${user.status eq 'active' || empty user.status ? 'selected' : ''}>Active</option>
                                                                <option value="inactive" ${user.status eq 'inactive' ? 'selected' : ''}>Inactive</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="card-footer">
                                                <button type="submit" class="btn btn-primary" id="submitBtn">
                                                    <i class="fas fa-save"></i> ${editMode ? 'Update' : 'Create'} User
                                                </button>
                                                <a href="${pageContext.request.contextPath}/management/users" class="btn btn-secondary">
                                                    <i class="fas fa-times"></i> Cancel
                                                </a>
                                            </div>
                                        </form>
                                    </div>
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
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            // Password match validation
            $('#password, #confirmPassword').on('keyup', function () {
                const password = $('#password').val();
                const confirmPassword = $('#confirmPassword').val();
                const passwordMatchElement = $('#passwordMatch');
                
                if (password === '' && confirmPassword === '') {
                    passwordMatchElement.text('');
                    passwordMatchElement.removeClass('text-success text-danger');
                } else if (password === confirmPassword) {
                    passwordMatchElement.text('Passwords match');
                    passwordMatchElement.removeClass('text-danger').addClass('text-success');
                } else {
                    passwordMatchElement.text('Passwords do not match');
                    passwordMatchElement.removeClass('text-success').addClass('text-danger');
                }
            });
            
            // Form validation before submit
            $('#userForm').on('submit', function(e) {
                const password = $('#password').val();
                const confirmPassword = $('#confirmPassword').val();
                
                // In edit mode, password is optional
                const editMode = ${editMode ? 'true' : 'false'};
                
                if (password !== confirmPassword) {
                    e.preventDefault();
                    alert('Passwords do not match');
                    return false;
                }
                
                // In edit mode, if password field is empty, it's fine
                if (!editMode && password.trim() === '') {
                    e.preventDefault();
                    alert('Password is required');
                    return false;
                }
                
                // If password is provided in edit mode, ensure it's confirmed
                if (editMode && password.trim() !== '' && confirmPassword.trim() === '') {
                    e.preventDefault();
                    alert('Please confirm your password');
                    return false;
                }
                
                return true;
            });
        });
    </script>
</body>
</html>
