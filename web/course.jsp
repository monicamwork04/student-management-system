
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="DB.JDBC" %>

<%
    // LOGIN SESSION PROTECTION
    Boolean loggedIn =
        (Boolean) session.getAttribute("adminLoggedIn");

    String role =
        (String) session.getAttribute("role");

    if (!Boolean.TRUE.equals(loggedIn)
            || !"admin".equals(role)) {

        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );
        return;
    }

    request.setCharacterEncoding("UTF-8");

    String id = request.getParameter("id");
    String name = request.getParameter("name");
    String action = request.getParameter("action");

    String message = "";
    String error = "";

    if (id == null) id = "";
    if (name == null) name = "";

    // ADD COURSE
    if ("add".equals(action)) {
        try {
            String courseId = id.trim();
            String courseName = name.trim();

            if (courseId.isEmpty()) {
                error = "Please enter course ID.";
            } else if (courseName.isEmpty()) {
                error = "Please enter course name.";
            } else if (courseId.length() > 20) {
                error = "Course ID must not exceed 20 characters.";
            } else if (courseName.length() > 100) {
                error = "Course name must not exceed 100 characters.";
            } else {
                String sql = "{CALL dbo.sp_c_insert(?, ?)}";

                try (Connection con = JDBC.con();
                     CallableStatement cs = con.prepareCall(sql)) {

                    cs.setString(1, courseId);
                    cs.setString(2, courseName);
                    cs.execute();
                }

                message = "Course added successfully!";
                id = "";
                name = "";
            }

        } catch (Exception e) {
            application.log("Course add error", e);
            error = "Course add failed. Check the server log.";
        }
    }

    // EDIT COURSE
    else if ("edit".equals(action)) {
        try {
            String courseId = id.trim();
            String courseName = name.trim();

            if (courseId.isEmpty()) {
                error = "Please enter course ID.";
            } else if (courseName.isEmpty()) {
                error = "Please enter course name.";
            } else if (courseId.length() > 20) {
                error = "Course ID must not exceed 20 characters.";
            } else if (courseName.length() > 100) {
                error = "Course name must not exceed 100 characters.";
            } else {
                String sql = "{CALL dbo.sp_c_update(?, ?)}";

                try (Connection con = JDBC.con();
                     CallableStatement cs = con.prepareCall(sql)) {

                    cs.setString(1, courseId);
                    cs.setString(2, courseName);
                    cs.execute();
                }

                message = "Course updated successfully!";
                id = "";
                name = "";
            }

        } catch (Exception e) {
            application.log("Course edit error", e);
            error = "Unable to update course. Check the server log.";
        }
    }

    // DELETE COURSE
    else if ("delete".equals(action)) {
        try {
            String courseId = id.trim();

            if (courseId.isEmpty()) {
                error = "Please enter course ID.";
            } else {
                String sql = "{CALL dbo.sp_c_delete(?)}";

                try (Connection con = JDBC.con();
                     CallableStatement cs = con.prepareCall(sql)) {

                    cs.setString(1, courseId);
                    cs.execute();
                }

                message = "Course deleted successfully!";
                id = "";
                name = "";
            }

        } catch (Exception e) {
            application.log("Course delete error", e);
            error = "Unable to delete course. Check the server log.";
        }
    }

    // SELECT COURSE
    // No database modification happens for this action.
    else if ("select".equals(action)) {
        message = "Course selected. You can edit its details.";
    }

    // HTML OUTPUT ESCAPING
    String safeInputId = id
        .replace("&", "&amp;")
        .replace("\"", "&quot;")
        .replace("<", "&lt;")
        .replace(">", "&gt;");

    String safeInputName = name
        .replace("&", "&amp;")
        .replace("\"", "&quot;")
        .replace("<", "&lt;")
        .replace(">", "&gt;");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>COURSE PAGE</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        body {
            background-color: #f4c476;
        }

        .course-box {
            background-color: #16e653;
            padding: 25px;
            margin-top: 25px;
            border-radius: 10px;
        }

        .table-box {
            margin-top: 30px;
            margin-bottom: 30px;
            background: white;
            padding: 20px;
            border: 2px solid blue;
            border-radius: 8px;
        }
    </style>
</head>

<body>

