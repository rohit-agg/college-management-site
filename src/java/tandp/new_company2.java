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
import java.sql.*;

import initial.server;

/**
 *
 * @author Administrator
 */
public class new_company2 extends HttpServlet {
   
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
            int company_id = 0;

            String name = request.getParameter("name");
            String contact_no = request.getParameter("contact-no");
            String address = request.getParameter("address");
            String avg_percent = request.getParameter("avg-percent");
            String sem_percent = request.getParameter("sem-percent");
            String backlog = request.getParameter("backlogs");
            String supplementary = request.getParameter("supplementary");
            String max_supplementary = request.getParameter("max-supplementary");
            if(address.length() >= 150)
                address = address.substring(0, 149);

            query = "select * from TandP.CompanyDetails where Name=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, name);
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>Company already exists, Enter valid Company Name.</li>";
            }

            if(message.length() == 0)
            {
                query = "insert into TandP.CompanyDetails (Name, Address, ContactNo, Placements) values (?,?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, name);
                execute_query.setString(2, address);
                execute_query.setString(3, contact_no);
                execute_query.setInt(4, 0);
                execute_query.executeUpdate();

                query = "select * from TandP.CompanyDetails where Name=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, name);
                result_set = execute_query.executeQuery();
                result_set.next();
                company_id = result_set.getInt("CompanyID");

                query = "insert into TandP.CompanyCriteria (CompanyID, AveragePercentage, Backlogs, Supplementary, MaxSupplementary, SemesterPercentile) values (?,?,?,?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, company_id);
                execute_query.setInt(2, Integer.parseInt(avg_percent));
                execute_query.setString(3, backlog);
                execute_query.setString(4, supplementary);
                if(supplementary.compareTo("Allowed") == 0)
                    execute_query.setInt(5, Integer.parseInt(max_supplementary));
                else
                    execute_query.setNull(5, Types.NULL);
                if(sem_percent != null && sem_percent.compareTo("") != 0)
                    execute_query.setInt(6, Integer.parseInt(sem_percent));
                else
                    execute_query.setNull(6, Types.NULL);
                execute_query.executeUpdate();

                request.setAttribute("success", "Company: " + name + ", Contact No.: " + contact_no + " succesfully registered in the College Placement List.");
                RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("name", name);
                request.setAttribute("address", address);
                request.setAttribute("contact-no", contact_no);
                request.setAttribute("avg-percent", avg_percent);
                request.setAttribute("sem-percent", sem_percent);
                request.setAttribute("backlog", backlog);
                request.setAttribute("supplementary", supplementary);
                request.setAttribute("max-supplementary", max_supplementary);
                RequestDispatcher new_company = request.getRequestDispatcher("new_company.jsp");
                new_company.forward(request, response);
            }
        }
        catch(SQLException e)
        {
            out.write("<h1>Error Code: " + e.getErrorCode() + "</h1>");
            out.write("<h3>Exception: " + e.getClass().getName() + "</h3>");
            out.write("<h4>" + e.getLocalizedMessage() + "</h4>");
            out.write("<h4>SQL State: " + e.getSQLState() + "</h4>");
            out.write("<h2><a href=\"new_company.jsp\">Back</a></h2>");
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
