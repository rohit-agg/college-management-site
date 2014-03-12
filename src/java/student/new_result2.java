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
import java.util.ArrayList;
import java.sql.*;

import initial.server;

/**
 *
 * @author Administrator
 */
public class new_result2 extends HttpServlet {
   
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
            int i, exam_id = 0, marks_obtained = 0;
            ArrayList<String> subject_code = new ArrayList<String>();
            ArrayList<String> sheet_no = new ArrayList<String>();

            String exam_roll_no = request.getParameter("exam-roll-no");
            
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
            }

            if(message.length() == 0)
            {
                query = "select * from ExamCell.StudentExam where ExamRollNo=? and ExamID=?";
                execute_query = server.server_connection.prepareStatement(query);
                execute_query.setString(1, exam_roll_no);
                execute_query.setInt(2, exam_id);
                result_set = execute_query.executeQuery();

                while(result_set.next())
                {
                    subject_code.add(result_set.getString("SubjectCode"));
                    sheet_no.add(result_set.getString("SheetNo"));
                }

                i= 0;
                for(String temp : sheet_no)
                {
                    query = "select * from ExamCell.PaperChecking where SheetNo=?";
                    execute_query = server.server_connection.prepareStatement(query);
                    execute_query.setString(1, temp);
                    result_set = execute_query.executeQuery();

                    if(result_set.next())
                    {
                        marks_obtained = result_set.getInt("MarksObtained");

                        query = "insert into Student.Result (ExamRollNo, SubjectExamCode, MarksObtained) values (?,?,?)";
                        execute_query = server.server_connection.prepareStatement(query);
                        execute_query.setString(1, exam_roll_no);
                        execute_query.setString(2, subject_code.get(i));
                        execute_query.setInt(3, marks_obtained);
                        execute_query.executeUpdate();
                    }

                    i++;

                    request.setAttribute("success", "Result for Student: " + exam_roll_no + " has been succesfully compiled and saved.");
                    RequestDispatcher index = request.getRequestDispatcher("/index.jsp");
                    index.forward(request, response);
                }
            }
            else
            {
                request.setAttribute("error", "Correct the following errors:<br/><br/>" + message);
                request.setAttribute("exam-roll-no", exam_roll_no);
                RequestDispatcher new_result = request.getRequestDispatcher("new_result.jsp");
                new_result.forward(request, response);
            }
        }
        catch(SQLException e)
        {
            out.write("<h1>Error Code: " + e.getErrorCode() + "</h1>");
            out.write("<h3>Exception: " + e.getClass().getName() + "</h3>");
            out.write("<h4>" + e.getLocalizedMessage() + "</h4>");
            out.write("<h4>SQL State: " + e.getSQLState() + "</h4>");
            out.write("<h2><a href=\"new_result.jsp\">Back</a></h2>");
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
