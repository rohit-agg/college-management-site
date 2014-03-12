<%-- 
    Document   : login
    Created on : Jun 28, 2011, 8:26:18 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login - College Management System - Login</title>
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/general.css" />
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/input.css" />
        <script type="text/javascript">
            <!--
            function validate()
            {
                var errors_tag = document.getElementById("errors");
                var user_name = document.getElementById("user-name");
                var password = document.getElementById("password");
                var error = new Boolean();

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";

                if(user_name.value == "" || user_name.value == null)
                {
                    errors_tag.innerHTML += "<li>User Name can't be left blank.</li>";
                    error = true;
                }
                if(password.value == "" || password.value == null)
                {
                    errors_tag.innerHTML += "<li>Password can't be left blank.</li>";
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
        String user_name = "";
        if(request.getAttribute("user-name") != null)
            user_name = (String)request.getAttribute("user-name");
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
                    <h1 class="pagetitle">Login</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="login2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td>User Name</td>
                                <td><input type="textbox" name="user-name" id="user-name" value="<%= user_name %>"/></td>
                            </tr>
                            <tr>
                                <td>Password</td>
                                <td><input type="password" name="password" id="password"/></td>
                            </tr>
                            <tr>
                                <td colspan="2"><input type="checkbox" name="remember"/>Remember Me</td>
                            </tr>
                            <tr>
                                <td class="button"><input type="submit" name="login" value="Login" /></td>
                                <td class="button"><input type="button" name="cancel" value="Cancel" onclick="cancel_page()" /></td>
                            </tr>
                            <tr>
                                <td><a href="">Forgot Password</a></td>
                                <td><a href="register.jsp">New User</a></td>
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
