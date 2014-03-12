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
public class new_exam_detail2 extends HttpServlet {
   
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
            int exam_id = 0, degree_id = 0, branch_id = 0, batch_id = 0;

            String registration_no = request.getParameter("registration-no");
            String exam_roll_no = request.getParameter("exam-roll-no");
            String exam_type = request.getParameter("exam-type");
            String semester = request.getParameter("semester");

            query = "select * from Student.ExamDetail where ExamRollNo=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, exam_roll_no);
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>Exam Roll No. already exists, Enter valid Exam Roll No.</li>";
            }

            query = "select * from Student.RegistrationDetail where RegistrationNo=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, registration_no);
            result_set = execute_query.executeQuery();

            if(! result_set.next())
            {
                message += "<li>Student doesn't exist, Enter valid Registration No.</li>";
            }
            else
            {
                query = "select * from Student.AdmissionDetail SAD join Student.RegistrationDetail SRD on SAD.RollNo = SRD.RollNo where SRD.RegistrationNo=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, registration_no);
                result_set = execute_query.executeQuery();
                result_set.next();
                degree_id = result_set.getInt("DegreeID");
                branch_id = result_set.getInt("DepartmentID");
                batch_id = result_set.getInt("BatchID");
            }

            query = "select * from ExamCell.Exam where BatchID=? and DegreeID=? and DepartmentID=? and Semester=? and Type=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setInt(1, batch_id);
            execute_query.setInt(2, degree_id);
            execute_query.setInt(3, branch_id);
            execute_query.setInt(4, Integer.parseInt(semester));
            execute_query.setString(5, exam_type);
            result_set = execute_query.executeQuery();

            if(! result_set.next())
            {
                message += "<li>Exam doesn't exist for the Student, Enter valid Exam Details.</li>";
            }
            else
            {
                exam_id = result_set.getInt("ExamID");
            }

            query = "select * from Student.ExamDetail where ExamID=? and RegistrationNo=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setInt(1, exam_id);
            execute_query.setString(2, registration_no);
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>Student is already registered for the Exam, Enter valid Exam Details.</li>";
            }

            if(message.length() == 0)
            {
                query = "insert into Student.ExamDetail (RegistrationNo, ExamRollNo, ExamID) values (?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, registration_no);
                execute_query.setString(2, exam_roll_no);
                execute_query.setInt(3, exam_id);
                execute_query.executeUpdate();

                request.setAttribute("success", "Student: " + registration_no + " has been succesfully registered for examination with Exam Roll No. - " + exam_roll_no);
                RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("registration-no", registration_no);
                request.setAttribute("exam-roll-no", exam_roll_no);
                request.setAttribute("exam-type", exam_type);
                request.setAttribute("semester", semester);
                RequestDispatcher new_exam_detail = request.getRequestDispatcher("new_exam_detail.jsp");
                new_exam_detail.forward(request, response);
            }
        }
        catch(SQLException e)
        {
            out.write("<h1>Error Code: " + e.getErrorCode() + "</h1>");
            out.write("<h3>Exception: " + e.getClass().getName() + "</h3>");
            out.write("<h4>" + e.getLocalizedMessage() + "</h4>");
            out.write("<h4>SQL State: " + e.getSQLState() + "</h4>");
            out.write("<h2><a href=\"new_exam_detail.jsp\">Back</a></h2>");
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
