<%-- 
    Document   : new_payroll
    Created on : Jun 29, 2011, 7:25:30 PM
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
                var salary = document.getElementById("salary");
                var error = new Boolean();

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";

                if(employee_id.value == "" || employee_id.value == null)
                {
                    errors_tag.innerHTML += "<li>Employee ID can't be left blank.</li>";
                    error = true;
                }
                if(salary.value == "" || salary.value == null)
                {
                    errors_tag.innerHTML += "<li>Monthly Salary can't be left blank.</li>";
                    error = true;
                }
                else if(isNaN(salary.value))
                {
                     errors_tag.innerHTML += "<li>Monthly Salary must be a valid number.</li>";
                     error = true;
                }
                else if(salary.value < 0)
                {
                     errors_tag.innerHTML += "<li>Monthly Salary can't be less than 0.</li>";
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
        String employee_id = "";
        if(request.getAttribute("employee-id") != null)
            employee_id = (String)request.getAttribute("employee-id");

        String salary = "";
        if(request.getAttribute("salary") != null)
            salary = (String)request.getAttribute("salary");
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
                    <h1 class="pagetitle">Employee Payroll - New</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="new_payroll2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td>Employee ID</td>
                                <td><input type="textbox" name="employee-id" id="employee-id" value="<%= employee_id %>" /></td>
                            </tr>
                            <tr>
                                <td>Monthly Salary</td>
                                <td><input type="textbox" name="salary" id="salary" value="<%= salary %>" /></td>
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
