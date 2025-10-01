<%-- 
    Document   : login.jsp
    Created on : 2025年4月19日, 上午2:06:23
    Author     : kelvin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>AIB System - Login</title>
    <link rel="stylesheet" href="css/login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
    <div class="login-container">
        <!-- Left panel with gradient background -->
        <div class="login-panel left-panel">
            <div class="left-panel-content">
                <h1>Welcome to AIB System</h1>
                <p>Acer International Bakery's integrated fruit management platform for efficient global operations</p>
                <div class="gradient-shapes"></div>
            </div>
        </div>
        
        <!-- Right panel with login form -->
        <div class="login-panel right-panel">
            <div class="login-form-container">
                <div class="login-header">
                    <h2>USER LOGIN</h2>
                </div>
                
                <% if (request.getParameter("logout") != null) { %>
                    <div class="message success">
                        You have been successfully logged out.
                    </div>
                <% } %>
                
                <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="message error">
                        <%= request.getAttribute("errorMessage") %>
                    </div>
                <% } %>
                
                <% if (request.getAttribute("successMessage") != null) { %>
                    <div class="message success">
                        <%= request.getAttribute("successMessage") %>
                    </div>
                <% } %>
                
                <form action="LoginServlet" method="post" class="login-form">
                    <div class="form-group">
                        <div class="input-with-icon">
                            <i class="fas fa-user"></i>
                            <input type="text" id="username" name="username" placeholder="Username" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <div class="input-with-icon">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="password" name="password" placeholder="Password" required>
                        </div>
                    </div>
                    
                    <div class="form-options">
                        <div class="remember-me">
                            <input type="checkbox" id="remember" name="remember">
                            <label for="remember">Remember</label>
                        </div>
                        <div class="forgot-password">
                            <a href="#">Forgot password?</a>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <button type="submit" class="btn-login">LOGIN</button>
                    </div>
                </form>
                
                <div class="register-link">
                    <p>Don't have an account? <a href="RegisterServlet">Register</a></p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>