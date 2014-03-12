<%-- 
    Document   : bill_details
    Created on : Jul 7, 2011, 8:40:11 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="initial.server, java.sql.*, java.util.ArrayList" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%!
        ResultSet get_bill_details(String bill_no)
	{
            ResultSet result_set = null;
            try
            {
                String query;
                PreparedStatement execute_query;

                query = "select * from Inventory.BillDetail where BillNo=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, bill_no);
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
	}

        ResultSet get_item_details(int purchase_id)
	{
            ResultSet result_set = null;
            try
            {
                String query;
                PreparedStatement execute_query;

                query = "select * from Inventory.Purchase where PurchaseID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, purchase_id);
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
	}

        String get_supplier(int supplier_id)
        {
            String supplier = "";

            try
            {
                String query;
                PreparedStatement execute_query;
                ResultSet result_set;

                query = "select * from Inventory.Supplier where SupplierID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, supplier_id);
                result_set = execute_query.executeQuery();
                result_set.next();
                supplier = result_set.getString("SupplierName");
            }
            catch(SQLException e)
            {
            }

            return supplier;
        }

        String get_item(int item_id)
        {
            String item = "";

            try
            {
                String query;
                PreparedStatement execute_query;
                ResultSet result_set;

                query = "select * from Inventory.Item where ItemID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, item_id);
                result_set = execute_query.executeQuery();
                result_set.next();
                item = result_set.getString("ItemName");
            }
            catch(SQLException e)
            {
            }

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
    else if(valid_user.compareTo("Exam Cell") == 0)
       valid = true;
    else if(valid_user.compareTo("Library") == 0)
       valid = true;
    else if(valid_user.compareTo("Training and Placement") == 0)
       valid = true;
    else if(valid_user.compareTo("Faculty") == 0)
       valid = true;
    if(valid == false)
      response.sendRedirect("/ClgMgtSite/general/login.jsp");

    String bill_no = (String)request.getParameter("bill-no");
    if(bill_no == null || bill_no.compareTo("") == 0)
        response.sendRedirect("all_bill.jsp");

    ResultSet bill_details = get_bill_details(bill_no);
    if(bill_details.next() == false)
    {
        request.setAttribute("warning", "Bill: " + bill_no + " doesn't exists in the database of college.");
        RequestDispatcher all_bill = request.getRequestDispatcher("all_bill.jsp");
        all_bill.forward(request, response);
    }
    int purchase_id = bill_details.getInt("PurchaseID");
    ResultSet item_details = get_item_details(purchase_id);
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>College Management System</title>
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/general.css" />
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/display.css" />
    </head>
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
                    <h1 class="pagetitle">Bill - <%= bill_no %></h1>
                    <div class="div-display">
                        <table>
                            <tr>
                                <th width="25%">Bill Number</th>
                                <td width="75%"><%= bill_no %></td>
                            </tr>
                            <tr>
                                <th>Bill Date</th>
                                <td><%= bill_details.getDate("BillDate") %></td>
                            </tr>
                            <tr>
                                <th>Supplier</th>
                                <td><%= get_supplier(bill_details.getInt("SupplierID")) %></td>
                            </tr>
                            <tr>
                                <th>Amount</th>
                                <td><%= bill_details.getInt("Amount") %></td>
                            </tr>
                        </table>
                    </div>
                    <div class="div-display">
                        <table width="300px">
                            <%
                                if(item_details != null)
                                {
                                    while(item_details.next())
                                    {
                                        if(item_details.getRow() == 1)
                                        {
                            %>
                                            <tr>
                                                <th width="60%">Item Name</th>
                                                <th width="40%">Quantity</th>
                                            </tr>
                            <%
                                        }
                            %>
                                        <tr>
                                            <td><%= get_item(item_details.getInt("ItemID")) %></td>
                                            <td><%= item_details.getInt("Quantity") %></td>
                                        </tr>
                            <%
                                    }
                                }
                            %>
                        </table>
                    </div>
                </div>
            </div>
            <div class="footer">
                <%@include file="/WEB-INF/resource/footer.jspf" %>
            </div>
        </div>
    </body>
</html>
