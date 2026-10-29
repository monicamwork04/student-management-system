<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
HttpSession httpSession = request.getSession(false);

if (httpSession == null ||
    !Boolean.TRUE.equals(httpSession.getAttribute("adminLoggedIn"))) {

    response.sendRedirect("login.jsp");
    return;
}

String adminName =
    (String) httpSession.getAttribute("adminName");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
</head>
<body>

    <h1>Welcome to Admin Dashboard!</h1>

    <h3>Hello, <%= adminName %></h3>

    <p>Login successful.</p>

    <a href="logout.jsp">Logout</a>

</body>
</html>
