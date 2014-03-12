/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package administration;

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
public class new_subject2 extends HttpServlet {
   
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

            String subject_name = request.getParameter("subject-name");
            String subject_code = request.getParameter("subject-code");
            String exam_code = request.getParameter("exam-code");
            String maximum_marks = request.getParameter("maximum-marks");

            query = "select * from Administration.Subject where SubjectCode=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, subject_code);
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>Subject Code already exists, Enter a valid Subject Code.</li>";
            }

            query = "select * from Administration.Subject where ExamCode=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, exam_code);
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>Exam Code already exists, Enter a valid Exam Code.</li>";
            }

            if(message.length() == 0)
            {
                query = "insert into Administration.Subject (SubjectName, SubjectCode, ExamCode, MaximumMarks) values (?,?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, subject_name);
                execute_query.setString(2, subject_code);
                execute_query.setString(3, exam_code);
                execute_query.setInt(4, Integer.parseInt(maximum_marks));
                execute_query.executeUpdate();

                request.setAttribute("success", "Subject: " + subject_name + " (" + subject_code + ") has been created succesfully.");
                RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("subject-name", subject_name);
                request.setAttribute("subject-code", subject_code);
                request.setAttribute("exam-code", exam_code);
                request.setAttribute("maximum-marks", maximum_marks);
                RequestDispatcher new_subject = request.getRequestDispatcher("new_subject.jsp");
                new_subject.forward(request, response);
            }
        }
        catch(SQLException e)
        {
            out.write("<h1>Error Code: " + e.getErrorCode() + "</h1>");
            out.write("<h3>Exception: " + e.getClass().getName() + "</h3>");
            out.write("<h4>" + e.getLocalizedMessage() + "</h4>");
            out.write("<h4>SQL State: " + e.getSQLState() + "</h4>");
            out.write("<h2><a href=\"new_subject.jsp\">Back</a></h2>");
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
