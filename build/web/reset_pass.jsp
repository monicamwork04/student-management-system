
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="DB.JDBC" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>RESET PASSWORD</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        body {
            background-color: #f4c476;
        }

        .reset-box {
            max-width: 600px;
            margin: 70px auto;
            padding: 30px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
    </style>
</head>

<body>
<div class="container">
    <div class="reset-box">

        <h1 class="text-center mb-4">RESET PASSWORD</h1>

        <%
            String message = "";
            String error = "";

            if ("POST".equalsIgnoreCase(request.getMethod())) {

                String name = request.getParameter("name");
                String password = request.getParameter("password");
                String confirm = request.getParameter("confirm");

                if (name == null || name.trim().isEmpty()
                        || password == null || password.isEmpty()
                        || confirm == null || confirm.isEmpty()) {

                    error = "Please fill in all fields.";

                } else if (!password.equals(confirm)) {

                    error = "Passwords do not match.";

                } else {
                    String sql =
                        "UPDATE dbo.tbl_admin SET pass = ? WHERE name = ?";

                    try (Connection con = JDBC.con();
                         PreparedStatement ps = con.prepareStatement(sql)) {

                        ps.setString(1, password);
                        ps.setString(2, name.trim());

                        int result = ps.executeUpdate();

                        if (result > 0) {
                            message = "Password reset successfully!";
                        } else {
                            error = "Name not found. Please check your name.";
                        }

                    } catch (SQLException e) {
                        application.log("Password reset SQL error", e);
                        error = "Database update failed. Check the server log.";
                    } catch (Exception e) {
                        application.log("Password reset connection error", e);
                        error = "Database connection failed. Check the server log.";
                    }
                }
            }
        %>

        <% if (!message.isEmpty()) { %>
            <div class="alert alert-success">
                <%= message %>
            </div>
        <% } %>

        <% if (!error.isEmpty()) { %>
            <div class="alert alert-danger">
                <%= error %>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/reset_pass.jsp"
              method="post">

            <div class="mb-3">
                <label for="name" class="form-label">Name:</label>
                <input type="text" id="name" name="name"
                       class="form-control" maxlength="100" required>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">New Password:</label>
                <input type="password" id="password" name="password"
                       class="form-control" required>
            </div>

            <div class="mb-3">
                <label for="confirm" class="form-label">
                    Confirm New Password:
                </label>
                <input type="password" id="confirm" name="confirm"
                       class="form-control" required>
            </div>

            <div class="d-flex flex-wrap gap-2">
                <button type="submit" class="btn btn-warning">
                    RESET PASSWORD
                </button>

                <a href="${pageContext.request.contextPath}/login.jsp"
                   class="btn btn-primary">
                    BACK TO LOGIN
                </a>
            </div>

        </form>
    </div>
</div>
</body>
</html>
