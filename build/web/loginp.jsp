<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.CallableStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="DB.JDBC" %>

<%
request.setCharacterEncoding("UTF-8");

String name = request.getParameter("name");
String password = request.getParameter("password");

if (name == null || name.trim().isEmpty()
        || password == null || password.isEmpty()) {

    response.sendRedirect(
        request.getContextPath() + "/login.jsp?error=invalid"
    );

} else {

    try (Connection con = JDBC.con();
         CallableStatement cs =
             con.prepareCall("{call dbo.sp_login(?, ?)}")) {

        cs.setString(1, name.trim());
        cs.setString(2, password);

        try (ResultSet rs = cs.executeQuery()) {

            if (rs.next()) {

                HttpSession userSession = request.getSession(true);

                userSession.setAttribute("adminName", name.trim());
                userSession.setAttribute("adminLoggedIn", Boolean.TRUE);
                userSession.setAttribute("role", "admin");
                userSession.setMaxInactiveInterval(30 * 60);

                response.sendRedirect(
                    request.getContextPath() + "/course.jsp"
                );

            } else {

                response.sendRedirect(
                    request.getContextPath() + "/login.jsp?error=invalid"
                );
            }
        }

    } catch (Exception e) {

        application.log("Login processing failed", e);

        response.sendRedirect(
            request.getContextPath() + "/login.jsp?error=server"
        );
    }
}
%>
