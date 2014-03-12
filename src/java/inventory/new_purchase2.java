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
public class new_purchase2 extends HttpServlet {
   
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

        String bill_no = null, supplier = null, bill_date = null, bill_month = null, bill_year = null, amount = null;
        String[] quantity = null, item = null;

        try
        {
            String query, query2, message = "";
            PreparedStatement execute_query, execute_query2;
            ResultSet result_set;
            int supplier_id, item_id, purchase_id, i;

            bill_no = request.getParameter("bill-no");
            supplier = request.getParameter("supplier");
            bill_date = request.getParameter("bill-date");
            bill_month = request.getParameter("bill-month");
            bill_year = request.getParameter("bill-year");
            amount = request.getParameter("amount");
            item = request.getParameterValues("item");
            quantity = request.getParameterValues("quantity");

            query = "select * from Inventory.Supplier where SupplierName=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, supplier);
            result_set = execute_query.executeQuery();
            result_set.next();
            supplier_id = result_set.getInt("SupplierID");

            query = "select * from Inventory.BillDetail where BillNo=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, bill_no);
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>Bill Number already exists, Enter valid Bill Number.</li>";
            }

            if(message.length() == 0)
            {
                server.server_connection.setAutoCommit(false);

                query = "insert into Inventory.BillDetail (BillNo, SupplierID, BillDate, Amount) values (?,?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, bill_no);
                execute_query.setInt(2, supplier_id);
                execute_query.setDate(3, new Date(Integer.parseInt(bill_year) - 1900, Integer.parseInt(bill_month) - 1, Integer.parseInt(bill_date)));
                execute_query.setInt(4, Integer.parseInt(amount));
                execute_query.executeUpdate();

                query = "select * from Inventory.BillDetail where BillNo=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, bill_no);
                result_set = execute_query.executeQuery();
                result_set.next();
                purchase_id = result_set.getInt("PurchaseID");

                query = "insert into Inventory.Purchase (PurchaseID, ItemID, Quantity) values (?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                if(item != null && quantity != null)
                {
                    for(i=0; i<item.length; i++)
                    {
                        if(item[i] != null && item[i].compareTo("") != 0)
                        {
                            query2 = "select * from Inventory.Item where ItemName=?";
                            execute_query2 = server.server_connection.prepareStatement(query2);
                            execute_query2.setString(1, item[i]);
                            result_set = execute_query2.executeQuery();
                            result_set.next();
                            item_id = result_set.getInt("ItemID");

                            execute_query.setInt(1, purchase_id);
                            execute_query.setInt(2, item_id);
                            execute_query.setInt(3, Integer.parseInt(quantity[i]));
                            execute_query.addBatch();
                        }
                    }
                }

                execute_query.executeBatch();
                server.server_connection.commit();
                server.server_connection.setAutoCommit(true);

                message = "Bill: " + bill_no + " has been prepared for the following items:<br/>";
                if(item != null)
                {
                    for(i=0; i<item.length; i++)
                    {
                        if(item[i] != null && item[i].compareTo("") != 0)
                            message += item[i] + " (" + quantity[i] + "), ";
                    }
                }
                request.setAttribute("success", message);
                RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("bill-no", bill_no);
                request.setAttribute("supplier", supplier);
                request.setAttribute("bill-date", bill_date);
                request.setAttribute("bill-month", bill_month);
                request.setAttribute("bill-year", bill_year);
                request.setAttribute("amount", amount);
                request.setAttribute("item", item);
                request.setAttribute("quantity", quantity);
                RequestDispatcher new_purchase = request.getRequestDispatcher("new_purchase.jsp");
                new_purchase.forward(request, response);
            }
        }
        catch(SQLException e)
        {
            try
            {
                server.server_connection.rollback();
                server.server_connection.setAutoCommit(true);
            }
            catch(SQLException ee)
            {
                out.write("<h1>Error Code: " + e.getErrorCode() + "</h1>");
                out.write("<h3>Exception: " + e.getClass().getName() + "</h3>");
                out.write("<h4>" + e.getLocalizedMessage() + "</h4>");
                out.write("<h4>SQL State: " + e.getSQLState() + "</h4>");
                out.write("<h2><a href=\"new_purchase.jsp\">Back</a></h2>");
            }

            request.setAttribute("error", "Correct the following errors:<br/><br/><li>One or more items have been entered multiple times, Enter valid Item Details.</li>");
            request.setAttribute("bill-no", bill_no);
            request.setAttribute("supplier", supplier);
            request.setAttribute("bill-date", bill_date);
            request.setAttribute("bill-month", bill_month);
            request.setAttribute("bill-year", bill_year);
            request.setAttribute("amount", amount);
            request.setAttribute("item", item);
            request.setAttribute("quantity", quantity);
            RequestDispatcher new_purchase = request.getRequestDispatcher("new_purchase.jsp");
            new_purchase.forward(request, response);
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
