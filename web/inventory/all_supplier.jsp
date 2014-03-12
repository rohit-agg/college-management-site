<%-- 
    Document   : all_supplier
    Created on : Jul 7, 2011, 8:25:12 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="initial.server, java.sql.*, java.util.ArrayList" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%!
        ResultSet get_all_supplier()
	{
            ResultSet result_set = null;
            try
            {
                String query;
                Statement execute_query;

                query = "select * from Inventory.Supplier";
                execute_query = server.server_connection.createStatement();
                result_set = execute_query.executeQuery(query);
            }
            catch(SQLException e)
            {
            }

            return result_set;
	}

        int count_supplier()
        {
            int count = 0;

            try
            {
                String query;
                Statement execute_query;
                ResultSet result_set;

                query = "select * from Inventory.CountSupplier";
                execute_query = server.server_connection.createStatement();
                result_set = execute_query.executeQuery(query);
                result_set.next();
                count = result_set.getInt("NoOfSupplier");
            }
            catch(SQLException e)
            {
            }

            return count;
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

    int count = count_supplier();
    String page_value = request.getParameter("page");
    int page_number = 1;
    if(count == 0)
    {
        request.setAttribute("warning", "No Supplier currently exists in the database of college.");
        RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
        index.forward(request, response);
    }

    ResultSet all_supplier = get_all_supplier();
    if(page_value != null && page_value.compareTo("") != 0)
    {
        page_number = Integer.parseInt(page_value);
        if(page_number <= 0)
            page_number = 1;
        else if(page_number > ((count % 10 == 0) ? (count / 10) : ((count / 10) + 1)))
            page_number = (count % 10 == 0) ? (count / 10) : ((count / 10) + 1);
    }
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
                    <h1 class="pagetitle">Supplier</h1>
                    <div class="div-display">
                        <table width="550px">
                            <tr>
                                <th width="30%">Supplier Name</th>
                                <th width="15%">Contact Number</th>
                                <th width="55%">Address</th>
                            </tr>
                            <%
                                if(all_supplier != null)
                                {
                                    int count_records = 0;
                                    while(count_records < ((page_number - 1) * 10))
                                    {
                                        all_supplier.next();
                                        count_records++;
                                    }

                                    count_records = 0;
                                    while(all_supplier.next() && count_records < 10)
                                    {
                            %>
                            <tr>
                                <td><%= all_supplier.getString("SupplierName") %></td>
                                <td><%= all_supplier.getString("ContactNo") %></td>
                                <td><%= all_supplier.getString("Address") %></td>
                            </tr>
                            <%
                                        count_records++;
                                    }
                                }
                            %>
                        </table>
                    </div>
                    <table class="page">
                        <tr>
                            <td><a href="all_supplier.jsp?page=<%= page_number - 1 %>">Previous</a></td>
                            <%
                                for(int i = (page_number - 5 > 1 ? page_number - 5 : 1); i <= (page_number - 1); i++)
                                {
                            %>
                            <td><a href="all_supplier.jsp?page=<%= i %>"><%= i %></a></td>
                            <%
                                }
                            %>
                            <td><a href="all_supplier.jsp?page=<%= page_number %>"><%= page_number %></a></td>
                            <%
                                for(int i = page_number + 1; i <= ((page_number + 5) < ((count % 10 == 0) ? (count / 10) : ((count / 10) + 1)) ? (page_number + 5) : ((count % 10 == 0) ? (count / 10) : ((count / 10) + 1))); i++)
                                {
                            %>
                            <td><a href="all_supplier.jsp?page=<%= i %>"><%= i %></a></td>
                            <%
                                }
                            %>
                            <td><a href="all_supplier.jsp?page=<%= page_number + 1 %>">Next</a></td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="footer">
                <%@include file="/WEB-INF/resource/footer.jspf" %>
            </div>
        </div>
    </body>
</html>
