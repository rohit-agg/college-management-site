<%-- 
    Document   : new_registration
    Created on : Jun 29, 2011, 11:50:34 PM
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
    else if(valid_user.compareTo("Exam Cell") == 0)
       valid = true;
    if(valid == false)
      response.sendRedirect("/ClgMgtSite/general/login.jsp");
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>College Management System - New Registration</title>
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/general.css" />
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/input.css" />
        <script type="text/javascript">
            <!--
            function validate()
            {
                var errors_tag = document.getElementById("errors");
                var roll_no = document.getElementById("roll-no");
                var registration_no = document.getElementById("registration-no");
                var semester = document.getElementById("semester");
                var error = new Boolean();

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";

                if(registration_no.value == "" || registration_no.value == null)
                {
                    errors_tag.innerHTML += "<li>Registration Number can't be left blank.</li>";
                    error = true;
                }
                if(roll_no.value == "" || roll_no.value == null)
                {
                    errors_tag.innerHTML += "<li>Roll Number can't be left blank.</li>";
                    error = true;
                }
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
        String registration_no = "";
        if(request.getAttribute("registration-no") != null)
            registration_no = (String)request.getAttribute("registration-no");

        String roll_no = "";
        if(request.getAttribute("roll-no") != null)
            roll_no = (String)request.getAttribute("roll-no");

        String semester = "";
        if(request.getAttribute("semester") != null)
            semester = (String)request.getAttribute("semester");
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
                    <h1 class="pagetitle">Student Registration - New</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="new_registration2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td>Roll Number</td>
                                <td><input type="textbox" name="roll-no" id="roll-no" value="<%= roll_no %>" /></td>
                            </tr>
                            <tr>
                                <td>Registration Number</td>
                                <td><input type="textbox" name="registration-no" id="registration-no" value="<%= registration_no %>" /></td>
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
