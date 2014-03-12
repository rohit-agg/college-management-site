/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package employee;

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
public class new_employee2 extends HttpServlet {
   
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
            int department_id;

            String employee_id = request.getParameter("employee-id");
            String name = request.getParameter("name");
            String father_name = request.getParameter("father-name");
            String mother_name = request.getParameter("mother-name");
            String address = request.getParameter("address");
            String gender = request.getParameter("gender");
            String date = request.getParameter("date");
            String month = request.getParameter("month");
            String year = request.getParameter("year");
            String contact_no = request.getParameter("contact-no");
            String email_id = request.getParameter("email-id");
            String photo = request.getParameter("photo");
            String department_details = request.getParameter("whether-department");
            String department = request.getParameter("department");
            String designation = request.getParameter("designation");
            String qualification_details = request.getParameter("whether-qualification");
            String x_year = request.getParameter("x-year");
            String x_marks = request.getParameter("x-marks");
            String xii_year = request.getParameter("xii-year");
            String xii_marks = request.getParameter("xii-marks");
            String grad_university = request.getParameter("grad-university");
            String grad_year = request.getParameter("grad-year");
            String grad_marks = request.getParameter("grad-marks");

            query = "select * from Employee.PersonalDetail where EmployeeID=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, employee_id);
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>Employee ID already exists, Enter valid Employee ID.</li>";
            }

            query = "select * from Employee.PersonalDetail where Name=? and FatherName=? and Address=? and DateOfBirth=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, name);
            execute_query.setString(2, father_name);
            execute_query.setString(3, address);
            execute_query.setDate(4, new Date(Integer.parseInt(year) - 1900, Integer.parseInt(month) - 1, Integer.parseInt(date)));
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>Employee with identical details exists, Enter valid Employee Details.</li>";
            }

            if(message.length() == 0)
            {
                query = "insert into Employee.PersonalDetail (EmployeeID, Name, FatherName, MotherName, Address, DateofBirth, Gender, ContactNo, EMailID, Photo) values (?,?,?,?,?,?,?,?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, employee_id);
                execute_query.setString(2, name);
                execute_query.setString(3, father_name);
                execute_query.setString(4, mother_name);
                execute_query.setString(5, address);
                execute_query.setDate(6, new Date(Integer.parseInt(year) - 1900, Integer.parseInt(month) - 1, Integer.parseInt(date)));
                execute_query.setString(7, gender);
                if(contact_no != null && contact_no.compareTo("") != 0)
                    execute_query.setString(8, contact_no);
                else
                    execute_query.setNull(8, java.sql.Types.NULL);
                if(email_id != null && email_id.compareTo("") != 0)
                    execute_query.setString(9, email_id);
                else
                    execute_query.setNull(9, java.sql.Types.NULL);
                if(photo != null && photo.compareTo("") != 0)
                    execute_query.setString(10, photo);
                else
                    execute_query.setNull(10, java.sql.Types.NULL);
                execute_query.executeUpdate();

                if(department_details != null)
                {
                    query = "select DepartmentID from Administration.Department where Name=?";
                    execute_query = server.server_connection.prepareStatement(query);
                    execute_query.setString(1, department);
                    result_set = execute_query.executeQuery();
                    result_set.next();
                    department_id = result_set.getInt("DepartmentID");

                    query = "insert into Employee.DepartmentDetail (EmployeeID, DepartmentID, Designation) values (?,?,?)";
                    execute_query = server.server_connection.prepareStatement(query);
                    execute_query.setString(1, employee_id);
                    execute_query.setInt(2, department_id);
                    execute_query.setString(3, designation);
                    execute_query.executeUpdate();
                }                   

                if(qualification_details != null)
                {
                    query = "insert into Employee.EducationalQualification (EmployeeID, XMarks, XYear, XIIMarks, XIIYear, GradMarks, GradYear, GradUniv) values (?,?,?,?,?,?,?,?)";
                    execute_query = server.server_connection.prepareStatement(query);
                    execute_query.setString(1, employee_id);
                    execute_query.setInt(2, Integer.parseInt(x_marks));
                    execute_query.setInt(3, Integer.parseInt(x_year));
                    execute_query.setInt(4, Integer.parseInt(xii_marks));
                    execute_query.setInt(5, Integer.parseInt(xii_year));
                    execute_query.setInt(6, Integer.parseInt(grad_marks));
                    execute_query.setInt(7, Integer.parseInt(grad_year));
                    execute_query.setString(8, grad_university);
                    execute_query.executeUpdate();
                }

                if(department_details != null)
                {
                    query = "select * from Administration.Department where Name=?";
                    execute_query = server.server_connection.prepareStatement(query);
                    execute_query.setString(1, department);
                    result_set = execute_query.executeQuery();
                    result_set.next();

                    if(result_set.getString("Type").compareTo("Education") == 0)
                    {
                        if(qualification_details != null)
                            request.setAttribute("grad-year", grad_year);
                        request.setAttribute("employee-id", employee_id);
                        RequestDispatcher new_faculty = request.getRequestDispatcher("faculty/new_faculty.jsp");
                        new_faculty.forward(request, response);
                    }
                    else
                    {
                        request.setAttribute("success", "Employee ID: " + employee_id + " has been created succesfully.");
                        RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                        index.forward(request, response);
                    }
                }
                else
                {
                    request.setAttribute("success", "Employee ID: " + employee_id + " has been created succesfully.");
                    RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                    index.forward(request, response);
                }
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("employee-id", employee_id);
                request.setAttribute("name", name);
                request.setAttribute("father-name", father_name);
                request.setAttribute("mother-name", mother_name);
                request.setAttribute("address", address);
                request.setAttribute("gender", gender);
                request.setAttribute("date", date);
                request.setAttribute("month", month);
                request.setAttribute("year", year);
                request.setAttribute("contact-no", contact_no);
                request.setAttribute("email-id", email_id);
                request.setAttribute("whether-department", department_details);
                if(department_details != null)
                {
                    request.setAttribute("department", department);
                    request.setAttribute("designation", designation);
                }
                request.setAttribute("whether-qualification", qualification_details);
                if(qualification_details != null)
                {
                    request.setAttribute("x-year", String.valueOf(x_year));
                    request.setAttribute("x-marks", String.valueOf(x_marks));
                    request.setAttribute("xii-year", String.valueOf(xii_year));
                    request.setAttribute("xii-marks", String.valueOf(xii_marks));
                    request.setAttribute("grad-university", grad_university);
                    request.setAttribute("grad-year", String.valueOf(grad_year));
                    request.setAttribute("grad-marks", String.valueOf(grad_marks));
                }
                RequestDispatcher new_employee = request.getRequestDispatcher("new_employee.jsp");
                new_employee.forward(request, response);
            }
        }
        catch(SQLException e)
        {
            out.write("<h1>Error Code: " + e.getErrorCode() + "</h1>");
            out.write("<h3>Exception: " + e.getClass().getName() + "</h3>");
            out.write("<h4>" + e.getLocalizedMessage() + "</h4>");
            out.write("<h4>SQL State: " + e.getSQLState() + "</h4>");
            out.write("<h2><a href=\"new_employee.jsp\">Back</a></h2>");
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
