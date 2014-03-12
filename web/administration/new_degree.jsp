<%-- 
    Document   : new_degree
    Created on : Jun 28, 2011, 8:59:26 PM
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
        <title>College Management System - New Degree</title>
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/general.css" />
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/input.css" />
        <script type="text/javascript">
            <!--
            function validate()
            {
                var errors_tag = document.getElementById("errors");
                var degree = document.getElementById("degree");
                var short_degree = document.getElementById("short-degree");
                var duration = document.getElementById("duration");
                var semester = document.getElementById("semester");
                var error = new Boolean();

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";

                if(degree.value == "" || degree.value == null)
                {
                    errors_tag.innerHTML += "<li>Degree Name can't be left blank.</li>";
                    error = true;
                }
                if(short_degree.value == "" || short_degree.value == null)
                {
                    errors_tag.innerHTML += "<li>Degree Name (Short) can't be left blank.</li>";
                    error = true;
                }
                if(duration.value == "" || duration.value == null)
                {
                    errors_tag.innerHTML += "<li>Duration can't be left blank.</li>";
                    error = true;
                }
                else if(isNaN(duration.value))
                {
                     errors_tag.innerHTML += "<li>Duration must be a valid number.</li>";
                     error = true;
                }
                else if(duration.value <= 0)
                {
                    errors_tag.innerHTML += "<li>Duration must be greater than zero.</li>";
                    error = true;
                }
                if(semester.value == "" || semester.value == null)
                {
                    errors_tag.innerHTML += "<li>No. of Semester can't be left blank.</li>";
                    error = true;
                }
                else if(isNaN(semester.value))
                {
                     errors_tag.innerHTML += "<li>No. of Semester must be a valid number.</li>";
                     error = true;
                }
                else if(semester.value <= 0)
                {
                    errors_tag.innerHTML += "<li>No. of Semester must be greater than zero.</li>";
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
        String degree = "";
        if(request.getAttribute("degree") != null)
            degree = (String)request.getAttribute("degree");

        String short_degree = "";
        if(request.getAttribute("short-degree") != null)
            short_degree = (String)request.getAttribute("short-degree");

        String duration = "";
        if(request.getAttribute("duration") != null)
            duration = (String)request.getAttribute("duration");

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
                    <h1 class="pagetitle">Degree - New</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="new_degree2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td>Degree Name</td>
                                <td><input type="textbox" name="degree" id="degree" value="<%= degree %>" /></td>
                            </tr>
                            <tr>
                                <td>Degree Name<br/>(Short)</td>
                                <td><input type="textbox" name="short-degree" id="short-degree" value="<%= short_degree %>" /></td>
                            </tr>
                            <tr>
                                <td>Duration (in years)</td>
                                <td><input type="textbox" name="duration" id="duration" value="<%= duration %>" /></td>
                            </tr>
                            <tr>
                                <td>No. of Semester</td>
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
