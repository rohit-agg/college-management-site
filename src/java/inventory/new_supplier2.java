/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package inventory;

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
public class new_supplier2 extends HttpServlet {
   
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

            String supplier_name = request.getParameter("supplier-name");
            String contact_no = request.getParameter("contact-no");
            String supplier_address = request.getParameter("supplier-address");
            if(supplier_address.length() >= 100)
                supplier_address = supplier_address.substring(0, 99);

            query = "select * from Inventory.Supplier where SupplierName=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, supplier_name);
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>Supplier already exists, Enter valid Supplier Name.</li>";
            }

            if(message.length() == 0)
            {
                query = "insert into Inventory.Supplier (SupplierName, Address, ContactNo) values (?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, supplier_name);
                execute_query.setString(2, supplier_address);
                execute_query.setString(3, contact_no);
                execute_query.executeUpdate();

                request.setAttribute("success", "Supplier: " + supplier_name + ", Contact No.: " + contact_no + " succesfully created.");
                RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("supplier-name", supplier_name);
                request.setAttribute("supplier-address", supplier_address);
                request.setAttribute("contact-no", contact_no);
                RequestDispatcher new_supplier = request.getRequestDispatcher("new_supplier.jsp");
                new_supplier.forward(request, response);
            }
        }
        catch(SQLException e)
        {
            out.write("<h1>Error Code: " + e.getErrorCode() + "</h1>");
            out.write("<h3>Exception: " + e.getClass().getName() + "</h3>");
            out.write("<h4>" + e.getLocalizedMessage() + "</h4>");
            out.write("<h4>SQL State: " + e.getSQLState() + "</h4>");
            out.write("<h2><a href=\"new_supplier.jsp\">Back</a></h2>");
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
