<%-- 
    Document   : student_details
    Created on : Jul 3, 2011, 11:47:28 AM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="initial.server, java.sql.*, java.util.ArrayList" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%!
        ResultSet get_student_details(String roll_no)
	{
            ResultSet result_set = null;
            try
            {
                String query;
                PreparedStatement execute_query;

                query = "select * from Student.PersonalDetail where RollNo=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, roll_no);
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
	}

        ResultSet get_admission_details(String roll_no)
	{
            ResultSet result_set = null;
            try
            {
                String query;
                PreparedStatement execute_query;

                query = "select * from Student.AdmissionDetail where RollNo=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, roll_no);
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
	}

        ResultSet get_extra_admission_details(String roll_no)
	{
            ResultSet result_set = null;
            try
            {
                String query;
                PreparedStatement execute_query;

                query = "select * from Student.ExtraAdmissionDetail where RollNo=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, roll_no);
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
	}

        ResultSet get_registration_details(String roll_no)
        {
            ResultSet result_set = null;
            try
            {
                String query;
                PreparedStatement execute_query;
                
                query = "select * from Student.RegistrationDetail where RollNo=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, roll_no);
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

        String get_batch(int batch_id)
        {
            String batch = "";

            try
            {
                String query;
                PreparedStatement execute_query;
                ResultSet result_set;

                query = "select * from Administration.Batch where BatchID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, batch_id);
                result_set = execute_query.executeQuery();
                result_set.next();
                batch = result_set.getInt("StartYear") + " - " + result_set.getInt("EndYear");
            }
            catch(SQLException e)
            {
            }

            return batch;
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

    ResultSet student_details = get_student_details(roll_no);
    if(student_details.next() == false)
    {
        request.setAttribute("warning", "Student: " + roll_no + " doesn't exists in the database of college.");
        RequestDispatcher all_student = request.getRequestDispatcher("all_student.jsp");
        all_student.forward(request, response);
    }
    ResultSet student_admission = get_admission_details(roll_no);
    boolean admission_exists = student_admission.next();
    ResultSet extra_admission = get_extra_admission_details(roll_no);
    boolean extra_admission_exists = extra_admission.next();
    ResultSet student_registration = get_registration_details(roll_no);
    boolean registration_exists = student_registration.next();
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
                    <h1 class="pagetitle">Student - <%= roll_no %></h1>
                    <%
                        if(request.getAttribute("warning") != null)
                        {
                    %>
                            <div class="message warning"><%= (String)request.getAttribute("warning") %></div>
                    <%
                        }
                    %>
                    <div class="div-display">
                        <table width="600px">
                            <tr>
                                <th width="20%">Roll Number</th>
                                <td width="52%"><%= student_details.getString("RollNo") %></td>
                                <td rowspan="10" width="28%">
                                    <img src="<%= student_details.getString("Photo") %>" width="150px" height="150px" />
                                </td>
                            </tr>
                            <tr>
                                <th>Name</th>
                                <td><%= student_details.getString("Name") %></td>
                            </tr>
                            <tr>
                                <th>Father's Name</th>
                                <td><%= student_details.getString("FatherName") %></td>
                            </tr>
                            <tr>
                                <th>Mother's Name</th>
                                <td><%= student_details.getString("MotherName") %></td>
                            </tr>
                            <tr>
                                <th>Address</th>
                                <td><%= student_details.getString("Address") %></td>
                            </tr>
                            <tr>
                                <th>Date of Birth</th>
                                <td><%= student_details.getDate("DateOfBirth").toString() %></td>
                            </tr>
                            <tr>
                                <th>Gender</th>
                                <td><%= student_details.getString("Gender") %></td>
                            </tr>
                            <tr>
                                <th>Category</th>
                                <td><%= student_details.getString("Category") %></td>
                            </tr>
                            <tr>
                                <th>Contact Number</th>
                                <td><%= student_details.getString("ContactNo") %></td>
                            </tr>
                            <tr>
                                <th>E-Mail ID</th>
                                <td><%= student_details.getString("EMailID") %></td>
                            </tr>
                            <%
                                if(admission_exists)
                                {
                            %>
                            <tr>
                                <th>Counseling</th>
                                <td><%= student_admission.getInt("Counselling") %></td>
                            </tr>
                            <tr>
                                <th>Batch</th>
                                <td><%= get_batch(student_admission.getInt("BatchID")) %></td>
                            </tr>
                            <tr>
                                <th>Degree</th>
                                <td><%= get_degree(student_admission.getInt("DegreeID")) %></td>
                            </tr>
                            <tr>
                                <th>Department</th>
                                <td><%= get_department(student_admission.getInt("DepartmentID")) %></td>
                            </tr>
                            <tr>
                                <th>X<sup>th</sup> Details</th>
                                <td><%= student_admission.getInt("XMarks") + " (" + student_admission.getInt("XYear") + ")" %></td>
                            </tr>
                            <tr>
                                <th>XII<sup>th</sup> Details</th>
                                <td><%= student_admission.getInt("XIIMarks") + " (" + student_admission.getInt("XIIYear") + ")" %></td>
                            </tr>
                            <tr>
                                <th>Entrance Details</th>
                                <td>
                                    <%= student_admission.getInt("EERank") + " (Score - " + student_admission.getInt("EEScore") + ", Roll Number - " +
                                        student_admission.getString("EERollNo") + ") - " + student_admission.getString("EntranceExam") %>
                                </td>
                            </tr>
                            <%
                                }

                                if(extra_admission_exists)
                                {
                            %>
                            <tr>
                                <th>Diploma College</th>
                                <td><%= extra_admission.getString("DiplomaCollege") %></td>
                            </tr>
                            <tr>
                                <th>Diploma Branch</th>
                                <td><%= extra_admission.getString("DiplomaBranch") %></td>
                            </tr>
                            <tr>
                                <th>Diploma Details</th>
                                <td><%= extra_admission.getInt("DiplomaMarks") + " (" + extra_admission.getInt("DiplomaYear") + ")" %></td>
                            </tr>
                            <%
                                }

                                if(registration_exists)
                                {
                            %>
                            <tr>
                                <th>Registration Number</th>
                                <td><%= student_registration.getString("RegistrationNo") %></td>
                            </tr>
                            <tr>
                                <th>Semester</th>
                                <td><%= student_registration.getInt("Semester") %></td>
                            </tr>
                            <%
                                }
                            %>
                            <tr>
                                <th>Fees</th>
                                <td><a href="student_fee.jsp?roll-no=<%= roll_no %>">Details</a></td>
                            </tr>
                            <tr>
                                <th>Attendance</th>
                                <td><a href="student_attendance.jsp?roll-no=<%= roll_no %>">Details</a></td>
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
