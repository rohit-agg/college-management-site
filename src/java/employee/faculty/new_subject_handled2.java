/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package employee.faculty;

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
public class new_subject_handled2 extends HttpServlet {
   
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

        String employee_id = "", message = "";
        String[] branch = null, semester = null, degree = null, subject = null;

        try
        {
            String query, query2;
            PreparedStatement execute_query, execute_query2;
            ResultSet result_set, result_set2;
            int department_id, degree_id, i;

            ArrayList<String> invalid_subject = new ArrayList<String>();
            ArrayList<String> invalid_subject_semester = new ArrayList<String>();

            employee_id = request.getParameter("employee-id");
            degree = request.getParameterValues("degree");
            branch = request.getParameterValues("branch");
            semester = request.getParameterValues("semester");            
            subject = request.getParameterValues("subject");

            query = "select * from Employee.PersonalDetail where EmployeeID=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, employee_id);
            result_set = execute_query.executeQuery();

            if(! result_set.next())
            {
                message += "<li>Employee doesn't exist, Enter valid Employee ID.</li>";
            }

            if(subject != null)
            {
                for(String temp : subject)
                {
                    if(temp != null && temp.compareTo("") != 0)
                    {
                        query = "select * from Administration.Subject where SubjectCode=?";
                        execute_query = server.server_connection.prepareStatement(query);
                        execute_query.setString(1, temp);
                        result_set = execute_query.executeQuery();
                        if(!result_set.next())
                            invalid_subject.add(temp);
                    }
                }
            }

            if(! invalid_subject.isEmpty())
            {
                message += "<li>Following subjects don't exist: <br/>";
                for(String temp : invalid_subject)
                    message += temp + ", ";
                message += "<br/>Enter valid Subject Codes.</li>";
            }

            if(subject != null && semester != null)
            {
                for(i=0; i<subject.length; i++)
                {
                    if(subject[i] != null && semester[i] != null && subject[i].compareTo("") != 0 && semester[i].compareTo("") != 0)
                    {
                        query = "select * from Administration.Department where Name=?";
                        execute_query = server.server_connection.prepareStatement(query);
                        execute_query.setString(1, branch[i]);
                        result_set = execute_query.executeQuery();
                        result_set.next();
                        department_id = result_set.getInt("DepartmentID");

                        query = "select * from Administration.Degree where SDegree=?";
                        execute_query = server.server_connection.prepareStatement(query);
                        execute_query.setString(1, degree[i]);
                        result_set = execute_query.executeQuery();
                        result_set.next();
                        degree_id = result_set.getInt("DegreeID");

                        query = "select * from Administration.AllowedSubject where SubjectCode=? and DepartmentID=? and DegreeID=? and Semester=?";
                        execute_query = server.server_connection.prepareStatement(query);
                        execute_query.setString(1, subject[i]);
                        execute_query.setInt(2, department_id);
                        execute_query.setInt(3, degree_id);
                        execute_query.setInt(4, Integer.parseInt(semester[i]));
                        result_set = execute_query.executeQuery();

                        if(!result_set.next())
                            invalid_subject_semester.add(subject[i] + ", " + degree[i] + " (" + branch[i] + "), " + semester[i]);
                    }
                }
            }

            if(!invalid_subject_semester.isEmpty())
            {
                message += "<li>Following Subjects don't exist for the given Degree (Branch) and Semester: <br/>";
                for(String temp : invalid_subject_semester)
                    message += temp + ", ";
                message += "<br/>Enter valid Subject Codes, Degree, Branch and Semester.</li>";
            }

            if(message.length() == 0)
            {
                server.server_connection.setAutoCommit(false);
                query = "insert into Faculty.SubjectHandled (EmployeeID, Semester, DegreeID, DepartmentID, SubjectCode) values (?,?,?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);

                if(subject != null && semester != null)
                {
                    for(i=0; i<subject.length; i++)
                    {
                        if(subject[i] != null && semester[i] != null && subject[i].compareTo("") != 0 && semester[i].compareTo("") != 0)
                        {
                            query2 = "select * from Administration.Department where Name=?";
                            execute_query2 = server.server_connection.prepareStatement(query2);
                            execute_query2.setString(1, branch[i]);
                            result_set2 = execute_query2.executeQuery();
                            result_set2.next();
                            department_id = result_set2.getInt("DepartmentID");

                            query2 = "select * from Administration.Degree where SDegree=?";
                            execute_query2 = server.server_connection.prepareStatement(query2);
                            execute_query2.setString(1, degree[i]);
                            result_set2 = execute_query2.executeQuery();
                            result_set2.next();
                            degree_id = result_set2.getInt("DegreeID");

                            execute_query.setString(1, employee_id);
                            execute_query.setInt(2, Integer.parseInt(semester[i]));
                            execute_query.setInt(3, degree_id);
                            execute_query.setInt(4, department_id);
                            execute_query.setString(5, subject[i]);
                            execute_query.addBatch();
                        }
                    }
                }

                execute_query.executeBatch();
                server.server_connection.commit();
                server.server_connection.setAutoCommit(true);

                message = "Following Subjects:<br/>";
                if(subject != null && semester != null)
                {
                    for(i=0; i<subject.length; i++)
                    {
                        if(subject[i] != null && semester[i] != null && subject[i].compareTo("") != 0 && semester[i].compareTo("") != 0)
                            message += subject[i] + " - " + degree[i] + " (" + branch[i] + ", Semester: " + semester[i] + ")<br/>";
                    }
                }
                message += "will be handled by " + employee_id + ".";
                request.setAttribute("success", message);
                RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("employee-id", employee_id);
                request.setAttribute("degree", degree);
                request.setAttribute("branch", branch);
                request.setAttribute("semester", semester);                
                request.setAttribute("subject", subject);
                RequestDispatcher new_subject_handled = request.getRequestDispatcher("new_subject_handled.jsp");
                new_subject_handled.forward(request, response);
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
                out.write("<h2><a href=\"new_subject_handled.jsp\">Back</a></h2>");
            }

            request.setAttribute("error", "Correct the following errors:<br/><br/><li>One or more subjects are either already present or have been entered multiple times for the Faculty " + employee_id + ".</li>");
            request.setAttribute("employee-id", employee_id);
            request.setAttribute("degree", degree);
            request.setAttribute("branch", branch);
            request.setAttribute("semester", semester);            
            request.setAttribute("subject", subject);
            RequestDispatcher new_subject_handled = request.getRequestDispatcher("new_subject_handled.jsp");
            new_subject_handled.forward(request, response);
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
