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
public class issue_student2 extends HttpServlet {
   
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
            String query, message = "", status;
            PreparedStatement execute_query;
            ResultSet result_set;

            String roll_no = request.getParameter("roll-no");
            String reference_no = request.getParameter("reference-no");
            String issue_date = request.getParameter("issue-date");
            String issue_month = request.getParameter("issue-month");
            String issue_year = request.getParameter("issue-year");
            String return_date = request.getParameter("return-date");
            String return_month = request.getParameter("return-month");
            String return_year = request.getParameter("return-year");

            query = "select * from Student.PersonalDetail where RollNo=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, roll_no);
            result_set = execute_query.executeQuery();

            if(! result_set.next())
            {
                message += "<li>Roll Number doesn't exist, Enter valid Roll Number.</li>";
            }

            query = "select * from Library.CurrentStudent where RollNo=? and ReferenceNo=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, roll_no);
            execute_query.setString(2, reference_no);
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>Roll Number already has this book issued, Enter valid Roll Number and Reference No.</li>";
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

                if(result_set.getString("Category").trim().compareTo("Reserved") == 0)
                {
                    message += "<li>The book is reserved for Employees and Faculty, Enter valid Reference No.</li>";
                }
            }

            if(message.length() == 0)
            {
                query = "insert into Library.CurrentStudent (RollNo, ReferenceNo, DateOfIssue, DateOfReturn) values (?,?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, roll_no);
                execute_query.setString(2, reference_no);
                execute_query.setDate(3, new Date(Integer.parseInt(issue_year) - 1900, Integer.parseInt(issue_month) - 1, Integer.parseInt(issue_date)));
                execute_query.setDate(4, new Date(Integer.parseInt(return_year) - 1900, Integer.parseInt(return_month) - 1, Integer.parseInt(return_date)));
                execute_query.executeUpdate();

                query = "update Library.BookRecord set Status=? where ReferenceNo=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, "Issued");
                execute_query.setString(2, reference_no);
                execute_query.executeUpdate();

                request.setAttribute("success", "Student: " + roll_no + " has issued the book: " + reference_no + " succesfully.");
                RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("roll-no", roll_no);
                request.setAttribute("reference-no", reference_no);
                request.setAttribute("issue-date", issue_date);
                request.setAttribute("issue-month", issue_month);
                request.setAttribute("issue-year", issue_year);
                request.setAttribute("return-date", return_date);
                request.setAttribute("return-month", return_month);
                request.setAttribute("return-year", return_year);
                RequestDispatcher issue_student = request.getRequestDispatcher("issue_student.jsp");
                issue_student.forward(request, response);
            }
        }
        catch(SQLException e)
        {
            out.write("<h1>Error Code: " + e.getErrorCode() + "</h1>");
            out.write("<h3>Exception: " + e.getClass().getName() + "</h3>");
            out.write("<h4>" + e.getLocalizedMessage() + "</h4>");
            out.write("<h4>SQL State: " + e.getSQLState() + "</h4>");
            out.write("<h2><a href=\"issue_student.jsp\">Back</a></h2>");
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
