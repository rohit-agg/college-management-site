<%-- 
    Document   : new_paper_checking
    Created on : Jul 1, 2011, 12:30:47 PM
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
            function validate()
            {
                var errors_tag = document.getElementById("errors");
                var employee_id = document.getElementById("employee-id");
                var marks_obtained = document.getElementsByName("marks-obtained");
                var sheet_no = document.getElementsByName("sheet-no");
                var count = sheet_no.length;
                var error = new Boolean();

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";
                error = false;

                for(var i=0; i<count; i++)
                {
                    if(sheet_no[i].value != null && sheet_no[i].value != "")
                    {
                        if(marks_obtained[i].value == "" || marks_obtained[i].value == null)
                        {
                            errors_tag.innerHTML += "<li>Marks Obtained can't be left blank for any sheet.</li>";
                            error = true;
                        }
                        else if(isNaN(marks_obtained[i].value))
                        {
                             errors_tag.innerHTML += "<li>Marks Obtained must be a valid number.</li>";
                             error = true;
                        }
                        else if(marks_obtained[i].value < 0)
                        {
                             errors_tag.innerHTML += "<li>Marks Obtained can't be less than 0.</li>";
                             error = true;
                        }
                    }

                    if(error == true)
                        break;
                }

                if(employee_id.value == "" || employee_id.value == null)
                {
                    errors_tag.innerHTML += "<li>Employee ID can't be left blank.</li>";
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

            function add_new_sheet()
            {
                var span_sheet = document.getElementById("add-sheet");
                var input = document.createElement("input");
                input.type= "textbox";
                input.name = "sheet-no";
                input.id = "sheet-no";
                span_sheet.appendChild(input);
                var break_ = document.createElement("br");
                span_sheet.appendChild(break_);

                var span_marks_obtained = document.getElementById("add-marks-obtained");
                var input = document.createElement("input");
                input.type= "textbox";
                input.name = "marks-obtained";
                input.id = "marks-obtained";
                span_marks_obtained.appendChild(input);
                var break_ = document.createElement("br");
                span_marks_obtained.appendChild(break_);
            }
            -->
        </script>
    </head>
    <%
        String employee_id = "";
        if(request.getAttribute("employee-id") != null)
            employee_id = (String)request.getAttribute("employee-id");

        String[] marks_obtained = null;
        if(request.getAttribute("marks-obtained") != null)
            marks_obtained = (String [])request.getAttribute("marks-obtained");

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
                    <h1 class="pagetitle">Paper Checking - New</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="new_paper_checking2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td>Employee ID</td>
                                <td><input type="textbox" name="employee-id" id="employee-id" value="<%= employee_id %>" /></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <table>
                                        <tr>
                                            <td>Sheet Number</td>
                                            <td>Marks Obtained</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span id="add-sheet">
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
                                            <td>
                                                <span id="add-marks-obtained">
                                                    <%
                                                        if(marks_obtained != null)
                                                        {
                                                            for(String temp : marks_obtained)
                                                            {
                                                    %>
                                                                <input type="textbox" name="marks-obtained" id="marks-obtained" value="<%= temp %>" /><br/>
                                                    <%
                                                            }
                                                        }
                                                    %>
                                                </span>
                                            </td>
                                            <td style="vertical-align: bottom;">
                                                <input type="button" name="add-new" value="Add New Sheet" onclick="add_new_sheet()" />
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
