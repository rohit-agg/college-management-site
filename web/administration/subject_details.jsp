<%-- 
    Document   : subject_details
    Created on : Jul 2, 2011, 1:03:27 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="initial.server, java.sql.*, java.util.ArrayList" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%!
        ResultSet get_details(String subject_code)
	{
            ResultSet result_set = null;
            try
            {
                String query;
                PreparedStatement execute_query;

                query = "select * from Administration.Subject where SubjectCode=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, subject_code);
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
	}
        
        ResultSet get_subject_details(String subject_code)
	{
            ResultSet result_set = null;
            try
            {
                String query;
                PreparedStatement execute_query;
                
                query = "select * from Administration.AllowedSubject where SubjectCode=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, subject_code);
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
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

    String subject_code = (String)request.getParameter("subject-code");
    if(subject_code == null || subject_code.compareTo("") == 0)
        response.sendRedirect("all_subject.jsp");

    ResultSet details = get_details(subject_code);
    String subject_name = "";
    if(details.next())
    {
        subject_name = details.getString("SubjectName");
    }
    else
    {
        request.setAttribute("warning", "Subject: " + subject_code + " doesn't exists in the database of college.");
        RequestDispatcher all_subject = request.getRequestDispatcher("all_subject.jsp");
        all_subject.forward(request, response);
    }

    ResultSet subject_details = get_subject_details(subject_code);
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
                    <h1 class="pagetitle">Subject - <%= subject_code %></h1>
                    <div class="div-display">
                        <table>
                            <tr>
                                <th width="40%">Subject Name</th>
                                <td width="60%"><%= subject_name %></td>
                            </tr>
                            <tr>
                                <th>Subject Code</th>
                                <td><%= subject_code %></td>
                            </tr>
                        </table>
                    </div>
                    <div class="div-display">
                        <table width="500px">
                            <%
                                if(subject_details != null)
                                {
                                    while(subject_details.next())
                                    {
                                        if(subject_details.getRow() == 1)
                                        {
                            %>
                            <tr>
                                <th width="17%">Degree</th>
                                <th width="50%">Department</th>
                                <th width="17%">Semester</th>
                                <th width="16%">Category</th>
                            </tr>
                            <%
                                        }
                            %>
                            <tr>
                                <td><%= get_degree(subject_details.getInt("DegreeID")) %></td>
                                <td><%= get_department(subject_details.getInt("DepartmentID")) %></td>
                                <td><%= subject_details.getInt("Semester") %></td>
                                <td><%= subject_details.getString("Category") %></td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </table>
                    </div>
                </div>
            </div>
            <div class="footer">
                <%@include file="/WEB-INF/resource/footer.jspf" %>
            </div>
        </div>
    </body>
</html>
