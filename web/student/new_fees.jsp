<%-- 
    Document   : new_fees
    Created on : Jun 30, 2011, 12:32:38 AM
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
        <title>College Management System - New Fees</title>
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/general.css" />
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/input.css" />
        <script type="text/javascript">
            <!--
            function validate()
            {
                var errors_tag = document.getElementById("errors");
                var roll_no = document.getElementById("roll-no");
                var receipt_no = document.getElementById("receipt-no");
                var date = document.getElementById("date");
                var month = document.getElementById("month");
                var year = document.getElementById("year");
                var amount = document.getElementById("amount");
                var error = new Boolean();
                var day = new Date(year.value, month.value-1, date.value);

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";

                if(roll_no.value == "" || roll_no.value == null)
                {
                    errors_tag.innerHTML += "<li>Roll Number can't be left blank.</li>";
                    error = true;
                }
                if((day.getMonth()+1 != month.value) || (day.getDate() != date.value) || (day.getFullYear() != year.value))
                {
                    errors_tag.innerHTML += "<li>Date of Submit is not valid.</li>";
                    error = true;
                }
                if(receipt_no.value == "" || receipt_no.value == null)
                {
                    errors_tag.innerHTML += "<li>Receipt No. can't be left blank.</li>";
                    error = true;
                }
                else if(isNaN(receipt_no.value))
                {
                     errors_tag.innerHTML += "<li>Receipt No. must be a valid number.</li>";
                     error = true;
                }
                if(amount.value == "" || amount.value == null)
                {
                    errors_tag.innerHTML += "<li>Amount can't be left blank.</li>";
                    error = true;
                }
                else if(isNaN(amount.value))
                {
                     errors_tag.innerHTML += "<li>Amount must be a valid number.</li>";
                     error = true;
                }
                else if(amount.value <= 0)
                {
                     errors_tag.innerHTML += "<li>Amount must be greater than 0.</li>";
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
                var maxlength = 50;
                var details = document.getElementById("details");
                if (details.value.length > maxlength)
                    details.value = details.value.substring(0, maxlength);
            }
            -->
        </script>
    </head>
    <%
        String roll_no = "";
        if(request.getAttribute("roll-no") != null)
            roll_no = (String)request.getAttribute("roll-no");

        String receipt_no = "";
        if(request.getAttribute("receipt-no") != null)
            receipt_no = (String)request.getAttribute("receipt-no");

        String date = "";
        if(request.getAttribute("date") != null)
            date = (String)request.getAttribute("date");

        String month = "";
        if(request.getAttribute("month") != null)
            month = (String)request.getAttribute("month");

        String year = "";
        if(request.getAttribute("year") != null)
            year = (String)request.getAttribute("year");

        String amount = "";
        if(request.getAttribute("amount") != null)
            amount = (String)request.getAttribute("amount");

        String type = "";
        if(request.getAttribute("type") != null)
            type = (String)request.getAttribute("type");

        String details = "";
        if(request.getAttribute("details") != null)
            details = (String)request.getAttribute("details");

        String[] show_date = (String [])getServletContext().getAttribute("date");
        String[] show_month = (String [])getServletContext().getAttribute("month");
        String[] show_month_value = (String [])getServletContext().getAttribute("month-value");
        String[] show_year = (String [])getServletContext().getAttribute("past-year");
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
                    <h1 class="pagetitle">Student Fees - New</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="new_fees2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td>Roll Number</td>
                                <td><input type="texbox" name="roll-no" id="roll-no" value="<%= roll_no %>" /></td>
                            </tr>
                            <tr>
                                <td>Date Of Submit</td>
                                <td>
                                    <select name="date" id="date">
                                        <%
                                            for(int i=0; i<31; i++)
                                            {
                                        %>
                                                <option value="<%= show_date[i] %>" <% if(show_date[i].compareTo(date) == 0) { out.write("selected"); }%> ><%= show_date[i] %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                    <select name="month" id="month">
                                        <%
                                            for(int i=0; i<12; i++)
                                            {
                                        %>
                                                <option value="<%= show_month_value[i] %>" <% if(show_month_value[i].compareTo(month) == 0) { out.write("selected"); }%> ><%= show_month[i] %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                    <select name="year" id="year">
                                        <%
                                            for(int i=0; i<50; i++)
                                            {
                                        %>
                                                <option value="<%= show_year[i] %>" <% if(show_year[i].compareTo(year) == 0) { out.write("selected"); }%> ><%= show_year[i] %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>Receipt No.</td>
                                <td><input type="texbox" name="receipt-no" id="receipt-no" value="<%= receipt_no %>" /></td>
                            </tr>
                            <tr>
                                <td>Amount<br/>(in Rs.)</td>
                                <td><input type="texbox" name="amount" id="amount" value="<%= amount %>" /></td>
                            </tr>
                            <tr>
                                <td>Submission Type</td>
                                <td>
                                    <select name="type" id="type">
                                        <option <% if(type.compareTo("Cash") == 0) { out.write("selected"); }%> >Cash</option>
                                        <option <% if(type.compareTo("Cheque") == 0) { out.write("selected"); }%> >Cheque</option>
                                        <option <% if(type.compareTo("Demand Draft") == 0) { out.write("selected"); }%> >Demand Draft</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>Details</td>
                                <td>
                                    <textarea name="details" id="details" cols="40" rows="3" onkeypress="limit_text()"><%= details %></textarea>
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
