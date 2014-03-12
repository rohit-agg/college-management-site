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
public class new_allowed_subject2 extends HttpServlet {
   
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
            int degree_id = 0, department_id = 0;
            
            String subject_code = request.getParameter("subject-code");
            String category = request.getParameter("category");
            String degree = request.getParameter("degree");
            String branch = request.getParameter("branch");
            Integer semester = Integer.parseInt(request.getParameter("semester"));

            query = "select * from Administration.Department where Name=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, branch);
            result_set = execute_query.executeQuery();
            result_set.next();
            department_id = result_set.getInt("DepartmentID");

            query = "select * from Administration.Degree where SDegree=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, degree);
            result_set = execute_query.executeQuery();
            result_set.next();
            degree_id = result_set.getInt("DegreeID");

            query = "select * from Administration.Subject where SubjectCode=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, subject_code);
            result_set = execute_query.executeQuery();

            if(! result_set.next())
            {
                message += "<li>Subject doesn't exists, Enter valid Subject Code.</li>";
            }

            query = "select * from Administration.AllowedSubject where SubjectCode=? and DegreeID=? and DepartmentID=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, subject_code);
            execute_query.setInt(2, degree_id);
            execute_query.setInt(3, department_id);
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>The subject is already allowed in one of the semesters of this Degree and Department.</li>";
            }

            query = "select * from Administration.Degree where DegreeID=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setInt(1, degree_id);
            result_set = execute_query.executeQuery();
            result_set.next();

            if(result_set.getInt("NoOfSemester") < semester)
            {
                message += "<li>Invalid Number of Semesters, The maximum Number of Semesters for the degree are " + result_set.getInt("NoOfSemester") + ".<li/>";
            }

            if(message.length() == 0)
            {
                query = "insert into Administration.AllowedSubject (SubjectCode, Category, DegreeID, DepartmentID, Semester) values (?,?,?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, subject_code);
                execute_query.setString(2, category);
                execute_query.setInt(3, degree_id);
                execute_query.setInt(4, department_id);
                execute_query.setInt(5, semester);
                execute_query.executeUpdate();

                request.setAttribute("success", "Subject: " + subject_code + " has been added to " + degree + " (" + branch + "), Semester - " + semester + " successfully.");
                RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("subject-code", subject_code);
                request.setAttribute("category", category);
                request.setAttribute("degree", degree);
                request.setAttribute("branch", branch);
                request.setAttribute("semester", semester.toString());
                RequestDispatcher new_allowed_subject = request.getRequestDispatcher("new_allowed_subject.jsp");
                new_allowed_subject.forward(request, response);
            }
        }
        catch(SQLException e)
        {
            out.write("<h1>Error Code: " + e.getErrorCode() + "</h1>");
            out.write("<h3>Exception: " + e.getClass().getName() + "</h3>");
            out.write("<h4>" + e.getLocalizedMessage() + "</h4>");
            out.write("<h4>SQL State: " + e.getSQLState() + "</h4>");
            out.write("<h2><a href=\"new_allowed_subject.jsp\">Back</a></h2>");
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
