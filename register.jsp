<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>AIB System - Registration</title>
    <link rel="stylesheet" href="css/login.css">
    <link rel="stylesheet" href="css/register.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
    <div class="login-container register-container">
        <!-- Left panel with gradient background -->
        <div class="left-panel">
            <div class="left-panel-content">
                <h1>Join AIB System</h1>
                <p>Create your account to access the fruit management system and start managing international bakery operations</p>
                <div class="gradient-shapes"></div>
            </div>
        </div>
        
        <!-- Right panel with registration form -->
        <div class="right-panel">
            <div class="login-form-container register-form-container">
                <div class="login-header">
                    <h2>NEW USER REGISTRATION</h2>
                </div>
                
                <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="message error">
                        <%= request.getAttribute("errorMessage") %>
                    </div>
                <% } %>
                
                <form action="RegisterServlet" method="post" class="login-form register-form">
                    <div class="form-group">
                        <div class="input-with-icon">
                            <i class="fas fa-user"></i>
                            <input type="text" id="username" name="username" placeholder="Username *" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <div class="input-with-icon">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="password" name="password" placeholder="Password *" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <div class="input-with-icon">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm Password *" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <div class="input-with-icon">
                            <i class="fas fa-id-card"></i>
                            <input type="text" id="fullName" name="fullName" placeholder="Full Name *" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <div class="input-with-icon">
                            <i class="fas fa-envelope"></i>
                            <input type="email" id="email" name="email" placeholder="Email *" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <div class="input-with-icon">
                            <i class="fas fa-phone"></i>
                            <input type="text" id="phone" name="phone" placeholder="Phone">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <div class="input-with-icon select-wrapper">
                            <i class="fas fa-user-tag"></i>
                            <select id="role" name="role" required>
                                <option value="">-- Select Role --</option>
                                <option value="shop_staff">Shop Staff</option>
                                <option value="warehouse_staff">Warehouse Staff</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <div class="input-with-icon select-wrapper">
                            <i class="fas fa-map-marker-alt"></i>
                            <select id="locationID" name="locationID" required>
                                <option value="">-- Select Location --</option>
                                <c:forEach items="${locations}" var="location">
                                    <c:if test="${location.status == 'active'}">
                                        <option value="${location.locationID}">
                                            ${location.locationName} (${location.city}, ${location.country})
                                        </option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <button type="submit" class="btn-login">REGISTER</button>
                    </div>
                </form>
                
                <div class="register-link">
                    <p>Already have an account? <a href="login.jsp">Login</a></p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>