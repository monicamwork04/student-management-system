<%
    Integer adminId = (Integer) session.getAttribute("adminId");
    String adminName = (String) session.getAttribute("adminName");
    String role = (String) session.getAttribute("role");

    if (adminId == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<h2>Welcome, <%= adminName %></h2>
<p>Admin ID: <%= adminId %></p>