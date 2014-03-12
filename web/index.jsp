<%-- 
    Document   : index
    Created on : Jun 28, 2011, 8:16:10 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>College Management System</title>
        <link rel="shortcut icon" href="/ClgMgtSite/resource/image/favicon.ico" >
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
                    <h1 class="pagetitle">Home</h1>
                    <%
                        if(request.getAttribute("sign-out") != null)
                        {
                    %>
                            <div class="message">
                                <%= (String)request.getAttribute("sign-out") %>
                            </div>
                   <%
                        }

                        if(request.getAttribute("success") != null)
                        {
                    %>
                            <div class="message success">
                                <%= (String)request.getAttribute("success") %>
                            </div>
                    <%
                        }
                        
                        if(request.getAttribute("warning") != null)
                        {
                    %>
                            <div class="message warning">
                                <%= (String)request.getAttribute("success") %>
                            </div>
                    <%
                        }
                    %>

                    <p style="clear:both;">
                        Lingaya’s Institute of Management & Technology (LIMAT) which was established in the memory
                        of great freedom fighter Late Shri Gadde Lingaya who sacrificed his life at the alter of
                        the freedom of his motherland and its very foundations are based on the dream of this
                        noble visionary son of India.                        
                        <img align="right" src="resource/image/college_logo.png"/>
                        <br/><br/>
                        The dreams of its founding fathers took shape in 1998 in the form of Lingaya’s Institute
                        of Management & Technology (LIMAT) which was established in the memory of great freedom
                        fighter Late Shri Gadde Lingaya who sacrificed his life at the alter of the freedom of
                        his motherland and its very foundations are based on the dream of this noble visionary
                        son of India.
                        <br/><br/>
                        The erstwhile Institute has been now declared as Deemed-to-be-University in the name &
                        style of Lingaya’s University under Section 3 of UGC Act. 1956 by the Ministry of Human
                        Resource Development, Govt. of India vide Notification No. F.9-23/2005-U.3 dated 5-1-2009.
                    </p>
                </div>
            </div>
            <div class="footer">
                <%@include file="/WEB-INF/resource/footer.jspf" %>
            </div>
        </div>
    </body>
</html>
