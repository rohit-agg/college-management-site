<%-- 
    Document   : contact
    Created on : Jul 10, 2011, 8:28:34 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>College Management System</title>
        <link rel="stylesheet" type="text/css" href="/ClgMgtSite/resource/general.css" />        
    </head>
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
                    <h1 class="pagetitle">Contact Us</h1>
                    <ol style="font-size: 125%; list-style-image: url(/ClgMgtSite/resource/image/bullet.png);">
                        <li style="margin-left:25px;padding-left:5px;">
                            <p>
                                <b>Lingaya’s University Campus</b><br/><br/>
                                <address>
                                    Nachauli, Jasana Road, Old Faridabad<br/>
                                    Faridabad-121002<br/>
                                </address>
                                <br/>Phone: +91-129-3064500,01,02,03,04,05<br/>
                                Email: lu@lingayasuniversity.edu.in
                            </p>
                        </li>
                        <li style="margin-left: 25px; padding-left: 5px;">
                            <p>
                                <b>Head Office of Lingaya’s University</b><br/><br/>
                                <address>
                                    Lingaya’s House,<br/>
                                    C-72, 2nd Floor, Shivalik,<br/>
                                    Malviya Nagar,<br/>
                                    New Delhi -110017
                                </address>
                                <br/>Phone: +91-11-40719000-99<br/>
                                Fax No.: 40719023<br/>
                            </p>
                        </li>                        
                    </ol>
                    <br/><br/>
                    <center>
                        <h2>Road Map For Campus of Lingaya’s University</h2><br/><br/>
                        <img width="600px" height="500px" src="../resource/image/map.jpg" />
                    </center>
                </div>
            </div>
            <div class="footer">
                <%@include file="/WEB-INF/resource/footer.jspf" %>
            </div>
        </div>
    </body>
</html>
