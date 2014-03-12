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
public class new_batch2 extends HttpServlet {
   
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

            Integer start_year = Integer.parseInt(request.getParameter("start-year"));
            Integer end_year = Integer.parseInt(request.getParameter("end-year"));

            query = "select * from Administration.Batch where StartYear=? and EndYear=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setInt(1, start_year);
            execute_query.setInt(2, end_year);
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>Batch already exists, Enter valid Batch Start and End Years.</li>";
            }

            if(message.length() == 0)
            {
                query = "insert into Administration.Batch (StartYear, EndYear) values (?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, start_year);
                execute_query.setInt(2, end_year);
                execute_query.executeUpdate();

                request.setAttribute("success", "Batch: " + start_year + " - " + end_year + " has been created succesfully.");
                RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("start-year", start_year.toString());
                request.setAttribute("end-year", end_year.toString());
                RequestDispatcher new_degree = request.getRequestDispatcher("new_batch.jsp");
                new_degree.forward(request, response);
            }
        }
        catch(SQLException e)
        {
            out.write("<h1>Error Code: " + e.getErrorCode() + "</h1>");
            out.write("<h3>Exception: " + e.getClass().getName() + "</h3>");
            out.write("<h4>" + e.getLocalizedMessage() + "</h4>");
            out.write("<h4>SQL State: " + e.getSQLState() + "</h4>");
            out.write("<h2><a href=\"new_batch.jsp\">Back</a></h2>");
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
