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
import java.sql.*;

import initial.server;

/**
 *
 * @author Administrator
 */
public class new_registration2 extends HttpServlet {
   
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
        try
        {
            String query, message = "";
            PreparedStatement execute_query;
            ResultSet result_set;
            int degree_id = 0;

            String registration_no = request.getParameter("registration-no");
            String roll_no = request.getParameter("roll-no");
            String semester = request.getParameter("semester");

            query = "select * from Student.PersonalDetail where RollNo=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, roll_no);
            result_set = execute_query.executeQuery();

            if(! result_set.next())
            {
                message += "<li>Student doesn't exist, Enter valid Roll Number.</li>";
            }

            query = "select * from Student.RegistrationDetail where RegistrationNo=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, registration_no);
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>Registration Number already exist, Enter valid Registration Number.</li>";
            }

            query = "select * from Student.RegistrationDetail where RollNo=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, roll_no);
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>Student is already registered with another Registration No., Enter valid Student details.</li>";
            }

            query = "select * from Student.AdmissionDetail where RollNo=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, roll_no);
            result_set = execute_query.executeQuery();
            if(result_set.next())
                degree_id = result_set.getInt("DegreeID");

            query = "select * from Administration.Degree where DegreeID=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setInt(1, degree_id);
            result_set = execute_query.executeQuery();
            if(result_set.next())
            {
                if(result_set.getInt("NoOfSemester") < Integer.parseInt(semester))
                {
                    message += "<li>Semester doesn't exist for this degree, Enter valid Semester.</li>";
                }
            }

            if(message.length() == 0)
            {
                query = "insert into Student.RegistrationDetail (RegistrationNo, RollNo, Semester) values (?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, registration_no);
                execute_query.setString(2, roll_no);
                execute_query.setInt(3, Integer.parseInt(semester));
                execute_query.executeUpdate();

                request.setAttribute("success", "Student: " + roll_no + " (" + registration_no + ") has been registered succesfully.");
                RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("registration-no", registration_no);
                request.setAttribute("roll-no", roll_no);
                request.setAttribute("semester", semester);
                RequestDispatcher new_registration = request.getRequestDispatcher("new_registration.jsp");
                new_registration.forward(request, response);
            }
        }
        catch(SQLException e)
        {
            out.write("<h1>Error Code: " + e.getErrorCode() + "</h1>");
            out.write("<h3>Exception: " + e.getClass().getName() + "</h3>");
            out.write("<h4>" + e.getLocalizedMessage() + "</h4>");
            out.write("<h4>SQL State: " + e.getSQLState() + "</h4>");
            out.write("<h2><a href=\"new_registration.jsp\">Back</a></h2>");
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
