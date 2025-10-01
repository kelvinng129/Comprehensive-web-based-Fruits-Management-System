<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="ict.bean.User" %>
<%
    User user = (User) session.getAttribute("user");
    String role = user != null ? user.getRole() : "";
%>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">AIB System</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNavDropdown">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <!-- Common Navigation -->
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Home</a>
                </li>
                
                <!-- Fruit Management -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="fruitDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        Fruit Management
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="fruitDropdown">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/fruit?action=list">All Fruits</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/category?action=list">Categories</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/inventory?action=list">Inventory</a></li>
                        <% if (role.equals("senior_management") || role.equals("warehouse_staff")) { %>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/fruit?action=showAddForm">Add New Fruit</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/category?action=showAddForm">Add New Category</a></li>
                        <% } %>
                    </ul>
                </li>
                
                <!-- Role-specific Navigation -->
                <% if (role.equals("shop_staff")) { %>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/shop/dashboard.jsp">Shop Dashboard</a>
                </li>
                <% } else if (role.equals("warehouse_staff")) { %>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/warehouse/dashboard.jsp">Warehouse Dashboard</a>
                </li>
                <% } else if (role.equals("senior_management")) { %>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/management/dashboard.jsp">Management Dashboard</a>
                </li>
                <% } %>
            </ul>
            
            <!-- User Controls -->
            <ul class="navbar-nav">
                <% if (user != null) { %>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <%= user.getFullName() %>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                        <li><a class="dropdown-item" href="#">Profile</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></li>
                    </ul>
                </li>
                <% } else { %>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/login.jsp">Login</a>
                </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>