<%-- 
    Document   : new_student_exam
    Created on : Jul 1, 2011, 12:11:10 AM
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
        <title>College Management System</title>
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/general.css" />
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/input.css" />
        <script type="text/javascript">
            <!--
            function validate()
            {
                var errors_tag = document.getElementById("errors");
                var exam_roll_no = document.getElementById("exam-roll-no");
                var subject_code = document.getElementsByName("subject");
                var sheet_no = document.getElementsByName("sheet-no");
                var count = subject_code.length;
                var error = new Boolean();

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";
                error = false;

                for(var i=0; i<count; i++)
                {
                    if(subject_code[i].value != null && subject_code[i].value != "")
                    {
                        if(sheet_no[i].value == "" || sheet_no[i].value == null)
                        {
                            errors_tag.innerHTML += "<li>Sheet Number can't be left blank for each subject.</li>";
                            error = true;
                        }
                    }

                    if(error == true)
                        break;
                }

                if(exam_roll_no.value == "" || exam_roll_no.value == null)
                {
                    errors_tag.innerHTML += "<li>Exam Roll No. can't be left blank.</li>";
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

            function add_new_subject()
            {
                var span_subject = document.getElementById("add-new-subject");
                var input = document.createElement("input");
                input.type= "textbox";
                input.name = "subject";
                input.id = "subject";
                span_subject.appendChild(input);
                var break_ = document.createElement("br");
                span_subject.appendChild(break_);

                var span_no_copies = document.getElementById("add-new-sheet");
                var input = document.createElement("input");
                input.type= "textbox";
                input.name = "sheet-no";
                input.id = "sheet-no";
                span_no_copies.appendChild(input);
                var break_ = document.createElement("br");
                span_no_copies.appendChild(break_);
            }
            -->
        </script>
    </head>
    <%
        String exam_roll_no = "";
        if(request.getAttribute("exam-roll-no") != null)
            exam_roll_no = (String)request.getAttribute("exam-roll-no");

        String[] subject = null;
        if(request.getAttribute("subject") != null)
            subject = (String [])request.getAttribute("subject");

        String[] sheet_no = null;
        if(request.getAttribute("sheet-no") != null)
            sheet_no = (String [])request.getAttribute("sheet-no");
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
                    <h1 class="pagetitle">Student (Exam) - New</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="new_student_exam2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td>Exam Roll No.</td>
                                <td><input type="textbox" name="exam-roll-no" id="exam-roll-no" value="<%= exam_roll_no %>" /></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <table>
                                        <tr>
                                            <td>Subject (Exam Code)</td>
                                            <td>Sheet Number</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span id="add-new-subject">
                                                    <%
                                                        if(subject != null)
                                                        {
                                                            for(String temp : subject)
                                                            {
                                                    %>
                                                                <input type="textbox" name="subject" id="subject" value="<%= temp %>" /><br/>
                                                    <%
                                                            }
                                                        }
                                                    %>
                                                </span>
                                            </td>
                                            <td>
                                                <span id="add-new-sheet">
                                                    <%
                                                        if(sheet_no != null)
                                                        {
                                                            for(String temp : sheet_no)
                                                            {
                                                    %>
                                                                <input type="textbox" name="sheet-no" id="sheet-no" value="<%= temp %>" /><br/>
                                                    <%
                                                            }
                                                        }
                                                    %>
                                                </span>
                                            </td>
                                            <td style="vertical-align: bottom;">
                                                <input type="button" name="add-new" value="Add New Subject" onclick="add_new_subject()" />
                                            </td>
                                        </tr>
                                    </table>
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
