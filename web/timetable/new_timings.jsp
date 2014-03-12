<%-- 
    Document   : new_timings
    Created on : Jun 30, 2011, 8:44:30 PM
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
                var lecture = document.getElementById("lecture");
                var start_hour = document.getElementById("start-hour");
                var start_min = document.getElementById("start-min");
                var end_hour = document.getElementById("end-hour");
                var end_min = document.getElementById("end-min");
                var error = new Boolean();

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";

                if(lecture.value == "" || lecture.value == null)
                {
                    errors_tag.innerHTML += "<li>Lecture can't be left blank.</li>";
                    error = true;
                }
                else if(isNaN(lecture.value))
                {
                     errors_tag.innerHTML += "<li>Lecture must be a valid number.</li>";
                     error = true;
                }
                else if(lecture.value < 0)
                {
                     errors_tag.innerHTML += "<li>Lecture must be greater than 0.</li>";
                     error = true;
                }
                if(start_hour.value == "" || start_hour.value == null)
                {
                    errors_tag.innerHTML += "<li>Start Time (Hour) can't be left blank.</li>";
                    error = true;
                }
                else if(isNaN(start_hour.value))
                {
                     errors_tag.innerHTML += "<li>Start Time (Hour) must be a valid number.</li>";
                     error = true;
                }
                else if(start_hour.value < 0 || start_hour.value > 23)
                {
                     errors_tag.innerHTML += "<li>Start Time (Hour) be between 0 and 23.</li>";
                     error = true;
                }
                if(start_min.value == "" || start_min.value == null)
                {
                    errors_tag.innerHTML += "<li>Start Time (Minute) can't be left blank.</li>";
                    error = true;
                }
                else if(isNaN(start_min.value))
                {
                     errors_tag.innerHTML += "<li>Start Time (Minute) must be a valid number.</li>";
                     error = true;
                }
                else if(start_min.value < 0 || start_min.value > 59)
                {
                     errors_tag.innerHTML += "<li>Start Time (Minute) be between 0 and 59.</li>";
                     error = true;
                }
                if(end_hour.value == "" || end_hour.value == null)
                {
                    errors_tag.innerHTML += "<li>End Time (Hour) can't be left blank.</li>";
                    error = true;
                }
                else if(isNaN(end_hour.value))
                {
                     errors_tag.innerHTML += "<li>End Time (Hour) must be a valid number.</li>";
                     error = true;
                }
                else if(end_hour.value < 0 || end_hour.value > 23)
                {
                     errors_tag.innerHTML += "<li>End Time (Hour) be between 0 and 23.</li>";
                     error = true;
                }
                if(end_min.value == "" || end_min.value == null)
                {
                    errors_tag.innerHTML += "<li>End Time (Minute) can't be left blank.</li>";
                    error = true;
                }
                else if(isNaN(end_min.value))
                {
                     errors_tag.innerHTML += "<li>End Time (Minute) must be a valid number.</li>";
                     error = true;
                }
                else if(end_min.value < 0 || end_min.value > 59)
                {
                     errors_tag.innerHTML += "<li>End Time (Minute) be between 0 and 59.</li>";
                     error = true;
                }
                if(start_hour.value > end_hour.value)
                {
                     errors_tag.innerHTML += "<li>Start Time can't be greater than End Time.</li>";
                     error = true;
                }
                else if(start_hour.value == end_hour.value && start_min.value > end_min.value)
                {
                     errors_tag.innerHTML += "<li>Start Time can't be greater than End Time.</li>";
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
        String lecture = "";
        if(request.getAttribute("lecture") != null)
            lecture = (String)request.getAttribute("lecture");

        String start_hour = "";
        if(request.getAttribute("start-hour") != null)
            start_hour = (String)request.getAttribute("start-hour");

        String start_min = "";
        if(request.getAttribute("start-min") != null)
            start_min = (String)request.getAttribute("start-min");

        String end_hour = "";
        if(request.getAttribute("end-hour") != null)
            end_hour = (String)request.getAttribute("end-hour");

        String end_min = "";
        if(request.getAttribute("end-min") != null)
            end_min = (String)request.getAttribute("end-min");
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
                    <h1 class="pagetitle">Lecture Timings - New</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="new_timings2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td>Lecture</td>
                                <td><input type="textbox" name="lecture" id="lecture" value="<%= lecture %>" /></td>
                            </tr>
                            <tr>
                                <td>Start Time</td>
                                <td>
                                    <input type="textbox" name="start-hour" id="start-hour" value="<%= start_hour %>" />
                                    <input type="textbox" name="start-min" id="start-min" value="<%= start_min %>" />
                                </td>
                            </tr>
                            <tr>
                                <td>End Time</td>
                                <td>
                                    <input type="textbox" name="end-hour" id="end-hour" value="<%= end_hour %>" />
                                    <input type="textbox" name="end-min" id="end-min" value="<%= end_min %>" />
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
