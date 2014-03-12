<%-- 
    Document   : time_table
    Created on : Jul 6, 2011, 12:30:13 AM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="initial.server, java.sql.*, java.util.ArrayList" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%!
        ResultSet get_class_details(String time_table_id)
	{
            ResultSet result_set = null;

            try
            {
                String query;
                PreparedStatement execute_query;

                query = "select * from TimeTable.ClassDetail where TimeTableID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, Integer.parseInt(time_table_id));
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
	}

        ResultSet get_monday(String time_table_id)
        {
            ResultSet result_set = null;

            try
            {
                String query;
                PreparedStatement execute_query;

                query = "select * from TimeTable.Monday where TimeTableID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, Integer.parseInt(time_table_id));
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
        }

        ResultSet get_tuesday(String time_table_id)
        {
            ResultSet result_set = null;

            try
            {
                String query;
                PreparedStatement execute_query;

                query = "select * from TimeTable.Tuesday where TimeTableID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, Integer.parseInt(time_table_id));
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
        }

        ResultSet get_wednesday(String time_table_id)
        {
            ResultSet result_set = null;

            try
            {
                String query;
                PreparedStatement execute_query;

                query = "select * from TimeTable.Wednesday where TimeTableID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, Integer.parseInt(time_table_id));
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
        }

        ResultSet get_thursday(String time_table_id)
        {
            ResultSet result_set = null;

            try
            {
                String query;
                PreparedStatement execute_query;

                query = "select * from TimeTable.Thursday where TimeTableID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, Integer.parseInt(time_table_id));
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
        }

        ResultSet get_friday(String time_table_id)
        {
            ResultSet result_set = null;

            try
            {
                String query;
                PreparedStatement execute_query;

                query = "select * from TimeTable.Friday where TimeTableID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, Integer.parseInt(time_table_id));
                result_set = execute_query.executeQuery();
            }
            catch(SQLException e)
            {
            }

            return result_set;
        }

        String[] get_lecture_timings()
	{
            ArrayList<String> temp_lecture_timings = new ArrayList<String>();
            try
            {
                String query;
                Statement execute_query;
                ResultSet result_set;

                query = "select * from TimeTable.Timings";
                execute_query = server.server_connection.createStatement();
                result_set = execute_query.executeQuery(query);

                while(result_set.next())
                    temp_lecture_timings.add(result_set.getTime("StartTime").getHours() + ":" + result_set.getTime("StartTime").getMinutes() + " - " + result_set.getTime("EndTime").getHours() + ":" + result_set.getTime("EndTime").getMinutes());
            }
            catch(SQLException e)
            {
            }

            int i = 0;
            String[] lecture_timings = new String[temp_lecture_timings.size()];
            for(String temp : temp_lecture_timings)
                lecture_timings[i++] = temp;

            return lecture_timings;
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
                degree = result_set.getString("Degree");
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

        String get_faculty(String employee_id)
        {
            String faculty = "";

            try
            {
                String query;
                PreparedStatement execute_query;
                ResultSet result_set;

                query = "select * from Employee.PersonalDetail where EmployeeID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, employee_id);
                result_set = execute_query.executeQuery();
                result_set.next();
                faculty = result_set.getString("Name");
            }
            catch(SQLException e)
            {
            }

            return faculty;
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

    String time_table_id = (String)request.getParameter("time-table-id");
    if(time_table_id == null || time_table_id.compareTo("") == 0)
        response.sendRedirect("all_class.jsp");

    ResultSet class_details = get_class_details(time_table_id);
    if(class_details.next() == false)
    {
        request.setAttribute("warning", "Time Table for the Class doesn't exists in the database of college.");
        RequestDispatcher all_class = request.getRequestDispatcher("all_class.jsp");
        all_class.forward(request, response);
    }
    
    ResultSet monday = get_monday(time_table_id);
    ResultSet tuesday = get_tuesday(time_table_id);
    ResultSet wednesday = get_wednesday(time_table_id);
    ResultSet thursday = get_thursday(time_table_id);
    ResultSet friday = get_friday(time_table_id);
    String[] timings = get_lecture_timings();
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
                    <h1 class="pagetitle">Time Table</h1>
                    <div class="div-display">
                        <table>
                            <tr>
                                <th width="25%">Degree</th>
                                <td width="75%"><%= get_degree(class_details.getInt("DegreeID")) %></td>
                            </tr>
                            <tr>
                                <th>Department</th>
                                <td><%= get_department(class_details.getInt("DepartmentID")) %></td>
                            </tr>
                            <tr>
                                <th>Batch</th>
                                <td><%= get_batch(class_details.getInt("BatchID")) %></td>
                            </tr>
                            <tr>
                                <th>Semester</th>
                                <td><%= class_details.getInt("Semester") %></td>
                            </tr>
                        </table>
                    </div>
                    <div class="div-display">
                        <table width="1500px">
                            <tr>
                                <td width="10%"></td>
                                <%
                                    for(int i = 0; i < timings.length; i++)
                                    {
                                %>
                                        <th width="10%"><%= timings[i] %></th>
                                <%
                                    }
                                %>
                            </tr>
                            <tr>
                                <th>Monday</th>
                                <%
                                    for(int i = 0; i < timings.length; i++)
                                    {
                                        monday.next();
                                %>
                                        <td><center><%= get_subject(monday.getString("SubjectCode")) + "<br/>(" + get_faculty(monday.getString("EmployeeID")) + ")" %></center></td>
                                <%
                                    }
                                %>
                            </tr>
                            <tr>
                                <th>Tuesday</th>
                                <%
                                    for(int i = 0; i < timings.length; i++)
                                    {
                                        tuesday.next();
                                %>
                                        <td><center><%= get_subject(tuesday.getString("SubjectCode")) + "<br/>(" + get_faculty(tuesday.getString("EmployeeID")) + ")" %></center></td>
                                <%
                                    }
                                %>
                            </tr>
                            <tr>
                                <th>Wednesday</th>
                                <%
                                    for(int i = 0; i < timings.length; i++)
                                    {
                                        wednesday.next();
                                %>
                                        <td><center><%= get_subject(wednesday.getString("SubjectCode")) + "<br/>(" + get_faculty(wednesday.getString("EmployeeID")) + ")" %></center></td>
                                <%
                                    }
                                %>
                            </tr>
                            <tr>
                                <th>Thursday</th>
                                <%
                                    for(int i = 0; i < timings.length; i++)
                                    {
                                        thursday.next();
                                %>
                                        <td><center><%= get_subject(thursday.getString("SubjectCode")) + "<br/>(" + get_faculty(thursday.getString("EmployeeID")) + ")" %></center></td>
                                <%
                                    }
                                %>
                            </tr>
                            <tr>
                                <th>Friday</th>
                                <%
                                    for(int i = 0; i < timings.length; i++)
                                    {
                                        friday.next();
                                %>
                                        <td><center><%= get_subject(friday.getString("SubjectCode")) + "<br/>(" + get_faculty(friday.getString("EmployeeID")) + ")" %></center></td>
                                <%
                                    }
                                %>
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
