/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package employee;

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
public class new_leave2 extends HttpServlet {
   
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
            String date = request.getParameter("date");
            String month = request.getParameter("month");
            String year = request.getParameter("year");
            String leave_details = request.getParameter("leave-details");
            if(leave_details.length() >= 150)
                leave_details = leave_details.substring(0, 149);

            query = "select * from Employee.PersonalDetail where EmployeeID=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, employee_id);
            result_set = execute_query.executeQuery();

            if(! result_set.next())
            {
                message += "<li>Employee doesn't exists, Enter valid Employee ID.</li>";
            }

            query = "select * from Employee.Leave where EmployeeID=? and LeaveDate=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, employee_id);
            execute_query.setDate(2, new Date(Integer.parseInt(year) - 1900, Integer.parseInt(month) - 1, Integer.parseInt(date)));
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>Employee Leave Details exists for this date, Enter valid Employee Leave Details.</li>";
            }

            if(message.length() == 0)
            {
                query = "insert into Employee.Leave (EmployeeID, LeaveDate, LeaveDetails) values (?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, employee_id);
                execute_query.setDate(2, new Date(Integer.parseInt(year) - 1900, Integer.parseInt(month) - 1, Integer.parseInt(date)));
                execute_query.setString(3, leave_details);
                execute_query.executeUpdate();

                request.setAttribute("success", "Employee: " + employee_id + " entered leave details for " + date + "/" + month + "/" + year + ".");
                RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("employee-id", employee_id);
                request.setAttribute("date", date);
                request.setAttribute("month", month);
                request.setAttribute("year", year);
                request.setAttribute("leave-details", leave_details);
                RequestDispatcher new_leave = request.getRequestDispatcher("new_leave.jsp");
                new_leave.forward(request, response);
            }
        }
        catch(SQLException e)
        {
            out.write("<h1>Error Code: " + e.getErrorCode() + "</h1>");
            out.write("<h3>Exception: " + e.getClass().getName() + "</h3>");
            out.write("<h4>" + e.getLocalizedMessage() + "</h4>");
            out.write("<h4>SQL State: " + e.getSQLState() + "</h4>");
            out.write("<h2><a href=\"new_leave.jsp\">Back</a></h2>");
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
