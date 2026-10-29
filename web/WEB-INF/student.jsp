<%@page import="jakarta.persistence.Timeout.s(...)"%>
<%@ page import ="java.sql.*" %>
<%@ page import ="jakarta.servlet.http.*" %>
<%@ page import ="jakarta.servlet.*" %>
<%@ page import ="DB.JDBC" %>

<%
    java.util.Date now = new java.util.Date();
     java.sql.Time ct = new java.sql.Time(now.getTime());
    
    HttpSession ses = request.getSession();
       String name=(String)ses.getAttribute("name");
       
       
       ses.setMaxInactiveInterval(180);
       
       
       if(name == null)
       {
          response.sendRedirect("login.jsp");
       }

if(request.getParameter("logout") !=null)
{
    s.removeAttribute("n");
    response.sendRedirect("login.jsp");
}
%>

<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ADMIN SIGNUP PAGE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
    <style>
        body{
            background-color: #f4c476;
        }
    </style>
        <script>
            function print(){
            alert ("print is on........");
            var toprint = documnet.getElementById("print");
            var newWin = window.open("");
            newWin.document.write('<html><head><title> STUDENTS DETAILS </title><head><body>');
            newWin.document.write(toPrint.outerHTML);
            newWin.document.write('</body></html>');
            newWin.print();
            newWin.close();
            }
            <% 
               String alert ="LOGGED OUT";
            %>
                   
             function show (msg)
                   {
                     alert(msg);
                     }
                   </script>
        </head>
  <body>
      <div class ="container-fluid">
          <h2> Welcome hai-----, <%=name%>!</h2><br>
          <h1 class="text-center">STUDENT INFORMATION PAGE </h1>
          <form action ="stu_add" method="post" enotype="multipost/form-data" class="row g-3">
              <div class="col-md-6">
                  <label> ID: </label>
                  <input type ="text" class="form-control" name="id" required>
              </div>
              <div class ="col-md-6">
                  <label> Name: </label>
                  <input type ="text" class="form-control" name="name" required>
              </div>
              <div class ="col-md-6">
                  <label> DOB </label>
                  <input type ="text" class="form-control" name="password" required>
              </div>
               <div class ="col-md-6">
                  <label> IMAGE </label>
                  <input type ="file" class="form-control" name="image" required>
              <div class ="col-md-6">
                  <label>TIME </label>
                  <input type ="text" class="form-control" name="time" value="<%=ct%>" randomly="">
                       </div>
               
       

              <div class ="col-md-6">
                  <label> Gender </label><!-- comment -->
                  <div  class="form-check">
                      
                     <input type ="radio"  name="gender" value="Male" class="form-check-input" required>
                     <label> Male </label><!-- comment -->
                  
                  </div>
                  
                  
             <div  class="form-check">
                   <input type ="radio"  name="gender" value="Female" class="form-check-input" required>
                     <label> Female </label><!-- comment -->
                
                  </div>
              </div>
                  
                  
             <div  class="col-md-6">
                 <label> COURSE </label>
                 <select name="course" class="form-select" required><!-- comment --><!-- comment -->
                     <option> ---select a course--- </option><!-- comment -->
                     <%
                         String sql2="sp_c_get_all";
                         
                         try(Connection con = JDBC.con();
                         PreparedStatement ps1 = con.preparedSatement(sql2);)
                         {
                          Resultset = ps1.executeQuery();
                          while(rs.next())
                          {
                          String cou = rs.getString("name");
                          %>
                          
                          <option><%=cou%></option>
                          <%
                              }
                                }
                                  catch(Exception e){
                                out.println(e);
                                  }
                          %>
                 </select>
                 </div>  
                 
                 <div class="col-12">
                     <button type="submit" class="btn btn-primary w-100">submit </button>
                 </div>
                 
                 }
             </div>
          </form>
    
          <br>
          <br>
          <br>
          <div class ="row">
              
              <div class="col">
                 <a href="course.jsp" class="btn btn-sucess"> course </a><!-- comment -->
              </div>
              <div class="col">
                  <form>
                      <input type="submit" name="logout" value="LOGOUT"
                             onclick="show('show<%= alert %>')" class"btn btn-primary"><!-- comment -->
                  </form>
              </div>
                  <div class="col">
                      <form>
                          <button class="btn btn-primary" onclick="print()">print</button>
                      </form>
                  </div>    
                  </div>  
                  
                 <br><!-- comment -->
                 <div class="container">
                     <h2 class="text-center"     style="color:brown"> student list </h2>
                     <table id="print" class="table table-bordered"
                            style="border:2px solid black; text-align:center;">
                         <tr>
                             <th> ID </th>
                             <th> Name </th>
                             <th> Dob </th>
                             <th> Gender</th>
                             <th> Time</th>
                             <th> course</th>
                             <th> Image</th>
                             <th> Actions</th>
                         </tr>
                 
                         <%
                             ResultSet resultSet=ps.execteQuery();
                             String sql = "sp_s1_get"; 
                             while(resultSet.next())
                             {
                             String id = resultSet.getString("id");
                             String name = resultSet.getString("name");
                             String dob = resultSet.getString("dob").toString;
                             String gender = resultSet.getString("gen");
                             String time= resultSet.getString("time").toString;
                             String course = resultSet.getString("cou");
                         %>
                         <tr>
                             <td> <%=id %> </td>
                             <td><%=name1 %> </td>
                             <td> <%=dob %> </td>
                             <td> <%=gender %> </td>
                             <td> <%=time%> </td>
                             <td> <%=course %> </td>
                             <td> 
                                 <img src="data:image/jpeg;base64,
                                      <%=java.util.Base64.getEncoder().encodeToString(resultSet.getBytes("img"))%>"
                                      width="50" height="50">
             
                            </td>
                            <td> 
                                    <form action="Stu_edit" method="post" style="display:inline-block;">
                                      <input type="hidden" name="id" value="<%=id%>">
                                      <button type="submit" class="btn btn-warning btn-sm"> Edit </button>
                                    </form>
                                      
                                      <form action="stu_del"  method="post" style="display:inline-block;">
                                          <input type="hidden" name="id" value="<%=id%>"><!-- comment -->
                                          <button type="submit" class="btn btn-danger btn-sm"> Delete </button>
                                      </form>
                            </td>
                         </tr><!-- comment -->
                         <%  
                             }
                         }catch(Exception e)

                       {
                         e.printStackTrace();
                        }
                      %>
                     </table>
                 </div>
                      <jsp:include page="footer.jsp"/>           
  </div>
      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
  </body>
  
</html>