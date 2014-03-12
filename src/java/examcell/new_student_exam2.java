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
public class new_student_exam2 extends HttpServlet {
   
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

        String exam_roll_no = null;
        String[] subject = null, sheet_no = null;

        try
        {
            String query, message = "", subject_code = "";
            PreparedStatement execute_query;
            ResultSet result_set;
            int exam_id = 0, degree_id = 0, branch_id = 0, semester = 0;

            exam_roll_no = request.getParameter("exam-roll-no");
            subject = request.getParameterValues("subject");
            sheet_no = request.getParameterValues("sheet-no");

            query = "select * from Student.ExamDetail where ExamRollNo=?";
            execute_query = server.server_connection.prepareStatement(query);
            execute_query.setString(1, exam_roll_no);
            result_set = execute_query.executeQuery();

            if(! result_set.next())
            {
                message += "<li>Exam Roll No. doesn't exists, Enter valid Exam Roll No.</li>";
            }
            else
            {
                exam_id = result_set.getInt("ExamID");
                
                query = "select * from ExamCell.Exam where ExamID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setInt(1, exam_id);
                result_set = execute_query.executeQuery();
                result_set.next();
                degree_id = result_set.getInt("DegreeID");
                branch_id = result_set.getInt("DepartmentID");
                semester = result_set.getInt("Semester");
            }

            ArrayList<String> invalid_subjects = new ArrayList<String>();
            ArrayList<String> invalid_student_subject = new ArrayList<String>();
            ArrayList<String> invalid_sheets = new ArrayList<String>();

            if(subject != null)
            {
                for(String temp : subject)
                {
                    if(temp != null && temp.compareTo("") != 0)
                    {
                        query = "select * from Administration.Subject where ExamCode=?";
                        execute_query = server.server_connection.prepareStatement(query);
                        execute_query.setString(1, temp);
                        result_set = execute_query.executeQuery();
                        if(!result_set.next())
                        {
                            invalid_subjects.add(temp);
                        }
                        else if(exam_id != 0)
                        {
                            subject_code = result_set.getString("SubjectCode");
                            
                            query = "select * from Administration.AllowedSubject where SubjectCode=? and DegreeID=? and DepartmentID=? and Semester=?";
                            execute_query = server.server_connection.prepareStatement(query);
                            execute_query.setString(1, subject_code);
                            execute_query.setInt(2, degree_id);
                            execute_query.setInt(3, branch_id);
                            execute_query.setInt(4, semester);
                            result_set = execute_query.executeQuery();

                            if(!result_set.next())
                            {
                                invalid_student_subject.add(temp);
                            }
                        }
                    }
                }
            }

            if(!invalid_subjects.isEmpty())
            {
                message += "<li>Following Subjects don't exist: <br/>";
                for(String temp : invalid_subjects)
                    message += temp + ", ";
                message += "<br/>Enter valid Subject (Exam Codes).</li>";
            }

            if(!invalid_student_subject.isEmpty())
            {
                message += "<li>Following Subjects are not present for the Student: <br/>";
                for(String temp : invalid_student_subject)
                    message += temp + ", ";
                message += "<br/>Enter valid Subject (Exam Codes) for the Student.</li>";
            }

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
                        if(result_set.next())
                            invalid_sheets.add(temp);

                    }
                }
            }

            if(!invalid_sheets.isEmpty())
            {
                message += "<li>Following Sheets have already been submitted: <br/>";
                for(String temp : invalid_sheets)
                    message += temp + ", ";
                message += "<br/>Enter valid Sheet Number.</li>";
            }

            if(message.length() == 0)
            {
                server.server_connection.setAutoCommit(false);

                query = "insert into ExamCell.StudentExam (ExamRollNo, ExamID, SubjectCode, SheetNo) values (?,?,?,?)";
                execute_query = server.server_connection.prepareStatement(query);
                if(subject != null && sheet_no != null)
                {
                    for(int i=0; i<subject.length; i++)
                    {
                        if(subject[i] != null && subject[i].compareTo("") != 0)
                        {
                            execute_query.setString(1, exam_roll_no);
                            execute_query.setInt(2, exam_id);
                            execute_query.setString(3, subject[i]);
                            execute_query.setString(4, sheet_no[i]);
                            execute_query.addBatch();
                        }
                    }
                }

                execute_query.executeBatch();
                server.server_connection.commit();
                server.server_connection.setAutoCommit(true);

                message = "Student: " + exam_roll_no + " succesfully attempted the following Exam papers:<br/>";
                if(subject != null)
                {
                    for(int i=0; i<subject.length; i++)
                    {
                        if(subject[i] != null && subject[i].compareTo("") != 0)
                            message += subject[i] + " (" + sheet_no[i] + "), ";
                    }
                }
                request.setAttribute("success", message);
                RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                index.forward(request, response);
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("exam-roll-no", exam_roll_no);
                request.setAttribute("subject", subject);
                request.setAttribute("sheet-no", sheet_no);
                RequestDispatcher new_exam_student = request.getRequestDispatcher("new_student_exam.jsp");
                new_exam_student.forward(request, response);
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
                out.write("<h2><a href=\"new_student_exam.jsp\">Back</a></h2>");
            }

            request.setAttribute("error", "Correct the following errors:<br/><br/><li>One or more Sheet Numbers and/or Subjects have been entered multiple times.</li>");
            request.setAttribute("exam-roll-no", exam_roll_no);
            request.setAttribute("subject", subject);
            request.setAttribute("sheet-no", sheet_no);
            RequestDispatcher new_exam_student = request.getRequestDispatcher("new_student_exam.jsp");
            new_exam_student.forward(request, response);
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
