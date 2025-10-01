<ul class="sidebar-menu">
    <li class="${activePage == 'dashboard' ? 'active' : ''}">
        <a href="${pageContext.request.contextPath}/shop/dashboard.jsp">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
    </li>
    
    <li class="${activePage == 'reservations' ? 'active' : ''}">
        <a href="${pageContext.request.contextPath}/reservation?action=list">
            <i class="fas fa-clipboard-list"></i> Reservations
        </a>
    </li>
    
    <li class="${activePage == 'inventory' ? 'active' : ''}">
        <a href="${pageContext.request.contextPath}/shop/inventory.jsp">
            <i class="fas fa-warehouse"></i> Inventory
        </a>
    </li>
    
    <li class="${activePage == 'borrowing' ? 'active' : ''}">
        <a href="${pageContext.request.contextPath}/shop/borrowing.jsp">
            <i class="fas fa-exchange-alt"></i> Borrowing
        </a>
    </li>
    
    <li class="${activePage == 'fruits' ? 'active' : ''}">
        <a href="${pageContext.request.contextPath}/fruit?action=list">
            <i class="fas fa-apple-alt"></i> Fruits
        </a>
    </li>
    
    <li class="${activePage == 'profile' ? 'active' : ''}">
        <a href="${pageContext.request.contextPath}/shop/profile.jsp">
            <i class="fas fa-user"></i> My Profile
        </a>
    </li>
    
    <li>
        <a href="${pageContext.request.contextPath}/LogoutServlet">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </li>
</ul>