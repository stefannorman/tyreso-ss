<%@ LANGUAGE = JScript %>
<!--#include file="check.inc" -->
<!--#include file="data/database.asp" -->   
<!--#include file="basicfuncs.asp" -->   
<%
var id = toString(Request.Form("id"));
var sql = "";
var _title = (new String(Request.Form("title"))).replace(/\'/g, "''");
var _text = (new String(Request.Form("text"))).replace(/\'/g, "''");

if(id != "")
{
	sql = "UPDATE news SET " +
		"title = '" + _title + "'," +
		"[text] = '" + _text + "'," +
		"created = '" + Request.Form("created") + "'" +
		" WHERE id = " + id;
}
else
{
	sql = "INSERT INTO news (title, [text], created, category, user) VALUES (" +
		"'" + _title + "'," +
		"'" + _text + "'," +
		"'" + Request.Form("created") + "'," +
		"'" + Request.Form("category") + "'," +
		Session("AuthUser").id +
		")";
}
//Response.Write(sql);
connect.Execute(sql);
Response.Redirect(Request.Form("referer"));
%>
