<%
var editable = isAuthorized("editor");
if(Request.QueryString("aktion") == "delete" && editable)
{
	var sql = "DELETE FROM calendar WHERE id = " + Request.QueryString("id");
	//Response.Write(sql);
	connect.Execute(sql);
}
var _year = "";
var dateWhereClause = "Stopdate >= Date()";
if(toString(Request.QueryString("year"))!="")
{
	_year = Request.QueryString("year");
	dateWhereClause = "YEAR(Startdate) = " + _year;
}


var events = Server.CreateObject("adodb.recordset");
var sql = "SELECT * FROM calendar WHERE " + dateWhereClause + " ORDER BY Startdate";
events.open(sql,connect,1,1);
%>