<div class="container-fluid">

    <!-- COURSE FORM -->
    <div class="course-box">

        <h2 class="text-center mb-4">
            COURSE ADD / EDIT / DELETE
        </h2>

        <p class="text-end">
            Welcome,
            <strong>
                <%= session.getAttribute("adminName") == null
                    ? "Admin"
                    : session.getAttribute("adminName") %>
            </strong>
        </p>

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

        <form action="<%= request.getContextPath() %>/course.jsp"
              method="post">

            <div class="mb-3">
                <label for="id" class="form-label">ID:</label>

                <input type="text"
                       id="id"
                       name="id"
                       class="form-control"
                       maxlength="20"
                       value="<%= safeInputId %>"
                       placeholder="Enter Course ID (e.g., CS101)"
                       required>
            </div>

            <div class="mb-3">
                <label for="name" class="form-label">Name:</label>

                <input type="text"
                       id="name"
                       name="name"
                       class="form-control"
                       maxlength="100"
                       value="<%= safeInputName %>"
                       placeholder="Enter Course Name"
                       required>
            </div>

            <div class="row g-2">

                <div class="col-6 col-md-3">
                    <button type="submit"
                            name="action"
                            value="add"
                            class="btn btn-primary w-100">
                        ADD
                    </button>
                </div>

                <div class="col-6 col-md-3">
                    <button type="submit"
                            name="action"
                            value="edit"
                            class="btn btn-success w-100">
                        EDIT
                    </button>
                </div>

                <div class="col-6 col-md-3">
                    <button type="submit"
                            name="action"
                            value="delete"
                            class="btn btn-danger w-100"
                            formnovalidate
                            onclick="return confirm('Delete this course?');">
                        DELETE
                    </button>
                </div>

                <div class="col-6 col-md-3">
                    <a href="<%= request.getContextPath() %>/Student.jsp"
                       class="btn btn-secondary w-100">
                        BACK
                    </a>
                </div>

            </div>
        </form>

    </div>

    <!-- COURSE TABLE -->
    <div class="table-box">

        <h2 class="text-center mb-4">COURSE DETAILS</h2>

        <div class="table-responsive">

            <table class="table table-hover table-bordered text-center">

                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Actions</th>
                    </tr>
                </thead>

                <tbody>

                <%
                    String listSql = "{CALL dbo.sp_c_get_all}";

                    try (Connection con = JDBC.con();
                         CallableStatement cs = con.prepareCall(listSql);
                         ResultSet rs = cs.executeQuery()) {

                        while (rs.next()) {

                            String courseId = rs.getString("id");
                            String courseName = rs.getString("name");

                            if (courseId == null) courseId = "";
                            if (courseName == null) courseName = "";

                            String safeId = courseId
                                .replace("&", "&amp;")
                                .replace("\"", "&quot;")
                                .replace("<", "&lt;")
                                .replace(">", "&gt;")
                                .replace("'", "&#39;");

                            String safeName = courseName
                                .replace("&", "&amp;")
                                .replace("\"", "&quot;")
                                .replace("<", "&lt;")
                                .replace(">", "&gt;")
                                .replace("'", "&#39;");
                %>

                    <tr>
                        <td><%= safeId %></td>
                        <td><%= safeName %></td>

                        <td>

                            <!-- SELECT / EDIT -->
                            <form action="<%= request.getContextPath() %>/course.jsp"
                                  method="post"
                                  style="display:inline-block">

                                <input type="hidden"
                                       name="id"
                                       value="<%= safeId %>">

                                <input type="hidden"
                                       name="name"
                                       value="<%= safeName %>">

                                <button type="submit"
                                        name="action"
                                        value="select"
                                        class="btn btn-warning btn-sm">
                                    Select / Edit
                                </button>

                            </form>

                            <!-- DELETE -->
                            <form action="<%= request.getContextPath() %>/course.jsp"
                                  method="post"
                                  style="display:inline-block"
                                  onsubmit="return confirm('Delete this course?');">

                                <input type="hidden"
                                       name="id"
                                       value="<%= safeId %>">

                                <button type="submit"
                                        name="action"
                                        value="delete"
                                        class="btn btn-danger btn-sm">
                                    Delete
                                </button>

                            </form>

                        </td>
                    </tr>

                <%
                        }

                    } catch (Exception e) {

                        application.log("Course list error", e);
                %>

                    <tr>
                        <td colspan="3">
                            Unable to load courses. Check the GlassFish server log.
                        </td>
                    </tr>

                <%
                    }
                %>

                </tbody>
            </table>
        </div>
    </div>

</div>

</body>
</html>
