<%-- 
    Document   : student_fee
    Created on : Jul 3, 2011, 6:19:01 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="initial.server, java.sql.*, java.util.ArrayList" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%!
        ResultSet get_fee_details(String roll_no)
	{
            ResultSet result_set = null;
            try
            {
                String query;
                PreparedStatement execute_query;

                query = "select * from Student.Fees where RollNo=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, roll_no);
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
	}

        boolean whether_fees(String roll_no)
        {
            boolean whether = false;

            try
            {
                String query;
                PreparedStatement execute_query;
                ResultSet result_set;

                query = "select * from Student.Fees where RollNo=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, roll_no);
                result_set = execute_query.executeQuery();

                if(result_set.next())
                    whether = true;
            }
            catch(SQLException e)
            {
            }

            return whether;
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

    String roll_no = (String)request.getParameter("roll-no");
    if(roll_no == null || roll_no.compareTo("") == 0)
        response.sendRedirect("all_student.jsp");

    boolean whether = whether_fees(roll_no);
    if(whether == false)
    {
        request.setAttribute("warning", "No Fees Details exists for the Student: " + roll_no + " in the database.");
        RequestDispatcher student = request.getRequestDispatcher("student_details.jsp?roll-no=" + roll_no);
        student.forward(request, response);
    }

    ResultSet fee_details = get_fee_details(roll_no);
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
                    <h1 class="pagetitle">Student - <%= roll_no %> (Fees)</h1>
                    <div class="div-display">
                        <table>
                            <tr>
                                <th width="25%">Roll Number</th>
                                <td width="75%"><%= roll_no %></td>
                            </tr>
                        </table>
                    </div>
                    <div class="div-display">
                        <table width="550px">
                            <tr>
                                <th width="16%">Date Of Submit</th>
                                <th width="16%">Receipt Number</th>
                                <th width="16%">Amount</th>
                                <th width="16%">Payment Type</th>
                                <th width="36%">Details</th>
                            </tr>
                            <%
                                if(fee_details != null)
                                {
                                    while(fee_details.next())
                                    {
                             %>
                             <tr>
                                 <td><%= fee_details.getDate("DateOfSubmit").toString() %></td>
                                 <td><%= fee_details.getInt("ReceiptNo") %></td>
                                 <td><%= fee_details.getInt("Amount") %></td>
                                 <td><%= fee_details.getString("Type") %></td>
                                 <td><%= fee_details.getString("Details") %></td>
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
