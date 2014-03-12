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
public class new_student2 extends HttpServlet {
   
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
            int degree_id, branch_id, batch_id, start_year, end_year;

            String roll_no = request.getParameter("roll-no");
            String student_name = request.getParameter("student-name");
            String father_name = request.getParameter("father-name");
            String mother_name = request.getParameter("mother-name");
            String address = request.getParameter("address");
            String gender = request.getParameter("gender");
            String date = request.getParameter("date");
            String month = request.getParameter("month");
            String year = request.getParameter("year");
            String contact_no = request.getParameter("contact-no");
            String email_id = request.getParameter("email-id");
            String category = request.getParameter("category");
            String photo = request.getParameter("photo");
            String counselling = request.getParameter("counselling");
            String degree = request.getParameter("degree");
            String branch = request.getParameter("branch");
            String batch = request.getParameter("batch");
            String x_year = request.getParameter("x-year");
            String x_marks = request.getParameter("x-marks");
            String xii_year = request.getParameter("xii-year");
            String xii_marks = request.getParameter("xii-marks");
            String entrance_exam = request.getParameter("entrance-exam");
            String ee_roll_no = request.getParameter("ee-roll-no");
            String ee_score = request.getParameter("ee-score");
            String ee_rank = request.getParameter("ee-rank");
            String diploma_details = request.getParameter("whether-diploma");
            String diploma_college = request.getParameter("diploma-college");
            String diploma_branch = request.getParameter("diploma-branch");
            String diploma_year = request.getParameter("diploma-year");
            String diploma_marks = request.getParameter("diploma-marks");

            start_year = Integer.parseInt(batch.split("-")[0].trim());
            end_year = Integer.parseInt(batch.split("-")[1].trim());

