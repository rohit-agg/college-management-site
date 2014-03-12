<%-- 
    Document   : new_item
    Created on : Jul 1, 2011, 3:18:58 PM
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
    else if(valid_user.compareTo("Accounts") == 0)
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
                var item_name = document.getElementById("item-name");
                var item_details = document.getElementById("item-details");
                var error = new Boolean();

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";
                error = false;

                if(item_name.value == "" || item_name.value == null)
                {
                    errors_tag.innerHTML += "<li>Item Name can't be left blank.</li>";
                    error = true;
                }
                if(item_details.value == "" || item_details.value == null)
                {
                    errors_tag.innerHTML += "<li>Item Details can't be left blank.</li>";
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

            function limit_text()
            {
                var maxlength = 250;
                var item_details = document.getElementById("item-details");
                if (item_details.value.length > maxlength)
                    item_details.value = item_details.value.substring(0, maxlength);
            }
            -->
        </script>
    </head>
    <%
        String item_name = "";
        if(request.getAttribute("item-name") != null)
            item_name = (String)request.getAttribute("item-name");

        String item_details = "";
        if(request.getAttribute("item-details") != null)
            item_details = (String)request.getAttribute("item-details");
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
                    <h1 class="pagetitle">Item - New</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="new_item2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td>Item Name</td>
                                <td><input type="textbox" name="item-name" id="item-name" value="<%= item_name %>" /></td>
                            </tr>
                            <tr>
                                <td>Item Details</td>
                                <td><textarea cols="25" rows="4" name="item-details" id="item-details" onkeypress="limit_text()"><%= item_details %></textarea></td>
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
