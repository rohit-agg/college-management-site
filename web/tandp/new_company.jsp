<%-- 
    Document   : new_company
    Created on : Jul 1, 2011, 8:37:33 PM
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
    else if(valid_user.compareTo("Training and Placement") == 0)
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
                var name = document.getElementById("name");
                var address = document.getElementById("address");
                var contact_no = document.getElementById("contact-no");
                var avg_percent = document.getElementById("avg-percent");
                var supplementary = document.getElementById("supplementary");
                var max_supplementary = document.getElementById("max-supplementary");
                var error = new Boolean();
                
                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";

                if(name.value == "" || name.value == null)
                {
                    errors_tag.innerHTML += "<li>Name can't be left blank.</li>";
                    error = true;
                }
                if(address.value == "" || address.value == null)
                {
                    errors_tag.innerHTML += "<li>Address can't be left blank.</li>";
                    error = true;
                }
                if(contact_no.value == "" || contact_no.value == null)
                {
                    errors_tag.innerHTML += "<li>Contact Number can't be left blank.</li>";
                    error = true;
                }
                if(avg_percent.value == "" || avg_percent.value == null)
                {
                    errors_tag.innerHTML += "<li>Average Percentage can't be left blank.</li>";
                    error = true;
                }
                else if(isNaN(avg_percent.value))
                {
                     errors_tag.innerHTML += "<li>Average Percentage must be a valid number.</li>";
                     error = true;
                }
                else if(avg_percent.value > 100 || avg_percent.value < 0)
                {
                     errors_tag.innerHTML += "<li>Average Percentage must be between 0 and 100.</li>";
                     error = true;
                }
                if(supplementary.value == "Allowed")
                {
                    if(max_supplementary.value == "" || max_supplementary.value == null)
                    {
                        errors_tag.innerHTML += "<li>Max. Supplementary Allowed can't be left blank.</li>";
                        error = true;
                    }
                    else if(isNaN(max_supplementary.value))
                    {
                         errors_tag.innerHTML += "<li>Max. Supplementary Allowed must be a valid number.</li>";
                         error = true;
                    }
                    else if(max_supplementary.value <= 0)
                    {
                         errors_tag.innerHTML += "<li>Max. Supplementary Allowed must be greater than 0.</li>";
                         error = true;
                    }
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
                var maxlength = 150;
                var address = document.getElementById("address");
                if (address.value.length > maxlength)
                    address.value = address.value.substring(0, maxlength);
            }
            
            function supplementary_change()
            {
                var supplementary_value = document.getElementById("supplementary");
                
                if(supplementary_value.value == "Allowed")
                {
                    var max_supp = document.getElementById("max-supp");
                    max_supp.style.visibility = "visible";
                    max_supp.style.display = "block";

                    var max_supp_2 = document.getElementById("max-supp-2");
                    max_supp_2.style.visibility = "visible";
                    max_supp_2.style.display = "block";
                }
                else
                {
                    var max_supp = document.getElementById("max-supp");
                    max_supp.style.visibility = "hidden";
                    max_supp.style.display = "none";

                    var max_supp_2 = document.getElementById("max-supp-2");
                    max_supp_2.style.visibility = "hidden";
                    max_supp_2.style.display = "none";
                }
            }
            -->
        </script>
    </head>
    <%
        String name = "";
        if(request.getAttribute("name") != null)
            name = (String)request.getAttribute("name");

        String address = "";
        if(request.getAttribute("address") != null)
            address = (String)request.getAttribute("address");

        String contact_no = "";
        if(request.getAttribute("contact-no") != null)
            contact_no = (String)request.getAttribute("contact-no");

        String avg_percent = "";
        if(request.getAttribute("avg-percent") != null)
            avg_percent = (String)request.getAttribute("avg-percent");

        String sem_percent = "";
        if(request.getAttribute("sem-percent") != null)
            sem_percent = (String)request.getAttribute("sem-percent");

        String backlogs = "";
        if(request.getAttribute("backlogs") != null)
            backlogs = (String)request.getAttribute("backlogs");

        String supplementary = "";
        if(request.getAttribute("supplementary") != null)
            supplementary = (String)request.getAttribute("supplementary");

        String max_supplementary = "";
        if(request.getAttribute("max-supplementary") != null)
            max_supplementary = (String)request.getAttribute("max-supplementary");
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
                    <h1 class="pagetitle">Company - New</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="new_company2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td>Name</td>
                                <td><input type="textbox" name="name" id="name" value="<%= name %>" /></td>
                            </tr>
                            <tr>
                                <td>Address</td>
                                <td>
                                    <textarea name="address" id="address" rows="4" cols="25" onkeypress="limit_text()"><%= address %></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td>Contact Number</td>
                                <td><input type="textbox" name="contact-no" id="contact-no" value="<%= contact_no %>" /></td>
                            </tr>
                            <tr>
                                <td colspan="2">Placement Criteria</td>
                            </tr>
                            <tr>
                                <td>Average Percentage</td>
                                <td><input type="textbox" name="avg-percent" id="avg-percent" value="<%= avg_percent %>" /></td>
                            </tr>
                            <tr>
                                <td>Semester Percentage</td>
                                <td><input type="textbox" name="sem-percent" id="sem-percent" value="<%= sem_percent %>" /></td>
                            </tr>
                            <tr>
                                <td>Backlogs</td>
                                <td>
                                    <select name="backlogs" id="backlogs">                                        
                                        <option <% if(backlogs.compareTo("Not Allowed") == 0) { out.write("selected"); }%> >Not Allowed</option>
                                        <option <% if(backlogs.compareTo("Allowed") == 0) { out.write("selected"); }%> >Allowed</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>Supplementary</td>
                                <td>
                                    <select name="supplementary" id="supplementary" onchange="supplementary_change()">                                        
                                        <option <% if(supplementary.compareTo("Not Allowed") == 0) { out.write("selected"); }%> >Not Allowed</option>
                                        <option <% if(supplementary.compareTo("Allowed") == 0) { out.write("selected"); }%> >Allowed</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <span id="max-supp" <% if(supplementary.compareTo("Allowed") == 0) { out.write("style=\"display: block; visibility: visible\""); }
                                                                else { out.write("style=\"display: none; visibility: hidden\""); } %> >Max. Supplementary Allowed
                                    </span>
                                </td>
                                <td>
                                    <span id="max-supp-2" <% if(supplementary.compareTo("Allowed") == 0) { out.write("style=\"display: block; visibility: visible\""); }
                                                                else { out.write("style=\"display: none; visibility: hidden\""); } %> >
                                        <input type="textbox" name="max-supplementary" id="max-supplementary" value="<%= max_supplementary %>" />
                                    </span>
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
