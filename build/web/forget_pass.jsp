<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="DB.JDBC" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>FORGET PASSWORD</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        body {
            background-color: #f4c476;
        }

        .forget-box {
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
    <div class="forget-box">

        <h1 class="text-center mb-4">FORGET PASSWORD</h1>

        <%
            String name = "";
            String password = "";
            String message = "";
            String error = "";

            if ("POST".equalsIgnoreCase(request.getMethod())
                    && request.getParameter("get") != null) {

                String idText = request.getParameter("id");

                if (idText == null || idText.trim().isEmpty()) {
                    error = "Please enter your ID.";
                } else {
                    try {
                        int id = Integer.parseInt(idText.trim());

                        String sql = "{CALL dbo.sp_a_get_one(?)}";

                        try (Connection con = JDBC.con();
                             PreparedStatement ps = con.prepareStatement(sql)) {

                            ps.setInt(1, id);

                            try (ResultSet rs = ps.executeQuery()) {
                                if (rs.next()) {
                                    name = rs.getString("name");
                                    password = rs.getString("pass");

                                    message = "Record found successfully.";
                                } else {
                                    error = "ID not found.";
                                }
                            }
                        }

                    } catch (NumberFormatException e) {
                        error = "Please enter a valid numeric ID.";
                    } catch (Exception e) {
                        application.log("Forget password GET error", e);
                        error = "Server error. Check the GlassFish server log.";
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

        <form action="${pageContext.request.contextPath}/forget_pass.jsp"
              method="post">

            <div class="mb-3">
                <label for="id" class="form-label">ID:</label>
                <input type="number"
                       id="id"
                       name="id"
                       class="form-control"
                       min="1"
                       required>
            </div>

            <div class="mb-3">
                <label for="name" class="form-label">Name:</label>
                <input type="text"
                       id="name"
                       class="form-control"
                       value="<%= name == null ? "" :
                           name.replace("&", "&amp;")
                               .replace("<", "&lt;")
                               .replace(">", "&gt;")
                               .replace("\"", "&quot;")
                               .replace("'", "&#39;") %>"
                       readonly>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">Password:</label>
                <input type="text"
       id="password"
       class="form-control"
       value="<%= password == null ? "" :
           password.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;") %>"
       readonly>
            </div>

            <div class="d-flex flex-wrap gap-2">
                <button type="submit"
                        name="get"
                        value="1"
                        class="btn btn-primary">
                    GET
                </button>

                <a href="${pageContext.request.contextPath}/login.jsp"
                   class="btn btn-success">
                    BACK TO LOGIN
                </a>
            </div>

        </form>

    </div>
</div>
</body>
</html>
