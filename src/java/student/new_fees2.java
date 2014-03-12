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
public class new_fees2 extends HttpServlet {
   
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

            String roll_no = request.getParameter("roll-no");
            String receipt_no = request.getParameter("receipt-no");
            String date = request.getParameter("date");
            String month = request.getParameter("month");
            String year = request.getParameter("year");
            String amount = request.getParameter("amount");
            String type = request.getParameter("type");
            String details = request.getParameter("details");
            if(details.length() >= 50)
                details = details.substring(0, 49);

            query = "select * from Student.PersonalDetail where RollNo=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, roll_no);
            result_set = execute_query.executeQuery();

            if(! result_set.next())
            {
                message += "<li>Student doesn't exists, Enter valid Roll Number.</li>";
            }

            query = "select * from Student.Fees where RollNo=? and DateOfSubmit=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, roll_no);
            execute_query.setDate(2, new Date(Integer.parseInt(year) - 1900, Integer.parseInt(month) - 1, Integer.parseInt(date)));
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>Student already deposited fees on this date, Enter valid details.</li>";
            }    

            if(message.length() == 0)
            {
                query = "insert into Student.Fees (RollNo, DateOfSubmit, ReceiptNo, Amount, Type, Details) values (?,?,?,?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, roll_no);
                execute_query.setDate(2, new Date(Integer.parseInt(year) - 1900, Integer.parseInt(month) - 1, Integer.parseInt(date)));
                execute_query.setInt(3, Integer.parseInt(receipt_no));
                execute_query.setInt(4, Integer.parseInt(amount));
                execute_query.setString(5, type);
                if(details != null && details.compareTo("") != 0)
                    execute_query.setString(6, details);
                else
                    execute_query.setNull(6, java.sql.Types.NULL);
                execute_query.executeUpdate();

                request.setAttribute("success", "Student: " + roll_no + " succesfully paid Rs. " + amount + " as fees.");
                RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("roll-no", roll_no);
                request.setAttribute("receipt-no", receipt_no);
                request.setAttribute("date", date);
                request.setAttribute("month", month);
                request.setAttribute("year", year);
                request.setAttribute("amount", amount);
                request.setAttribute("type", type);
                request.setAttribute("details", details);
                RequestDispatcher new_fees = request.getRequestDispatcher("new_fees.jsp");
                new_fees.forward(request, response);
            }
        }
        catch(SQLException e)
        {
            out.write("<h1>Error Code: " + e.getErrorCode() + "</h1>");
            out.write("<h3>Exception: " + e.getClass().getName() + "</h3>");
            out.write("<h4>" + e.getLocalizedMessage() + "</h4>");
            out.write("<h4>SQL State: " + e.getSQLState() + "</h4>");
            out.write("<h2><a href=\"new_fees.jsp\">Back</a></h2>");
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
