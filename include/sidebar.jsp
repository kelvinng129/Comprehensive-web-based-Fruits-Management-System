<%-- 
    Document   : sidebar
    Created on : 2025年4月20日, 上午8:12:46
    Author     : kelvin
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Add this block in the management section of your sidebar -->
<c:if test="${user.role == 'senior_management'}">
    <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/management/forecast/">
            <i class="fas fa-truck-loading"></i>
            <span>SKU Forecast</span>
        </a>
    </li>
</c:if>