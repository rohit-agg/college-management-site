/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package library;

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
public class issue_faculty2 extends HttpServlet {
   
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
            String query, status, message = "";
            PreparedStatement execute_query;
            ResultSet result_set;

            String employee_id = request.getParameter("employee-id");
            String reference_no = request.getParameter("reference-no");
            String date = request.getParameter("date");
            String month = request.getParameter("month");
            String year = request.getParameter("year");

            query = "select * from Employee.PersonalDetail where EmployeeID=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, employee_id);
            result_set = execute_query.executeQuery();

            if(! result_set.next())
            {
                message += "<li>Employee ID doesn't exist, Enter valid Employee ID.</li>";
            }

            query = "select * from Library.CurrentFaculty where EmployeeID=? and ReferenceNo=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, employee_id);
            execute_query.setString(2, reference_no);
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>Employee ID already has this book issued, Enter valid Employee ID and Reference No.</li>";
            }

            query = "select * from Library.BookRecord where ReferenceNo=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, reference_no);
            result_set = execute_query.executeQuery();

            if(! result_set.next())
            {
                message += "<li>The book doesn't exists, Enter valid Reference No.</li>";
            }
            else
            {
                status = result_set.getString("Status").trim();
                if(status.compareTo("Issued") == 0)
                {
                    message += "<li>The book is already issued, Enter valid Reference No.</li>";
                }
            }

            if(message.length() == 0)
            {
                query = "insert into Library.CurrentFaculty (EmployeeID, ReferenceNo, DateOfIssue) values (?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, employee_id);
                execute_query.setString(2, reference_no);
                execute_query.setDate(3, new Date(Integer.parseInt(year) - 1900, Integer.parseInt(month) - 1, Integer.parseInt(date)));
                execute_query.executeUpdate();

                query = "update Library.BookRecord set Status=? where ReferenceNo=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, "Issued");
                execute_query.setString(2, reference_no);
                execute_query.executeUpdate();

                request.setAttribute("success", "Employee: " + employee_id + " has issued the book: " + reference_no + " succesfully.");
                RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("unique-id", employee_id);
                request.setAttribute("reference-no", reference_no);
                request.setAttribute("date", date);
                request.setAttribute("month", month);
                request.setAttribute("year", year);
                RequestDispatcher issue_faculty = request.getRequestDispatcher("issue_faculty.jsp");
                issue_faculty.forward(request, response);
            }
        }
        catch(SQLException e)
        {
            out.write("<h1>Error Code: " + e.getErrorCode() + "</h1>");
            out.write("<h3>Exception: " + e.getClass().getName() + "</h3>");
            out.write("<h4>" + e.getLocalizedMessage() + "</h4>");
            out.write("<h4>SQL State: " + e.getSQLState() + "</h4>");
            out.write("<h2><a href=\"issue_faculty.jsp\">Back</a></h2>");
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
