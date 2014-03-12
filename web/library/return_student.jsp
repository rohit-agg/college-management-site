<%-- 
    Document   : return_student
    Created on : Jun 30, 2011, 1:40:45 PM
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
    else if(valid_user.compareTo("Library") == 0)
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
                var roll_no = document.getElementById("roll-no");
                var reference_no = document.getElementById("reference-no");
                var error = new Boolean();

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";

                if(roll_no.value == "" || roll_no.value == null)
                {
                    errors_tag.innerHTML += "<li>Roll Number can't be left blank.</li>";
                    error = true;
                }
                if(reference_no.value == "" || reference_no.value == null)
                {
                    errors_tag.innerHTML += "<li>Reference Number can't be left blank.</li>";
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
        String reference_no = "";
        if(request.getAttribute("reference-no") != null)
            reference_no = (String)request.getAttribute("reference-no");

        String roll_no = "";
        if(request.getAttribute("roll-no") != null)
            roll_no = (String)request.getAttribute("roll-no");
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
                    <h1 class="pagetitle">Return Book - Student</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="return_student2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td>Roll Number</td>
                                <td><input type="textbox" name="roll-no" id="roll-no" value="<%= roll_no %>" /></td>
                            </tr>
                            <tr>
                                <td>Reference Number</td>
                                <td><input type="textbox" name="reference-no" id="reference-no" value="<%= reference_no %>" /></td>
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
