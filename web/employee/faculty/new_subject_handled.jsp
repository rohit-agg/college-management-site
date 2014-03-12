<%-- 
    Document   : new_subject_handled
    Created on : Jun 29, 2011, 7:47:30 PM
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
                var employee_id = document.getElementById("employee-id");
                var semesters = document.getElementsByName("semester");
                var error = new Boolean();

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";

                if(employee_id.value == "" || employee_id.value == null)
                {
                     errors_tag.innerHTML += "<li>Employee ID can't be left blank.</li>";
                     error = true;
                }

                for(var i=0; i<semesters.length; i++)
                {
                    if(semesters[i].value != "" && semesters[i].value != null)
                    {
                        if(isNaN(semesters[i].value))
                        {
                            errors_tag.innerHTML += "<li>All semesters must be a valid number.</li>";
                            error = true;
                            break;
                        }
                    }
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

            function add_new_subject()
            {
                var span_branch = document.getElementById("add-branch");
                var span_semester = document.getElementById("add-semester");
                var span_degree = document.getElementById("add-degree");
                var span_subject = document.getElementById("add-subject");

                var input = document.createElement("select");
                input.name = "degree";
                input.id = "degree";

                var degree_values = document.getElementsByName("degree-value");
                for(var i=0; i<degree_values.length; i++)
                {
                    var option = document.createElement("option");
                    option.value = degree_values[i].value;
                    option.textContent = degree_values[i].value;
                    input.appendChild(option);
                }
                span_degree.appendChild(input);
                var break_ = document.createElement("br");
                span_degree.appendChild(break_);

                var input = document.createElement("select");
                input.name = "branch";
                input.id = "branch";

                var branch_values = document.getElementsByName("branch-value");
                for(var i=0; i<branch_values.length; i++)
                {
                    var option = document.createElement("option");
                    option.value = branch_values[i].value;
                    option.textContent = branch_values[i].value;
                    input.appendChild(option);
                }
                span_branch.appendChild(input);
                var break_ = document.createElement("br");
                span_branch.appendChild(break_);

                var input = document.createElement("input");
                input.type = "textbox";
                input.name = "semester";
                input.id = "semester";
                span_semester.appendChild(input);
                var break_ = document.createElement("br");
                span_semester.appendChild(break_);

                var input = document.createElement("input");
                input.type = "textbox";
                input.name = "subject";
                input.id = "subject";
                span_subject.appendChild(input);
                var break_ = document.createElement("br");
                span_subject.appendChild(break_);
            }
            -->
        </script>
    </head>
    <%
        String message = "";
        if(request.getAttribute("error") != null)
            message = (String)request.getAttribute("error");

        String employee_id = "";
        if(request.getAttribute("employee-id") != null)
            employee_id = (String)request.getAttribute("employee-id");

        String[] branch = null;
        if(request.getAttribute("branch") != null)
            branch = (String [])request.getAttribute("branch");

        String[] semester = null;
        if(request.getAttribute("semester") != null)
            semester = (String [])request.getAttribute("semester");

        String[] degree = null;
        if(request.getAttribute("degree") != null)
            degree = (String [])request.getAttribute("degree");

        String[] subject = null;
        if(request.getAttribute("subject") != null)
            subject = (String [])request.getAttribute("subject");

        String[] show_branch = get_branch_name();
        String[] show_degree = get_degree_name();
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
                    <h1 class="pagetitle">Subject Handled - New</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="new_subject_handled2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td>Employee ID</td>
                                <td><input type="textbox" name="employee-id" id="employee-id" value="<%= employee_id %>" /></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <table>
                                        <tr>
                                            <td>Degree</td>
                                            <td>Branch</td>
                                            <td>Semester</td>                                            
                                            <td>Subject</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <%
                                                    for(String temp : show_degree)
                                                    {
                                                %>
                                                        <input type="hidden" name="degree-value" id="degree-value" value="<%= temp %>" />
                                                <%
                                                    }
                                                %>
                                                <span id="add-degree">
                                                    <%
                                                        if(degree != null)
                                                        {
                                                            for(String temp : degree)
                                                            {
                                                    %>
                                                                <select name="degree" id="degree">
                                                    <%
                                                                for(String temp2 : show_degree)
                                                                {
                                                    %>
                                                                    <option value="<%= temp2 %>" <% if(temp2.compareTo(temp) == 0) { out.write("selected"); }%> ><%= temp2 %></option>
                                                    <%
                                                                }
                                                    %>
                                                                </select><br/>
                                                    <%
                                                            }
                                                        }
                                                    %>
                                                </span>
                                            </td>
                                            <td>
                                                <%
                                                    for(String temp : show_branch)
                                                    {
                                                %>
                                                        <input type="hidden" name="branch-value" id="branch-value" value="<%= temp %>" />
                                                <%
                                                    }
                                                %>
                                                <span id="add-branch">
                                                    <%
                                                        if(branch != null)
                                                        {
                                                            for(String temp : branch)
                                                            {
                                                    %>
                                                                <select name="branch" id="branch">
                                                    <%
                                                                for(String temp2 : show_branch)
                                                                {
                                                    %>
                                                                    <option value="<%= temp2 %>" <% if(temp2.compareTo(temp) == 0) { out.write("selected"); }%> ><%= temp2 %></option>
                                                    <%
                                                                }
                                                    %>
                                                                </select><br/>
                                                    <%
                                                            }
                                                        }
                                                    %>
                                                </span>
                                            </td>
                                            <td>
                                                <span id="add-semester">
                                                    <%
                                                        if(semester != null)
                                                        {
                                                            for(String temp : semester)
                                                            {
                                                    %>
                                                                <input type="textbox" name="semester" id="semester" value="<%= temp %>" /><br/>
                                                    <%
                                                            }
                                                        }
                                                    %>
                                                </span>
                                            </td>                                            
                                            <td>
                                                <span id="add-subject">
                                                    <%
                                                        if(subject != null)
                                                        {
                                                            for(String temp : subject)
                                                            {
                                                    %>
                                                                <input type="textbox" name="subject" id="subject" value="<%= temp %>" /><br/>
                                                    <%
                                                            }
                                                        }
                                                    %>
                                                </span>
                                            </td>
                                            <td style="vertical-align: bottom;">
                                                <input type="button" name="add-new" value="Add Subject" onclick="add_new_subject()" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
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
