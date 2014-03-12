<%-- 
    Document   : new_student
    Created on : Jun 29, 2011, 11:21:31 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="initial.server, java.sql.*, java.util.ArrayList, java.io.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%!
	String[] get_degree_name()
	{
            ArrayList<String> temp_degree_name = new ArrayList<String>();
            try
            {
                String query;
                Statement execute_query;
                ResultSet result_set;

                query = "select SDegree from Administration.Degree";
                execute_query = server.server_connection.createStatement();
                result_set = execute_query.executeQuery(query);

                while(result_set.next())
                    temp_degree_name.add(result_set.getString("SDegree"));
            }
            catch(SQLException e)
            {
            }

            int i = 0;
            String[] degree_name = new String[temp_degree_name.size()];
            for(String temp : temp_degree_name)
                degree_name[i++] = temp;

            return degree_name;
	}

	String[] get_branch_name()
	{
            ArrayList<String> temp_department_name = new ArrayList<String>();
            try
            {
                String query;
                Statement execute_query;
                ResultSet result_set;

                query = "select Name from Administration.Department where Type=\'Education\'";
                execute_query = server.server_connection.createStatement();
                result_set = execute_query.executeQuery(query);

                while(result_set.next())
                    temp_department_name.add(result_set.getString("Name"));
            }
            catch(SQLException e)
            {
            }

            int i = 0;
            String[] department_name = new String[temp_department_name.size()];
            for(String temp : temp_department_name)
                department_name[i++] = temp;

            return department_name;
	}

        String[] get_batch_details()
	{
            ArrayList<String> temp_batch_details = new ArrayList<String>();
            try
            {
                String query;
                Statement execute_query;
                ResultSet result_set;

                query = "select * from Administration.Batch";
                execute_query = server.server_connection.createStatement();
                result_set = execute_query.executeQuery(query);

                while(result_set.next())
                    temp_batch_details.add(result_set.getString("StartYear") + " - " + result_set.getString("EndYear"));
            }
            catch(SQLException e)
            {
            }

            int i = 0;
            String[] batch_details = new String[temp_batch_details.size()];
            for(String temp : temp_batch_details)
                batch_details[i++] = temp;

            return batch_details;
	}
%>

<%
    String valid_user = request.getSession().getAttribute("user").toString();
    boolean valid = false;
    if(valid_user.compareTo("Administrator") == 0)
       valid = true;
    if(valid == false)
      response.sendRedirect("/ClgMgtSite/general/login.jsp");
%>

