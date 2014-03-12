/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package examcell;

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
public class new_paper_checking2 extends HttpServlet {
   
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

        String employee_id = null;
        String[] marks_obtained = null, sheet_no = null;

        try
        {
            String query, message = "";
            PreparedStatement execute_query;
            ResultSet result_set;

            employee_id = request.getParameter("employee-id");
            marks_obtained = request.getParameterValues("marks-obtained");
            sheet_no = request.getParameterValues("sheet-no");

            query = "select * from Employee.PersonalDetail where EmployeeID=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, employee_id);
            result_set = execute_query.executeQuery();

            if(! result_set.next())
            {
                message += "<li>Employee doesn't exists, Enter valid Employee ID.</li>";
            }

            ArrayList<String> invalid_sheets = new ArrayList<String>();

            if(sheet_no != null)
            {
                for(String temp : sheet_no)
                {
                    if(temp != null && temp.compareTo("") != 0)
                    {
                        query = "select * from ExamCell.StudentExam where SheetNo=?";
                        execute_query = server.server_connection.prepareStatement(query);
                        execute_query.setString(1, temp);
                        result_set = execute_query.executeQuery();
                        if(!result_set.next())
                            invalid_sheets.add(temp);
                    }
                }
            }

            if(!invalid_sheets.isEmpty())
            {
                message += "<li>Following sheets don't exist: <br/>";
                for(String temp : invalid_sheets)
                    message += temp + ", ";
                message += "<br/>Enter valid Sheet Numbers.</li>";
            }
                    
            if(message.length() == 0)
            {
                server.server_connection.setAutoCommit(false);

                query = "insert into ExamCell.PaperChecking (EmployeeID, SheetNo, MarksObtained) values (?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                if(marks_obtained != null && sheet_no != null)
                {
                    for(int i=0; i<sheet_no.length; i++)
                    {
                        if(sheet_no[i] != null && sheet_no[i].compareTo("") != 0)
                        {
                            execute_query.setString(1, employee_id);
                            execute_query.setString(2, sheet_no[i]);
                            execute_query.setInt(3, Integer.parseInt(marks_obtained[i]));
                            execute_query.addBatch();
                        }
                    }
                }

                execute_query.executeBatch();
                server.server_connection.commit();
                server.server_connection.setAutoCommit(true);

                message = "Employee: " + employee_id + " succesfully checked the following Exam papers:<br/>";
                if(sheet_no != null)
                {
                    for(String temp : sheet_no)
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
                request.setAttribute("employee-id", employee_id);
                request.setAttribute("marks-obtained", marks_obtained);
                request.setAttribute("sheet-no", sheet_no);
                RequestDispatcher new_paper_checking = request.getRequestDispatcher("new_paper_checking.jsp");
                new_paper_checking.forward(request, response);
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
                out.write("<h2><a href=\"new_paper_checking.jsp\">Back</a></h2>");
            }

            request.setAttribute("error", "Correct the following errors:<br/><br/><li>One or more Sheet numbers have been entered multiple times.</li>");
            request.setAttribute("employee-id", employee_id);
            request.setAttribute("marks-obtained", marks_obtained);
            request.setAttribute("sheet-no", sheet_no);
            RequestDispatcher new_paper_checking = request.getRequestDispatcher("new_paper_checking.jsp");
            new_paper_checking.forward(request, response);
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
