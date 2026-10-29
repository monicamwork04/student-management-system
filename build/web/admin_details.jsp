<!doctype html>

<%@ page import="java.sql.*" %>
<%@ page import="DB.JDBC" %>

<%
    if (request.getParameter("signup") != null) {

        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String password = request.getParameter("password");

        String sql = "sp_a_insert ?,?,?";

        try (
            Connection con = JDBC.con();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, id);
            ps.setString(2, name);
            ps.setString(3, password);

            int a = ps.executeUpdate();

            if (a == 1) {
%>

                <script>
                    alert("ADDED-------");
                    location.assign("signup.jsp");
                </script>

<%
            } else {
%>

                <script>
                    alert("Not added-------");
                </script>

<%
            }

        } catch (Exception e) {
%>

            <script>
                alert("Error: <%= e.getMessage() %>");
            </script>

<%
        }
    }
%>

<html lang="en">

<head>

    <meta charset="utf-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>ADMIN SIGNUP PAGE</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>

        body {
            background-color: #f4c476;
        }

    </style>

</head>

<body>

<div class="container">

    <h1 class="text-center">
        SIGNUP PAGE
    </h1>

    <form action="signup.jsp" method="post">

        <div class="mb-3">

            <label>ID:</label>

            <input type="text"
                   class="form-control"
                   name="id"
                   required>

        </div>


        <div class="mb-3">

            <label>Name:</label>

            <input type="text"
                   class="form-control"
                   name="name"
                   required>

        </div>


        <div class="mb-3">

            <label>PASSWORD:</label>

            <input type="password"
                   class="form-control"
                   name="password"
                   required>

        </div>


        <div class="row">

            <div class="col">

                <input type="submit"
                       class="btn btn-primary"
                       name="signup"
                       value="Signup">

            </div>


            <div class="col">

                <a href="login.jsp"
                   class="btn btn-success">
                    LOGIN
                </a>

            </div>


            <div class="col">

                <a href="reset_pass.jsp"
                   class="btn btn-success">
                    RESET PASSWORD
                </a>

            </div>


            <div class="col">

                <a href="forget_pass.jsp"
                   class="btn btn-success">
                    FORGET PASSWORD
                </a>

            </div>

        </div>

    </form>

</div>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>
```
