<%-- 
    Document   : employee_details
    Created on : Jul 2, 2011, 2:22:11 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="initial.server, java.sql.*, java.util.ArrayList" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%!
        ResultSet get_employee_details(String employee_id)
	{
            ResultSet result_set = null;
            try
            {
                String query;
                PreparedStatement execute_query;

                query = "select * from Employee.PersonalDetail where EmployeeID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, employee_id);
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
	}

        ResultSet get_department_details(String employee_id)
	{
            ResultSet result_set = null;
            try
            {
                String query;
                PreparedStatement execute_query;

                query = "select * from Employee.DepartmentDetail where EmployeeID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, employee_id);
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
	}

        ResultSet get_employee_education(String employee_id)
	{
            ResultSet result_set = null;
            try
            {
                String query;
                PreparedStatement execute_query;

                query = "select * from Employee.EducationalQualification where EmployeeID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, employee_id);
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
	}

        int get_employee_salary(String employee_id)
        {
            int salary = 0;
            try
            {
                String query;
                PreparedStatement execute_query;
                ResultSet result_set;

                query = "select * from Employee.Payroll where EmployeeID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, employee_id);
                result_set = execute_query.executeQuery();
                if(result_set.next())
                    salary = result_set.getInt("MonthlySalary");
            }
            catch(SQLException e)
            {
            }

            return salary;
        }

        String get_department(int department_id)
        {
            String department = "";

            try
            {
                String query;
                PreparedStatement execute_query;
                ResultSet result_set;

                query = "select * from Administration.Department where DepartmentID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, department_id);
                result_set = execute_query.executeQuery();
                result_set.next();
                department = result_set.getString("Name");
            }
            catch(SQLException e)
            {
            }

            return department;
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

    String employee_id = (String)request.getParameter("employee-id");
    if(employee_id == null || employee_id.compareTo("") == 0)
        response.sendRedirect("all_employee.jsp");

    ResultSet employee_details = get_employee_details(employee_id);
    if(employee_details.next() == false)
    {
        request.setAttribute("warning", "Employee: " + employee_id + " doesn't exists in the database of college.");
        RequestDispatcher all_employee = request.getRequestDispatcher("all_employee.jsp");
        all_employee.forward(request, response);
    }
    ResultSet employee_department = get_department_details(employee_id);
    boolean department_exists = employee_department.next();
    ResultSet employee_education = get_employee_education(employee_id);
    boolean education_exists = employee_education.next();
    int monthly_salary = get_employee_salary(employee_id);
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
                    <h1 class="pagetitle">Employee - <%= employee_id %></h1>
                    <div class="div-display">                        
                        <table width="600px">
                            <tr>
                                <th width="20%">Employee ID</th>
                                <td width="52%"><%= employee_id %></td>
                                <td rowspan="10" width="28%">
                                    <img src="<%= employee_details.getString("Photo") %>" width="150px" height="150px" />
                                </td>
                            </tr>
                            <tr>
                                <th>Employee Name</th>
                                <td><%= employee_details.getString("Name") %></td>
                            </tr>
                            <tr>
                                <th>Father's Name</th>
                                <td><%= employee_details.getString("FatherName") %></td>
                            </tr>
                            <tr>
                                <th>Mother's Name</th>
                                <td><%= employee_details.getString("MotherName") %></td>
                            </tr>
                            <tr>
                                <th>Address</th>
                                <td><%= employee_details.getString("Address") %></td>
                            </tr>
                            <tr>
                                <th>Date of Birth</th>
                                <td><%= employee_details.getDate("DateOfBirth").toString() %></td>
                            </tr>
                            <tr>
                                <th>Gender</th>
                                <td><%= employee_details.getString("Gender") %></td>
                            </tr>
                            <tr>
                                <th>Contact Number</th>
                                <td><%= employee_details.getString("ContactNo") %></td>
                            </tr>
                            <tr>
                                <th>E-Mail ID</th>
                                <td><%= employee_details.getString("EMailID") %></td>
                            </tr>
                            <%
                                if(education_exists)
                                {
                            %>
                            <tr>
                                <th>X<sup>th</sup> Details</th>
                                <td><%= employee_education.getInt("XMarks") + " (" + employee_education.getInt("XYear") + ")" %></td>
                            </tr>
                            <tr>
                                <th>XII<sup>th</sup> Details</th>
                                <td><%= employee_education.getInt("XIIMarks") + " (" + employee_education.getInt("XIIYear") + ")" %></td>
                            </tr>
                            <tr>
                                <th>Graduation Details</th>
                                <td><%= employee_education.getInt("GradMarks") + " (" + employee_education.getInt("GradYear") + ") - " + employee_education.getString("GradUniv") %></td>
                            </tr>
                            <%
                                }

                                if(department_exists)
                                {
                            %>
                            <tr>
                                <th>Department</th>
                                <td><%= get_department(employee_department.getInt("DepartmentID")) %></td>
                            </tr>
                            <tr>
                                <th>Designation</th>
                                <td><%= employee_department.getString("Designation") %></td>
                            </tr>
                            <%
                                }

                                if(monthly_salary != 0)
                                {
                            %>
                            <tr>
                                <th>Monthly Salary</th>
                                <td><%= monthly_salary %></td>
                            </tr>
                            <%
                                }
                            %>
                            <tr>
                                <th>Employee Leaves</th>
                                <td>
                                    <a href="employee_leave.jsp?employee-id=<%= employee_id %>">Details</a>
                                </td>
                            </tr>
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
