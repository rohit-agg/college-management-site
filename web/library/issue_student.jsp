<%-- 
    Document   : issue_student
    Created on : Jun 30, 2011, 12:33:06 PM
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
    else if(valid_user.compareTo("Library") == 0)
       valid = true;
    if(valid == false)
      response.sendRedirect("/ClgMgtSite/general/login.jsp");
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>College Management System - Issue</title>
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/general.css" />
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/input.css" />
        <script type="text/javascript">
            <!--
            function validate()
            {
                var errors_tag = document.getElementById("errors");
                var roll_no = document.getElementById("roll-no");
                var reference_no = document.getElementById("reference-no");
                var issue_date = document.getElementById("issue-date");
                var issue_month = document.getElementById("issue-month");
                var issue_year = document.getElementById("issue-year");
                var return_date = document.getElementById("return-date");
                var return_month = document.getElementById("return-month");
                var return_year = document.getElementById("return-year");
                var error = new Boolean();
                var issue_day = new Date(issue_year.value, issue_month.value-1, issue_date.value);
                var return_day = new Date(return_year.value, return_month.value-1, return_date.value);

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";

                if(roll_no.value == "" || roll_no.value == null)
                {
                    errors_tag.innerHTML += "<li>Roll Number can't be left blank.</li>";
                    error = true;
                }
                if(reference_no.value == "" || reference_no.value == null)
                {
                    errors_tag.innerHTML += "<li>Reference No. can't be left blank.</li>";
                    error = true;
                }
                if((issue_day.getMonth()+1 != issue_month.value) || (issue_day.getDate() != issue_date.value) || (issue_day.getFullYear() != issue_year.value))
                {
                    errors_tag.innerHTML += "<li>Date of Issue is not valid.</li>";
                    error = true;
                }
                if((return_day.getMonth()+1 != return_month.value) || (return_day.getDate() != return_date.value) || (return_day.getFullYear() != return_year.value))
                {
                    errors_tag.innerHTML += "<li>Date of Return is not valid.</li>";
                    error = true;
                }
                if(issue_day >= return_day)
                {
                    errors_tag.innerHTML += "<li>Date of Issue can't be greater than Date of Return.</li>";
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
        String roll_no = "";
        if(request.getAttribute("roll-no") != null)
            roll_no = (String)request.getAttribute("roll-no");

        String reference_no = "";
        if(request.getAttribute("reference-no") != null)
            reference_no = (String)request.getAttribute("reference-no");

        String issue_date = "";
        if(request.getAttribute("issue-date") != null)
            issue_date = (String)request.getAttribute("issue-date");

        String issue_month = "";
        if(request.getAttribute("issue-month") != null)
            issue_month = (String)request.getAttribute("issue-month");

        String issue_year = "";
        if(request.getAttribute("issue-year") != null)
            issue_year = (String)request.getAttribute("issue-year");

        String return_date = "";
        if(request.getAttribute("return-date") != null)
            return_date = (String)request.getAttribute("return-date");

        String return_month = "";
        if(request.getAttribute("return-month") != null)
            return_month = (String)request.getAttribute("return-month");

        String return_year = "";
        if(request.getAttribute("return-year") != null)
            return_year = (String)request.getAttribute("return-year");

        String[] show_date = (String [])getServletContext().getAttribute("date");
        String[] show_month = (String [])getServletContext().getAttribute("month");
        String[] show_month_value = (String [])getServletContext().getAttribute("month-value");
        String[] show_past_year = (String [])getServletContext().getAttribute("past-year");
        String[] show_future_year = (String [])getServletContext().getAttribute("future-year");
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
                    <h1 class="pagetitle">Issue Book - Student</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="issue_student2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td>Roll Number</td>
                                <td><input type="textbox" name="roll-no" id="roll-no" value="<%= roll_no %>" /></td>
                            </tr>
                            <tr>
                                <td>Reference No.</td>
                                <td><input type="textbox" name="reference-no" id="reference-no" value="<%= reference_no %>" /></td>
                            </tr>
                            <tr>
                                <td>Date of Issue</td>
                                <td>
                                    <select name="issue-date" id="issue-date">
                                        <%
                                            for(int i=0; i<31; i++)
                                            {
                                        %>
                                                <option value="<%= show_date[i] %>" <% if(show_date[i].compareTo(issue_date) == 0) { out.write("selected"); }%> ><%= show_date[i] %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                    <select name="issue-month" id="issue-month">
                                        <%
                                            for(int i=0; i<12; i++)
                                            {
                                        %>
                                                <option value="<%= show_month_value[i] %>" <% if(show_month_value[i].compareTo(issue_month) == 0) { out.write("selected"); }%> ><%= show_month[i] %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                    <select name="issue-year" id="issue-year">
                                        <option value="<%= show_future_year[1] %>" <% if(show_future_year[1].compareTo(issue_year) == 0) { out.write("selected"); }%> ><%= show_future_year[1] %></option>
                                        <option value="<%= show_past_year[0] %>" <% if(show_past_year[0].compareTo(issue_year) == 0) { out.write("selected"); }%> ><%= show_past_year[0] %></option>
                                        <option value="<%= show_past_year[1] %>" <% if(show_past_year[1].compareTo(issue_year) == 0) { out.write("selected"); }%> ><%= show_past_year[1] %></option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>Date of Return</td>
                                <td>
                                    <select name="return-date" id="return-date">
                                        <%
                                            for(int i=0; i<31; i++)
                                            {
                                        %>
                                                <option value="<%= show_date[i] %>" <% if(show_date[i].compareTo(return_date) == 0) { out.write("selected"); }%> ><%= show_date[i] %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                    <select name="return-month" id="return-month">
                                        <%
                                            for(int i=0; i<12; i++)
                                            {
                                        %>
                                                <option value="<%= show_month_value[i] %>" <% if(show_month_value[i].compareTo(return_month) == 0) { out.write("selected"); }%> ><%= show_month[i] %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                    <select name="return-year" id="return-year">
                                        <option value="<%= show_future_year[1] %>" <% if(show_future_year[1].compareTo(return_year) == 0) { out.write("selected"); }%> ><%= show_future_year[1] %></option>
                                        <option value="<%= show_past_year[0] %>" <% if(show_past_year[0].compareTo(return_year) == 0) { out.write("selected"); }%> ><%= show_past_year[0] %></option>
                                        <option value="<%= show_past_year[1] %>" <% if(show_past_year[1].compareTo(return_year) == 0) { out.write("selected"); }%> ><%= show_past_year[1] %></option>
                                    </select>
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
