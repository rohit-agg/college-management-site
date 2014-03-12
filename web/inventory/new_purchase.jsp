<%-- 
    Document   : new_purchase
    Created on : Jul 1, 2011, 3:26:12 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="initial.server, java.sql.*, java.util.ArrayList" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%!
	String[] get_supplier_name()
	{
            ArrayList<String> temp_supplier = new ArrayList<String>();
            try
            {
                String query;
                Statement execute_query;
                ResultSet result_set;

                query = "select SupplierName from Inventory.Supplier";
                execute_query = server.server_connection.createStatement();
                result_set = execute_query.executeQuery(query);

                while(result_set.next())
                    temp_supplier.add(result_set.getString("SupplierName"));
            }
            catch(SQLException e)
            {
            }

            int i = 0;
            String[] supplier = new String[temp_supplier.size()];
            for(String temp : temp_supplier)
                supplier[i++] = temp;

            return supplier;
	}

        String[] get_item_name()
	{
            ArrayList<String> temp_item = new ArrayList<String>();
            try
            {
                String query;
                Statement execute_query;
                ResultSet result_set;

                query = "select ItemName from Inventory.Item";
                execute_query = server.server_connection.createStatement();
                result_set = execute_query.executeQuery(query);

                while(result_set.next())
                    temp_item.add(result_set.getString("ItemName"));
            }
            catch(SQLException e)
            {
            }

            int i = 0;
            String[] item = new String[temp_item.size()];
            for(String temp : temp_item)
                item[i++] = temp;

            return item;
	}
