<!--#include file="basicfuncs.asp" -->   
<%
var editable = isAuthorized("editor");
var _referer = new String(Request.ServerVariables("HTTP_REFERER"));

if(Request.Form("aktion") == "save" && _referer.indexOf("chat.asp")>0)
{
	var _name = (new String(Request.Form("name"))).replace(/\'/g, "''");
	var _text = (new String(Request.Form("text"))).replace(/\'/g, "''");

	var sql = "INSERT INTO messages (name, [text], remote_addr) VALUES (" +
		"'" + _name + "'," +
		"'" + _text + "'," +
		"'" + Request.ServerVariables("REMOTE_ADDR") + "'" +
		")";
	//Response.Write(sql);
	connect.Execute(sql);
}
if(Request.QueryString("aktion") == "delete" && editable)
{
	var sql = "DELETE FROM messages WHERE id = " + Request.QueryString("id");
	//Response.Write(sql);
	connect.Execute(sql);
}

var messages = Server.CreateObject("adodb.recordset");
var sql = "SELECT * FROM messages ORDER BY created DESC";
messages.open(sql,connect,1,1);
%>