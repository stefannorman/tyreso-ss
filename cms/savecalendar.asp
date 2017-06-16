<%@ LANGUAGE = JScript %>
<!--#include file="check.inc" -->
<!--#include file="basicfuncs.asp" -->
<!--#include file="data/database.asp" -->
<%
var id = toString(Request.Form("id"));
var sql = "";
var _name = (new String(Request.Form("name"))).replace(/\'/g, "''");
var _type = (new String(Request.Form("type"))).replace(/\'/g, "''");
var _location = (new String(Request.Form("location"))).replace(/\'/g, "''");
var _groups = toString(Request.Form("groups")).replace(/\'/g, "''");
var _description = (new String(Request.Form("description"))).replace(/\'/g, "''");
var _local = (toString(Request.Form("local")) == "true") ? "1" : "0";
var _sessions = toInt(Request.Form("sessions"));
var _inbjudan = (new String(Request.Form("inbjudan"))).replace(/\'/g, "''");
var _grenfil = (new String(Request.Form("grenfil"))).replace(/\'/g, "''");
var _startlista = (new String(Request.Form("startlista"))).replace(/\'/g, "''");
var _resultatlista = (new String(Request.Form("resultatlista"))).replace(/\'/g, "''");
var _resultatfil = (new String(Request.Form("resultatfil"))).replace(/\'/g, "''");
var _imagearchive = (new String(Request.Form("imagearchive"))).replace(/\'/g, "''");
var _startdate = new String(Request.Form("startdate"));
var _stopdate = new String(Request.Form("stopdate"));
var _registrationdate = new String(Request.Form("registrationdate"));

if(_stopdate.length == 0)
	_stopdate = _startdate;

if(_registrationdate.length == 0)
	_registrationdate = "NULL";
else
	_registrationdate = "'" + _registrationdate + "'";

if(id != "")
{
	sql = "UPDATE calendar SET " +
		"name = '" + _name + "'," +
		"type = '" + _type + "'," +
		"location = '" + _location + "'," +
		"groups = '" + _groups + "'," +
		"description = '" + _description + "'," +
		"local = " + _local + "," +
		"sessions = " + _sessions + "," +
		"inbjudan = '" + _inbjudan + "'," +
		"grenfil = '" + _grenfil + "'," +
		"startlista = '" + _startlista + "'," +
		"resultatlista = '" + _resultatlista + "'," +
		"resultatfil = '" + _resultatfil + "'," +
		"imagearchive = '" + _imagearchive + "'," +
		"startdate = '" + _startdate + "'," +
		"stopdate = '" + _stopdate + "'," +
		"registrationdate = " + _registrationdate +
		" WHERE id = " + id;
}
else
{
	sql = "INSERT INTO calendar (name, type, location, groups, description, local, sessions, inbjudan, grenfil, startlista, resultatlista, resultatfil, imagearchive, startdate, stopdate, registrationdate) VALUES (" +
		"'" + _name + "'," +
		"'" + _type + "'," +
		"'" + _location + "'," +
		"'" + _groups + "'," +
		"'" + _description + "'," +
		+ _local + "," +
		+ _sessions + "," +
		"'" + _inbjudan + "'," +
		"'" + _grenfil + "'," +
		"'" + _startlista + "'," +
		"'" + _resultatlista + "'," +
		"'" + _resultatfil + "'," +
		"'" + _imagearchive + "'," +
		"'" + _startdate + "'," +
		"'" + _stopdate + "'," +
		_registrationdate +
		")";
}
//Response.Write(sql);
connect.Execute(sql);
Response.Redirect(Request.Form("referer"));
%>