%>

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
                var bill_no = document.getElementById("bill-no");
                var amount = document.getElementById("amount");
                var item = document.getElementsByName("item");
                var quantity = document.getElementsByName("quantity");
                var count = item.length;
                var error = new Boolean();

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";
                error = false;

                for(var i=0; i<count; i++)
                {
                    if(item[i].value != null && item[i].value != "")
                    {
                        if(quantity[i].value == "" || quantity[i].value == null)
                        {
                            errors_tag.innerHTML += "<li>Quantity can't be left blank for each item.</li>";
                            error = true;
                        }
                        else if(isNaN(quantity[i].value))
                        {
                             errors_tag.innerHTML += "<li>Quantity must be a valid number for each item.</li>";
                             error = true;
                        }
                        else if(quantity[i].value <= 0)
                        {
                             errors_tag.innerHTML += "<li>Quantity must be greater than 0 for each item.</li>";
                             error = true;
                        }
                    }

                    if(error == true)
                        break;
                }

                if(bill_no.value == "" || bill_no.value == null)
                {
                    errors_tag.innerHTML += "<li>Bill Number can't be left blank.</li>";
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
                else if(amount.value < 0)
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

            function add_new_item()
            {
                var span_quantity = document.getElementById("add-quantity");
                var input = document.createElement("input");
                input.type= "textbox";
                input.name = "quantity";
                input.id = "quantity";
                span_quantity.appendChild(input);
                var break_ = document.createElement("br");
                span_quantity.appendChild(break_);

                var span_item = document.getElementById("add-item");

                var input = document.createElement("select");
                input.name = "item";
                input.id = "item";
                var item_value = document.getElementsByName("item-value");
                for(var i=0; i<item_value.length; i++)
                {
                    var option = document.createElement("option");
                    option.value = item_value[i].value;
                    option.textContent = item_value[i].value;
                    input.appendChild(option);
                }
                span_item.appendChild(input);

                var break_ = document.createElement("br");
                span_item.appendChild(break_);
            }
            -->
        </script>
    </head>
    <%
        String bill_no = "";
        if(request.getAttribute("bill-no") != null)
            bill_no = (String)request.getAttribute("bill-no");

        String supplier = "";
        if(request.getAttribute("supplier") != null)
            supplier = (String)request.getAttribute("supplier");

        String bill_date = "";
        if(request.getAttribute("bill-date") != null)
            bill_date = (String)request.getAttribute("bill-date");

        String bill_month = "";
        if(request.getAttribute("bill-month") != null)
            bill_month = (String)request.getAttribute("bill-month");

        String bill_year = "";
        if(request.getAttribute("bill-year") != null)
            bill_year = (String)request.getAttribute("bill-year");

        String amount = "";
        if(request.getAttribute("amount") != null)
            amount = (String)request.getAttribute("amount");

        String[] item = null;
        if(request.getAttribute("item") != null)
            item = (String [])request.getAttribute("item");

        String[] quantity = null;
        if(request.getAttribute("quantity") != null)
            quantity = (String [])request.getAttribute("quantity");

        String[] show_date = (String [])getServletContext().getAttribute("date");
        String[] show_month = (String [])getServletContext().getAttribute("month");
        String[] show_month_value = (String [])getServletContext().getAttribute("month-value");
        String[] show_year = (String [])getServletContext().getAttribute("past-year");
	String[] show_supplier = get_supplier_name();
	String[] show_item = get_item_name();
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
                    <h1 class="pagetitle">Bill (Purchase) - New</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="new_purchase2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td>Bill Number</td>
                                <td><input type="textbox" name="bill-no" id="bill-no" value="<%= bill_no %>" /></td>
                            </tr>
                            <tr>
                                <td>Supplier</td>
                                <td>
                                    <select name="supplier" id="supplier">
                                        <%
                                            for(String temp : show_supplier)
                                            {
                                        %>
                                                <option value="<%= temp %>" <% if(temp.compareTo(supplier) == 0) { out.write("selected"); }%> ><%= temp %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>Bill Date</td>
                                <td>
                                    <select name="bill-date" id="bill-date">
                                        <%
                                            for(int i=0; i<31; i++)
                                            {
                                        %>
                                                <option value="<%= show_date[i] %>" <% if(show_date[i].compareTo(bill_date) == 0) { out.write("selected"); }%> ><%= show_date[i] %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                    <select name="bill-month" id="bill-month">
                                        <%
                                            for(int i=0; i<12; i++)
                                            {
                                        %>
                                                <option value="<%= show_month_value[i] %>" <% if(show_month_value[i].compareTo(bill_month) == 0) { out.write("selected"); }%> ><%= show_month[i] %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                    <select name="bill-year" id="bill-year">
                                        <%
                                            for(int i=0; i<3; i++)
                                            {
                                        %>
                                                <option value="<%= show_year[i] %>" <% if(show_year[i].compareTo(bill_year) == 0) { out.write("selected"); }%> ><%= show_year[i] %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>Amount</td>
                                <td><input type="textbox" name="amount" id="amount" value="<%= amount %>" /></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <table>
                                        <tr>
                                            <td>Item</td>
                                            <td>Quantity</td>
                                            <td>
                                                <%
                                                    for(String temp : show_item)
                                                    {
                                                %>
                                                        <input type="hidden" name="item-value" id="item-value" value="<%= temp %>" />
                                                <%
                                                    }
                                                %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span id="add-item">
                                                    <%
                                                        if(item != null)
                                                        {
                                                            for(String temp : item)
                                                            {
                                                    %>
                                                                <select name="item" id="item">
                                                    <%
                                                                    for(String temp2 : show_item)
                                                                    {
                                                    %>
                                                                        <option value="<%= temp2 %>" <% if(temp2.compareTo(temp) == 0) { out.write("selected"); }%> ><%= temp2 %></option>
                                                    <%
                                                                    }
                                                    %>
                                                                </select><br/>
                                                    <%
                                                            }
                                                        }
                                                    %>
                                                </span>
                                            </td>
                                            <td>
                                                <span id="add-quantity">
                                                    <%
                                                        if(quantity != null)
                                                        {
                                                            for(String temp : quantity)
                                                            {
                                                    %>
                                                                <input type="textbox" name="quantity" id="quantity" value="<%= temp %>" /><br/>
                                                    <%
                                                            }
                                                        }
                                                    %>
                                                </span>
                                            </td>
                                            <td style="vertical-align: bottom;">
                                                <input type="button" name="add-new-item" value="Add Item" onclick="add_new_item()" />
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
