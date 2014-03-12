<%-- 
    Document   : book_details
    Created on : Jul 3, 2011, 7:45:47 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="initial.server, java.sql.*, java.util.ArrayList" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%!
        ResultSet get_book_details(String isbn_no)
	{
            ResultSet result_set = null;
            try
            {
                String query;
                PreparedStatement execute_query;

                query = "select * from Library.Book where ISBNNo=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, isbn_no);
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
	}

        ResultSet get_book_record(String isbn_no)
	{
            ResultSet result_set = null;
            try
            {
                String query;
                PreparedStatement execute_query;

                query = "select * from Library.BookRecord where ISBNNo=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, isbn_no);
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
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
    else if(valid_user.compareTo("Student") == 0)
       valid = true;
    if(valid == false)
      response.sendRedirect("/ClgMgtSite/general/login.jsp");

    String isbn_no = (String)request.getParameter("isbn-no");
    if(isbn_no == null || isbn_no.compareTo("") == 0)
        response.sendRedirect("all_book.jsp");

    ResultSet book_details = get_book_details(isbn_no);
    if(book_details.next() == false)
    {
        request.setAttribute("warning", "Book: " + isbn_no + " doesn't exists in the database of library.");
        RequestDispatcher all_book = request.getRequestDispatcher("all_book.jsp");
        all_book.forward(request, response);
    }
    
    ResultSet book_record = get_book_record(isbn_no);
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
                    <h1 class="pagetitle">Book - <%= book_details.getString("Title") %></h1>
                    <div class="div-display">
                        <table>
                            <tr>
                                <th width="25%">ISBN Number</th>
                                <td width="75%"><%= book_details.getString("ISBNNo") %></td>
                            </tr>
                            <tr>
                                <th>Title</th>
                                <td><%= book_details.getString("Title") %></td>
                            </tr>
                            <tr>
                                <th>Author</th>
                                <td><%= book_details.getString("Author") %></td>
                            </tr>
                            <tr>
                                <th>Publisher</th>
                                <td><%= book_details.getString("Publisher") %></td>
                            </tr>
                            <tr>
                                <th>Price</th>
                                <td>Rs. <%= book_details.getInt("Price") %></td>
                            </tr>
                        </table>
                    </div>
                    <div class="div-display">
                        <table width="400px">
                            <%
                                if(book_record != null)
                                {
                                    while(book_record.next())
                                    {
                                        if(book_record.getRow() == 1)
                                        {
                            %>
                            <tr>
                                <th width="50%">Reference Number</th>
                                <th width="25%">Category</th>
                                <th width="25%">Status</th>
                            </tr>
                            <%
                                        }
                            %>
                            <tr>
                                <td><%= book_record.getString("ReferenceNo") %></td>
                                <td><%= book_record.getString("Category") %></td>
                                <td><%= book_record.getString("Status") %></td>
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
