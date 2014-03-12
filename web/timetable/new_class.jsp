<%-- 
    Document   : new_class
    Created on : Jun 30, 2011, 6:29:00 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="initial.server, java.sql.*, java.util.ArrayList" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%!
	String[] get_degree_name()
	{
            ArrayList<String> temp_degree_name = new ArrayList<String>();
            try
            {
                String query;
                Statement execute_query;
                ResultSet result_set;

                query = "select SDegree from Administration.Degree";
                execute_query = server.server_connection.createStatement();
                result_set = execute_query.executeQuery(query);

                while(result_set.next())
                    temp_degree_name.add(result_set.getString("SDegree"));
            }
            catch(SQLException e)
            {
            }

            int i = 0;
            String[] degree_name = new String[temp_degree_name.size()];
            for(String temp : temp_degree_name)
                degree_name[i++] = temp;

            return degree_name;
	}

	String[] get_branch_name()
	{
            ArrayList<String> temp_department_name = new ArrayList<String>();
            try
            {
                String query;
                Statement execute_query;
                ResultSet result_set;

                query = "select Name from Administration.Department where Type=\'Education\'";
                execute_query = server.server_connection.createStatement();
                result_set = execute_query.executeQuery(query);

                while(result_set.next())
                    temp_department_name.add(result_set.getString("Name"));
            }
            catch(SQLException e)
            {
            }

            int i = 0;
            String[] department_name = new String[temp_department_name.size()];
            for(String temp : temp_department_name)
                department_name[i++] = temp;

            return department_name;
	}

        String[] get_batch_details()
	{
            ArrayList<String> temp_batch_details = new ArrayList<String>();
            try
            {
                String query;
                Statement execute_query;
                ResultSet result_set;

                query = "select * from Administration.Batch";
                execute_query = server.server_connection.createStatement();
                result_set = execute_query.executeQuery(query);

                while(result_set.next())
                    temp_batch_details.add(result_set.getString("StartYear") + " - " + result_set.getString("EndYear"));
            }
            catch(SQLException e)
            {
            }

            int i = 0;
            String[] batch_details = new String[temp_batch_details.size()];
            for(String temp : temp_batch_details)
                batch_details[i++] = temp;

            return batch_details;
	}
%>

<%
    String valid_user = request.getSession().getAttribute("user").toString();
    boolean valid = false;
    if(valid_user.compareTo("Administrator") == 0)
       valid = true;
    else if(valid_user.compareTo("Administration") == 0)
       valid = true;
    else if(valid_user.compareTo("Faculty") == 0)
       valid = true;
    if(valid == false)
      response.sendRedirect("/ClgMgtSite/general/login.jsp");
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>College Management System</title>
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/general.css" />
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/input.css" />
        <script type="text/javascript">
            <!--
            function validate()
            {
                var errors_tag = document.getElementById("errors");                
                var semester = document.getElementById("semester");
                var error = new Boolean();

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";

                if(semester.value == "" || semester.value == null)
                {
                    errors_tag.innerHTML += "<li>Semester can't be left blank.</li>";
                    error = true;
                }
                else if(isNaN(semester.value))
                {
                     errors_tag.innerHTML += "<li>Semester must be a valid number.</li>";
                     error = true;
                }
                else if(semester.value <= 0)
                {
                     errors_tag.innerHTML += "<li>Semester must be greater than 0.</li>";
                     error = true;
                }
                
                if(error == true)
                {
                    errors_tag.className = "internal-error";
                    return false;
                }
                else
                {
                    errors_tag.className = "";
                    errors_tag.style.display = "none";
                    return true;
                }
            }
            -->
        </script>
    </head>
    <%
        String batch = "";
        if(request.getAttribute("batch") != null)
            batch = (String)request.getAttribute("batch");

        String degree = "";
        if(request.getAttribute("degree") != null)
            degree = (String)request.getAttribute("degree");

        String branch = "";
        if(request.getAttribute("branch") != null)
            branch = (String)request.getAttribute("branch");

        String semester = "";
        if(request.getAttribute("semester") != null)
            semester = (String)request.getAttribute("semester");

        String[] show_degree = get_degree_name();
	String[] show_branch = get_branch_name();
        String[] show_batch = get_batch_details();
    %>
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
                    <h1 class="pagetitle">Class (Time Table) - New</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="new_class2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td>Batch</td>
                                <td>
                                    <select name="batch" id="batch">
                                        <%
                                            for(String temp : show_batch)
                                            {
                                        %>
                                                <option value="<%= temp %>" <% if(temp.compareTo(batch) == 0) { out.write("selected"); }%> ><%= temp %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>Degree</td>
                                <td>
                                    <select name="degree" id="degree">
                                        <%
                                            for(String temp : show_degree)
                                            {
                                        %>
                                                <option value="<%= temp %>" <% if(temp.compareTo(degree) == 0) { out.write("selected"); }%> ><%= temp %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>Branch</td>
                                <td>
                                    <select name="branch" id="branch">
                                        <%
                                            for(String temp : show_branch)
                                            {
                                        %>
                                                <option value="<%= temp %>" <% if(temp.compareTo(branch) == 0) { out.write("selected"); }%> ><%= temp %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>Semester</td>
                                <td><input type="textbox" name="semester" id="semester" value="<%= semester %>" /></td>
                            </tr>
                            <tr>
                                <td class="button"><input type="submit" name="enter" value="Enter Details" /></td>
                                <td class="button"><input type="button" name="cancel" value="Cancel" onclick="cancel_page()" /></td>
                            </tr>
                        </table>
                    </form>
                </div>
            </div>
            <div class="footer">
                <%@include file="/WEB-INF/resource/footer.jspf" %>
            </div>
        </div>
    </body>
</html>
