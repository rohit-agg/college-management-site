<%-- 
    Document   : new_batch
    Created on : Jun 28, 2011, 9:03:25 PM
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
        <title>College Management System - New Batch</title>
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/general.css" />
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/input.css" />
        <script type="text/javascript">
            <!--
            function validate()
            {
                var errors_tag = document.getElementById("errors");
                var start_year = document.getElementById("start-year");
                var end_year = document.getElementById("end-year");
                var error = new Boolean();

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";

                if(start_year.value == end_year.value)
                {
                    errors_tag.innerHTML += "<li>Start Year can't be equal to End Year.</li>";
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
        String start_year = "";
        if(request.getAttribute("start-year") != null)
            start_year = (String)request.getAttribute("start-year");

        String end_year = "";
        if(request.getAttribute("end-year") != null)
            end_year = (String)request.getAttribute("end-year");
        
        String[] show_past_year = (String [])getServletContext().getAttribute("past-year");
        String[] show_future_year = (String [])getServletContext().getAttribute("future-year");
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
                    <h1 class="pagetitle">Batch - New</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="new_batch2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td>Start Year</td>
                                <td>
                                    <select name="start-year" id="start-year">
                                        <%
                                            for(int i=0; i<10; i++)
                                            {
                                        %>
                                                <option value="<%= show_past_year[i] %>" <% if(show_past_year[i].compareTo(start_year) == 0) { out.write("selected"); }%> ><%= show_past_year[i] %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>End Year</td>
                                <td>
                                    <select name="end-year" id="end-year">
                                        <%
                                            for(int i=0; i<10; i++)
                                            {
                                        %>
                                                <option value="<%= show_future_year[i] %>" <% if(show_future_year[i].compareTo(end_year) == 0) { out.write("selected"); }%> ><%= show_future_year[i] %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td class="button"><input type="submit" name="enter" value="Enter Details" /></td>
                                <td class="button"><input type="button" name="cancel" value="Cancel" onclick="cancel_page()"</td>
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
