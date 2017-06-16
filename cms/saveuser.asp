<%@ LANGUAGE = JScript %>
<!--#include file="check.inc" -->
<!--#include file="basicfuncs.asp" -->
<!--#include file="data/database.asp" -->   
<%
var id = toString(Request.Form("id"));
var sql = "";
var _name = (new String(Request.Form("name"))).replace(/\'/g, "''");
var _email = (new String(Request.Form("email"))).replace(/\'/g, "''");
var _phone = (new String(Request.Form("phone"))).replace(/\'/g, "''");
var _mobile = (new String(Request.Form("mobile"))).replace(/\'/g, "''");
var _bonus_2007 = (new String(Request.Form("bonus_2007"))).replace(/\'/g, "''");
var _username = toString(Request.Form("username")).replace(/\'/g, "''");
var _password = toString(Request.Form("password")).replace(/\'/g, "''");
var _medlemsnr = toString(Request.Form("medlemsnr"));
if(_medlemsnr == "-1")
	medlems_nr = "NULL";
var _roles = toString(Request.Form("roles")).replace(/\'/g, "''");

if(id != "")
{
	sql = "UPDATE user SET " +
		"username = '" + _username + "'," +
		"password = '" + _password + "'," +
		"name = '" + _name + "'," +
		"email = '" + _email + "'," +
		"phone = '" + _phone + "'," +
		"mobile = '" + _mobile + "'," +
		"bonus = " + _bonus_2007 + "," +
		"bonus_2007 = " + _bonus_2007 + "," +
		"roles = '" + _roles + "'" +
		" WHERE id = " + id;
}
else
{
	sql = "INSERT INTO user (name, email, phone, mobile, bonus, bonus_2007, username, password, medlemsnr, roles) VALUES (" +
		"'" + _name + "'," +
		"'" + _email + "'," +
		"'" + _phone + "'," +
		"'" + _mobile + "'," +
		_bonus_2007 + "," +
		_bonus_2007 + "," +
		"'" + _username + "'," +
		"'" + _password + "'," +
		_medlemsnr + "," +
		"'" + _roles + "'" +
		")";
}
Response.Write(sql);
connect.Execute(sql);
Response.Redirect(Request.ServerVariables("HTTP_REFERER"));
%>