            query = "select * from Student.PersonalDetail where RollNo=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, roll_no);
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>Student with Roll Number already exists. Enter valid Roll Number.</li>";
            }

            query = "select * from Student.PersonalDetail where Name=? and FatherName=? and Address=? and DateOfBirth=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, student_name);
            execute_query.setString(2, father_name);
            execute_query.setString(3, address);
            execute_query.setDate(4, new Date(Integer.parseInt(year) - 1900, Integer.parseInt(month) - 1, Integer.parseInt(date)));
            result_set = execute_query.executeQuery();

            if(result_set.next())
            {
                message += "<li>Student with identical details already exists. Enter valid Student Details.</li>";
            }

            if(message.length() == 0)
            {
                query = "insert into Student.PersonalDetail (Name, FatherName, MotherName, Address, DateofBirth, Gender, ContactNo, EMailID, Category, RollNo, Photo) values (?,?,?,?,?,?,?,?,?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, student_name);
                execute_query.setString(2, father_name);
                execute_query.setString(3, mother_name);
                execute_query.setString(4, address);
                execute_query.setDate(5, new Date(Integer.parseInt(year) - 1900, Integer.parseInt(month) - 1, Integer.parseInt(date)));
                execute_query.setString(6, gender);
                if(contact_no != null && contact_no.compareTo("") != 0)
                    execute_query.setString(7, contact_no);
                else
                    execute_query.setNull(7, java.sql.Types.NULL);
                if(email_id != null && email_id.compareTo("") != 0)
                    execute_query.setString(8, email_id);
                else
                    execute_query.setNull(8, java.sql.Types.NULL);
                execute_query.setString(9, category);
                execute_query.setString(10, roll_no);
                if(photo != null && photo.compareTo("") != 0)
                    execute_query.setString(11, photo);
                else
                    execute_query.setNull(11, java.sql.Types.NULL);
                execute_query.executeUpdate();

                query = "select * from Administration.Degree where SDegree=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, degree);
                result_set = execute_query.executeQuery();
                result_set.next();
                degree_id = result_set.getInt("DegreeID");

                query = "select * from Administration.Department where Name=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, branch);
                result_set = execute_query.executeQuery();
                result_set.next();
                branch_id = result_set.getInt("DepartmentID");

                query = "select * from Administration.Batch where StartYear=? and EndYear=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, start_year);
                execute_query.setInt(2, end_year);
                result_set = execute_query.executeQuery();
                result_set.next();
                batch_id = result_set.getInt("BatchID");

                query = "insert into Student.AdmissionDetail (RollNo, Counselling, BatchID, DegreeID, DepartmentID, XMarks, XYear, XIIMarks, XIIYear, EntranceExam, EERollNo, EEScore, EERank) values (?,?,?,?,?,?,?,?,?,?,?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, roll_no);
                execute_query.setInt(2, Integer.parseInt(counselling));
                execute_query.setInt(3, batch_id);
                execute_query.setInt(4, degree_id);
                execute_query.setInt(5, branch_id);
                execute_query.setInt(6, Integer.parseInt(x_marks));
                execute_query.setInt(7, Integer.parseInt(x_year));
                if(xii_marks != null && xii_marks.compareTo("") != 0)
                {
                    execute_query.setInt(8, Integer.parseInt(xii_marks));
                    execute_query.setInt(9, Integer.parseInt(xii_year));
                }
                else
                {
                    execute_query.setNull(8, java.sql.Types.NULL);
                    execute_query.setNull(9, java.sql.Types.NULL);
                }
                execute_query.setString(10, entrance_exam);
                execute_query.setString(11, ee_roll_no);
                execute_query.setInt(12, Integer.parseInt(ee_score));
                execute_query.setInt(13, Integer.parseInt(ee_rank));
                execute_query.executeUpdate();

                if(diploma_details != null)
                {
                    query = "insert into Student.ExtraAdmissionDetail (RollNo, DiplomaCollege, DiplomaBranch, DiplomaYear, DiplomaMarks) values (?,?,?,?,?)";
                    execute_query = server.server_connection.prepareStatement(query);
                    execute_query.setString(1, roll_no);
                    execute_query.setString(2, diploma_college);
                    execute_query.setString(3, diploma_branch);
                    execute_query.setInt(4, Integer.parseInt(diploma_year));
                    execute_query.setInt(5, Integer.parseInt(diploma_marks));
                    execute_query.executeUpdate();
                }

                request.setAttribute("success", "Student: " + student_name + " (" + roll_no + ") has been created succesfully.");
                RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("roll-no", roll_no);
                request.setAttribute("student-name", student_name);
                request.setAttribute("father-name", father_name);
                request.setAttribute("mother-name", mother_name);
                request.setAttribute("address", address);
                request.setAttribute("gender", gender);
                request.setAttribute("date", date);
                request.setAttribute("month", month);
                request.setAttribute("year", year);
                request.setAttribute("contact-no", contact_no);
                request.setAttribute("email-id", email_id);
                request.setAttribute("category", category);
                request.setAttribute("counselling", counselling);
                request.setAttribute("batch", batch);
                request.setAttribute("degree", degree);
                request.setAttribute("branch", branch);
                request.setAttribute("x-year", x_year);
                request.setAttribute("x-marks", x_marks);
                request.setAttribute("xii-year", xii_year);
                request.setAttribute("xii-marks", xii_marks);
                request.setAttribute("entrance-exam", entrance_exam);
                request.setAttribute("ee-roll-no", ee_roll_no);
                request.setAttribute("ee-score", ee_score);
                request.setAttribute("ee-rank", ee_rank);
                request.setAttribute("whether-diploma", diploma_details);
                if(diploma_details != null)
                {
                    request.setAttribute("diploma-college", diploma_college);
                    request.setAttribute("diploma-branch", diploma_branch);
                    request.setAttribute("diploma-marks", diploma_marks);
                    request.setAttribute("diploma-year", diploma_year);
                }
                RequestDispatcher new_student = request.getRequestDispatcher("new_student.jsp");
                new_student.forward(request, response);
            }
        }
        catch(SQLException e)
        {
            out.write("<h1>Error Code: " + e.getErrorCode() + "</h1>");
            out.write("<h3>Exception: " + e.getClass().getName() + "</h3>");
            out.write("<h4>" + e.getLocalizedMessage() + "</h4>");
            out.write("<h4>SQL State: " + e.getSQLState() + "</h4>");
            out.write("<h2><a href=\"new_student.jsp\">Back</a></h2>");
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
