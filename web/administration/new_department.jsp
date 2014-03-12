<%-- 
    Document   : new_department
    Created on : Jun 28, 2011, 8:42:31 PM
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
        <title>College Management System - New Department</title>
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/general.css" />
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/input.css" />
        <script type="text/javascript">
            <!--
            function validate()
            {
                var errors_tag = document.getElementById("errors");
                var department_name = document.getElementById("department-name");
                var error = new Boolean();

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";

                if(department_name.value == "" || department_name.value == null)
                {
                    errors_tag.innerHTML += "<li>Department Name can't be left blank.</li>";
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
        String department_name = "";
        if(request.getAttribute("department-name") != null)
            department_name = (String)request.getAttribute("department-name");

        String department_type = "";
        if(request.getAttribute("department-type") != null)
            department_type = (String)request.getAttribute("department-type");
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
                    <h1 class="pagetitle">Department - New</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="new_department2" method="post" onsubmit="return validate()">                        
                        <table>
                            <tr>
                                <td>Department Name</td>
                                <td><input type="textbox" name="department-name" id="department-name" value="<%= department_name %>" /></td>
                            </tr>
                            <tr>
                                <td>Department Type</td>
                                <td>
                                    <select name="department-type" id="department-type">
                                        <option value="Management" <% if(department_type.compareTo("Management") == 0) { out.write("selected"); }%> >Management</option>
                                        <option value="Education" <% if(department_type.compareTo("Education") == 0) { out.write("selected"); }%> >Education</option>
                                    </select>
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
