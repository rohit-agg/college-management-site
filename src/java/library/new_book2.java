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
public class new_book2 extends HttpServlet {
   
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

        String query, message = "";
        PreparedStatement execute_query;

        String isbn_no = "", title = "", author = "", publisher = "", price = "";
        String[] reference_no = null, category = null;

        try
        {
            ResultSet result_set;

            isbn_no = request.getParameter("isbn-no");
            title = request.getParameter("title");
            author = request.getParameter("author");
            publisher = request.getParameter("publisher");
            price = request.getParameter("price");
            reference_no = request.getParameterValues("reference-no");
            category = request.getParameterValues("category");

            query = "select * from Library.Book where ISBNNo=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, isbn_no);
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>Book already exists, Enter valid ISBN Number.</li>";
            }

            if(message.length() == 0)
            {
                query = "insert into Library.Book (ISBNNo, Title, Author, Publisher, Price) values (?,?,?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, isbn_no);
                execute_query.setString(2, title);
                execute_query.setString(3, author);
                execute_query.setString(4, publisher);
                execute_query.setInt(5, Integer.parseInt(price));
                execute_query.executeUpdate();

                server.server_connection.setAutoCommit(false);
                query = "insert into Library.BookRecord (ReferenceNo, ISBNNo, Category, Status) values (?,?,?,?) ";
                execute_query = server.server_connection.prepareStatement(query);

                if(reference_no != null)
                {
                    for(int i=0; i<reference_no.length; i++)
                    {
                        if(reference_no[i] != null && reference_no[i].compareTo("") != 0)
                        {
                            execute_query.setString(1, reference_no[i]);
                            execute_query.setString(2, isbn_no);
                            execute_query.setString(3, category[i]);
                            execute_query.setString(4, "Available");
                            execute_query.addBatch();
                        }
                    }
                }

                execute_query.executeBatch();
                server.server_connection.commit();
                server.server_connection.setAutoCommit(true);

                message = "Following Books:<br/>";
                if(reference_no != null)
                {
                    for(String temp : reference_no)
                    {
                        if(temp != null && temp.compareTo("") != 0)
                            message += temp + ", ";
                    }
                }
                message += "<br/>have been added under " + title + " (" + isbn_no + ").";
                request.setAttribute("success", message);
                RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("isbn-no", isbn_no);
                request.setAttribute("title", title);
                request.setAttribute("author", author);
                request.setAttribute("publisher", publisher);
                request.setAttribute("price", price);
                request.setAttribute("reference-no", reference_no);
                request.setAttribute("category", category);
                RequestDispatcher new_book = request.getRequestDispatcher("new_book.jsp");
                new_book.forward(request, response);
            }
        }
        catch(SQLException e)
        {
            try
            {
                server.server_connection.rollback();
                server.server_connection.setAutoCommit(true);

                query = "delete from Library.Book where ISBNNo=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, isbn_no);
                execute_query.executeUpdate();
            }
            catch(SQLException ee)
            {
                out.write("<h1>Error Code: " + e.getErrorCode() + "</h1>");
                out.write("<h3>Exception: " + e.getClass().getName() + "</h3>");
                out.write("<h4>" + e.getLocalizedMessage() + "</h4>");
                out.write("<h4>SQL State: " + e.getSQLState() + "</h4>");
                out.write("<h2><a href=\"new_book.jsp\">Back</a></h2>");
            }

            request.setAttribute("error", "One or more Reference No. (Books) are either already present or have been entered multiple times.");
            request.setAttribute("isbn-no", isbn_no);
            request.setAttribute("title", title);
            request.setAttribute("author", author);
            request.setAttribute("publisher", publisher);
            request.setAttribute("price", price);
            request.setAttribute("reference-no", reference_no);
            request.setAttribute("category", category);
            RequestDispatcher new_book = request.getRequestDispatcher("new_book.jsp");
            new_book.forward(request, response);
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
