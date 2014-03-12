/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package general;

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
public class register2 extends HttpServlet {
   
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

            String category = request.getParameter("category");
            String unique_id = request.getParameter("unique-id");
            String user_name = request.getParameter("user-name");
            String password = request.getParameter("password");
            String security_question = request.getParameter("security-question");
            String security_answer = request.getParameter("security-answer");

            if(category.compareTo("Student") == 0)
                query = "select * from Student.RegistrationDetail where RegistrationNo=?";
            else
                query = "select * from Employee.PersonalDetail where EmployeeID=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, unique_id);
            result_set = execute_query.executeQuery();

            if(! result_set.next())
            {
                if(category.compareTo("Student") == 0)
                    message += "<li>Registration No. doesn't exist, Enter valid Registration No.</li>";
                else
                    message += "<li>Employee ID doesn't exist, Enter valid Employee ID.</li>";
            }

            query = "select * from Login where UniqueID=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, unique_id);
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                if(category.compareTo("Student") == 0)
                    message += "<li>Registration No. already has a User Name registered.</li>";
                else
                    message += "<li>Employee ID already has a User Name registered.</li>";
            }
            
            query = "select * from Login where UserName=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, user_name);
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>User Name already in use, Choose another User Name.</li>";
            }

            if(message.length() == 0)
            {
                query = "insert into Login (UserName, Password, Category, UniqueID) values (?,?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, user_name);
                execute_query.setString(2, password);
                execute_query.setString(3, category);
                execute_query.setString(4, unique_id);
                result_set = execute_query.executeQuery();

                query = "insert into ForgotPassword (Question, Answer, UserName) values (?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, security_question);
                execute_query.setString(2, security_answer);
                execute_query.setString(3, user_name);
                result_set = execute_query.executeQuery();

                if(category.compareTo("Student") == 0)
                    request.setAttribute("success", "User:" + user_name + " for Registration No.:" + unique_id + " has been created succesfully.");
                else
                    request.setAttribute("success", "User:" + user_name + " for Employee ID:" + unique_id + " has been created succesfully.");
                RequestDispatcher index = request.getRequestDispatcher("index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("category", category);
                request.setAttribute("unique-id", unique_id);
                request.setAttribute("user-name", user_name);
                request.setAttribute("scurity-question", security_question);
                request.setAttribute("security-answer", security_answer);
                RequestDispatcher register = request.getRequestDispatcher("register.jsp");
                register.forward(request, response);
            }
        }
        catch(SQLException e)
        {
            out.write("<h1>Error Code: " + e.getErrorCode() + "</h1>");
            out.write("<h3>Exception: " + e.getClass().getName() + "</h3>");
            out.write("<h4>" + e.getLocalizedMessage() + "</h4>");
            out.write("<h4>SQL State: " + e.getSQLState() + "</h4>");
            out.write("<h2><a href=\"register.jsp\">Back</a></h2>");
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
