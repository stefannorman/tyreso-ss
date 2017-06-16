<%@ LANGUAGE = JScript %>
<!--#include file="basicfuncs.asp" -->
<%
sendEmail(Request.Form("email"), unescape(Request.Form("subject")), unescape(Request.Form("mailbody")));
%>
Mail skickat till <%=Request.Form("email")%>!
