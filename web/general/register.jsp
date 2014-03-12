<%-- 
    Document   : register
    Created on : Jun 28, 2011, 8:31:19 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>College Management System - New User</title>
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/general.css" />
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/input.css" />
        <script type="text/javascript">
            <!--
            function validate()
            {
                var errors_tag = document.getElementById("errors");
                var category_value = document.getElementById("category");
                var unique_id = document.getElementById("unique-id");
                var user_name = document.getElementById("user-name");
                var password = document.getElementById("password");
                var retype_password = document.getElementById("retype-password");
                var security_question = document.getElementById("security-question");
                var security_answer = document.getElementById("security-answer");
                var error = new Boolean();
                var check_password = new Boolean();
                check_password = true;

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";

                if(unique_id.value == "" || unique_id.value == null)
                {
                    if(category_value.value == "Student")
                        errors_tag.innerHTML += "<li>Registration Number can't be left blank.</li>";
                    else
                        errors_tag.innerHTML += "<li>Employee ID can't be left blank.</li>";
                    error = true;
                }
                if(user_name.value == "" || user_name.value == null)
                {
                    errors_tag.innerHTML += "<li>User Name can't be left blank.</li>";
                    error = true;
                }
                if(password.value == "" || password.value == null)
                {
                    errors_tag.innerHTML += "<li>Password can't be left blank.</li>";
                    error = true;
                    check_password = false;
                }
                if(retype_password.value == "" || retype_password.value == null)
                {
                    errors_tag.innerHTML += "<li>Retype Password can't be left blank.</li>";
                    error = true;
                    check_password = false;
                }
                if(check_password == true && password.value != retype_password.value)
                {
                    errors_tag.innerHTML += "<li>Password and Retype Password must be same.</li>";
                    error = true;
                }
                if(security_question.value == "" || security_question.value == null)
                {
                    errors_tag.innerHTML += "<li>Security Question can't be left blank.</li>";
                    error = true;
                }
                if(security_answer.value == "" || security_answer.value == null)
                {
                    errors_tag.innerHTML += "<li>Security Answer can't be left blank.</li>";
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

            function category_change()
            {
                var category_value = document.getElementById("category");
                var display_id = document.getElementById("show-id");
                if(category_value.value == "Student")
                    display_id.innerHTML = "Registration Number";
                else
                    display_id.innerHTML = "Employee ID";
            }
            -->
        </script>
    </head>
    <%
        String category = "";
        if(request.getAttribute("category") != null)
            category = (String)request.getAttribute("category");

        String unique_id = "";
        if(request.getAttribute("unique-id") != null)
            unique_id = (String)request.getAttribute("unique-id");

        String user_name = "";
        if(request.getAttribute("user-name") != null)
            user_name = (String)request.getAttribute("user-name");

        String security_question = "";
        if(request.getAttribute("security-question") != null)
            security_question = (String)request.getAttribute("security_question");

        String security_answer = "";
        if(request.getAttribute("security-answer") != null)
            security_answer = (String)request.getAttribute("security-answer");

    %>
    <body onload="category_change()">
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
                    <h1 class="pagetitle">Register</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="register2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td>Category</td>
                                <td>
                                    <select name="category" id="category" onchange="category_change()">
                                        <option <% if(category.compareTo("Administration") == 0) { out.write("selected"); }%> >Administration</option>
                                        <option <% if(category.compareTo("Accounts") == 0) { out.write("selected"); }%> >Accounts</option>
                                        <option <% if(category.compareTo("Exam Cell") == 0) { out.write("selected"); }%> >Exam Cell</option>
                                        <option <% if(category.compareTo("Library") == 0) { out.write("selected"); }%> >Library</option>
                                        <option <% if(category.compareTo("Training and Placement") == 0) { out.write("selected"); }%> >Training and Placement</option>
                                        <option <% if(category.compareTo("Faculty") == 0) { out.write("selected"); }%> >Faculty</option>
                                        <option <% if(category.compareTo("Student") == 0) { out.write("selected"); }%> >Student</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td><span id="show-id"></span></td>
                                <td><input type="textbox" name="unique-id" id="unique-id" value="<%= unique_id %>" /></td>
                            </tr>
                            <tr>
                                <td>User Name</td>
                                <td><input type="textbox" name="user-name" id="user-name" value="<%= user_name %>" /></td>
                            </tr>
                            <tr>
                                <td>Password</td>
                                <td><input type="password" name="password" id="password" /></td>
                            </tr>
                            <tr>
                                <td>Retype Password</td>
                                <td><input type="password" id="retype-password" /></td>
                            </tr>
                            <tr>
                                <td>Security Question</td>
                                <td><input type="textbox" name="security-question" id="security-question" value="<%= security_question %>" /></td>
                            </tr>
                            <tr>
                                <td>Security Answer</td>
                                <td><input type="password" name="security-answer" id="security-answer" value="<%= security_answer %>" /></td>
                            </tr>
                            <tr>
                                <td class="button"><input type="submit" name="register" value="Register" /></td>
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
