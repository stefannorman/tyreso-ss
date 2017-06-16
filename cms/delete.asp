<%@ LANGUAGE = JScript %>
<!--#include file="check.inc" -->
<!--#include file="basicfuncs.asp" -->   
<!--#include file="data/database.asp" -->   
<%
var id = toInt(Request.QueryString("id"));;
connect.Execute("DELETE FROM news WHERE id = " + id);

Response.Redirect(Request.ServerVariables("HTTP_REFERER"));
%>
