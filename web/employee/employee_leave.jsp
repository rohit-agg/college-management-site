<%-- 
    Document   : employee_leave
    Created on : Jul 2, 2011, 6:29:10 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="initial.server, java.sql.*, java.util.ArrayList" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%!
        ResultSet get_leave_details(String employee_id)
	{
            ResultSet result_set = null;
            try
            {
                String query;
                PreparedStatement execute_query;
                
                query = "select * from Employee.Leave where EmployeeID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, employee_id);
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
	}

        boolean whether_leave(String employee_id)
        {
            boolean whether = false;

            try
            {
                String query;
                PreparedStatement execute_query;
                ResultSet result_set;

                query = "select * from Employee.Leave where EmployeeID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, employee_id);
                result_set = execute_query.executeQuery();

                if(result_set.next())
                    whether = true;
            }
            catch(SQLException e)
            {
            }

            return whether;
        }
%>

<%
    String valid_user = request.getSession().getAttribute("user").toString();
    boolean valid = false;
    if(valid_user.compareTo("Administrator") == 0)
       valid = true;
    else if(valid_user.compareTo("Administration") == 0)
       valid = true;
    else if(valid_user.compareTo("Accounts") == 0)
       valid = true;
    else if(valid_user.compareTo("Exam Cell") == 0)
       valid = true;
    else if(valid_user.compareTo("Library") == 0)
       valid = true;
    else if(valid_user.compareTo("Training and Placement") == 0)
       valid = true;
    else if(valid_user.compareTo("Faculty") == 0)
       valid = true;
    if(valid == false)
      response.sendRedirect("/ClgMgtSite/general/login.jsp");

    String employee_id = (String)request.getParameter("employee-id");
    if(employee_id == null || employee_id.compareTo("") == 0)
        response.sendRedirect("all_employee.jsp");

    boolean whether = whether_leave(employee_id);
    if(whether == false)
    {
        request.setAttribute("warning", "No Leave Details exists for the Employee: " + employee_id + " in the database.");
        RequestDispatcher all_employee = request.getRequestDispatcher("all_employee.jsp");
        all_employee.forward(request, response);
    }
    
    ResultSet leave_details = get_leave_details(employee_id);
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>College Management System</title>
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/general.css" />
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/display.css" />
    </head>
    <body>
        <div class="page-container">
            <div class="header">
                <%@include file="/WEB-INF/resource/header.jspf" %>
            </div>
            <div>
                <%@include file="/WEB-INF/resource/menubar.jspf" %>
            </div>
            <div class="main">
                <div class="main-navigation">
                    <%@include file="/WEB-INF/resource/navigationbar.jspf" %>
                </div>
                <div class="main-content">
                    <h1 class="pagetitle">Employee - <%= employee_id %> (Leaves)</h1>
                    <table width="500px">
                        <tr>
                            <th width="20%">Leave Date</th>
                            <th width="80%">Leave Details</th>
                        </tr>
                        <%
                            if(leave_details != null)
                            {
                                while(leave_details.next())
                                {
                         %>
                         <tr>
                             <td><%= leave_details.getDate("LeaveDate").toString() %></td>
                             <td><%= leave_details.getString("LeaveDetails") %></td>
                         </tr>
                         <%
                                }
                            }
                        %>
                    </table>
                </div>
            </div>
            <div class="footer">
                <%@include file="/WEB-INF/resource/footer.jspf" %>
            </div>
        </div>
    </body>
</html>
