<%-- 
    Document   : company_details
    Created on : Jul 7, 2011, 10:23:38 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="initial.server, java.sql.*, java.util.ArrayList" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%!
        ResultSet get_company_details(int company_id)
	{
            ResultSet result_set = null;
            try
            {
                String query;
                PreparedStatement execute_query;

                query = "select * from TandP.CompanyDetails where CompanyID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, company_id);
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
	}

        ResultSet get_company_criteria(int company_id)
	{
            ResultSet result_set = null;
            try
            {
                String query;
                PreparedStatement execute_query;

                query = "select * from TandP.CompanyCriteria where CompanyID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, company_id);
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
	}

        ResultSet get_placed_students(int company_id)
	{
            ResultSet result_set = null;
            try
            {
                String query;
                PreparedStatement execute_query;

                query = "select * from TandP.PlacedStudent where CompanyID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, company_id);
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
	}

        boolean whether_placed_students(int company_id)
        {
            boolean whether = false;

            try
            {
                String query;
                PreparedStatement execute_query;
                ResultSet result_set;

                query = "select * from TandP.PlacedStudent where CompanyID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, company_id);
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

    String company_id = (String)request.getParameter("company-id");
    if(company_id == null || company_id.compareTo("") == 0)
        response.sendRedirect("all_company.jsp");

    ResultSet company_details = get_company_details(Integer.parseInt(company_id));
    if(company_details.next() == false)
    {
        request.setAttribute("warning", "Company doesn't exists in the database of college.");
        RequestDispatcher all_company = request.getRequestDispatcher("all_company.jsp");
        all_company.forward(request, response);
    }
    ResultSet company_criteria = get_company_criteria(Integer.parseInt(company_id));
    company_criteria.next();
    ResultSet placed_students = get_placed_students(Integer.parseInt(company_id));
    boolean whether_placed = whether_placed_students(Integer.parseInt(company_id));
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
                    <h1 class="pagetitle">Company - <%= company_details.getString("Name") %></h1>
                    <div class="div-display">
                        <table>
                            <tr>
                                <th width="25%">Company Name</th>
                                <td width="75%"><%= company_details.getString("Name") %></td>
                            </tr>
                            <tr>
                                <th>Address</th>
                                <td><%= company_details.getString("Address") %></td>
                            </tr>
                            <tr>
                                <th>Contact Number</th>
                                <td><%= company_details.getString("ContactNo") %></td>
                            </tr>
                            <tr>
                                <th>Average Percentage</th>
                                <td><%= company_criteria.getInt("AveragePercentage") %></td>
                            </tr>
                            <tr>
                                <th>Semester Percentage</th>
                                <td><%= company_criteria.getInt("SemesterPercentile") %></td>
                            </tr>
                            <tr>
                                <th>Backlogs</th>
                                <td><%= company_criteria.getString("Backlogs") %></td>
                            </tr>
                            <tr>
                                <th>Supplementary</th>
                                <td><%= company_criteria.getString("Supplementary") %></td>
                            </tr>
                                <%
                                    if(company_criteria.getString("Supplementary").compareTo("Allowed") == 0)
                                    {
                                %>
                                    <tr>
                                        <th>Maximum Supplementary</th>
                                        <td><%= company_criteria.getInt("MaxSupplementary") %></td>
                                    </tr>
                                <%
                                    }
                                %>
                        </table>
                    </div>
                    <div class="div-display">
                        <table width="450px">
                            <%
                                if(placed_students != null)
                                {
                                    if(whether_placed)
                                    {
                            %>
                                        <tr>
                                            <th width="35%">Roll Number</th>
                                            <th width="35">Designation</th>
                                            <th width="30">Package</th>
                                        </tr>
                            <%
                                    }
                                    while(placed_students.next())
                                    {
                            %>
                                        <tr>
                                            <td><%= placed_students.getString("RollNo") %></td>
                                            <td><%= placed_students.getString("Designation") %></td>
                                            <td><%= placed_students.getInt("Package") %></td>
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
