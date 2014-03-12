<%-- 
    Document   : new_faculty
    Created on : Jun 29, 2011, 7:35:15 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="initial.server, java.sql.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%!
	boolean get_educational_details(String employee_id)
	{
            boolean educational_details = false;
            try
            {
                String query;
                PreparedStatement execute_query;
                ResultSet result_set;

                query = "select * from Employee.EducationalQualification where EmployeeID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, employee_id);
                result_set = execute_query.executeQuery();

                if(result_set.next())
                    educational_details = true;
            }
            catch(SQLException e)
            {
            }

            return educational_details;
	}
%>

<%
    String valid_user = request.getSession().getAttribute("user").toString();
    boolean valid = false;
    if(valid_user.compareTo("Administrator") == 0)
       valid = true;
    if(valid == false)
      response.sendRedirect("/ClgMgtSite/general/login.jsp");

    if(request.getAttribute("employee-id") == null)
        response.sendRedirect("/ClgMgtSite/employee/new_employee.jsp");
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>College Management System - New Faculty</title>
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/general.css" />
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/input.css" />
        <script type="text/javascript">
            <!--
            function validate()
            {
                var errors_tag = document.getElementById("errors");
                var education_details = document.getElementById("whether-education");
                var x_marks = document.getElementById("x-marks");
                var x_year = document.getElementById("x-year");
                var xii_marks = document.getElementById("xii-marks");
                var xii_year = document.getElementById("xii-year");
                var grad_marks = document.getElementById("grad-marks");
                var grad_year = document.getElementById("grad-year");
                var grad_university = document.getElementById("grad-university");
                var post_grad_marks = document.getElementById("post-grad-marks");
                var post_grad_year = document.getElementById("post-grad-year");
                var post_grad_university = document.getElementById("post-grad-university");
                var error = new Boolean();

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";

                if(education_details.value == "false")
                {
                   if(x_marks.value == "" || x_marks.value == null)
                   {
                        errors_tag.innerHTML += "<li>X<sup>th</sup> Marks can't be left blank.</li>";
                        error = true;
                   }
                   else if(isNaN(x_marks.value))
                   {
                        errors_tag.innerHTML += "<li>X<sup>th</sup> Marks must be a valid number.</li>";
                        error = true;
                   }
                   else if(x_marks.value > 100 || x_marks.value < 0)
                   {
                        errors_tag.innerHTML += "<li>X<sup>th</sup> Marks must be between 0 and 100.</li>";
                        error = true;
                   }
                   if(xii_marks.value == "" || xii_marks.value == null)
                   {
                        errors_tag.innerHTML += "<li>XII<sup>th</sup> Marks can't be left blank.</li>";
                        error = true;
                   }
                   else if(isNaN(xii_marks.value))
                   {
                        errors_tag.innerHTML += "<li>XII<sup>th</sup> Marks must be a valid number.</li>";
                        error = true;
                   }
                   else if(xii_marks.value > 100 || xii_marks.value < 0)
                   {
                        errors_tag.innerHTML += "<li>XII<sup>th</sup> Marks must be between 0 and 100.</li>";
                        error = true;
                   }
                   if(grad_marks.value == "" || grad_marks.value == null)
                   {
                        errors_tag.innerHTML += "<li>Graduation Marks can't be left blank.</li>";
                        error = true;
                   }
                   else if(isNaN(grad_marks.value))
                   {
                        errors_tag.innerHTML += "<li>Graduation Marks must be a valid number.</li>";
                        error = true;
                   }
                   else if(grad_marks.value > 100 || grad_marks.value < 0)
                   {
                        errors_tag.innerHTML += "<li>Graduation Marks must be between 0 and 100.</li>";
                        error = true;
                   }
                   if(grad_university.value == "" || grad_university.value == null)
                   {
                        errors_tag.innerHTML += "<li>Graduation University can't be left blank.</li>";
                        error = true;
                   }
                   if(x_year.value >= xii_year.value)
                   {
                        errors_tag.innerHTML += "<li>X<sup>th</sup> Year can't be greater than XII<sup>th</sup> Year</li>";
                        error = true;
                   }
                   if(xii_year.value >= grad_year.value)
                   {
                        errors_tag.innerHTML += "<li>XII<sup>th</sup> Year can't be greater than Graduation Year</li>";
                        error = true;
                   }
                }
                if(post_grad_marks.value == "" || post_grad_marks.value == null)
                {
                     errors_tag.innerHTML += "<li>Post-Graduation Marks can't be left blank.</li>";
                     error = true;
                }
                else if(isNaN(post_grad_marks.value))
                {
                     errors_tag.innerHTML += "<li>Post-Graduation Marks must be a valid number.</li>";
                     error = true;
                }
                else if(post_grad_marks.value > 100 || post_grad_marks.value < 0)
                {
                     errors_tag.innerHTML += "<li>Post-Graduation Marks must be between 0 and 100.</li>>";
                     error = true;
                }
                if(post_grad_university.value == "" || post_grad_university.value == null)
                {
                     errors_tag.innerHTML += "<li>Post-Graduation University can't be left blank.</li>";
                     error = true;
                }
                if(grad_year.value >= post_grad_year.value)
                {
                     errors_tag.innerHTML += "<li>Graduation Year can't be greater than Post-Graduation Year</li>";
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
                var maxlength = 100;
                if (this.value.length > maxlength)
                    this.value = this.value.substring(0, maxlength);
            }
            -->
        </script>
    </head>
    <%
        String employee_id = "";
        employee_id = (String)request.getAttribute("employee-id");

        String x_year = "";
        if(request.getAttribute("x-year") != null)
            x_year = (String)request.getAttribute("x-year");

        String x_marks = "";
        if(request.getAttribute("x-marks") != null)
            x_marks = (String)request.getAttribute("x-marks");

        String xii_year = "";
        if(request.getAttribute("xii-year") != null)
            xii_year = (String)request.getAttribute("xii-year");

        String xii_marks = "";
        if(request.getAttribute("xii-marks") != null)
            xii_marks = (String)request.getAttribute("xii-marks");

        String grad_university = "";
        if(request.getAttribute("grad-university") != null)
            grad_university = (String)request.getAttribute("grad-university");

        String grad_year = "";
        if(request.getAttribute("grad-year") != null)
            grad_year = (String)request.getAttribute("grad-year");

        String grad_marks = "";
        if(request.getAttribute("grad-marks") != null)
            grad_marks = (String)request.getAttribute("grad-marks");

        String post_grad_university = "";
        if(request.getAttribute("post-grad-university") != null)
            post_grad_university = (String)request.getAttribute("post-grad-university");

        String post_grad_year = "";
        if(request.getAttribute("post-grad-year") != null)
            post_grad_year = (String)request.getAttribute("post-grad-year");

        String post_grad_marks = "";
        if(request.getAttribute("post-grad-marks") != null)
            post_grad_marks = (String)request.getAttribute("post-grad-marks");

        String phd_university = "";
        if(request.getAttribute("phd-university") != null)
            phd_university = (String)request.getAttribute("phd-university");

        String phd_year = "";
        if(request.getAttribute("phd-year") != null)
            phd_year = (String)request.getAttribute("phd-year");

        String[] show_year = (String [])getServletContext().getAttribute("past-year");
        boolean educational_details = get_educational_details(employee_id);
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
                    <h1 class="pagetitle">Faculty - New</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="faculty/new_faculty2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td colspan="2">Employee ID</td>
                                <td colspan="2"><input type="textbox" name="employee-id" id="employee-id" value="<%= employee_id %>" readonly /></td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <span id="educational-details" <% if(educational_details == true) { out.write("style=\"display: none; \"visibility: hidden\""); }
                                                                        else { out.write("style=\"display: block; \"visibility: visible\""); } %> >
                                        <fieldset>
                                            <legend>Educational Details</legend>
                                            <input type="hidden" name="whether-education" id="whether-education" value="<%= educational_details %>" />
                                            <table width="100%">
                                                <tr>
                                                    <td>X<sup>th</sup> Year</td>
                                                    <td>
                                                        <select name="x-year" id="x-year">
                                                            <%
                                                                for(int i=0; i<50; i++)
                                                                {
                                                            %>
                                                                    <option value="<%= show_year[i] %>" <% if(show_year[i].compareTo(x_year) == 0) { out.write("selected"); }%> ><%= show_year[i] %></option>
                                                            <%
                                                                }
                                                            %>
                                                        </select>
                                                    </td>
                                                    <td>X<sup>th</sup> Marks</td>
                                                    <td><input type="textbox" name="x-marks" id="x-marks" value="<%= x_marks %>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>XII<sup>th</sup> Year</td>
                                                    <td>
                                                        <select name="xii-year" id="xii-year">
                                                            <%
                                                                for(int i=0; i<50; i++)
                                                                {
                                                            %>
                                                                    <option value="<%= show_year[i] %>" <% if(show_year[i].compareTo(xii_year) == 0) { out.write("selected"); }%> ><%= show_year[i] %></option>
                                                            <%
                                                                }
                                                            %>
                                                        </select>
                                                    </td>
                                                    <td>XII<sup>th</sup> Marks</td>
                                                    <td><input type="textbox" name="xii-marks" id="xii-marks" value="<%= xii_marks %>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Graduation University</td>
                                                    <td colspan="3"><input type="textbox" name="grad-university" id="grad-university" value="<%= grad_university %>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Graduation Year</td>
                                                    <td>
                                                        <select name="grad-year" id="grad-year">
                                                            <%
                                                                for(int i=0; i<50; i++)
                                                                {
                                                            %>
                                                                    <option value="<%= show_year[i] %>" <% if(show_year[i].compareTo(grad_year) == 0) { out.write("selected"); }%> ><%= show_year[i] %></option>
                                                            <%
                                                                }
                                                            %>
                                                        </select>
                                                    </td>
                                                    <td>Graduation Marks</td>
                                                    <td><input type="textbox" name="grad-marks" id="grad-marks" value="<%= grad_marks %>" /></td>
                                                </tr>
                                            </table>
                                        </fieldset>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4">Higher Educational Details</td>
                            </tr>
                            <tr>
                                <td>Post-Graduation University</td>
                                <td colspan="3"><input type="textbox" name="post-grad-university" id="post-grad-university" value="<%= post_grad_university %>" /></td>
                            </tr>
                            <tr>
                                <td>Post-Graduation Year</td>
                                <td>
                                    <select name="post-grad-year" id="post-grad-year">
                                        <%
                                            for(int i=0; i<50; i++)
                                            {
                                        %>
                                                <option value="<%= show_year[i] %>" <% if(show_year[i].compareTo(post_grad_year) == 0) { out.write("selected"); }%> ><%= show_year[i] %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                                <td>Post-Graduation Marks</td>
                                <td><input type="textbox" name="post-grad-marks" id="post-grad-marks" value="<%= post_grad_marks %>" /></td>
                            </tr>
                            <tr>
                                <td>PhD. University</td>
                                <td><input type="textbox" name="phd-university" id="phd-university" value="<%= phd_university %>" /></td>
                                <td>PhD. Year</td>
                                <td>
                                    <select name="phd-year" id="phd-year">
                                        <%
                                            for(int i=0; i<50; i++)
                                            {
                                        %>
                                                <option value="<%= show_year[i] %>" <% if(show_year[i].compareTo(phd_year) == 0) { out.write("selected"); }%> ><%= show_year[i] %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
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
