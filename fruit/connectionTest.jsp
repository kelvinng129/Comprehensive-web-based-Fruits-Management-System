<%@ page import="java.sql.*" %>
<%@ page import="ict.db.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Database Connection Test</title>
</head>
<body>
    <h1>Database Connection Test</h1>
    
    <%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    
    try {
        // Get connection
        conn = DatabaseConnection.getConnection();
        out.println("<p>Connection established successfully!</p>");
        
        // Test a simple query
        stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT COUNT(*) FROM users");
        
        if(rs.next()) {
            int count = rs.getInt(1);
            out.println("<p>Total users in database: " + count + "</p>");
        }
        
        // Test specific user query
        PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM users WHERE username = 'admin'");
        ResultSet userRs = pstmt.executeQuery();
        
        if(userRs.next()) {
            out.println("<p>Found admin user:</p>");
            out.println("<p>Username: " + userRs.getString("username") + "</p>");
            out.println("<p>Password: " + userRs.getString("password") + "</p>");
            out.println("<p>Status: " + userRs.getString("status") + "</p>");
        } else {
            out.println("<p>Admin user not found!</p>");
        }
        
        userRs.close();
        pstmt.close();
        
    } catch(Exception e) {
        out.println("<p style='color:red'>ERROR: " + e.getMessage() + "</p>");
        e.printStackTrace(new java.io.PrintWriter(out));
    } finally {
        try { if(rs != null) rs.close(); } catch(Exception e) {}
        try { if(stmt != null) stmt.close(); } catch(Exception e) {}
        try { if(conn != null) conn.close(); } catch(Exception e) {}
    }
    %>
</body>
</html>