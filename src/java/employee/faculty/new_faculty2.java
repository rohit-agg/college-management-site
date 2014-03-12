/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package employee.faculty;

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
public class new_faculty2 extends HttpServlet {
   
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

            String employee_id = request.getParameter("employee-id");
            String education_details = request.getParameter("whether-education");
            String x_year = request.getParameter("x-year");
            String x_marks = request.getParameter("x-marks");
            String xii_year = request.getParameter("xii-year");
            String xii_marks = request.getParameter("xii-marks");
            String grad_university = request.getParameter("grad-university");
            String grad_year = request.getParameter("grad-year");
            String grad_marks = request.getParameter("grad-marks");
            String post_grad_university = request.getParameter("post-grad-university");
            String post_grad_year = request.getParameter("post-grad-year");
            String post_grad_marks = request.getParameter("post-grad-marks");
            String phd_university = request.getParameter("phd-university");
            String phd_year = request.getParameter("phd-year");
            
            query = "select * from Faculty.AdditionalQualification where EmployeeID=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, employee_id);
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>Faculty Details for Employee ID already exists, Enter valid Employee ID.</li>";
            }

            if(message.length() == 0)
            {
                if(education_details.compareTo("false") == 0)
                {
                    query = "insert into Employee.EducationalQualification (EmployeeID, XMarks, XYear, XIIMarks, XIIYear, GradMarks, GradYear, GradUniv) values (?,?,?,?,?,?,?,?)";
                    execute_query = server.server_connection.prepareStatement(query);
                    execute_query.setString(1, employee_id);
                    execute_query.setInt(2, Integer.parseInt(x_marks));
                    execute_query.setInt(3, Integer.parseInt(x_year));
                    execute_query.setInt(4, Integer.parseInt(xii_marks));
                    execute_query.setInt(5, Integer.parseInt(xii_year));
                    execute_query.setInt(6, Integer.parseInt(grad_marks));
                    execute_query.setInt(7, Integer.parseInt(grad_year));
                    execute_query.setString(8, grad_university);
                    execute_query.executeUpdate();
                }

                query = "insert into Faculty.AdditionalQualification (EmployeeID, PostGradMarks, PostGradYear, PostGradUniv, PHdYear, PHdUniv) values (?,?,?,?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, employee_id);
                execute_query.setInt(2, Integer.parseInt(post_grad_marks));
                execute_query.setInt(3, Integer.parseInt(post_grad_year));
                execute_query.setString(4, post_grad_university);
                if(phd_university != null && phd_university.compareTo("") != 0)
                {
                    execute_query.setInt(5, Integer.parseInt(phd_year));
                    execute_query.setString(6, phd_university);
                }
                else
                {
                    execute_query.setNull(5, java.sql.Types.NULL);
                    execute_query.setNull(6, java.sql.Types.NULL);
                }
                execute_query.executeUpdate();

                request.setAttribute("success", "Faculty, Employee ID: " + employee_id + " has been created succesfully.");
                RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("employee-id", employee_id);
                request.setAttribute("whether-education", education_details);
                request.setAttribute("x-year", String.valueOf(x_year));
                request.setAttribute("x-marks", String.valueOf(x_marks));
                request.setAttribute("xii-year", String.valueOf(xii_year));
                request.setAttribute("xii-marks", String.valueOf(xii_marks));
                request.setAttribute("grad-university", grad_university);
                request.setAttribute("grad-year", String.valueOf(grad_year));
                request.setAttribute("grad-marks", String.valueOf(grad_marks));
                request.setAttribute("post-grad-university", post_grad_university);
                request.setAttribute("post-grad-year", String.valueOf(post_grad_year));
                request.setAttribute("post-grad-marks", String.valueOf(post_grad_marks));
                request.setAttribute("phd-university", phd_university);
                request.setAttribute("phd-year", String.valueOf(phd_year));
                RequestDispatcher new_faculty = request.getRequestDispatcher("new_faculty.jsp");
                new_faculty.forward(request, response);
            }
        }
        catch(SQLException e)
        {
            out.write("<h1>Error Code: " + e.getErrorCode() + "</h1>");
            out.write("<h3>Exception: " + e.getClass().getName() + "</h3>");
            out.write("<h4>" + e.getLocalizedMessage() + "</h4>");
            out.write("<h4>SQL State: " + e.getSQLState() + "</h4>");
            out.write("<h2><a href=\"new_faculty.jsp\">Back</a></h2>");
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
