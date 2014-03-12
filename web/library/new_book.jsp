<%-- 
    Document   : new_book
    Created on : Jun 30, 2011, 11:51:40 AM
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
        <title>College Management System - New Book</title>
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/general.css" />
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/input.css" />
        <script type="text/javascript">
            <!--
            function validate()
            {
                var errors_tag = document.getElementById("errors");
                var isbn_no = document.getElementById("isbn-no");
                var title = document.getElementById("title");
                var author = document.getElementById("author");
                var publisher = document.getElementById("publisher");
                var price = document.getElementById("price");
                var error = new Boolean();

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";

                if(isbn_no.value == "" || isbn_no.value == null)
                {
                    errors_tag.innerHTML += "<li>ISBN Number can't be left blank.</li>";
                    error = true;
                }
                if(title.value == "" || title.value == null)
                {
                    errors_tag.innerHTML += "<li>Title can't be left blank.</li>";
                    error = true;
                }
                if(author.value == "" || author.value == null)
                {
                    errors_tag.innerHTML += "<li>Author can't be left blank.</li>";
                    error = true;
                }
                if(publisher.value == "" || publisher.value == null)
                {
                    errors_tag.innerHTML += "<li>Publisher can't be left blank.</li>";
                    error = true;
                }
                if(price.value == "" || price.value == null)
                {
                    errors_tag.innerHTML += "<li>Price can't be left blank.</li>";
                    error = true;
                }
                else if(isNaN(price.value))
                {
                     errors_tag.innerHTML += "<li>Price must be a valid number.</li>";
                     error = true;
                }
                else if(price.value <= 0)
                {
                     errors_tag.innerHTML += "<li>Price can't be less than 0.</li>";
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

            function add_new_book()
            {
                var span_reference = document.getElementById("add-reference");
                var span_category = document.getElementById("add-category");

                var input = document.createElement("select");
                input.name = "category";
                input.id = "category";

                var option = document.createElement("option");
                option.value = "General";
                option.textContent = "General";
                input.appendChild(option);

                var option = document.createElement("option");
                option.value = "Reserved";
                option.textContent = "Reserved";
                input.appendChild(option);

                span_category.appendChild(input);
                var break_ = document.createElement("br");
                span_category.appendChild(break_);

                var input = document.createElement("input");
                input.type = "textbox";
                input.name = "reference-no";
                input.id = "reference-no";
                span_reference.appendChild(input);
                var break_ = document.createElement("br");
                span_reference.appendChild(break_);
            }
            -->
        </script>
    </head>
    <%
        String isbn_no = "";
        if(request.getAttribute("isbn-no") != null)
            isbn_no = (String)request.getAttribute("isbn-no");

        String title = "";
        if(request.getAttribute("title") != null)
            title = (String)request.getAttribute("title");

        String author = "";
        if(request.getAttribute("author") != null)
            author = (String)request.getAttribute("author");

        String publisher = "";
        if(request.getAttribute("publisher") != null)
            publisher = (String)request.getAttribute("publisher");

        String price = "";
        if(request.getAttribute("price") != null)
            price = (String)request.getAttribute("price");

        String[] reference_no = null;
        if(request.getAttribute("reference-no") != null)
            reference_no = (String[])request.getAttribute("reference-no");

        String[] category = null;
        if(request.getAttribute("category") != null)
            category = (String[])request.getAttribute("category");
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
                    <h1 class="pagetitle">Book - New</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="new_book2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td>ISBN Number</td>
                                <td><input type="textbox" name="isbn-no" id="isbn-no" value="<%= isbn_no %>" /></td>
                            </tr>
                            <tr>
                                <td>Title</td>
                                <td><input type="textbox" name="title" id="title" value="<%= title %>" /></td>
                            </tr>
                            <tr>
                                <td>Author</td>
                                <td><input type="textbox" name="author" id="author" value="<%= author %>" /></td>
                            </tr>
                            <tr>
                                <td>Publisher</td>
                                <td><input type="textbox" name="publisher" id="publisher" value="<%= publisher %>" /></td>
                            </tr>
                            <tr>
                                <td>Price</td>
                                <td><input type="textbox" name="price" id="price" value="<%= price %>" /></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <table width="100%">
                                        <tr>
                                            <td>Reference Number</td>
                                            <td>Category</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span id="add-reference">
                                                    <%
                                                        if(reference_no != null)
                                                        {
                                                            for(String temp : reference_no)
                                                            {
                                                    %>
                                                                <input type="textbox" name="reference-no" id="reference-no" value="<%= temp %>" /><br/>
                                                    <%
                                                            }
                                                        }
                                                    %>
                                                </span>
                                            </td>
                                            <td>
                                                <span id="add-category">
                                                    <%
                                                        if(category != null)
                                                        {
                                                            for(String temp : category)
                                                            {
                                                    %>
                                                                <select name="category" id="category">
                                                                    <option value="General" <% if(temp.compareTo("General") == 0) { out.write("selected"); }%> >General</option>
                                                                    <option value="Reserved" <% if(temp.compareTo("Reserved") == 0) { out.write("selected"); }%> >Reserved</option>
                                                                </select><br/>
                                                    <%
                                                            }
                                                        }
                                                    %>
                                                </span>
                                            </td>
                                            <td style="vertical-align: bottom;">
                                                <input type="button" name="add-new" value="Add New Book" onclick="add_new_book()" />
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
