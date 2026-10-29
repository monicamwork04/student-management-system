
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="DB.JDBC" %>

<%
    String message = null;
    String messageType = "danger";

    // Session timeout: 30 minutes
    session.setMaxInactiveInterval(30 * 60);

    if ("POST".equalsIgnoreCase(request.getMethod())
            && request.getParameter("signup") != null) {

        String idText = request.getParameter("id");
        String name = request.getParameter("name");
        String password = request.getParameter("password");

        if (idText != null && name != null && password != null
                && !idText.trim().isEmpty()
                && !name.trim().isEmpty()
                && !password.isEmpty()) {

            try {
                int id = Integer.parseInt(idText.trim());

                try (
                    Connection con = JDBC.con();
                    CallableStatement cs =
                        con.prepareCall("{call dbo.sp_a_insert(?, ?, ?)}")
                ) {
                    cs.setInt(1, id);
                    cs.setString(2, name.trim());
                    cs.setString(3, password);

                    cs.execute();

                    // Create session after successful signup
                    session.setAttribute("adminId", id);
                    session.setAttribute("adminName", name.trim());
                    session.setAttribute("role", "admin");

                    message = "Admin added successfully!";
                    messageType = "success";

                } catch (SQLIntegrityConstraintViolationException e) {
                    message = "Signup failed. This ID may already exist.";
                }

            } catch (NumberFormatException e) {
                message = "Please enter a valid numeric ID.";
            } catch (Exception e) {
                application.log("Admin signup failed", e);
                message = "Signup failed. Check the server log.";
            }

        } else {
            message = "Please enter ID, name, and password.";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>ADMIN SIGNUP PAGE</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        body {
            background-color: #f4c476;
        }

        .signup-box {
            max-width: 650px;
            margin: 40px auto;
            padding: 25px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
    </style>
</head>

<body>
<div class="container">
    <div class="signup-box">

        <h1 class="text-center mb-4">SIGNUP PAGE</h1>

        <% if (message != null) { %>
            <div class="alert alert-<%= messageType %>">
                <%= message %>
            </div>
        <% } %>

        <form action="signup.jsp" method="post">

            <div class="mb-3">
                <label for="id" class="form-label">ID:</label>
                <input type="number" id="id" name="id"
                       class="form-control"
                       min="1" required>
            </div>

            <div class="mb-3">
                <label for="name" class="form-label">Name:</label>
                <input type="text" id="name" name="name"
                       class="form-control"
                       maxlength="100" required>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">Password:</label>
                <input type="password" id="password" name="password"
                       class="form-control"
                       maxlength="255" required>
            </div>

            <div class="d-flex flex-wrap gap-2">
                <button type="submit" name="signup" value="Signup"
                        class="btn btn-primary">
                    Signup
                </button>

                <a href="login.jsp" class="btn btn-success">LOGIN</a>

                <a href="reset_pass.jsp" class="btn btn-warning">
                    RESET PASSWORD
                </a>

                <a href="forget_pass.jsp" class="btn btn-info">
                    FORGET PASSWORD
                </a>
            </div>

        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
