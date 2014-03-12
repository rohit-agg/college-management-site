<%-- 
    Document   : all_class
    Created on : Jul 6, 2011, 12:22:58 AM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="initial.server, java.sql.*, java.util.ArrayList" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%!
        ResultSet get_all_class()
	{
            ResultSet result_set = null;
            try
            {
                String query;
                Statement execute_query;

                query = "select * from TimeTable.ClassDetail";
                execute_query = server.server_connection.createStatement();
                result_set = execute_query.executeQuery(query);
            }
            catch(SQLException e)
            {
            }

            return result_set;
	}

        String get_department(int department_id)
        {
            String department = "";

            try
            {
                String query;
                PreparedStatement execute_query;
                ResultSet result_set;

                query = "select * from Administration.Department where DepartmentID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, department_id);
                result_set = execute_query.executeQuery();
                result_set.next();
                department = result_set.getString("Name");
            }
            catch(SQLException e)
            {
            }

            return department;
        }

        String get_degree(int degree_id)
        {
            String degree = "";

            try
            {
                String query;
                PreparedStatement execute_query;
                ResultSet result_set;

                query = "select * from Administration.Degree where DegreeID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, degree_id);
                result_set = execute_query.executeQuery();
                result_set.next();
                degree = result_set.getString("SDegree");
            }
            catch(SQLException e)
            {
            }

            return degree;
        }

        String get_batch(int batch_id)
        {
            String batch = "";

            try
            {
                String query;
                PreparedStatement execute_query;
                ResultSet result_set;

                query = "select * from Administration.Batch where BatchID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, batch_id);
                result_set = execute_query.executeQuery();
                result_set.next();
                batch = result_set.getInt("StartYear") + " - " + result_set.getInt("EndYear");
            }
            catch(SQLException e)
            {
            }

            return batch;
        }

        int count_class()
        {
            int count = 0;

            try
            {
                String query;
                Statement execute_query;
                ResultSet result_set;

                query = "select * from TimeTable.CountClass";
                execute_query = server.server_connection.createStatement();
                result_set = execute_query.executeQuery(query);
                result_set.next();
                count = result_set.getInt("NoOfClass");
            }
            catch(SQLException e)
            {
            }

            return count;
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
    else if(valid_user.compareTo("Student") == 0)
       valid = true;
    if(valid == false)
      response.sendRedirect("/ClgMgtSite/general/login.jsp");

    int count = count_class();
    String page_value = request.getParameter("page");
    int page_number = 1;
    if(count == 0)
    {
        request.setAttribute("warning", "No Class Detail currently exists in the database of college.");
        RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
        index.forward(request, response);
    }

    ResultSet all_class = get_all_class();
    if(page_value != null && page_value.compareTo("") != 0)
    {
        page_number = Integer.parseInt(page_value);
        if(page_number <= 0)
            page_number = 1;
        else if(page_number > ((count % 10 == 0) ? (count / 10) : ((count / 10) + 1)))
            page_number = (count % 10 == 0) ? (count / 10) : ((count / 10) + 1);
    }
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
                    <h1 class="pagetitle">Class</h1>
                    <%
                        if(request.getAttribute("warning") != null)
                        {
                    %>
                            <div class="message warning"><%= (String)request.getAttribute("warning") %></div>
                    <%
                        }
                    %>
                    <div class="div-display">
                        <table width="600px">
                            <tr>
                                <th width="15%">Degree</th>
                                <th width="40%">Department</th>
                                <th width="15%">Batch</th>
                                <th width="15%">Semester</th>
                                <th width="15%"></th>
                            </tr>
                            <%
                                if(all_class != null)
                                {
                                    int count_records = 0;
                                    while(count_records < ((page_number - 1) * 10))
                                    {
                                        all_class.next();
                                        count_records++;
                                    }

                                    count_records = 0;
                                    while(all_class.next() && count_records < 10)
                                    {
                            %>
                            <tr>
                                <td><%= get_degree(all_class.getInt("DegreeID")) %></td>
                                <td><%= get_department(all_class.getInt("DepartmentID")) %></td>
                                <td><%= get_batch(all_class.getInt("BatchID")) %></td>
                                <td><%= all_class.getInt("Semester") %></td>
                                <td>
                                    <a href="time_table.jsp?time-table-id=<%= all_class.getString("TimeTableID") %>">Time Table</a>
                                </td>
                            </tr>
                            <%
                                        count_records++;
                                    }
                                }
                            %>
                        </table>
                    </div>
                    <table class="page">
                        <tr>
                            <td><a href="all_department.jsp?page=<%= page_number - 1 %>">Previous</a></td>
                            <%
                                for(int i = (page_number - 5 > 1 ? page_number - 5 : 1); i <= (page_number - 1); i++)
                                {
                            %>
                            <td><a href="all_department.jsp?page=<%= i %>"><%= i %></a></td>
                            <%
                                }
                            %>
                            <td><a href="all_department.jsp?page=<%= page_number %>"><%= page_number %></a></td>
                            <%
                                for(int i = page_number + 1; i <= ((page_number + 5) < ((count % 10 == 0) ? (count / 10) : ((count / 10) + 1)) ? (page_number + 5) : ((count % 10 == 0) ? (count / 10) : ((count / 10) + 1))); i++)
                                {
                            %>
                            <td><a href="all_department.jsp?page=<%= i %>"><%= i %></a></td>
                            <%
                                }
                            %>
                            <td><a href="all_department.jsp?page=<%= page_number + 1 %>">Next</a></td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="footer">
                <%@include file="/WEB-INF/resource/footer.jspf" %>
            </div>
        </div>
    </body>
</html>
