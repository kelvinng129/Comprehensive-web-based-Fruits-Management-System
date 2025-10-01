<%-- 
    Document   : profile
    Created on : 2025年4月20日, 上午11:43:06
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
    <title>User Profile</title>
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
                                    <h1 class="m-0">User Profile</h1>
                                </div>
                                <div class="col-sm-6">
                                    <ol class="breadcrumb float-sm-end">
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/management/dashboard">Home</a></li>
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/management/users">User Management</a></li>
                                        <li class="breadcrumb-item active">User Profile</li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="content">
                        <div class="container-fluid">
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="card card-primary card-outline">
                                        <div class="card-body box-profile">
                                            <div class="text-center">
                                                <img class="profile-user-img img-fluid img-circle"
                                                     src="${pageContext.request.contextPath}/images/user-avatar.png"
                                                     alt="User profile picture">
                                            </div>
                                            
                                            <h3 class="profile-username text-center">${user.fullName}</h3>
                                            
                                            <p class="text-muted text-center">
                                                <c:choose>
                                                    <c:when test="${user.role eq 'shop_staff'}">Shop Staff</c:when>
                                                    <c:when test="${user.role eq 'warehouse_staff'}">Warehouse Staff</c:when>
                                                    <c:when test="${user.role eq 'senior_management'}">Senior Management</c:when>
                                                    <c:otherwise>${user.role}</c:otherwise>
                                                </c:choose>
                                            </p>
                                            
                                            <ul class="list-group list-group-unbordered mb-3">
                                                <li class="list-group-item">
                                                    <b>Username</b> <a class="float-end">${user.username}</a>
                                                </li>
                                                <li class="list-group-item">
                                                    <b>Email</b> <a class="float-end">${user.email}</a>
                                                </li>
                                                <li class="list-group-item">
                                                    <b>Status</b> 
                                                    <span class="float-end badge ${user.status eq 'active' ? 'bg-success' : 'bg-danger'}">
                                                        ${user.status}
                                                    </span>
                                                </li>
                                            </ul>
                                            
                                            <a href="${pageContext.request.contextPath}/management/users/edit?id=${user.userID}" class="btn btn-primary btn-block">
                                                <i class="fas fa-edit"></i> Edit
                                            </a>
                                            
                                            <c:if test="${user.userID != sessionScope.user.userID}">
                                                <button type="button" class="btn btn-danger btn-block mt-2 delete-user" 
                                                        data-user-id="${user.userID}" 
                                                        data-user-name="${user.fullName}">
                                                    <i class="fas fa-trash"></i> Delete
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                    
                                    <div class="card card-primary">
                                        <div class="card-header">
                                            <h3 class="card-title">Contact Information</h3>
                                        </div>
                                        <div class="card-body">
                                            <strong><i class="fas fa-phone mr-1"></i> Phone</strong>
                                            <p class="text-muted">${not empty user.phone ? user.phone : 'N/A'}</p>
                                            <hr>
                                            
                                            <strong><i class="fas fa-map-marker-alt mr-1"></i> Location</strong>
                                            <p class="text-muted">${locationName}</p>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-md-8">
                                    <div class="card">
                                        <div class="card-header p-2">
                                            <ul class="nav nav-pills">
                                                <li class="nav-item">
                                                    <a class="nav-link active" href="#activity" data-bs-toggle="tab">Activity</a>
                                                </li>
                                                <li class="nav-item">
                                                    <a class="nav-link" href="#timeline" data-bs-toggle="tab">Timeline</a>
                                                </li>
                                                <li class="nav-item">
                                                    <a class="nav-link" href="#settings" data-bs-toggle="tab">Settings</a>
                                                </li>
                                            </ul>
                                        </div>
                                        <div class="card-body">
                                            <div class="tab-content">
                                                <div class="tab-pane active" id="activity">
                                                    <div class="user-activity">
                                                        <p class="lead">Account Information</p>
                                                        <div class="table-responsive">
                                                            <table class="table table-striped">
                                                                <tbody>
                                                                    <tr>
                                                                        <td>User ID</td>
                                                                        <td>${user.userID}</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>Last Login</td>
                                                                        <td>
                                                                            <c:choose>
                                                                                <c:when test="${user.lastLogin != null}">
                                                                                    <fmt:formatDate value="${user.lastLogin}" pattern="yyyy-MM-dd HH:mm:ss" />
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span class="text-muted">Never</span>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>Account Created</td>
                                                                        <td>
                                                                            <fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>Last Updated</td>
                                                                        <td>
                                                                            <fmt:formatDate value="${user.updatedAt}" pattern="yyyy-MM-dd HH:mm:ss" />
                                                                        </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                        
                                                        <p class="lead mt-4">Recent Activity (Placeholder)</p>
                                                        <div class="post">
                                                            <div class="user-block">
                                                                <img class="img-circle img-bordered-sm" src="${pageContext.request.contextPath}/images/user-avatar.png" alt="User Image">
                                                                <span class="username">
                                                                    <a href="#">${user.fullName}</a>
                                                                </span>
                                                                <span class="description">Logged in - 7 minutes ago</span>
                                                            </div>
                                                            <p>User logged in from 192.168.1.1 using Chrome on Windows.</p>
                                                        </div>
                                                        
                                                        <div class="post">
                                                            <div class="user-block">
                                                                <img class="img-circle img-bordered-sm" src="${pageContext.request.contextPath}/images/user-avatar.png" alt="User Image">
                                                                <span class="username">
                                                                    <a href="#">${user.fullName}</a>
                                                                </span>
                                                                <span class="description">Updated inventory - 1 day ago</span>
                                                            </div>
                                                            <p>User updated inventory for Apple, Banana, and Orange.</p>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <div class="tab-pane" id="timeline">
                                                    <div class="timeline timeline-inverse">
                                                        <div class="time-label">
                                                            <span class="bg-danger">
                                                                <fmt:formatDate value="${user.createdAt}" pattern="dd MMM yyyy" />
                                                            </span>
                                                        </div>
                                                        
                                                        <div>
                                                            <i class="fas fa-user bg-primary"></i>
                                                            <div class="timeline-item">
                                                                <span class="time"><i class="far fa-clock"></i> <fmt:formatDate value="${user.createdAt}" pattern="HH:mm" /></span>
                                                                <h3 class="timeline-header"><a href="#">System</a> created user account</h3>
                                                                <div class="timeline-body">
                                                                    User account was created with username: ${user.username}
                                                                </div>
                                                            </div>
                                                        </div>
                                                        
                                                        <c:if test="${user.lastLogin != null}">
                                                            <div class="time-label">
                                                                <span class="bg-success">
                                                                    <fmt:formatDate value="${user.lastLogin}" pattern="dd MMM yyyy" />
                                                                </span>
                                                            </div>
                                                            
                                                            <div>
                                                                <i class="fas fa-sign-in-alt bg-info"></i>
                                                                <div class="timeline-item">
                                                                    <span class="time"><i class="far fa-clock"></i> <fmt:formatDate value="${user.lastLogin}" pattern="HH:mm" /></span>
                                                                    <h3 class="timeline-header"><a href="#">${user.username}</a> logged in</h3>
                                                                    <div class="timeline-body">
                                                                        User last logged in to the system.
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:if>
                                                        
                                                        <div>
                                                            <i class="far fa-clock bg-gray"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <div class="tab-pane" id="settings">
                                                    <div class="alert alert-info">
                                                        <i class="fas fa-info-circle"></i> User settings management is available on the edit page.
                                                    </div>
                                                    <a href="${pageContext.request.contextPath}/management/users/edit?id=${user.userID}" class="btn btn-primary">
                                                        <i class="fas fa-edit"></i> Go to Edit Page
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
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
        });
    </script>
</body>
</html>
