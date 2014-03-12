<%-- 
    Document   : new_employee
    Created on : Jun 29, 2011, 12:18:20 AM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="initial.server, java.sql.*, java.util.ArrayList, java.io.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%!
	String[] get_department_name()
	{
            ArrayList<String> temp_department_name = new ArrayList<String>();
            try
            {
                String query;
                Statement execute_query;
                ResultSet result_set;

                query = "select Name from Administration.Department";
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
%>

<%
    String valid_user = request.getSession().getAttribute("user").toString();
    boolean valid = false;
    if(valid_user.compareTo("Administrator") == 0)
       valid = true;
    if(valid == false)
      response.sendRedirect("/CollegeMgtSite/general/login.jsp");
%>

<%
    String contentType = request.getContentType();
    String employee_file = "";
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

        employee_file = file.substring(file.indexOf("filename=\"") + 10);
        employee_file = employee_file.substring(0, employee_file.indexOf("\n"));
        employee_file = employee_file.substring(employee_file.lastIndexOf("\\") + 1, employee_file.indexOf("\""));
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

        String str = getServletContext().getRealPath("\\resource\\Employee") + "\\" + employee_file;

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
        <title>College Management System - New Employee</title>
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
                var employee_id = document.getElementById("employee-id");
                var name = document.getElementById("name");
                var father_name = document.getElementById("father-name");
                var mother_name = document.getElementById("mother-name");
                var address = document.getElementById("address");
                var gender_male = document.getElementById("gender-male");
                var gender_female = document.getElementById("gender-female");
                var date = document.getElementById("date");
                var month = document.getElementById("month");
                var year = document.getElementById("year");
                var department_details = document.getElementById("whether-department");
                var designation = document.getElementById("designation");
                var qualification_details = document.getElementById("whether-qualification");
                var x_marks = document.getElementById("x-marks");
                var x_year = document.getElementById("x-year");
                var xii_marks = document.getElementById("xii-marks");
                var xii_year = document.getElementById("xii-year");
                var grad_marks = document.getElementById("grad-marks");
                var grad_year = document.getElementById("grad-year");
                var grad_university = document.getElementById("grad-university");
                var error = new Boolean();
                var day = new Date(year.value, month.value-1, date.value);

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";

                if(employee_id.value == "" || employee_id.value == null)
                {
                    errors_tag.innerHTML += "<li>Employee ID can't be left blank.</li>";
                    error = true;
                }
                if(name.value == "" || name.value == null)
                {
                    errors_tag.innerHTML += "<li>Employee's Name can't be left blank.</li>";
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
                if(department_details.checked)
                {
                   if(designation.value == "" || designation.value == null)
                   {
                        errors_tag.innerHTML += "<li>Designation can't be left blank.</li>";
                        error = true;
                   }
                }
                if(qualification_details.checked)
                {
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
                   if(xii_marks.value == "" || xii_marks.value == null)
                   {
                        errors_tag.innerHTML += "<li>XII<sup>th</sup> Marks can't be left blank.</li>";
                        error = true;
                   }
                   else if(isNaN(xii_marks.value))
                   {
                        errors_tag.innerHTML += "<li>XII<sup>th</sup> Marks must be a valid number.</li>";
                        error = true;
                   }
                   else if(xii_marks.value > 100 || xii_marks.value < 0)
                   {
                        errors_tag.innerHTML += "<li>XII<sup>th</sup> Marks must be between 0 and 100.</li>";
                        error = true;
                   }
                   if(grad_marks.value == "" || grad_marks.value == null)
                   {
                        errors_tag.innerHTML += "<li>Graduation Marks can't be left blank.</li>";
                        error = true;
                   }
                   else if(isNaN(grad_marks.value))
                   {
                        errors_tag.innerHTML += "<li>Graduation Marks must be a valid number.</li>";
                        error = true;
                   }
                   else if(grad_marks.value > 100 || grad_marks.value < 0)
                   {
                        errors_tag.innerHTML += "<li>Graduation Marks must be between 0 and 100.</li>";
                        error = true;
                   }
                   if(grad_university.value == "" || grad_university.value == null)
                   {
                        errors_tag.innerHTML += "<li>Graduation University can't be left blank.</li>";
                        error = true;
                   }
                   if(x_year.value >= xii_year.value)
                   {
                        errors_tag.innerHTML += "<li>X<sup>th</sup> Year can't be greater than XII<sup>th</sup> Year</li>";
                        error = true;
                   }
                   if(xii_year.value >= grad_year.value)
                   {
                        errors_tag.innerHTML += "<li>XII<sup>th</sup> Year can't be greater than Graduation Year</li>";
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

            function show_hide_department()
            {
                var department_block = document.getElementById("department-details");
                if(department_block.style.visibility == "hidden")
                {
                    department_block.style.visibility = "visible";
                    department_block.style.display = "block";
                }
                else
                {
                    department_block.style.visibility = "hidden";
                    department_block.style.display = "none";
                }
            }

            function show_hide_qualification()
            {
                var qualification_block = document.getElementById("qualification-details");
                if(qualification_block.style.visibility == "hidden")
                {
                    qualification_block.style.visibility = "visible";
                    qualification_block.style.display = "block";
                }
                else
                {
                    qualification_block.style.visibility = "hidden";
                    qualification_block.style.display = "none";
                }
            }
            -->
        </script>
    </head>
    <%
        String employee_id = "";
        if(request.getAttribute("employee-id") != null)
            employee_id = (String)request.getAttribute("employee-id");

        String name = "";
        if(request.getAttribute("name") != null)
            name = (String)request.getAttribute("name");

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

        String department_details = "";
        if(request.getAttribute("whether-department") != null)
            department_details = (String)request.getAttribute("whether-department");

        String department = "";
        if(request.getAttribute("department") != null)
            department = (String)request.getAttribute("department");

        String designation = "";
        if(request.getAttribute("designation") != null)
            designation = (String)request.getAttribute("designation");

        String qualification_details = "";
        if(request.getAttribute("whether-qualification") != null)
            qualification_details = (String)request.getAttribute("whether-qualification");

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

        String grad_university = "";
        if(request.getAttribute("grad-university") != null)
            grad_university = (String)request.getAttribute("grad-university");

        String grad_year = "";
        if(request.getAttribute("grad-year") != null)
            grad_year = (String)request.getAttribute("grad-year");

        String grad_marks = "";
        if(request.getAttribute("grad-marks") != null)
            grad_marks = (String)request.getAttribute("grad-marks");

        String[] show_date = (String [])getServletContext().getAttribute("date");
        String[] show_month = (String [])getServletContext().getAttribute("month");
        String[] show_month_value = (String [])getServletContext().getAttribute("month-value");
        String[] show_year = (String [])getServletContext().getAttribute("past-year");
        String[] show_department = get_department_name();
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
                    <h1 class="pagetitle">Employee - New</h1>
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
                            <form action="new_employee.jsp" enctype="multipart/form-data" method="post" id="photo-form">
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
                    <form action="new_employee2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td>Employee ID</td>
                                <td><input type="textbox" name="employee-id" id="employee-id" value="<%= employee_id %>" /></td>
                                <td>Employee's Name</td>
                                <td><input type="textbox" name="name" id="name" value="<%= name %>" </td>
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
                                            for(int i=0; i<100; i++)
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
                            <%
                                if(photo_exists == true)
                                {
                            %>
                                    <tr>
                                        <td>Photo</td>
                                        <td><input type="textbox" name="photo" id="photo" readonly value="<%= getServletContext().getContextPath()+"/resource/Employee/" + employee_file %>" /></td>
                                    </tr>
                            <%
                                }
                            %>
                            <tr>
                                <td colspan="4"><input type="checkbox" name="whether-department" id="whether-department" value="Department Details" onchange="show_hide_department()" <% if(department_details.compareTo("Department Details") == 0) { out.write("checked"); }%> />Department Details</td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <span id="department-details" <% if(department_details.compareTo("Department Details") == 0) { out.write("style=\"display: block; visibility: visible\""); }
                                                                    else { out.write("style=\"display: none; visibility: hidden\""); } %> >
                                        <fieldset>
                                            <legend>Department Details</legend>
                                            <table width="100%">
                                                <tr>
                                                    <td>Department</td>
                                                    <td>
                                                        <select name="department" id="department">
                                                            <%
                                                                for(String temp : show_department)
                                                                {
                                                            %>
                                                                    <option value="<%= temp %>" <% if(temp.compareTo(department) == 0) { out.write("selected"); }%> ><%= temp %></option>
                                                            <%
                                                                }
                                                            %>
                                                        </select>
                                                    </td>
                                                    <td>Designation</td>
                                                    <td><input type="textbox" name="designation" id="designation" value="<%= designation %>" /></td>
                                                </tr>
                                            </table>
                                        </fieldset>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <td colspan ="4"><input type="checkbox" name="whether-qualification" id="whether-qualification" value="Qualification Details" onchange="show_hide_qualification()" <% if(qualification_details.compareTo("Qualification Details") == 0) { out.write("checked"); }%> />Educational Qualification Details</td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <span id="qualification-details" <% if(qualification_details.compareTo("Qualification Details") == 0) { out.write("style=\"display: block; visibility: visible\""); }
                                                                    else { out.write("style=\"display: none; visibility: hidden\""); } %> >
                                        <fieldset>
                                            <legend>Educational Details</legend>
                                            <table width="100%">
                                                <tr>
                                                    <td>X<sup>th</sup> Year</td>
                                                    <td>
                                                        <select name="x-year" id="x-year">
                                                            <%
                                                                for(int i=0; i<50; i++)
                                                                {
                                                            %>
                                                                    <option value="<%= show_year[i] %>" <% if(show_year[i].compareTo(x_year) == 0) { out.write("selected"); }%> ><%= show_year[i] %></option>
                                                            <%
                                                                }
                                                            %>
                                                        </select>
                                                    </td>
                                                    <td>X<sup>th</sup> Marks</td>
                                                    <td><input type="textbox" name="x-marks" id="x-marks" value="<%= x_marks %>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>XII<sup>th</sup> Year</td>
                                                    <td>
                                                        <select name="xii-year" id="xii-year">
                                                            <%
                                                                for(int i=0; i<50; i++)
                                                                {
                                                            %>
                                                                    <option value="<%= show_year[i] %>" <% if(show_year[i].compareTo(xii_year) == 0) { out.write("selected"); }%> ><%= show_year[i] %></option>
                                                            <%
                                                                }
                                                            %>
                                                        </select>
                                                    </td>
                                                    <td>XII<sup>th</sup> Marks</td>
                                                    <td><input type="textbox" name="xii-marks" id="xii-marks" value="<%= xii_marks %>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Graduation University</td>
                                                    <td colspan="3"><input type="textbox" name="grad-university" id="grad-university" value="<%= grad_university %>" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Graduation Year</td>
                                                    <td>
                                                        <select name="grad-year" id="grad-year">
                                                            <%
                                                                for(int i=0; i<50; i++)
                                                                {
                                                            %>
                                                                    <option value="<%= show_year[i] %>" <% if(show_year[i].compareTo(grad_year) == 0) { out.write("selected"); }%> ><%= show_year[i] %></option>
                                                            <%
                                                                }
                                                            %>
                                                        </select>
                                                    </td>
                                                    <td>Graduation Marks</td>
                                                    <td><input type="textbox" name="grad-marks" id="grad-marks" value="<%= grad_marks %>" /></td>
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