<%
    String contentType = request.getContentType();
    String student_file = "";
    boolean photo_exists = false;

    if ((contentType != null) && (contentType.indexOf("multipart/form-data") >= 0))
    {
        DataInputStream in = new DataInputStream(request.getInputStream());

        int formDataLength = request.getContentLength();
        byte dataBytes[] = new byte[formDataLength];
        int byteRead = 0;
        int totalBytesRead = 0;

        while (totalBytesRead < formDataLength)
        {
            byteRead = in.read(dataBytes, totalBytesRead, formDataLength);
            totalBytesRead += byteRead;
        }

        String file = new String(dataBytes);

        student_file = file.substring(file.indexOf("filename=\"") + 10);
        student_file = student_file.substring(0, student_file.indexOf("\n"));
        student_file = student_file.substring(student_file.lastIndexOf("\\") + 1, student_file.indexOf("\""));
        int lastIndex = contentType.lastIndexOf("=");
        String boundary = contentType.substring(lastIndex + 1, contentType.length());
        int pos;

        pos = file.indexOf("filename=\"");
        pos = file.indexOf("\n", pos) + 1;
        pos = file.indexOf("\n", pos) + 1;
        pos = file.indexOf("\n", pos) + 1;
        int boundaryLocation = file.indexOf(boundary, pos) - 4;
        int startPos = ((file.substring(0, pos)).getBytes()).length;
        int endPos = ((file.substring(0, boundaryLocation)).getBytes()).length;

        String str = getServletContext().getRealPath("\\resource\\Student") + "\\" + student_file;

        FileOutputStream fileOut = new FileOutputStream(str);
        fileOut.write(dataBytes, startPos, (endPos - startPos));
        fileOut.flush();
        fileOut.close();

        photo_exists = true;
    }
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>College Management System</title>
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/general.css" />
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/input.css" />
        <script type="text/javascript">
            <!--
            function check_photo()
            {
                var photo = document.getElementById("photo").value;
                if(photo.value != '')
                {
                    var extensions = /(.jpg|.jpeg|.gif|.bmp|.png|.dib|.jpe|.jfif|.tif|.tiff)$/i;
                    if(extensions.test(photo) == false)
                    {
                        alert("Selected file may not be an image, Select correct file.");
                    }
                    else
                    {
                        document.getElementById("photo-form").submit();
                    }
                }
            }

            function validate()
            {
                var errors_tag = document.getElementById("errors");
                var student_name = document.getElementById("student-name");
                var roll_no = document.getElementById("roll-no");
                var father_name = document.getElementById("father-name");
                var mother_name = document.getElementById("mother-name");
                var address = document.getElementById("address");
                var gender_male = document.getElementById("gender-male");
                var gender_female = document.getElementById("gender-female");
                var date = document.getElementById("date");
                var month = document.getElementById("month");
                var year = document.getElementById("year");
                var x_year = document.getElementById("x-year");
                var x_marks = document.getElementById("x-marks");
                var xii_year = document.getElementById("xii-year");
                var xii_marks = document.getElementById("xii-marks");
                var entrance_exam = document.getElementById("entrance-exam");
                var ee_roll_no = document.getElementById("ee-roll-no");
                var ee_score = document.getElementById("ee-score");
                var ee_rank = document.getElementById("ee-rank");
                var diploma_details = document.getElementById("whether-diploma");
                var diploma_college = document.getElementById("diploma-college");
                var diploma_branch = document.getElementById("diploma-branch");
                var diploma_year = document.getElementById("diploma-year");
                var diploma_marks = document.getElementById("diploma-marks");
                var error = new Boolean();
                var day = new Date(year.value, month.value-1, date.value);

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";

                if(student_name.value == "" || student_name.value == null)
                {
                    errors_tag.innerHTML += "<li>Student's Name can't be left blank.</li>";
                    error = true;
                }
                if(roll_no.value == "" || roll_no.value == null)
                {
                    errors_tag.innerHTML += "<li>Roll Number can't be left blank.</li>";
                    error = true;
                }
                if(father_name.value == "" || father_name.value == null)
                {
                    errors_tag.innerHTML += "<li>Father's Name can't be left blank.</li>";
                    error = true;
                }
                if(mother_name.value == "" || mother_name.value == null)
                {
                    errors_tag.innerHTML += "<li>Mother's Name can't be left blank.</li>";
                    error = true;
                }
                if(address.value == "" || address.value == null)
                {
                    errors_tag.innerHTML += "<li>Address can't be left blank.</li>";
                    error = true;
                }
                if((!gender_male.checked) && (!gender_female.checked))
                {
                    errors_tag.innerHTML += "<li>Gender can't be left unmarked.</li>";
                    error = true;
                }
                if((day.getMonth()+1 != month.value) || (day.getDate() != date.value) || (day.getFullYear() != year.value))
                {
                    errors_tag.innerHTML += "<li>Date of Birth is not valid.</li>";
                    error = true;
                }
                if(x_marks.value == "" || x_marks.value == null)
                {
                    errors_tag.innerHTML += "<li>X<sup>th</sup> Marks can't be left blank.</li>";
                    error = true;
                }
                else if(isNaN(x_marks.value))
                {
                     errors_tag.innerHTML += "<li>X<sup>th</sup> Marks must be a valid number.</li>";
                     error = true;
                }
                else if(x_marks.value > 100 || x_marks.value < 0)
                {
                     errors_tag.innerHTML += "<li>X<sup>th</sup> Marks must be between 0 and 100.</li>";
                     error = true;
                }
                if(entrance_exam.value == "" || entrance_exam.value == null)
                {
                     errors_tag.innerHTML += "<li>Entrance Exam can't be left blank.</li>";
                     error = true;
                }
                if(ee_roll_no.value == "" || ee_roll_no.value == null)
                {
                     errors_tag.innerHTML += "<li>EE Roll No. can't be left blank.</li>";
                     error = true;
                }
                if(ee_score.value == "" || ee_score.value == null)
                {
                     errors_tag.innerHTML += "<li>EE Score can't be left blank.</li>";
                     error = true;
                }
                else if(isNaN(ee_score.value))
                {
                     errors_tag.innerHTML += "<li>EE Score must be a valid number.</li>";
                     error = true;
                }
                if(ee_rank.value == "" || ee_rank.value == null)
                {
                     errors_tag.innerHTML += "<li>EE Rank can't be left blank.</li>";
                     error = true;
                }
                else if(isNaN(ee_rank.value))
                {
                     errors_tag.innerHTML += "<li>EE Rank must be a valid number.</li>";
                     error = true;
                }
                else if(ee_rank.value < 0)
                {
                     errors_tag.innerHTML += "<li>EE Rank must be greater than 0.</li>";
                     error = true;
                }
                if(diploma_details.checked)
                {
                    if(diploma_college.value == "" || diploma_college.value == null)
                    {
                         errors_tag.innerHTML += "<li>Diploma College can't be left blank.</li>";
                         error = true;
                    }
                    if(diploma_branch.value == "" || diploma_branch.value == null)
                    {
                         errors_tag.innerHTML += "<li>Diploma Branch can't be left blank.</li>";
                         error = true;
                    }
                    if(diploma_marks.value == "" || diploma_marks.value == null)
                    {
                         errors_tag.innerHTML += "<li>Diploma Marks can't be left blank.</li>";
                         error = true;
                    }
                    else if(isNaN(diploma_marks.value))
                    {
                         errors_tag.innerHTML += "<li>Diploma Marks must be a valid number.</li>";
                         error = true;
                    }
                    else if(diploma_marks.value > 100 || diploma_marks.value < 0)
                    {
                         errors_tag.innerHTML += "<li>Diploma Marks must be between 0 and 100.</li>";
                         error = true;
                    }
                    if(xii_marks.value != "" && xii_marks.value != null)
                    {
                        if(xii_marks.value == "" || xii_marks.value == null)
                        {
                             errors_tag.innerHTML += "<li>XII<sup>th</sup> Marks can't be left blank.</li>";
                             error = true;
                        }
                        if(isNaN(xii_marks.value))
                        {
                             errors_tag.innerHTML += "<li>XII<sup>th</sup> Marks must be a valid number.</li>";
                             error = true;
                        }
                        else if(xii_marks.value > 100 || xii_marks.value < 0)
                        {
                             errors_tag.innerHTML += "<li>XII<sup>th</sup> Marks must be between 0 and 100.</li>";
                             error = true;
                        }
                        if(xii_year.value >= diploma_year.value)
                        {
                             errors_tag.innerHTML += "<li>XII<sup>th</sup> Year can't be greater than Diploma Year.</li>";
                             error = true;
                        }
                    }
                    else if(x_year.value >= diploma_year.value)
                    {
                         errors_tag.innerHTML += "<li>X<sup>th</sup> Year can't be greater than Diploma Year.</li>";
                         error = true;
                    }
                }
                else if(!diploma_details.checked)
                {
                    if(xii_marks.value == "" || xii_marks.value == null)
                    {
                         errors_tag.innerHTML += "<li>XII<sup>th</sup> Marks can't be left blank.</li>";
                         error = true;
                    }
                    if(isNaN(xii_marks.value))
                    {
                         errors_tag.innerHTML += "<li>XII<sup>th</sup> Marks must be a valid number.</li>";
                         error = true;
                    }
                    else if(xii_marks.value > 100 || xii_marks.value < 0)
                    {
                         errors_tag.innerHTML += "<li>XII<sup>th</sup> Marks must be between 0 and 100.</li>";
                         error = true;
                    }
                    if(x_year.value >= xii_year.value)
                    {
                         errors_tag.innerHTML += "<li>X<sup>th</sup> Year can't be greater than XII<sup>th</sup> Year.</li>";
                         error = true;
                    }
                }

                if(error == true)
                {
                    errors_tag.className = "internal-error";
                    return false;
                }
                else
                {
                    errors_tag.className = "";
                    errors_tag.style.display = "none";
                    return true;
                }
            }

            function limit_text()
            {
                var maxlength = 150;
                var address = document.getElementById("address");
                if (address.value.length > maxlength)
                    address.value = address.value.substring(0, maxlength);
            }

            function show_hide_diploma()
            {
                var diploma_block = document.getElementById("diploma-details");
                if(diploma_block.style.visibility == "hidden")
                {
                    diploma_block.style.visibility = "visible";
                    diploma_block.style.display = "block";
                }
                else
                {
                    diploma_block.style.visibility = "hidden";
                    diploma_block.style.display = "none";
                }
            }
            -->
        </script>
    </head>
    <%
        String student_name = "";
        if(request.getAttribute("student-name") != null)
            student_name = (String)request.getAttribute("student-name");

        String roll_no = "";
        if(request.getAttribute("roll-no") != null)
            roll_no = (String)request.getAttribute("roll-no");

        String father_name = "";
        if(request.getAttribute("father-name") != null)
            father_name = (String)request.getAttribute("father-name");

        String mother_name = "";
        if(request.getAttribute("mother-name") != null)
            mother_name = (String)request.getAttribute("mother-name");

        String address = "";
        if(request.getAttribute("address") != null)
            address = (String)request.getAttribute("address");

        String gender = "";
        if(request.getAttribute("gender") != null)
            gender = (String)request.getAttribute("gender");

        String date = "";
        if(request.getAttribute("date") != null)
            date = (String)request.getAttribute("date");

        String month = "";
        if(request.getAttribute("month") != null)
            month = (String)request.getAttribute("month");

        String year = "";
        if(request.getAttribute("year") != null)
            year = (String)request.getAttribute("year");

        String contact_no = "";
        if(request.getAttribute("contact-no") != null)
            contact_no = (String)request.getAttribute("contact-no");

        String email_id = "";
        if(request.getAttribute("email-id") != null)
            email_id = (String)request.getAttribute("email-id");

        String category = "";
        if(request.getAttribute("category") != null)
            category = (String)request.getAttribute("category");

        String counselling = "";
        if(request.getAttribute("counselling") != null)
            counselling = (String)request.getAttribute("counselling");

        String batch = "";
        if(request.getAttribute("batch") != null)
            batch = (String)request.getAttribute("batch");

        String degree = "";
        if(request.getAttribute("degree") != null)
            degree = (String)request.getAttribute("degree");

        String branch = "";
        if(request.getAttribute("branch") != null)
            branch = (String)request.getAttribute("branch");

        String x_year = "";
        if(request.getAttribute("x-year") != null)
            x_year = (String)request.getAttribute("x-year");

        String x_marks = "";
        if(request.getAttribute("x-marks") != null)
            x_marks = (String)request.getAttribute("x-marks");

        String xii_year = "";
        if(request.getAttribute("xii-year") != null)
            xii_year = (String)request.getAttribute("xii-year");

        String xii_marks = "";
        if(request.getAttribute("xii-marks") != null)
            xii_marks = (String)request.getAttribute("xii-marks");

        String entrance_exam = "";
        if(request.getAttribute("entrance-exam") != null)
            entrance_exam = (String)request.getAttribute("entrance-exam");

        String ee_roll_no = "";
        if(request.getAttribute("ee-roll-no") != null)
            ee_roll_no = (String)request.getAttribute("ee-roll-no");

        String ee_score = "";
        if(request.getAttribute("ee-score") != null)
            ee_score = (String)request.getAttribute("ee-score");

        String ee_rank = "";
        if(request.getAttribute("ee-rank") != null)
            ee_rank = (String)request.getAttribute("ee-rank");

        String diploma_details = "";
        if(request.getAttribute("whether-diploma") != null)
            diploma_details = (String)request.getAttribute("whether-diploma");

        String diploma_college = "";
        if(request.getAttribute("diploma-college") != null)
            diploma_college = (String)request.getAttribute("diploma-college");

        String diploma_branch = "";
        if(request.getAttribute("diploma-branch") != null)
            diploma_branch = (String)request.getAttribute("diploma-branch");

        String diploma_year = "";
        if(request.getAttribute("diploma-year") != null)
            diploma_year = (String)request.getAttribute("diploma-year");

        String diploma_marks = "";
        if(request.getAttribute("diploma-marks") != null)
            diploma_marks = (String)request.getAttribute("diploma-marks");

        String[] show_date = (String [])getServletContext().getAttribute("date");
        String[] show_month = (String [])getServletContext().getAttribute("month");
        String[] show_month_value = (String [])getServletContext().getAttribute("month-value");
        String[] show_year = (String [])getServletContext().getAttribute("past-year");
	String[] show_degree = get_degree_name();
	String[] show_branch = get_branch_name();
        String[] show_batch = get_batch_details();
    %>
    <body>
        <div class="page-container">
            <div class="header">
                <%@include file="/WEB-INF/resource/header.jspf" %>
            </div>
            <div>
                <%@include file="/WEB-INF/resource/menubar.jspf" %>
            </div>
            <div class="main">
                <div class="main-navigation">
                    <%@include file="/WEB-INF/resource/navigationbar.jspf" %>
                </div>
                <div class="main-content">
                    <h1 class="pagetitle">Student - New</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <%
                        if(photo_exists == false)
                        {
                    %>
                            <form action="new_student.jsp" enctype="multipart/form-data" method="post" id="photo-form">
                                <table>
                                    <tr>
                                        <td>Photo</td>
                                        <td><input type="file" name="photo" id="photo" onchange="check_photo()" /></td>
                                    </tr>
                                </table>
                            </form>
                    <%
                        }
                    %>
                    <form action="new_student2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td colspan="4">Personal Details</td>
                            </tr>
                            <tr>
                                <td>Student's Name</td>
                                <td><input type="textbox" name="student-name" id="student-name" value="<%= student_name %>" /></td>
                                <td>Roll Number</td>
                                <td><input type="textbox" name="roll-no" id="roll-no" value="<%= roll_no %>" /></td>
                            </tr>
                            <tr>
                                <td>Father's Name</td>
                                <td><input type="textbox" name="father-name" id="father-name" value="<%= father_name %>" /></td>
                                <td>Mother's Name</td>
                                <td><input type="textbox" name="mother-name" id="mother-name" value="<%= mother_name %>" /></td>
                            </tr>
                            <tr>
                                <td>Address</td>
                                <td>
                                    <textarea name="address" id="address" rows="4" cols="25" onkeypress="limit_text()"><%= address %></textarea>
                                </td>
                                <td>Gender</td>
                                <td>
                                    <input type="radio" name="gender" id="gender-male" value="Male" <% if(gender.compareTo("Male") == 0) { out.write("checked"); }%> />Male
                                    <input type="radio" name="gender" id="gender-female" value="Female" <% if(gender.compareTo("Female") == 0) { out.write("checked"); }%> />Female
                                </td>
                            </tr>
                            <tr>
                                <td>Date of Birth</td>
                                <td>
                                    <select name="date" id="date">
                                        <%
                                            for(int i=0; i<31; i++)
                                            {
                                        %>
                                                <option value="<%= show_date[i] %>" <% if(show_date[i].compareTo(date) == 0) { out.write("selected"); }%> ><%= show_date[i] %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                    <select name="month" id="month">
                                        <%
                                            for(int i=0; i<12; i++)
                                            {
                                        %>
                                                <option value="<%= show_month_value[i] %>" <% if(show_month_value[i].compareTo(month) == 0) { out.write("selected"); }%> ><%= show_month[i] %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                    <select name="year" id="year">
                                        <%
                                            for(int i=0; i<50; i++)
                                            {
                                        %>
                                                <option value="<%= show_year[i] %>" <% if(show_year[i].compareTo(year) == 0) { out.write("selected"); }%> ><%= show_year[i] %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>Contact No.</td>
                                <td><input type="textbox" name="contact-no" id="contact-no" value="<%= contact_no %>" /></td>
                                <td>EMail ID</td>
                                <td><input type="textbox" name="email-id" id="email-id" value="<%= email_id %>" /></td>
                            </tr>
                            <tr>
                                <td>Category</td>
                                <td>
                                    <select name="category" id="category">
                                        <option <% if(category.compareTo("General") == 0) { out.write("selected"); }%> >General</option>
                                        <option <% if(category.compareTo("SC/ST") == 0) { out.write("selected"); }%> >SC/ST</option>
                                        <option <% if(category.compareTo("OBC") == 0) { out.write("selected"); }%> >OBC</option>
                                    </select>
                                </td>
                            </tr>
                            <%
                                if(photo_exists == true)
                                {
                            %>
                                    <tr>
                                        <td>Photo</td>
                                        <td><input type="textbox" name="photo" id="photo" readonly value="<%= getServletContext().getContextPath()+"/resource/Student/" + student_file %>" /></td>
                                    </tr>
                            <%
                                }
                            %>
                            <tr>
                                <td colspan="4">Admission Details</td>
                            </tr>
                            <tr>
                                <td>Counseling</td>
                                <td>
                                    <select name="counselling" id="counselling">
                                        <option <% if(counselling.compareTo("1") == 0) { out.write("selected"); }%> >1</option>
                                        <option <% if(counselling.compareTo("2") == 0) { out.write("selected"); }%> >2</option>
                                        <option <% if(counselling.compareTo("3") == 0) { out.write("selected"); }%> >3</option>
                                        <option <% if(counselling.compareTo("4") == 0) { out.write("selected"); }%> >4</option>
                                    </select>
                                </td>
                                <td>Batch</td>
                                <td>
                                    <select name="batch" id="batch">
                                        <%
                                            for(String temp : show_batch)
                                            {
                                        %>
                                                <option value="<%= temp %>" <% if(temp.compareTo(batch) == 0) { out.write("selected"); }%> ><%= temp %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>Degree</td>
                                <td>
                                    <select name="degree" id="degree">
                                        <%
                                            for(String temp : show_degree)
                                            {
                                        %>
                                                <option value="<%= temp %>" <% if(temp.compareTo(degree) == 0) { out.write("selected"); }%> ><%= temp %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                                <td>Branch</td>
                                <td>
                                    <select name="branch" id="branch">
                                        <%
                                            for(String temp : show_branch)
                                            {
                                        %>
                                                <option value="<%= temp %>" <% if(temp.compareTo(branch) == 0) { out.write("selected"); }%> ><%= temp %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>X<sup>th</sup> Year</td>
                                <td>
                                    <select name="x-year" id="x-year">
                                        <%
                                            for(int i=0; i<25; i++)
                                            {
                                        %>
                                                <option value="<%= show_year[i] %>" <% if(show_year[i].compareTo(x_year) == 0) { out.write("selected"); }%> ><%= show_year[i] %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                                <td>X<sup>th</sup> Marks</td>
                                <td><input type="textbox" name="x-marks" id="x-marks" value="<%= x_marks %>" /><td>
                            </tr>
                            <tr>
                                <td>XII<sup>th</sup> Year</td>
                                <td>
                                    <select name="xii-year" id="xii-year">
                                        <%
                                            for(int i=0; i<25; i++)
                                            {
                                        %>
                                                <option value="<%= show_year[i] %>" <% if(show_year[i].compareTo(xii_year) == 0) { out.write("selected"); }%> ><%= show_year[i] %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                                <td>XII<sup>th</sup> Marks</td>
                                <td><input type="textbox" name="xii-marks" id="xii-marks" value="<%= xii_marks %>" /><td>
                            </tr>
                            <tr>
                                <td>Entrance Exam</td>
                                <td><input type="textbox" name="entrance-exam" id="entrance-exam" value="<%= entrance_exam %>" /></td>
                                <td>EE Roll No.</td>
                                <td><input type="textbox" name="ee-roll-no" id="ee-roll-no" value="<%= ee_roll_no %>" /></td>
                            </tr>
                            <tr>
                                <td>EE Score</td>
                                <td><input type="textbox" name="ee-score" id="ee-score" value="<%= ee_score %>" /></td>
                                <td>EE Rank</td>
                                <td><input type="textbox" name="ee-rank" id="ee-rank" value="<%= ee_rank %>" /></td>
                            </tr>
                            <tr>
                                <td colspan="4"><input type="checkbox" name="whether-diploma" id="whether-diploma" value="Diploma Details" onchange="show_hide_diploma()" <% if(diploma_details.compareTo("Diploma Details") == 0) { out.write("checked"); }%> />Diploma Details</td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <span id="diploma-details" <% if(diploma_details.compareTo("Diploma Details") == 0) { out.write("style=\"display: block; visibility: visible\""); }
                                                                else { out.write("style=\"display: none; visibility: hidden\""); } %> >
                                        <fieldset>
                                            <legend>Diploma Details</legend>
                                            <table>
                                                <tr>
                                                    <td>Diploma College</td>
                                                    <td><input type="textbox" name="diploma-college" id="diploma-college" value="<%= diploma_college %>" /></td>
                                                    <td>Diploma Branch</td>
                                                    <td><input type="textbox" name="diploma-branch" id="diploma-branch" value="<%= diploma_branch %>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Diploma Year</td>
                                                    <td>
                                                        <select name="diploma-year" id="diploma-year">
                                                            <%
                                                                for(int i=0; i<25; i++)
                                                                {
                                                            %>
                                                                    <option value="<%= show_year[i] %>" <% if(show_year[i].compareTo(diploma_year) == 0) { out.write("selected"); }%> ><%= show_year[i] %></option>
                                                            <%
                                                                }
                                                            %>
                                                        </select>
                                                    </td>
                                                    <td>Diploma Marks</td>
                                                    <td><input type="textbox" name="diploma-marks" id="diploma-marks" value="<%= diploma_marks %>" /></td>
                                                </tr>
                                            </table>
                                        </fieldset>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <td class="button" colspan="2"><input type="submit" name="enter" value="Enter Details" /></td>
                                <td class="button" colspan="2"><input type="button" name="cancel" value="Cancel" onclick="cancel_page()" /></td>
                            </tr>
                        </table>
                    </form>
                </div>
            </div>
            <div class="footer">
                <%@include file="/WEB-INF/resource/footer.jspf" %>
            </div>
        </div>
    </body>
</html>
