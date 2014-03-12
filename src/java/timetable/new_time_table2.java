/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package timetable;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.RequestDispatcher;
import java.sql.*;
import java.util.ArrayList;

import initial.server;

/**
 *
 * @author Administrator
 */
public class new_time_table2 extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String query, message = "";
        PreparedStatement execute_query;

        String batch = "", degree = "", branch = "", semester = "", no_of_lectures = "";
        String[][] employee_id = null, subject_code = null;
        int time_table_id = 0;

        try
        {
            ResultSet result_set;
            int degree_id = 0, branch_id = 0, batch_id = 0;
            int i, j, start_year, end_year;

            batch = request.getParameter("batch");
            degree = request.getParameter("degree");
            branch = request.getParameter("branch");
            semester = request.getParameter("semester");
            no_of_lectures = request.getParameter("no-of-lectures");
            employee_id = new String[5][Integer.parseInt(no_of_lectures)];
            subject_code = new String[5][Integer.parseInt(no_of_lectures)];

            start_year = Integer.parseInt(batch.split("-")[0].trim());
            end_year = Integer.parseInt(batch.split("-")[1].trim());

            for(i=0; i<5; i++)
            {
                employee_id[i] = request.getParameterValues("employee-id-" + i);
                subject_code[i] = request.getParameterValues("subject-code-" + i);
            }

            ArrayList<String> invalid_employee = new ArrayList<String>();
            ArrayList<String> invalid_subject = new ArrayList<String>();
            ArrayList<String> invalid_employee_subject = new ArrayList<String>();

            for(String[] temp : employee_id)
            {
                for(String temp2 : temp)
                {
                    if(temp != null && temp2.compareTo("") != 0)
                    {
                        query = "select * from Employee.PersonalDetail where EmployeeID=?";
                        execute_query = server.server_connection.prepareStatement(query);
                        execute_query.setString(1, temp2);
                        result_set = execute_query.executeQuery();
                        if(!result_set.next())
                            invalid_employee.add(temp2);
                    }
                }
            }

            if(!invalid_employee.isEmpty())
            {
                message += "<li>Following Employees don't exist: <br/>";
                for(String temp : invalid_employee)
                    message += temp + ", ";
                message += "<br/>Enter valid Employee ID's.</li>";
            }

            for(String[] temp : subject_code)
            {
                for(String temp2 : temp)
                {
                    if(temp != null && temp2.compareTo("") != 0)
                    {
                        query = "select * from Administration.Subject where SubjectCode=?";
                        execute_query = server.server_connection.prepareStatement(query);
                        execute_query.setString(1, temp2);
                        result_set = execute_query.executeQuery();
                        if(!result_set.next())
                            invalid_subject.add(temp2);
                    }
                }
            }

            if(!invalid_subject.isEmpty())
            {
                message += "<li>Following Subjects don't exist: <br/>";
                for(String temp : invalid_subject)
                    message += temp + ", ";
                message += "<br/>Enter valid Subject Codes.</li>";
            }

            for(i=0; i<Integer.parseInt(no_of_lectures); i++)
            {
                for(j=0; j<5; j++)
                {
                    if(subject_code[j][i] != null && subject_code[j][i].compareTo("") != 0 && employee_id[j][i] != null && employee_id[j][i].compareTo("") != 0)
                    {
                        query = "select * from Faculty.SubjectHandled where EmployeeID=? and SubjectCode=?";
                        execute_query = server.server_connection.prepareStatement(query);
                        execute_query.setString(1, employee_id[j][i]);
                        execute_query.setString(2, subject_code[j][i]);
                        result_set = execute_query.executeQuery();
                        if(!result_set.next())
                            invalid_employee_subject.add(employee_id[j][i] + " (" + subject_code[j][i] + ")");
                    }
                }
            }

            if(!invalid_employee_subject.isEmpty())
            {
                message += "<li>Following Subjects are not taught by the respective Faculty: <br/>";
                for(String temp : invalid_employee_subject)
                    message += temp + ", ";
                message += "<br/>Enter valid Subject Codes and Employee ID's.</li>";
            }

            query = "select * from Administration.Degree where SDegree=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, degree);
            result_set = execute_query.executeQuery();
            result_set.next();
            degree_id = result_set.getInt("DegreeID");

            query = "select * from Administration.Department where Name=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, branch);
            result_set = execute_query.executeQuery();
            result_set.next();
            branch_id = result_set.getInt("DepartmentID");

            query = "select * from Administration.Batch where StartYear=? and EndYear=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setInt(1, start_year);
            execute_query.setInt(2, end_year);
            result_set = execute_query.executeQuery();
            result_set.next();
            batch_id = result_set.getInt("BatchID");

            query = "select * from TimeTable.ClassDetail where BatchID=? and DegreeID=? and DepartmentID=? and Semester=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setInt(1, batch_id);
            execute_query.setInt(2, degree_id);
            execute_query.setInt(3, branch_id);
            execute_query.setInt(4, Integer.parseInt(semester));
            result_set = execute_query.executeQuery();
            result_set.next();
            time_table_id = result_set.getInt("TimeTableID");

            query = "select * from TimeTable.Monday where TimeTableID=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setInt(1, time_table_id);
            result_set = execute_query.executeQuery();
            result_set.next();

            if(result_set.next())
            {
                message += "<li>Time Table for the given Class already exists, Enter valid Class details.</li>";
            }

            if(message.length() == 0)
            {
                server.server_connection.setAutoCommit(false);

                query = "insert into TimeTable.Monday (TimeTableID, Lecture, SubjectCode, EmployeeID) values (?,?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                for(i=0; i<Integer.parseInt(no_of_lectures); i++)
                {
                    execute_query.setInt(1, time_table_id);
                    execute_query.setInt(2, i+1);
                    if(subject_code[0][i] != null && subject_code[0][i].compareTo("") != 0)
                        execute_query.setString(3, subject_code[0][i]);
                    else
                        execute_query.setNull(3, java.sql.Types.NULL);

                    if(employee_id[0][i] != null && employee_id[0][i].compareTo("") != 0)
                        execute_query.setString(4, employee_id[0][i]);
                    else
                        execute_query.setNull(4, java.sql.Types.NULL);
                    execute_query.addBatch();
                }

                execute_query.executeBatch();
                server.server_connection.commit();

                query = "insert into TimeTable.Tuesday (TimeTableID, Lecture, SubjectCode, EmployeeID) values (?,?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                for(i=0; i<Integer.parseInt(no_of_lectures); i++)
                {
                    execute_query.setInt(1, time_table_id);
                    execute_query.setInt(2, i+1);
                    if(subject_code[1][i] != null && subject_code[1][i].compareTo("") != 0)
                        execute_query.setString(3, subject_code[1][i]);
                    else
                        execute_query.setNull(3, java.sql.Types.NULL);

                    if(employee_id[1][i] != null && employee_id[1][i].compareTo("") != 0)
                        execute_query.setString(4, employee_id[1][i]);
                    else
                        execute_query.setNull(4, java.sql.Types.NULL);
                    execute_query.addBatch();
                }

                execute_query.executeBatch();
                server.server_connection.commit();

                query = "insert into TimeTable.Wednesday (TimeTableID, Lecture, SubjectCode, EmployeeID) values (?,?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                for(i=0; i<Integer.parseInt(no_of_lectures); i++)
                {
                    execute_query.setInt(1, time_table_id);
                    execute_query.setInt(2, i+1);
                    if(subject_code[2][i] != null && subject_code[2][i].compareTo("") != 0)
                        execute_query.setString(3, subject_code[2][i]);
                    else
                        execute_query.setNull(3, java.sql.Types.NULL);

                    if(employee_id[2][i] != null && employee_id[2][i].compareTo("") != 0)
                        execute_query.setString(4, employee_id[2][i]);
                    else
                        execute_query.setNull(4, java.sql.Types.NULL);
                    execute_query.addBatch();
                }

                execute_query.executeBatch();
                server.server_connection.commit();

                query = "insert into TimeTable.Thursday (TimeTableID, Lecture, SubjectCode, EmployeeID) values (?,?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                for(i=0; i<Integer.parseInt(no_of_lectures); i++)
                {
                    execute_query.setInt(1, time_table_id);
                    execute_query.setInt(2, i+1);
                    if(subject_code[3][i] != null && subject_code[3][i].compareTo("") != 0)
                        execute_query.setString(3, subject_code[3][i]);
                    else
                        execute_query.setNull(3, java.sql.Types.NULL);

                    if(employee_id[3][i] != null && employee_id[3][i].compareTo("") != 0)
                        execute_query.setString(4, employee_id[3][i]);
                    else
                        execute_query.setNull(4, java.sql.Types.NULL);
                    execute_query.addBatch();
                }

                execute_query.executeBatch();
                server.server_connection.commit();

                query = "insert into TimeTable.Friday (TimeTableID, Lecture, SubjectCode, EmployeeID) values (?,?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                for(i=0; i<Integer.parseInt(no_of_lectures); i++)
                {
                    execute_query.setInt(1, time_table_id);
                    execute_query.setInt(2, i+1);
                    if(subject_code[4][i] != null && subject_code[4][i].compareTo("") != 0)
                        execute_query.setString(3, subject_code[4][i]);
                    else
                        execute_query.setNull(3, java.sql.Types.NULL);

                    if(employee_id[4][i] != null && employee_id[4][i].compareTo("") != 0)
                        execute_query.setString(4, employee_id[4][i]);
                    else
                        execute_query.setNull(4, java.sql.Types.NULL);
                    execute_query.addBatch();
                }

                execute_query.executeBatch();
                server.server_connection.commit();

                server.server_connection.setAutoCommit(true);

                request.setAttribute("success", "Class: " + degree + " (" + branch + ", Semester - " + semester + ") has been successfully alloted a Time Table.");
                RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("batch", batch);
                request.setAttribute("degree", degree);
                request.setAttribute("branch", branch);
                request.setAttribute("semester", semester);
                request.setAttribute("no-of-lectures", no_of_lectures);
                request.setAttribute("employee-id", employee_id);
                request.setAttribute("subject-code", subject_code);
                RequestDispatcher new_time_table = request.getRequestDispatcher("new_time_table.jsp");
                new_time_table.forward(request, response);
            }
        }
        catch(SQLException e)
        {
            try
            {
                server.server_connection.rollback();
                server.server_connection.setAutoCommit(true);

                query = "delete from TimeTable.Monday where TimeTableID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, time_table_id);
                execute_query.executeUpdate();

                query = "delete from TimeTable.Tuesday where TimeTableID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, time_table_id);
                execute_query.executeUpdate();

                query = "delete from TimeTable.Wednesday where TimeTableID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, time_table_id);
                execute_query.executeUpdate();

                query = "delete from TimeTable.Thursday where TimeTableID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, time_table_id);
                execute_query.executeUpdate();

                query = "delete from TimeTable.Friday where TimeTableID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, time_table_id);
                execute_query.executeUpdate();
            }
            catch(SQLException ee)
            {
                out.write("<h1>Error Code: " + e.getErrorCode() + "</h1>");
                out.write("<h3>Exception: " + e.getClass().getName() + "</h3>");
                out.write("<h4>" + e.getLocalizedMessage() + "</h4>");
                out.write("<h4>SQL State: " + e.getSQLState() + "</h4>");
                out.write("<h2><a href=\"new_time_table.jsp\">Back</a></h2>");
            }

            request.setAttribute("error", "Correct the following errors:<br/><br/><li>One or more Faculty are teaching other Classes during the same respective Lecture Timings.</li>");
            request.setAttribute("batch", batch);
            request.setAttribute("degree", degree);
            request.setAttribute("branch", branch);
            request.setAttribute("semester", semester);
            request.setAttribute("no-of-lectures", no_of_lectures);
            request.setAttribute("employee-id", employee_id);
            request.setAttribute("subject-code", subject_code);
            RequestDispatcher new_time_table = request.getRequestDispatcher("new_time_table.jsp");
            new_time_table.forward(request, response);
        }
        finally
        {
            out.close();
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
