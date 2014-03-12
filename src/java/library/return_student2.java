package library;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


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
public class return_student2 extends HttpServlet {
   
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
            Date issue_date = new Date(0), actual_return_date = new Date(0);
            int fine = 0;

            String roll_no = request.getParameter("roll-no");
            String reference_no = request.getParameter("reference-no");
            java.util.Date return_date = new java.util.Date();
            java.util.Date return_date_actual = new java.util.Date();

            query = "select * from Student.PersonalDetail where RollNo=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, roll_no);
            result_set = execute_query.executeQuery();

            if(! result_set.next())
            {
                message += "<li>Student doesn't exist, Enter valid Roll Number.</li>";
            }

            query = "select * from Library.CurrentStudent where RollNo=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, roll_no);
            result_set = execute_query.executeQuery();

            if(! result_set.next())
            {
                message += "<li>Student doesn't have any books issued, Enter valid Roll Number.</li>";
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
                query = "select * from Library.CurrentStudent where ReferenceNo=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, reference_no);
                result_set = execute_query.executeQuery();

                if(! result_set.next())
                {
                    message += "<li>Book is not issued to any Student, Enter valid Reference Number.</li>";
                }
            }

            query = "select * from Library.CurrentStudent where RollNo=? and ReferenceNo=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, roll_no);
            execute_query.setString(2, reference_no);
            result_set = execute_query.executeQuery();

            if(! result_set.next())
            {
                message += "<li>Student doesn't have the particular Book issued, Enter valid Book Return Details.</li>";
            }
            else
            {
                issue_date = result_set.getDate("DateOfIssue");
                actual_return_date = result_set.getDate("DateOfReturn");

                return_date_actual.setDate(actual_return_date.getDate());
                return_date_actual.setMonth(actual_return_date.getMonth());
                return_date_actual.setYear(actual_return_date.getYear());

                if(return_date.compareTo(return_date_actual) > 0)
                {
                    long time_return_date = return_date.getTime();
                    long time_return_date_actual = return_date_actual.getTime();                    
                    fine = (int)(10 * (((time_return_date - time_return_date_actual)/(24 * 60 * 60 * 1000)) / 7));

                    if(fine < 0)
                        fine = 0;
                }
            }

            if(message.length() == 0)
            {
                query = "delete from Library.CurrentStudent where RollNo=? and ReferenceNo=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, roll_no);
                execute_query.setString(2, reference_no);
                execute_query.executeUpdate();

                query = "insert into Library.StudentTransaction (RollNo, ReferenceNo, DateOfIssue, ActualDateOfReturn, DateOfReturn, Fine) values (?,?,?,?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, roll_no);
                execute_query.setString(2, reference_no);
                execute_query.setDate(3, issue_date);
                execute_query.setDate(4, actual_return_date);
                execute_query.setDate(5, new Date(return_date.getYear(), return_date.getMonth(), return_date.getDate()));
                execute_query.setInt(6, fine);
                execute_query.executeUpdate();

                query = "update Library.BookRecord set Status=? where ReferenceNo=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, "Available");
                execute_query.setString(2, reference_no);
                execute_query.executeUpdate();

                request.setAttribute("success", "Book: " + reference_no + " was successfully returned by Student: " + roll_no + " with a fine of Rs. " + fine + ".");
                RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("roll-no", roll_no);
                request.setAttribute("reference-no", reference_no);
                RequestDispatcher return_student = request.getRequestDispatcher("return_student.jsp");
                return_student.forward(request, response);
            }
        }
        catch(SQLException e)
        {
            out.write("<h1>Error Code: " + e.getErrorCode() + "</h1>");
            out.write("<h3>Exception: " + e.getClass().getName() + "</h3>");
            out.write("<h4>" + e.getLocalizedMessage() + "</h4>");
            out.write("<h4>SQL State: " + e.getSQLState() + "</h4>");
            out.write("<h2><a href=\"return_student.jsp\">Back</a></h2>");
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
