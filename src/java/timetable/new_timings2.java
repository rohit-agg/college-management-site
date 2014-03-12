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

import initial.server;

/**
 *
 * @author Administrator
 */
public class new_timings2 extends HttpServlet {
   
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

            String lecture = request.getParameter("lecture");
            String start_hour = request.getParameter("start-hour");
            String start_min = request.getParameter("start-min");
            String end_hour = request.getParameter("end-hour");
            String end_min = request.getParameter("end-min");

            query = "select * from TimeTable.Timings where Lecture=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setInt(1, Integer.parseInt(lecture));
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>Lecture already exists, Enter valid Lecture.</li>";
            }

            query = "select * from TimeTable.Timings where StartTime=? or EndTime=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setTime(1, new Time(Integer.parseInt(start_hour), Integer.parseInt(start_min), 0));
            execute_query.setTime(2, new Time(Integer.parseInt(end_hour), Integer.parseInt(end_min), 0));
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>Invalid Start Time or End Time, Enter valid Start Time and End Time.</li>";
            }
                
            if(message.length() == 0)
            {
                query = "insert into TimeTable.Timings (Lecture, StartTime, EndTime) values (?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, Integer.parseInt(lecture));
                execute_query.setTime(2, new Time(Integer.parseInt(start_hour), Integer.parseInt(start_min), 0));
                execute_query.setTime(3, new Time(Integer.parseInt(end_hour), Integer.parseInt(end_min), 0));
                execute_query.executeUpdate();

                request.setAttribute("success", "Lecture: " + lecture + " (" + start_hour + ":" + start_min + " - " + end_hour + ":" + end_min + ") has been created successfully.");
                RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("lecture", lecture);
                request.setAttribute("start-hour", start_hour);
                request.setAttribute("start-min", start_min);
                request.setAttribute("end-hour", end_hour);
                request.setAttribute("end-min", end_min);
                RequestDispatcher new_timings = request.getRequestDispatcher("new_timings.jsp");
                new_timings.forward(request, response);
            }
        }
        catch(SQLException e)
        {
            out.write("<h1>Error Code: " + e.getErrorCode() + "</h1>");
            out.write("<h3>Exception: " + e.getClass().getName() + "</h3>");
            out.write("<h4>" + e.getLocalizedMessage() + "</h4>");
            out.write("<h4>SQL State: " + e.getSQLState() + "</h4>");
            out.write("<h2><a href=\"new_timings.jsp\">Back</a></h2>");
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
