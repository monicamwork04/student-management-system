
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="DB.JDBC" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) return "";

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    String message = "";
    String error = "";

    String id = "";
    String name = "";
    String dob = "";
    String time = "";
    String gen = "";
    String cou = "";

    boolean editing = false;
    String editId = request.getParameter("editId");

    if ("1".equals(request.getParameter("success"))) {
        message = "Student added successfully!";
    } else if ("1".equals(request.getParameter("updated"))) {
        message = "Student updated successfully!";
    } else if ("1".equals(request.getParameter("deleted"))) {
        message = "Student deleted successfully!";
    } else if ("0".equals(request.getParameter("deleted"))) {
        error = "Student was not found or could not be deleted.";
    } else if ("1".equals(request.getParameter("editError"))) {
        error = "Student not found.";
    }

    // Load saved details when editing
    if (editId != null && !editId.trim().isEmpty()) {
        try (Connection con = JDBC.con();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT id, name, gen, cou, dob, stud_time " +
                 "FROM dbo.tbl_stud1 WHERE id = ?")) {

            ps.setString(1, editId.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    editing = true;

                    id = String.valueOf(rs.getInt("id"));
                    name = rs.getString("name");
                    gen = rs.getString("gen");
                    cou = rs.getString("cou");

                    java.sql.Date dateValue = rs.getDate("dob");
                    if (dateValue != null) {
                        dob = dateValue.toString();
                    }

                    java.sql.Time timeValue = rs.getTime("stud_time");
                    if (timeValue != null) {
                        time = timeValue.toString();
                    }
                } else {
                    error = "Student not found.";
                }
            }
        } catch (Exception ex) {
            application.log("Unable to load student for editing", ex);
            error = "Unable to load student details.";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Student Information Page</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            background: #f0f8ff;
            font-family: Arial, sans-serif;
            margin: 15px;
            color: #333;
        }

        .container {
            max-width: 1100px;
            margin: 20px auto;
            padding: 25px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 3px 12px rgba(0,0,0,.10);
        }

        h1, h2 {
            text-align: center;
            color: #123456;
        }

        .form-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px 16px;
        }

        .field {
            display: flex;
            flex-direction: column;
            min-width: 0;
        }

        .field > label {
            margin-bottom: 7px;
            font-weight: bold;
            color: #555;
        }

        input[type="text"],
        input[type="date"],
        input[type="file"],
        select {
            width: 100%;
            padding: 11px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background: white;
            font-size: 15px;
        }

        input[readonly] {
            background: #f3f3f3;
        }

        .gender-options label {
            display: block;
            margin: 8px 0;
        }

        .main-button {
            width: 100%;
            padding: 13px;
            margin-top: 25px;
            background: #0875f5;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
        }

        .message {
            padding: 12px;
            margin: 15px 0;
            border-radius: 5px;
        }

        .success {
            background: #d1e7dd;
            color: #0f5132;
        }

        .failure {
            background: #f8d7da;
            color: #842029;
        }

        .table-wrap {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }

        th, td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: left;
        }

        th {
            background: #0875f5;
            color: white;
        }

        .student-img {
            width: 70px;
            height: 70px;
            object-fit: cover;
        }

        .action-form {
            display: inline-block;
            margin: 2px;
        }

        .action-button {
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            color: white;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
        }

        .edit-button {
            background: #198754;
        }

        .delete-button {
            background: #dc3545;
        }

        .cancel-button {
            display: inline-block;
            margin-top: 12px;
            color: #0875f5;
        }

        .download-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            flex-wrap: wrap;
            margin: 20px 0;
        }

        .download-button {
            display: inline-block;
            padding: 12px 22px;
            border: none;
            border-radius: 6px;
            color: white;
            font-size: 15px;
            font-weight: bold;
            text-decoration: none;
            cursor: pointer;
        }

        .csv-button {
            background: #198754;
        }

        .pdf-button {
            background: #dc3545;
        }

        .download-button:hover {
            opacity: 0.85;
        }

        @media (max-width: 600px) {
            .container {
                padding: 16px;
            }

            .form-container {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>

<div class="container">

    <h1>STUDENT INFORMATION PAGE</h1>

    <% if (!message.isEmpty()) { %>
        <div class="message success">
            <%= escapeHtml(message) %>
        </div>
    <% } %>

    <% if (!error.isEmpty()) { %>
        <div class="message failure">
            <%= escapeHtml(error) %>
        </div>
    <% } %>

    <h2><%= editing ? "Edit Student" : "Add Student" %></h2>

    <form action="<%= request.getContextPath() %>/<%= editing ? "stu_update" : "stu_add" %>"
          method="post"
          enctype="multipart/form-data">

        <% if (editing) { %>
            <input type="hidden" name="id"
                   value="<%= escapeHtml(id) %>">
        <% } %>

        <div class="form-container">

            <div class="field">
                <label for="id">ID</label>

                <input type="text"
                       id="id"
                       name="<%= editing ? "displayId" : "id" %>"
                       value="<%= escapeHtml(id) %>"
                       inputmode="numeric"
                       maxlength="10"
                       pattern="[0-9]+"
                       <%= editing ? "readonly" : "" %>
                       required>
            </div>

            <div class="field">
                <label for="name">NAME</label>

                <input type="text"
                       id="name"
                       name="name"
                       value="<%= escapeHtml(name) %>"
                       maxlength="100"
                       required>
            </div>

            <div class="field">
                <label for="dob">DOB</label>

                <input type="date"
                       id="dob"
                       name="dob"
                       value="<%= escapeHtml(dob) %>"
                       required>
            </div>

            <div class="field">
                <label for="img">
                    IMAGE
                    <%= editing ? "(Optional: choose to replace image)" : "" %>
                </label>

                <input type="file"
                       id="img"
                       name="img"
                       accept="image/*"
                       <%= editing ? "" : "required" %>>
            </div>

            <div class="field">
                <label for="time">STUDENT TIME</label>

                <input type="text"
                       id="time"
                       name="time"
                       value="<%= escapeHtml(time) %>"
                       readonly
                       placeholder="Laptop time appears here">
            </div>

            <div class="field">
                <label>GENDER</label>

                <div class="gender-options">
                    <label>
                        <input type="radio"
                               name="gen"
                               value="Male"
                               <%= "Male".equals(gen) ? "checked" : "" %>
                               required>
                        Male
                    </label>

                    <label>
                        <input type="radio"
                               name="gen"
                               value="Female"
                               <%= "Female".equals(gen) ? "checked" : "" %>
                               required>
                        Female
                    </label>
                </div>
            </div>

            <div class="field">
                <label for="cou">COURSE</label>

                <select id="cou" name="cou" required>
                    <option value="">-- Select a Course --</option>

                    <option value="java"
                        <%= "java".equalsIgnoreCase(cou) ? "selected" : "" %>>
                        Java
                    </option>
                </select>
            </div>

        </div>

        <input class="main-button"
               type="submit"
               value="<%= editing ? "Update Student" : "Add Student" %>">
    </form>

    <% if (editing) { %>
        <a class="cancel-button"
           href="<%= request.getContextPath() %>/student.jsp">
            Cancel Editing
        </a>
    <% } %>

</div>

<div class="container">

    <h2>Saved Student Information</h2>

    <div class="download-buttons">
        <a class="download-button csv-button"
           href="<%= request.getContextPath() %>/csv">
            Download CSV
        </a>

        <a class="download-button pdf-button"
           href="<%= request.getContextPath() %>/pdf">
            Download PDF
        </a>
    </div>

    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Gender</th>
                    <th>Course</th>
                    <th>DOB</th>
                    <th>Image</th>
                    <th>Student Time</th>
                    <th>Action</th>
                </tr>
            </thead>

            <tbody>
            <%
                boolean found = false;

                try (Connection con = JDBC.con();
                     PreparedStatement ps = con.prepareStatement(
                         "SELECT id, name, gen, cou, dob, img, stud_time " +
                         "FROM dbo.tbl_stud1 ORDER BY id DESC");
                     ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {
                        found = true;

                        int studentId = rs.getInt("id");
                        byte[] imageBytes = rs.getBytes("img");
            %>

                <tr>
                    <td><%= studentId %></td>
                    <td><%= escapeHtml(rs.getString("name")) %></td>
                    <td><%= escapeHtml(rs.getString("gen")) %></td>
                    <td><%= escapeHtml(rs.getString("cou")) %></td>

                    <td><%= rs.getDate("dob") == null
                              ? ""
                              : rs.getDate("dob").toString() %></td>

                    <td>
                        <% if (imageBytes != null && imageBytes.length > 0) { %>
                            <img class="student-img"
                                 src="<%= request.getContextPath() %>/student_image?id=<%= studentId %>"
                                 alt="Student Image">
                        <% } else { %>
                            No image
                        <% } %>
                    </td>

                    <td><%= rs.getTime("stud_time") == null
                              ? ""
                              : rs.getTime("stud_time").toString() %></td>

                    <td>
                        <a class="action-button edit-button"
                           href="<%= request.getContextPath() %>/student.jsp?editId=<%= studentId %>">
                            Edit
                        </a>

                        <form class="action-form"
                              action="<%= request.getContextPath() %>/stu_del"
                              method="post"
                              onsubmit="return confirm('Are you sure you want to delete student ID <%= studentId %>?');">

                            <input type="hidden"
                                   name="id"
                                   value="<%= studentId %>">

                            <button class="action-button delete-button"
                                    type="submit">
                                Delete
                            </button>
                        </form>
                    </td>
                </tr>

            <%
                    }

                    if (!found) {
            %>
                <tr>
                    <td colspan="8" style="text-align:center;">
                        No student records found.
                    </td>
                </tr>
            <%
                    }

                } catch (Exception ex) {
                    application.log("Unable to load student records", ex);
            %>
                <tr>
                    <td colspan="8">
                        Unable to load student records.
                        Check the server log and confirm the table and column names.
                    </td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>

</div>

<script>
    const timeField = document.getElementById("time");
    const editing = <%= editing %>;

    function updateLaptopTime() {
        if (!timeField || editing) {
            return;
        }

        const now = new Date();

        timeField.value = now.toLocaleTimeString("en-IN", {
            hour: "2-digit",
            minute: "2-digit",
            second: "2-digit",
            hour12: false
        });
    }

    // Show laptop's current time only when adding a student.
    if (!editing) {
        updateLaptopTime();
        setInterval(updateLaptopTime, 1000);
    }
</script>

</body>
</html>
