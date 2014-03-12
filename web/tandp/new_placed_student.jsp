<%-- 
    Document   : new_placed_student
    Created on : Jul 1, 2011, 11:51:27 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="initial.server, java.sql.*, java.util.ArrayList" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%!
	String[] get_company_name()
	{
            ArrayList<String> temp_company_name = new ArrayList<String>();
            try
            {
                String query;
                Statement execute_query;
                ResultSet result_set;

                query = "select Name from TandP.CompanyDetails";
                execute_query = server.server_connection.createStatement();
                result_set = execute_query.executeQuery(query);

                while(result_set.next())
                    temp_company_name.add(result_set.getString("Name"));
            }
            catch(SQLException e)
            {
            }

            int i = 0;
            String[] company_name = new String[temp_company_name.size()];
            for(String temp : temp_company_name)
                company_name[i++] = temp;

            return company_name;
	}
%>

<%
    String valid_user = request.getSession().getAttribute("user").toString();
    boolean valid = false;
    if(valid_user.compareTo("Administrator") == 0)
       valid = true;
    else if(valid_user.compareTo("Administration") == 0)
       valid = true;
    else if(valid_user.compareTo("Training and Placement") == 0)
       valid = true;
    if(valid == false)
      response.sendRedirect("/ClgMgtSite/general/login.jsp");
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>College Management System</title>
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/general.css" />
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/input.css" />
        <script type="text/javascript">
            <!--
            function validate()
            {
                var errors_tag = document.getElementById("errors");
                var roll_no = document.getElementsByName("roll-no");
                var designation = document.getElementsByName("designation");
                var package_ = document.getElementsByName("package");
                var count = roll_no.length;
                var error = new Boolean();

                errors_tag.innerHTML = "Correct the following errors:<br/><br/>";
                error = false;

                for(var i=0; i<count; i++)
                {
                    if(roll_no[i].value != null && roll_no[i].value != "")
                    {
                        if(designation[i].value == "" || designation[i].value == null)
                        {
                            errors_tag.innerHTML += "<li>Designation can't be left blank for any Student (Roll Number).</li>";
                            error = true;
                        }
                        if(package_[i].value == "" || package_[i].value == null)
                        {
                            errors_tag.innerHTML += "<li>Package can't be left blank for any Student (Roll Number).</li>";
                            error = true;
                        }
                        else if(isNaN(package_[i].value))
                        {
                             errors_tag.innerHTML += "<li>Package must be a valid number for every Student (Roll Number).</li>";
                             error = true;
                        }
                        else if(package_[i].value <= 0)
                        {
                             errors_tag.innerHTML += "<li>Package must be greater than 0 for every Student (Roll Number).</li>";
                             error = true;
                        }
                    }

                    if(error == true)
                        break;
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

            function add_new_student()
            {
                var span_sheet = document.getElementById("add-roll-no");
                var input = document.createElement("input");
                input.type= "textbox";
                input.name = "roll-no";
                input.id = "roll-no";
                span_sheet.appendChild(input);
                var break_ = document.createElement("br");
                span_sheet.appendChild(break_);

                var span_marks_obtained = document.getElementById("add-designation");
                var input = document.createElement("input");
                input.type= "textbox";
                input.name = "designation";
                input.id = "designation";
                span_marks_obtained.appendChild(input);
                var break_ = document.createElement("br");
                span_marks_obtained.appendChild(break_);

                var span_marks_obtained = document.getElementById("add-package");
                var input = document.createElement("input");
                input.type= "textbox";
                input.name = "package";
                input.id = "package";
                span_marks_obtained.appendChild(input);
                var break_ = document.createElement("br");
                span_marks_obtained.appendChild(break_);
            }
            -->
        </script>
    </head>
    <%
        String company = "";
        if(request.getAttribute("company") != null)
            company = (String)request.getAttribute("company");

        String[] roll_no = null;
        if(request.getAttribute("roll-no") != null)
            roll_no = (String [])request.getAttribute("roll-no");

        String[] designation = null;
        if(request.getAttribute("designation") != null)
            designation = (String [])request.getAttribute("designation");

        String[] package_ = null;
        if(request.getAttribute("package") != null)
            package_ = (String [])request.getAttribute("package");

        String[] show_company = get_company_name();
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
                    <h1 class="pagetitle">Placed Students - New</h1>
                    <%
                        if(request.getAttribute("error") != null)
                        {
                    %>
                            <div class="message error"><%= (String)request.getAttribute("error") %></div>
                    <%
                        }
                    %>
                    <div id="errors"></div>
                    <form action="new_placed_student2" method="post" onsubmit="return validate()">
                        <table>
                            <tr>
                                <td>Company</td>
                                <td>
                                    <select name="company" id="company">
                                        <%
                                            for(String temp : show_company)
                                            {
                                        %>
                                                <option value="<%= temp %>" <% if(temp.compareTo(company) == 0) { out.write("selected"); }%> ><%= temp %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <table width="100%">
                                        <tr>
                                            <td>Roll Number</td>
                                            <td>Designation</td>
                                            <td>Package</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span id="add-roll-no">
                                                    <%
                                                        if(roll_no != null)
                                                        {
                                                            for(String temp : roll_no)
                                                            {
                                                    %>
                                                                <input type="textbox" name="roll-no" id="roll-no" value="<%= temp %>" /><br/>
                                                    <%
                                                            }
                                                        }
                                                    %>
                                                </span>
                                            </td>
                                            <td>
                                                <span id="add-designation">
                                                    <%
                                                        if(designation != null)
                                                        {
                                                            for(String temp : designation)
                                                            {
                                                    %>
                                                                <input type="textbox" name="designation" id="designation" value="<%= temp %>" /><br/>
                                                    <%
                                                            }
                                                        }
                                                    %>
                                                </span>
                                            </td>
                                            <td>
                                                <span id="add-package">
                                                    <%
                                                        if(package_ != null)
                                                        {
                                                            for(String temp : package_)
                                                            {
                                                    %>
                                                                <input type="textbox" name="package" id="package" value="<%= temp %>" /><br/>
                                                    <%
                                                            }
                                                        }
                                                    %>
                                                </span>
                                            </td>
                                            <td style="vertical-align: bottom;">
                                                <input type="button" name="add-new" value="Add New Student" onclick="add_new_student()" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="button"><input type="submit" name="enter" value="Enter Details" /></td>
                                <td class="button"><input type="button" name="cancel" value="Cancel" onclick="cancel_page()" /></td>
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
