<%-- 
    Document   : new_attendance
    Created on : Jun 30, 2011, 12:09:09 AM
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
    else if(valid_user.compareTo("Faculty") == 0)
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
            function add_new_subject()
            {
                var span_subjects = document.getElementById("subjects");
                var input = document.createElement("input");
                input.type= "textbox";
                input.name = "subject";
                input.id = "subject";
                span_subjects.appendChild(input);
            }

            function add_new_student()
            {
                var span_students = document.getElementById("students");
                var input = document.createElement("input");
                input.type= "textbox";
                input.name = "student";
                input.id = "student";
                span_students.appendChild(input);
            }
            -->
        </script>
    </head>
    <%
        String[] subjects = null;
        if(request.getAttribute("subject") != null)
            subjects = (String[])request.getAttribute("subject");

        String[] students = null;
        if(request.getAttribute("student") != null)
            students = (String[])request.getAttribute("student");
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
                    <h1 class="pagetitle">Student Attendance - New</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="new_attendance2" method="post">
                        <table>
                            <tr>
                                <td colspan="2">Students (Roll No.)</td>
                            </tr>
                            <tr>
                                <td>
                                    <span id="students">
                                        <%
                                            if(students != null)
                                            {
                                                for(String temp : students)
                                                {
                                        %>
                                                    <input type="textbox" name="student" id="student" value="<%= temp %>" />
                                        <%
                                                }
                                            }
                                        %>
                                    </span>
                                </td>
                                <td style="vertical-align: bottom;">
                                    <input type="button" name="add_new_students" value="Add New Student" onclick="add_new_student()" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">Subjects (Subject Code)</td>
                            </tr>
                            <tr>
                                <td>
                                    <span id="subjects">
                                        <%
                                            if(subjects != null)
                                            {
                                                for(String temp : subjects)
                                                {
                                        %>
                                                    <input type="textbox" name="subject" id="subject" value="<%= temp %>" />
                                        <%
                                                }
                                            }
                                        %>
                                    </span>
                                </td>
                                <td style="vertical-align: bottom;">
                                    <input type="button" name="add-new-subjects" value="Add New Subject" onclick="add_new_subject()" />
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
