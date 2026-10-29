
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>LOGIN PAGE</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        body {
            background-color: #f4c476;
        }

        .login-box {
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
    <div class="login-box">

        <h1 class="text-center mb-4">LOGIN PAGE</h1>

        <% if ("invalid".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger">
                Invalid name or password. Please try again.
            </div>
        <% } %>

        <% if ("server".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger">
                Login failed due to a server error. Please try again.
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/loginp.jsp"
              method="post">

            <div class="mb-3">
                <label for="name" class="form-label">Name:</label>
                <input type="text"
                       id="name"
                       name="name"
                       class="form-control"
                       maxlength="100"
                       required>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">Password:</label>
                <input type="password"
                       id="password"
                       name="password"
                       class="form-control"
                       required>
            </div>

            <div class="d-flex flex-wrap gap-2">
                <button type="submit" class="btn btn-primary">
                    LOGIN
                </button>

                <a href="${pageContext.request.contextPath}/signup.jsp"
                   class="btn btn-success">
                    SIGNUP
                </a>

                <a href="${pageContext.request.contextPath}/reset_pass.jsp"
                   class="btn btn-warning">
                    RESET PASSWORD
                </a>

                <a href="${pageContext.request.contextPath}/forget_pass.jsp"
                   class="btn btn-info">
                    FORGET PASSWORD
                </a>
            </div>

        </form>
    </div>
</div>
</body>
</html>
