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
public class new_degree2 extends HttpServlet {
   
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

            String degree = request.getParameter("degree");
            String short_degree = request.getParameter("short-degree");            
            Integer duration = Integer.parseInt(request.getParameter("duration"));            
            Integer semester = Integer.parseInt(request.getParameter("semester"));

            query = "select * from Administration.Degree where Degree=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, degree);
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>Degree already exists, Enter valid Degree name.</li>";
            }

            if(message.length() == 0)
            {
                query = "insert into Administration.Degree (Degree, SDegree, Duration, NoOfSemester) values (?,?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, degree);
                execute_query.setString(2, short_degree);
                execute_query.setInt(3, duration);
                execute_query.setInt(4, semester);
                execute_query.executeUpdate();

                request.setAttribute("success", "Degree: " + degree + " has been created succesfully.");
                RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("degree", degree);
                request.setAttribute("short-degree", short_degree);
                request.setAttribute("duration", duration.toString());
                request.setAttribute("semester", semester.toString());
                RequestDispatcher new_degree = request.getRequestDispatcher("new_degree.jsp");
                new_degree.forward(request, response);
            }
        }
        catch(SQLException e)
        {
            out.write("<h1>Error Code: " + e.getErrorCode() + "</h1>");
            out.write("<h3>Exception: " + e.getClass().getName() + "</h3>");
            out.write("<h4>" + e.getLocalizedMessage() + "</h4>");
            out.write("<h4>SQL State: " + e.getSQLState() + "</h4>");
            out.write("<h2><a href=\"new_degree.jsp\">Back</a></h2>");
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
