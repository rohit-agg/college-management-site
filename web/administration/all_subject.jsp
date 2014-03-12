<%-- 
    Document   : all_subject
    Created on : Jul 2, 2011, 12:49:26 AM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="initial.server, java.sql.*, java.util.ArrayList" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%!
        ResultSet get_all_subject()
	{
            ResultSet result_set = null;
            try
            {
                String query;
                Statement execute_query;
                
                query = "select * from Administration.Subject";
                execute_query = server.server_connection.createStatement();
                result_set = execute_query.executeQuery(query);
            }
            catch(SQLException e)
            {
            }

            return result_set;
	}

        int count_subject()
        {
            int count = 0;

            try
            {
                String query;
                Statement execute_query;
                ResultSet result_set;

                query = "select * from Administration.CountSubject";
                execute_query = server.server_connection.createStatement();
                result_set = execute_query.executeQuery(query);
                result_set.next();
                count = result_set.getInt("NoOfSubject");
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

    int count = count_subject();
    String page_value = request.getParameter("page");
    int page_number = 1;
    if(count == 0)
    {
        request.setAttribute("warning", "No Subject currently exists in the database of college.");
        RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
        index.forward(request, response);
    }

    ResultSet all_subject = get_all_subject();
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
                    <h1 class="pagetitle">Subject</h1>
                    <%
                        if(request.getAttribute("warning") != null)
                        {
                    %>
                            <div class="message warning"><%= (String)request.getAttribute("warning") %></div>
                    <%
                        }
                    %>
                    <div class="div-content">
                        <table width="600px">
                            <tr>
                                <th width="50%">Subject Name</th>
                                <th width="16%">Subject Code</th>
                                <th width="13%">Exam Code</th>
                                <th width="13%">Maximum Marks</th>
                                <th width="8%"></th>
                            </tr>
                            <%
                                if(all_subject != null)
                                {
                                    int count_records = 0;
                                    while(count_records < ((page_number - 1) * 10))
                                    {
                                        all_subject.next();
                                        count_records++;
                                    }

                                    count_records = 0;
                                    while(all_subject.next() && count_records < 10)
                                    {
                            %>
                            <tr>
                                <td><%= all_subject.getString("SubjectName") %></td>
                                <td><%= all_subject.getString("SubjectCode") %></td>
                                <td><%= all_subject.getString("ExamCode") %></td>
                                <td><%= all_subject.getInt("MaximumMarks") %></td>
                                <td>
                                    <a href="subject_details.jsp?subject-code=<%= all_subject.getString("SubjectCode") %>">Details</a>
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
                            <td><a href="all_subject.jsp?page=<%= page_number - 1 %>">Previous</a></td>
                            <%
                                for(int i = (page_number - 5 > 1 ? page_number - 5 : 1); i <= (page_number - 1); i++)
                                {
                            %>
                            <td><a href="all_subject.jsp?page=<%= i %>"><%= i %></a></td>
                            <%
                                }
                            %>
                            <td><a href="all_subject.jsp?page=<%= page_number %>"><%= page_number %></a></td>
                            <%
                                for(int i = page_number + 1; i <= ((page_number + 5) < ((count % 10 == 0) ? (count / 10) : ((count / 10) + 1)) ? (page_number + 5) : ((count % 10 == 0) ? (count / 10) : ((count / 10) + 1))); i++)
                                {
                            %>
                            <td><a href="all_subject.jsp?page=<%= i %>"><%= i %></a></td>
                            <%
                                }
                            %>
                            <td><a href="all_subject.jsp?page=<%= page_number + 1 %>">Next</a></td>
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
