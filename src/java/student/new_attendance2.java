/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package student;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.RequestDispatcher;
import java.util.ArrayList;
import java.sql.*;

import initial.server;

/**
 *
 * @author Administrator
 */
public class new_attendance2 extends HttpServlet {
   
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

        String[] subjects = null, students = null;

        try
        {
            String query, message = "";
            PreparedStatement execute_query;
            ResultSet result_set;
            
            ArrayList<String> invalid_subjects = new ArrayList<String>();
            ArrayList<String> invalid_students = new ArrayList<String>();            

            subjects = request.getParameterValues("subject");
            students = request.getParameterValues("student");            

            if(students != null)
            {
                for(String temp : students)
                {
                    if(temp != null && temp.compareTo("") != 0)
                    {
                        query = "select * from Student.PersonalDetail where RollNo=?";
                        execute_query = server.server_connection.prepareStatement(query);
                        execute_query.setString(1, temp);
                        result_set = execute_query.executeQuery();
                        if(!result_set.next())
                            invalid_students.add(temp);
                    }
                }
            }

            if(! invalid_students.isEmpty())
            {
                message += "<li>Following students don't exist: <br/>";
                for(String temp : invalid_students)
                    message += temp + ", ";
                message += "<br/>Enter valid Students (Roll Number).</li>";
            }

            if(subjects != null)
            {
                for(String temp : subjects)
                {
                    if(temp != null && temp.compareTo("") != 0)
                    {
                        query = "select * from Administration.Subject where SubjectCode=?";
                        execute_query = server.server_connection.prepareStatement(query);
                        execute_query.setString(1, temp);
                        result_set = execute_query.executeQuery();
                        if(!result_set.next())
                            invalid_subjects.add(temp);
                    }
                }
            }

            if(! invalid_subjects.isEmpty())
            {
                message += "<li>Following subjects don't exist: <br/>";
                for(String temp : invalid_subjects)
                    message += temp + ", ";
                message += "<br/>Enter valid Subjects (Subject Code).</li>";
            }
                        
            if(message.length() == 0)
            {
                server.server_connection.setAutoCommit(false);
                query = "insert into Student.Attendance (RollNo, SubjectCode, Attendance, AttendanceTotal) values (?,?,?,?) ";
                execute_query = server.server_connection.prepareStatement(query);

                if(subjects != null && students != null)
                {
                    for(String temp : students)
                    {
                        if(temp != null && temp.compareTo("") != 0)
                        {
                            for(String temp2 : subjects)
                            {
                                if(temp2 != null && temp2.compareTo("") != 0)
                                {
                                    execute_query.setString(1, temp);
                                    execute_query.setString(2, temp2);
                                    execute_query.setInt(3, 0);
                                    execute_query.setInt(4, 0);
                                    execute_query.addBatch();
                                }
                            }
                        }
                    }
                }

                execute_query.executeBatch();
                server.server_connection.commit();
                server.server_connection.setAutoCommit(true);

                message = "Following Students:<br/>";
                if(students != null)
                {
                    for(String temp : students)
                    {
                        if(temp != null && temp.compareTo("") != 0)
                        {
                            message += temp + ", ";
                        }
                    }
                }

                message += "<br/>have been added for the Attendance of the following Subjects:<br/>";
                if(subjects != null)
                {
                    for(String temp : subjects)
                    {
                        if(temp != null && temp.compareTo("") != 0)
                        {
                            message += temp + ", ";
                        }
                    }
                }
                
                request.setAttribute("success", message);
                RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("subject", subjects);
                request.setAttribute("student", students);
                RequestDispatcher new_attendance = request.getRequestDispatcher("new_attendance.jsp");
                new_attendance.forward(request, response);
            }
        }
        catch(SQLException e)
        {
            try
            {
                server.server_connection.rollback();
                server.server_connection.setAutoCommit(true);
            }
            catch(SQLException ee)
            {
                out.write("<h1>Error Code: " + e.getErrorCode() + "</h1>");
                out.write("<h3>Exception: " + e.getClass().getName() + "</h3>");
                out.write("<h4>" + e.getLocalizedMessage() + "</h4>");
                out.write("<h4>SQL State: " + e.getSQLState() + "</h4>");
                out.write("<h2><a href=\"new_attendance.jsp\">Back</a></h2>");
            }

            request.setAttribute("error", "Correct the following errors:<br/><br/><li>One or more students and/or subjects have been entered multiple times.</li>");
            request.setAttribute("subject", subjects);
            request.setAttribute("student", students);            
            RequestDispatcher new_attendance = request.getRequestDispatcher("new_attendance.jsp");
            new_attendance.forward(request, response);
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
