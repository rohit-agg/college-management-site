/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package tandp;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.RequestDispatcher;
import java.util.ArrayList;
import java.sql.*;

import initial.server;

/**
 *
 * @author Administrator
 */
public class new_placed_student2 extends HttpServlet {
   
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
        
        String company = null;
        String[] roll_no = null, designation = null, package_ = null;

        try
        {
            String query, message = "";
            PreparedStatement execute_query;
            ResultSet result_set;
            int company_id = 0;

            company = request.getParameter("company");
            roll_no = request.getParameterValues("roll-no");
            designation = request.getParameterValues("designation");
            package_ = request.getParameterValues("package");

            query = "select * from TandP.CompanyDetails where Name=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, company);
            result_set = execute_query.executeQuery();
            result_set.next();
            company_id = result_set.getInt("CompanyID");

            ArrayList<String> invalid_students = new ArrayList<String>();

            if(roll_no != null)
            {
                for(String temp : roll_no)
                {
                    if(temp != null && temp.compareTo("") != 0)
                    {
                        query = "select * from Student.PersonalDetail where RollNo=?";
                        execute_query = server.server_connection.prepareStatement(query);
                        execute_query.setString(1, temp);
                        result_set = execute_query.executeQuery();
                        if(!result_set.next())
                            invalid_students.add(temp);
                    }
                }
            }

            if(!invalid_students.isEmpty())
            {
                message += "<li>Following Students don't exist: <br/>";
                for(String temp : invalid_students)
                    message += temp + ", ";
                message += "<br/>Enter valid Roll Numbers.</li>";
            }
            
            invalid_students.clear();

            if(roll_no != null)
            {
                for(String temp : roll_no)
                {
                    if(temp != null && temp.compareTo("") != 0)
                    {
                        query = "select * from TandP.PlacedStudent where RollNo=? and CompanyID=?";
                        execute_query = server.server_connection.prepareStatement(query);
                        execute_query.setString(1, temp);
                        execute_query.setInt(2, company_id);
                        result_set = execute_query.executeQuery();
                        if(result_set.next())
                            invalid_students.add(temp);
                    }
                }
            }

            if(!invalid_students.isEmpty())
            {
                message += "<li>Following Students are already placed in this Company: <br/>";
                for(String temp : invalid_students)
                    message += temp + ", ";
                message += "<br/>Enter valid Roll Numbers and Company Name.</li>";
            }

            if(message.length() == 0)
            {
                server.server_connection.setAutoCommit(false);

                query = "insert into TandP.PlacedStudent (RollNo, CompanyID, Designation, Package) values (?,?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                if(roll_no != null && designation != null && package_ != null)
                {
                    for(int i=0; i<roll_no.length; i++)
                    {
                        if(roll_no[i] != null && roll_no[i].compareTo("") != 0)
                        {
                            execute_query.setString(1, roll_no[i]);
                            execute_query.setInt(2, company_id);
                            execute_query.setString(3, designation[i]);
                            execute_query.setString(4, package_[i]);
                            execute_query.addBatch();
                        }
                    }
                }

                execute_query.executeBatch();
                server.server_connection.commit();
                server.server_connection.setAutoCommit(true);

                message = "Company: " + company + " succesfully placed the following Students:<br/>";
                if(roll_no != null)
                {
                    for(String temp : roll_no)
                    {
                        if(temp != null && temp.compareTo("") != 0)
                            message += temp + ", ";
                    }
                }
                request.setAttribute("success", message);
                RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("company", company);
                request.setAttribute("roll-no", roll_no);
                request.setAttribute("designation", designation);
                request.setAttribute("package", package_);
                RequestDispatcher new_placed_student = request.getRequestDispatcher("new_placed_student.jsp");
                new_placed_student.forward(request, response);
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
                out.write("<h2><a href=\"new_placed_student.jsp\">Back</a></h2>");
            }

            request.setAttribute("error", "Correct the following errors:<br/><br/><li>One or more Students (Roll Number) have been entered multiple times.<li>");
            request.setAttribute("company", company);
            request.setAttribute("roll-no", roll_no);
            request.setAttribute("designation", designation);
            request.setAttribute("package", package_);
            RequestDispatcher new_placed_student = request.getRequestDispatcher("new_placed_student.jsp");
            new_placed_student.forward(request, response);
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
