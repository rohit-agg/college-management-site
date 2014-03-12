<%-- 
    Document   : new_time_table
    Created on : Jun 30, 2011, 6:43:15 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="initial.server, java.sql.*, java.util.ArrayList" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%!
	String[] get_lecture_timings()
	{
            ArrayList<String> temp_lecture_timings = new ArrayList<String>();
            try
            {
                String query;
                Statement execute_query;
                ResultSet result_set;

                query = "select * from TimeTable.Timings";
                execute_query = server.server_connection.createStatement();
                result_set = execute_query.executeQuery(query);

                while(result_set.next())
                    temp_lecture_timings.add(result_set.getTime("StartTime").getHours() + ":" + result_set.getTime("StartTime").getMinutes() + " - " + result_set.getTime("EndTime").getHours() + ":" + result_set.getTime("EndTime").getMinutes());
            }
            catch(SQLException e)
            {
            }

            int i = 0;
            String[] lecture_timings = new String[temp_lecture_timings.size()];
            for(String temp : temp_lecture_timings)
                lecture_timings[i++] = temp;

            return lecture_timings;
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

    if(request.getAttribute("batch") == null || request.getAttribute("degree") == null || request.getAttribute("branch") == null || request.getAttribute("semester") == null)
        response.sendRedirect("/ClgMgtSite/timetable/new_class.jsp");
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>College Management System - Time Table</title>
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/general.css" />
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/input.css" />
        <script type="text/javascript">
            <!--
            function validate()
            {
                var errors_tag = document.getElementById("errors");
                var no_of_lectures = document.getElementById("no-of-lectures");
                var employee_id_string = "employee-id-";
                var subject_code_string = "subject-code-";
                var employee_id = new Array();
                var subject_code = new Array();
                var error = new Boolean();

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";

                for(var i=0; i<5; i++)
                {
                    employee_id[i] = document.getElementsByName(employee_id_string.concat(i));
                    subject_code[i] = document.getElementsByName(subject_code_string.concat(i));
                }

                error = false;
                for(var i=0; i<5; i++)
                {
                    for(var j=0; j<no_of_lectures.value; j++)
                    {
                        if(employee_id[i][j].value != null && employee_id[i][j].value != "")
                        {
                            if(subject_code[i][j].value == null || subject_code[i][j].value == "")
                            {
                                errors_tag.innerHTML += "<li>Every Employee ID must have a corresponding Subject Code.</li>";
                                error = true;
                                break;
                            }
                        }
                        else
                        {
                            if(subject_code[i][j].value != null && subject_code[i][j].value != "")
                            {
                                errors_tag.innerHTML += "<li>Every Subject Code must have a corresponding Employee ID.</li>";
                                error = true;
                                break;
                            }
                        }
                    }

                    if(error == true)
                        break;
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
        batch = (String)request.getAttribute("batch");

        String degree = "";
        degree = (String)request.getAttribute("degree");

        String branch = "";
        branch = (String)request.getAttribute("branch");

        String semester = "";
        semester = (String)request.getAttribute("semester");

        String[] lecture_timings = get_lecture_timings();

        int no_of_lectures = 0;
        if(request.getAttribute("no-of-lectures") != null)
            no_of_lectures = Integer.parseInt((String)request.getAttribute("no-of-lectures"));
        else
            no_of_lectures = lecture_timings.length;

        String[][] employee_id = new String[5][no_of_lectures];
        if(request.getAttribute("employee-id") != null)
            employee_id = (String[][])request.getAttribute("employee-id");
        else
            for(int i=0; i<no_of_lectures; i++)
                for(int j=0; j<5; j++)
                    employee_id[j][i] = "";
        
        String[][] subject_code = new String[5][no_of_lectures];
        if(request.getAttribute("subject-code") != null)
            subject_code = (String[][])request.getAttribute("subject-code");
        else
            for(int i=0; i<no_of_lectures; i++)
                for(int j=0; j<5; j++)
                    subject_code[j][i] = "";
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
                    <form action="new_time_table2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td colspan="2">Batch</td>
                                <td colspan="2"><input type="textbox" name="batch" id="batch" value="<%= batch %>" readonly /></td>
                                <td colspan="2">Semester</td>
                                <td colspan="2"><input type="textbox" name="semester" id="semester" value="<%= semester %>" readonly /></td>
                            </tr>
                            <tr>
                                <td colspan="2">Degree</td>
                                <td colspan="2"><input type="textbox" name="degree" id="degree" value="<%= degree %>" readonly /></td>
                                <td colspan="2">Branch</td>
                                <td colspan="2"><input type="textbox" name="branch" id="branch" value="<%= branch %>" readonly /></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><input type="hidden" name="no-of-lectures" id="no-of-lectures" value="<%= no_of_lectures %>" /></td>
                                <td>Monday</td>
                                <td>Tuesday</td>
                                <td>Wednesday</td>
                                <td>Thursday</td>
                                <td>Friday</td>
                            </tr>
                            <%
                                for(int i=0; i<no_of_lectures; i++)
                                {
                            %>
                                    <tr>
                                        <td rowspan="2">Lecture <%= i+1 %><br/><%= lecture_timings[i] %></td>
                                        <td>Employee ID</td>
                                        <td><input type="textbox" name="employee-id-0" id="employee-id-0" value="<%= employee_id[0][i] %>" /></td>
                                        <td><input type="textbox" name="employee-id-1" id="employee-id-1" value="<%= employee_id[1][i] %>" /></td>
                                        <td><input type="textbox" name="employee-id-2" id="employee-id-2" value="<%= employee_id[2][i] %>" /></td>
                                        <td><input type="textbox" name="employee-id-3" id="employee-id-3" value="<%= employee_id[3][i] %>" /></td>
                                        <td><input type="textbox" name="employee-id-4" id="employee-id-4" value="<%= employee_id[4][i] %>" /></td>
                                    </tr>
                                    <tr>
                                        <td>Subject Code</td>
                                        <td><input type="textbox" name="subject-code-0" id="subject-code-0" value="<%= subject_code[0][i] %>" /></td>
                                        <td><input type="textbox" name="subject-code-1" id="subject-code-1" value="<%= subject_code[1][i] %>" /></td>
                                        <td><input type="textbox" name="subject-code-2" id="subject-code-2" value="<%= subject_code[2][i] %>" /></td>
                                        <td><input type="textbox" name="subject-code-3" id="subject-code-3" value="<%= subject_code[3][i] %>" /></td>
                                        <td><input type="textbox" name="subject-code-4" id="subject-code-4" value="<%= subject_code[4][i] %>" /></td>
                                    </tr>
                            <%
                                }
                            %>
                            <tr>
                                <td class="button" colspan="2"><input type="submit" name="enter" value="Enter Details" /></td>
                                <td class="button" colspan="2"><input type="button" name="cancel" value="Cancel" onclick="cancel_page()" /></td>
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
