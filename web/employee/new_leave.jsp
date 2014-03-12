<%-- 
    Document   : new_leave
    Created on : Jun 29, 2011, 12:44:10 AM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

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
    else if(valid_user.compareTo("Faculty") == 0)
       valid = true;
    if(valid == false)
      response.sendRedirect("/CollegeMgtSite/general/login.jsp");
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>College Management System - New Employee Leave</title>
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/general.css" />
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/input.css" />
        <script type="text/javascript">
            <!--
            function validate()
            {
                var errors_tag = document.getElementById("errors");
                var employee_id = document.getElementById("employee-id");
                var date = document.getElementById("date");
                var month = document.getElementById("month");
                var year = document.getElementById("year");
                var leave_details = document.getElementById("leave-details");
                var error = new Boolean();
                var day = new Date(year.value, month.value-1, date.value);

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";

                if(employee_id.value == "" || employee_id.value == null)
                {
                    errors_tag.innerHTML += "<li>Employee ID can't be left blank.</li>";
                    error = true;
                }
                if((day.getMonth()+1 != month.value) || (day.getDate() != date.value) || (day.getFullYear() != year.value))
                {
                    errors_tag.innerHTML += "<li>Leave Date is not valid.</li>";
                    error = true;
                }
                if(leave_details.value == "" || leave_details.value == null)
                {
                    errors_tag.innerHTML += "<li>Leave Details can't be left blank.</li>";
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

            function limit_text()
            {
                var maxlength = 150;
                var details = document.getElementById("details");
                if (details.value.length > maxlength)
                    details.value = details.value.substring(0, maxlength);
            }
            -->
        </script>
    </head>
    <%
        String employee_id = "";
        if(request.getAttribute("employee-id") != null)
            employee_id = (String)request.getAttribute("employee-id");

        String date = "";
        if(request.getAttribute("date") != null)
            date = (String)request.getAttribute("date");

        String month = "";
        if(request.getAttribute("month") != null)
            month = (String)request.getAttribute("month");

        String year = "";
        if(request.getAttribute("year") != null)
            year = (String)request.getAttribute("year");

        String leave_details = "";
        if(request.getAttribute("leave-details") != null)
            leave_details = (String)request.getAttribute("leave-details");

        String[] show_date = (String [])getServletContext().getAttribute("date");
        String[] show_month = (String [])getServletContext().getAttribute("month");
        String[] show_month_value = (String [])getServletContext().getAttribute("month-value");
        String[] show_year = (String [])getServletContext().getAttribute("past-year");
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
                    <h1 class="pagetitle">Employee Leave - New</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="new_leave2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td>Employee ID</td>
                                <td><input type="textbox" name="employee-id" id="employee-id" value="<%= employee_id %>" /></td>
                            </tr>
                            <tr>
                                <td>Leave Date</td>
                                <td>
                                    <select name="date" id="date">
                                        <%
                                            for(int i=0; i<31; i++)
                                            {
                                        %>
                                                <option value="<%= show_date[i] %>" <% if(show_date[i].compareTo(date) == 0) { out.write("selected"); }%> ><%= show_date[i] %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                    <select name="month" id="month">
                                        <%
                                            for(int i=0; i<12; i++)
                                            {
                                        %>
                                                <option value="<%= show_month_value[i] %>" <% if(show_month_value[i].compareTo(month) == 0) { out.write("selected"); }%> ><%= show_month[i] %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                    <select name="year" id="year">
                                        <option value="<%= show_year[0] %>" <% if(show_year[0].compareTo(year) == 0) { out.write("selected"); }%> ><%= show_year[0] %></option>
                                        <option value="<%= show_year[1] %>" <% if(show_year[1].compareTo(year) == 0) { out.write("selected"); }%> ><%= show_year[1] %></option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>Leave Details</td>
                                <td>
                                    <textarea name="leave-details" id="leave-details" cols="40" rows="4" onkeypress="limit_text()"><%= leave_details %></textarea>
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
