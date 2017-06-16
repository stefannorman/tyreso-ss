<%@ LANGUAGE = JScript %>
<!--#include file="cms/basicfuncs.asp" -->   
<!--#include file="cms/data/database.asp" -->
<%
var event_id = toString(Request.QueryString("event"));
var group_id = toString(Request.QueryString("group"));
var sql;

var query = Server.CreateObject("adodb.recordset");
sql = "SELECT name, location, startdate, Date() as today, groups, grenfil FROM calendar WHERE id=" + event_id;
query.open(sql,connect,1,1);
var eventName = toString(query("name"));
var eventLocation = toString(query("location"));
var eventDate = toString(query("startdate"));
var today = toString(query("today"));
var grenfil = toString(query("grenfil"));
query.close();

// read grenfil
var fso = new ActiveXObject("Scripting.FileSystemObject");
var ts = fso.OpenTextFile(Server.MapPath(grenfil),1,false);
// skip first line
ts.skipLine();

var line;
var swimmerStarts = new Array();
while (!ts.AtEndOfStream) {
	line = ts.ReadLine();
	var lineArray = line.split(";");
	var gender = trim(lineArray[1]);
	var startID = trim(lineArray[0]);
	var startText = trim(lineArray[2]);
	var poolLength = trim(lineArray[3]);

	sql = "SELECT distinct swimmer FROM eventstart WHERE event_id=" + event_id + " AND start = " + startID;
	query.open(sql,connect,1,1);
	while(!query.EOF) {
		var swimStart = new Object();
		swimStart.gender = gender;
		swimStart.startID = startID;
		swimStart.startText = startText;
		swimStart.poolLength = poolLength;
		swimStart.swimmer = toString(query("swimmer"));
		swimmerStarts.push(swimStart);
		query.MoveNext();
	}
	query.close();
}
%>
<%
var groupName = "";
sql = "SELECT aktivitetsgruppnamn FROM aktivitetsgrupper WHERE aktivitetsgruppID = " + group_id;
query.open(sql,servette,1,1);
if(!query.EOF) {
	groupName = toString(query("aktivitetsgruppnamn"));
}
query.close();
%>
<html>
<head><title><%=eventName%>&nbsp;<%=eventDate%>, <%=eventLocation%></title></head>
<body>
	<h1>Starter för grupp <%=groupName%> i <%=eventName%>&nbsp;<%=eventDate%>, <%=eventLocation%></h1>
<table>
<%
var swimmerIDs = new Array();
sql = "SELECT m.medlemsnummer FROM medlemmar m, [Kopplingar medlemmar och aktivitetsgrupper] k WHERE k.medlemsnummer = m.medlemsnummer and k.period = "+termin+" and k.aktivitetsgruppID = " + group_id;
query.open(sql,servette,1,1);
while(!query.EOF) {
	swimmerIDs.push(toString(query("medlemsnummer")));
	query.MoveNext();
}
query.close();

var tmpSwimCode = 0;
for(var i = 0; i < swimmerStarts.length; i++) {
	if(arrayContains(swimmerIDs, swimmerStarts[i].swimmer))
	{
		var swimCode = 0;
		var startText = swimmerStarts[i].startText;
		startText = trim(startText.toLowerCase());
		startText = startText.replace(" herrar", "");
		startText = startText.replace(" damer", "");
		startText = startText.replace(" mixed", "");
		startText = startText.replace("m ", " ");
		sql = "SELECT simsättkod " + 
			"FROM simsätt WHERE bassänglängd = " + swimmerStarts[i].poolLength + " AND simsätt = '" + startText + "'";
		query.open(sql,servette,1,1);
		if(!query.EOF) {
			swimCode = toInt(query("simsättkod"));
		}
		query.close();
		
			
		var pbTime = "";
		var pbDatum = "";
		var pbRace = "";
		if(swimCode > 0) {
			sql = "SELECT min(tid) as pbtid " + 
				"FROM resultat WHERE simsättkod = " + swimCode + " and medlemsnummer = " + swimmerStarts[i].swimmer;
			query.open(sql,servette,1,1);
			if(!query.EOF) {
				pbTime = trim(toString(query("pbtid")));
			}
			query.close();
			if(pbTime.length > 0) {
				sql = "SELECT datum, plats " + 
					"FROM resultat WHERE simsättkod = " + swimCode + " and medlemsnummer = " + swimmerStarts[i].swimmer + " and tid = " + pbTime;
				query.open(sql,servette,1,1);
				if(!query.EOF) {
					pbDatum = toString(query("datum"));
					pbRace = toString(query("plats"));
				}
				query.close();
			}
		}

		sql = "SELECT TOP 1 year(m.Födelsedatum) as year, m.medlemsnummer, m.förnamn, m.efternamn, m.kvinna " + 
			"FROM medlemmar m WHERE m.medlemsnummer = " + swimmerStarts[i].swimmer + "";
		query.open(sql,servette,1,1);
		var swimmerName = query("förnamn") + " " + query("efternamn");
		var swimmerSex = eval(toString(query("kvinna")).toLowerCase()) ? "D" : "H";
		if(swimCode!=tmpSwimCode) {
			%>
			<tr><td colspan="4"><b><%=startText%></b></td></tr>
		<% } %>
		<tr>
			<td><%=swimmerName%></td>
			<td>Heat <input size="3" /></td>
			<td>
				Tid <input size="5" />
				<% if(pbTime > 0) { %>
					Personbästa <%=formatPBTime(pbTime)%>
				<% } %>
			</td>
		</tr>
		<%
		tmpSwimCode = swimCode;
		query.close();
	}
}
%>
</table>
</body>
</html>
