<%-- 
    Document   : new_subject
    Created on : Jun 28, 2011, 10:15:35 PM
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
                var subject_name = document.getElementById("subject-name");
                var subject_code = document.getElementById("subject-code");
                var exam_code = document.getElementById("exam-code");
                var maximum_marks = document.getElementById("maximum-marks");
                var error = new Boolean();

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";

                if(subject_name.value == "" || subject_name.value == null)
                {
                    errors_tag.innerHTML += "<li>Subject Name can't be left blank.</li>";
                    error = true;
                }
                if(subject_code.value == "" || subject_code.value == null)
                {
                    errors_tag.innerHTML += "<li>Subject Code can't be left blank.</li>";
                    error = true;
                }
                if(exam_code.value == "" || exam_code.value == null)
                {
                    errors_tag.innerHTML += "<li>Exam Code can't be left blank.</li>";
                    error = true;
                }
                if(maximum_marks.value == "" || maximum_marks.value == null)
                {
                    errors_tag.innerHTML += "<li>Maximum Marks can't be left blank.</li>";
                    error = true;
                }
                else if(isNaN(maximum_marks.value))
                {
                    errors_tag.innerHTML += "<li>Maximum Marks must be a valid number.</li>";
                    error = true;
                }
                else if(maximum_marks.value <= 0)
                {
                    errors_tag.innerHTML += "<li>Maximum Marks must be greater than 0.</li>";
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
        String subject_name = "";
        if(request.getAttribute("subject-name") != null)
            subject_name = (String)request.getAttribute("subject-name");

        String subject_code = "";
        if(request.getAttribute("subject-code") != null)
            subject_code = (String)request.getAttribute("subject-code");

        String exam_code = "";
        if(request.getAttribute("exam-code") != null)
            exam_code = (String)request.getAttribute("exam-code");

        String maximum_marks = "";
        if(request.getAttribute("maximum-marks") != null)
            maximum_marks = (String)request.getAttribute("maximum-marks");
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
                    <h1 class="pagetitle">Subject - New</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="new_subject2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td>Subject Name</td>
                                <td><input type="textbox" name="subject-name" id="subject-name" value="<%= subject_name %>" /></td>
                            </tr>
                            <tr>
                                <td>Subject Code</td>
                                <td><input type="textbox" name="subject-code" id="subject-code" value="<%= subject_code %>" /></td>
                            </tr>
                            <tr>
                                <td>Exam Code</td>
                                <td><input type="textbox" name="exam-code" id="exam-code" value="<%= exam_code %>" /></td>
                            </tr>
                            <tr>
                                <td>Maximum Marks</td>
                                <td><input type="textbox" name="maximum-marks" id="maximum-marks" value="<%= maximum_marks %>" /></td>
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
