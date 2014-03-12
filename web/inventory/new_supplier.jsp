<%-- 
    Document   : new_supplier
    Created on : Jul 1, 2011, 3:21:18 PM
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
                var supplier_name = document.getElementById("supplier-name");
                var supplier_address = document.getElementById("supplier-address");
                var contact_no = document.getElementById("contact-no");
                var error = new Boolean();

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";
                error = false;

                if(supplier_name.value == "" || supplier_name.value == null)
                {
                    errors_tag.innerHTML += "<li>Supplier Name can't be left blank.</li>";
                    error = true;
                }
                if(supplier_address.value == "" || supplier_address.value == null)
                {
                    errors_tag.innerHTML += "<li>Supplier Address can't be left blank.</li>";
                    error = true;
                }
                if(contact_no.value == "" || contact_no.value == null)
                {
                    errors_tag.innerHTML += "<li>Contact Number can't be left blank.</li>";
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
                var maxlength = 100;
                var supplier_address = document.getElementById("supplier-address");
                if (supplier_address.value.length > maxlength)
                    supplier_address.value = supplier_address.value.substring(0, maxlength);
            }
            -->
        </script>
    </head>
    <%
        String supplier_name = "";
        if(request.getAttribute("supplier-name") != null)
            supplier_name = (String)request.getAttribute("supplier-name");

        String supplier_address = "";
        if(request.getAttribute("supplier-address") != null)
            supplier_address = (String)request.getAttribute("supplier-address");

        String contact_no = "";
        if(request.getAttribute("contact-no") != null)
            contact_no = (String)request.getAttribute("contact-no");
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
                    <h1 class="pagetitle">Supplier - New</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="new_supplier2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td>Supplier Name</td>
                                <td><input type="textbox" name="supplier-name" id="supplier-name" value="<%= supplier_name %>" /></td>
                            </tr>
                            <tr>
                                <td>Supplier Address</td>
                                <td><textarea rows="4" cols="25" name="supplier-address" id="supplier-address" onkeypress="limit_text()"><%= supplier_address %></textarea></td>
                            </tr>
                            <tr>
                                <td>Contact Number</td>
                                <td><input type="textbox" name="contact-no" id="contact-no" value="<%= contact_no %>" /></td>
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
