/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package initial;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import javax.servlet.ServletContext;
import java.util.Calendar;
import java.io.*;
import java.sql.*;

/**
 * Web application lifecycle listener.
 * @author Administrator
 */
public class server implements ServletContextListener, HttpSessionListener {

    public static Connection server_connection;

    public void contextInitialized(ServletContextEvent sce) {
        Calendar now = Calendar.getInstance();
        String[] date = {"01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"};
        String[] month = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
        String[] month_value = {"01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"};
        String[] past_year = new String[100];
        String[] future_year = new String[100];

        for(int i=0; i<100; i++)
        {
           past_year[i] = String.valueOf(now.get(Calendar.YEAR) - i);
           future_year[i] = String.valueOf(now.get(Calendar.YEAR) + i);
        }

        try
        {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            server_connection = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;databaseName=ClgMgtSite;","sa","rohit");
        }
        catch(ClassNotFoundException e)
        {
        }
        catch(SQLException e)
        {
        }

        File employee_directory = new File(sce.getServletContext().getRealPath("\\resource") + "\\Employee\\");
        if(employee_directory.exists() == false)
        {
            employee_directory.mkdir();
        }

        File student_directory = new File(sce.getServletContext().getRealPath("\\resource") + "\\Student\\");
        if(student_directory.exists() == false)
        {
            student_directory.mkdir();
        }

        ServletContext param = sce.getServletContext();
        param.setAttribute("date", date);
        param.setAttribute("month", month);
        param.setAttribute("month-value", month_value);
        param.setAttribute("past-year", past_year);
        param.setAttribute("future-year", future_year);
    }

    public void contextDestroyed(ServletContextEvent sce) {
        try
        {
            server_connection.close();
        }
        catch(SQLException e)
        {
        }

        ServletContext param = sce.getServletContext();
        param.removeAttribute("date");
        param.removeAttribute("month");
        param.removeAttribute("month-value");
        param.removeAttribute("past-year");
        param.removeAttribute("future-year");
    }

    public void sessionCreated(HttpSessionEvent se) {
        se.getSession().setAttribute("user", "Guest");
    }

    public void sessionDestroyed(HttpSessionEvent se) {
        se.getSession().removeAttribute("user");
    }
}
