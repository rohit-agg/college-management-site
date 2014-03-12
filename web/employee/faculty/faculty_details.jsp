<%-- 
    Document   : faculty_details
    Created on : Jul 2, 2011, 8:10:59 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="initial.server, java.sql.*, java.util.ArrayList" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%!
        ResultSet get_faculty_details(String employee_id)
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

        ResultSet get_faculty_education(String employee_id)
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

        ResultSet get_faculty_additional_education(String employee_id)
	{
            ResultSet result_set = null;
            try
            {
                String query;
                PreparedStatement execute_query;

                query = "select * from Faculty.AdditionalQualification where EmployeeID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, employee_id);
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
	}

        ResultSet get_subject_handled(String employee_id)
	{
            ResultSet result_set = null;
            try
            {
                String query;
                PreparedStatement execute_query;

                query = "select * from Faculty.SubjectHandled where EmployeeID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, employee_id);
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
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

        String get_degree(int degree_id)
        {
            String degree = "";

            try
            {
                String query;
                PreparedStatement execute_query;
                ResultSet result_set;

                query = "select * from Administration.Degree where DegreeID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, degree_id);
                result_set = execute_query.executeQuery();
                result_set.next();
                degree = result_set.getString("SDegree");
            }
            catch(SQLException e)
            {
            }

            return degree;
        }

        String get_subject(String subject_code)
        {
            String subject = "";

            try
            {
                String query;
                PreparedStatement execute_query;
                ResultSet result_set;

                query = "select * from Administration.Subject where SubjectCode=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, subject_code);
                result_set = execute_query.executeQuery();
                result_set.next();
                subject = result_set.getString("SubjectName");
            }
            catch(SQLException e)
            {
            }

            return subject;
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

    String employee_id = (String)request.getParameter("employee-id");
    if(employee_id == null || employee_id.compareTo("") == 0)
        response.sendRedirect("all_faculty.jsp");

    ResultSet faculty_details = get_faculty_details(employee_id);
    if(faculty_details.next() == false)
    {
        request.setAttribute("warning", "Faculty: " + employee_id + " doesn't exists in the database of college.");
        RequestDispatcher all_faculty = request.getRequestDispatcher("all_faculty.jsp");
        all_faculty.forward(request, response);
    }
    
    ResultSet faculty_department = get_department_details(employee_id);
    boolean department_exists = faculty_department.next();
    ResultSet faculty_education = get_faculty_education(employee_id);
    boolean education_exists = faculty_education.next();
    ResultSet faculty_additional_education = get_faculty_additional_education(employee_id);
    boolean additional_education_exists = faculty_additional_education.next();
    ResultSet faculty_subject = get_subject_handled(employee_id);
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
                    <h1 class="pagetitle">Faculty - <%= employee_id %></h1>
                    <div class="div-display">
                        <table>
                            <tr>
                                <th width="25%">Employee ID</th>
                                <td width="75%"><%= faculty_details.getString("EmployeeID") %></td>
                            </tr>
                            <tr>
                                <th>Faculty Name</th>
                                <td><%= faculty_details.getString("Name") %></td>
                            </tr>
                            <tr>
                                <th>Father's Name</th>
                                <td><%= faculty_details.getString("FatherName") %></td>
                            </tr>
                            <tr>
                                <th>Mother's Name</th>
                                <td><%= faculty_details.getString("MotherName") %></td>
                            </tr>
                            <tr>
                                <th>Address</th>
                                <td><%= faculty_details.getString("Address") %></td>
                            </tr>
                            <tr>
                                <th>Date of Birth</th>
                                <td><%= faculty_details.getDate("DateOfBirth").toString() %></td>
                            </tr>
                            <tr>
                                <th>Gender</th>
                                <td><%= faculty_details.getString("Gender") %></td>
                            </tr>
                            <tr>
                                <th>Contact Number</th>
                                <td><%= faculty_details.getString("ContactNo") %></td>
                            </tr>
                            <tr>
                                <th>E-Mail ID</th>
                                <td><%= faculty_details.getString("EMailID") %></td>
                            </tr>
                            <%
                                if(education_exists)
                                {
                            %>
                            <tr>
                                <th>X<sup>th</sup> Details</th>
                                <td><%= faculty_education.getInt("XMarks") + " (" + faculty_education.getInt("XYear") + ")" %></td>
                            </tr>
                            <tr>
                                <th>XII<sup>th</sup> Details</th>
                                <td><%= faculty_education.getInt("XIIMarks") + " (" + faculty_education.getInt("XIIYear") + ")" %></td>
                            </tr>
                            <tr>
                                <th>Graduation Details</th>
                                <td><%= faculty_education.getInt("GradMarks") + " (" + faculty_education.getInt("GradYear") + ") - " + faculty_education.getString("GradUniv") %></td>
                            </tr>
                            <%
                                }

                                if(additional_education_exists)
                                {
                            %>
                            <tr>
                                <th>Post-Graduation Details</th>
                                <td><%= faculty_additional_education.getInt("PostGradMarks") + " (" + faculty_additional_education.getInt("PostGradYear") + ") - " + faculty_additional_education.getString("PostGradUniv") %></td>
                            </tr>
                            <tr>
                                <th>PhD Details</th>
                                <td><%= faculty_additional_education.getInt("PHdYear") + " - " + faculty_additional_education.getString("PHdUniv") %></td>
                            </tr>
                            <%
                                }

                                if(department_exists)
                                {
                            %>
                            <tr>
                                <th>Department</th>
                                <td><%= get_department(faculty_department.getInt("DepartmentID")) %></td>
                            </tr>
                            <tr>
                                <th>Designation</th>
                                <td><%= faculty_department.getString("Designation") %></td>
                            </tr>
                            <%
                                }
                            %>
                        </table>
                    </div>
                    <div class="div-display">
                        Subjects Handled
                        <table width="550px">
                            <%
                                if(faculty_subject != null)
                                {
                                    while(faculty_subject.next())
                                    {
                                        if(faculty_subject.getRow() == 1)
                                        {
                            %>
                            <tr>
                                <th width="36%">Subject</th>
                                <th width="13%">Degree</th>
                                <th width="36%">Department</th>
                                <th width="15%">Semester</th>
                            </tr>
                            <%
                                        }
                            %>
                            <tr>
                                <td><%= get_subject(faculty_subject.getString("SubjectCode")) %></td>
                                <td><%= get_degree(faculty_subject.getInt("DegreeID")) %></td>
                                <td><%= get_department(faculty_subject.getInt("DepartmentID")) %></td>
                                <td><%= faculty_subject.getInt("Semester") %></td>
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
