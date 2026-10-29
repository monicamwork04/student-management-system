<!doctype html>
<%@ page import ="java.sql.*" %>
<%@ page import ="DB.JDBC" %>
<%
    if(request.getParameter("signup") != null)
    {
      String id =  request.getParameter("id");
      String name = request.getParameter("name");
      String password = request.getParameter("password");
      String sql = "sp_a_insert ?,?,?";
      
      Connection con = JDBC.con();

PreparedStatement ps = con.prepareStatement(sql);

ps.setString(1, id);
ps.setString(2, name);
ps.setString(3, password);

int a = ps.executeUpdate();

ps.close();
con.close();
     
      
      <script>
      alert("ADDED-------");
      location.assign("http://10.217.123.110:8080/JSP_STUDENT/signup.jsp");
      </script>
      
       <script>
      alert("Not added-------");
      </script>
      
}
      </script>
      <% 
       }
       }catch (Exception e) {out.println("Error:" +e);}
       }
       %>
      
     
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>STUDENT WEBSITE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
    <style>
        body{
            background-color: #f4c476;
        }
    </style>
  </head>
  <body>
      <nav class ="navbar navbar-expand-lg navbar-dark bg-dark">
          < a class ="navbar-brand" href="student.jsp">JSP STUDENT</a>
      
      <div class="collapse navbar-collapse">
          <ul class="navbar-nav ml-auto">
              <li class="nav-item">
                  <a class="nav-link" href="admin_details.jsp">ADMIN</a><!-- comment -->
                 
              </li>
              <li class="nav-item">
                  <form action="PDF" method="get">
                      <button type ="submit" class="btn btn-success">PDF</button><!-- comment -->
                  </form>
              </li>
              <li class="nav-item">
                  <form action="CSV" method="get">
                
                    <button type="submit" class="btn btn-primary"> CSV </button> 
                    </form>   
              </li>
              <li  class="nav-item">
                  <form action="CSV" method="get">
                      <button type="submmit" class="btn btn-primary"> csv </button><!-- comment -->
                  </form>
              </li>
          </ul>
      </div>
  </nav>
      
      
      
      
      
      <div class ="container">
          <h1 class="text-center"> SIGNUP PAGE </h1>
          <form action ="signup.jsp" method="post">
              <div class="mb-3">
                  <label> ID: </label>
                  <input type ="text" class="form-control" name="id" required="">
              </div>
              <div class ="mb-3">
                  <label> Name: </label>
                  <input type ="text" class="form-control" name="name" required="">
              </div>
              <div class ="mb-3">
                  <label> PASSWORD: </label>
                  <input type ="text" class="form-control" name="password" required="">
              </div>
              <div class ="row">
                  <div  class="col">
                      <input type ="submit" class="btn btn-primary" name="signup" value="signup">
                  </div>
             <div  class="col">
                 <a href=login.jsp" class="btn btn-success"> LOGIN </a>
                  </div>
             <div  class="col">
                 <a href="reset_pass.jsp" class="btn btn-success"> RESET PASSWORD </a>
                  </div>
             <div  class="col">
                 <a href="forget_pass.jsp" class="btn btn-success"> FORGET PASSWORD </a>
                  </div>
              </div>
          </form>
      </div> 
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
  </body>
</html>