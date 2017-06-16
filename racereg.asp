<%@ LANGUAGE = JScript %>
<%
Response.AddHeader("Pragma", "no-cache");
Response.AddHeader("cache-control", "no-cache");
%>
<!--#include file="cms/check.inc" -->
<!--#include file="cms/basicfuncs.asp" -->   
<!--#include file="cms/data/database.asp" -->
<%
var event_id = toString(Request.QueryString("event"));
var swimmer_id = toString(Request.QueryString("swimmer"));
var start_id = toString(Request.QueryString("start"));
var action = toString(Request.QueryString("action"));
var sql;

var query = Server.CreateObject("adodb.recordset");
sql = "SELECT name, startdate, groups, grenfil FROM calendar WHERE id=" + event_id;
query.open(sql,connect,1,1);
var eventName = toString(query("name"));
var eventDate = toString(query("startdate"));
var allowedGroups = toString(query("groups")).split(", ");
var grenfil = toString(query("grenfil"));
query.close();

// read grenfil
var fso = new ActiveXObject("Scripting.FileSystemObject");
var ts = fso.OpenTextFile(Server.MapPath(grenfil),1,false);
// skip first line
ts.skipLine();

if (action == "add"){
	connect.Execute("INSERT INTO eventstart (event_id, swimmer, start) VALUES ("+event_id+","+swimmer_id+","+start_id+")");
}
if (action == "remove"){
	connect.Execute("DELETE FROM eventstart WHERE event_id="+event_id+" AND swimmer="+swimmer_id+" AND start="+start_id);
}
if (action == "add" || action == "remove"){
	//Response.Redirect("racereg.asp?event="+event_id+"&swimmer="+swimmer_id+"&preventCache="+(new Date()).getTime());
}

var swimmerStarts = new Array();
if (swimmer_id != ""){
	sql = "SELECT start FROM eventstart WHERE swimmer=" + swimmer_id + " AND event_id=" + event_id;
	query.open(sql,connect,1,1);
	while(!query.EOF) {
		swimmerStarts.push(toString(query("start")));
		query.MoveNext();
	}
	query.close();
}


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<!--#include file="includes/htmlhead.htm"-->
		<script language="javascript">
		function changeSwimmer(swimmerSelect) {
			var chosenValue = swimmerSelect.options[swimmerSelect.selectedIndex].value;
			if(chosenValue > 0) {
				window.location = "racereg.asp?event=<%=event_id%>&swimmer=" + chosenValue;
			}
		}
		function changeStart(start, action) {
			window.location = "racereg.asp?event=<%=event_id%>&swimmer=<%=swimmer_id%>&start=" + start + "&action=" + action;
		}
		</script>
	</head>
	<body onload="showBanner();">
	<div id="wrapper">
		<div id="header">
			<!--#include file="includes/header.htm"-->
		</div>
		<div id="main">
			<div id="menuColumn">
				<!--#include file="includes/menu.asp"-->
			</div>
			<div id="contentColumn">
				<div class="box">
					<div class="header">.: T&auml;vlingsregistrering till <%=eventName%>&nbsp;<%=eventDate%> :.</div>
					<div class="content">

						<form action="">
							<select name="swimmer" id="swimmer" onchange="changeSwimmer(this)">
								<option value="0">V&auml;lj simmare...</option>
								<%
								var womanChosen = "false";
								var swimmer_age = -1;

								sql = "SELECT IDnummer, namn, efternamn, klass, fodelsear FROM Medlem ORDER BY namn, efternamn";
								query.open(sql,grodan,1,1);
								%>query.EOF:<%=query.EOF%><%
								while(!query.EOF) {
									if(swimmer_id == query("IDnummer")) {
										womanChosen = (trim(toString(query("klass"))) == "D");
										swimmer_age = (new Date()).getFullYear() - toInt(query("fodelsear"));
									}
									%>
									<option
										value="<%=query("IDnummer")%>"
										<%=(swimmer_id == query("IDnummer")) ? "selected=\"selected\"" : ""%>>
										<%=query("namn")%>&nbsp;<%=query("efternamn")%>
									</option>
									<%
									query.MoveNext();
								}
								query.close();
								%>
							</select>
						</form>
						<br/>
						<%
						if(swimmer_id != "" && swimmer_id != "-1") {
							var line;
							while (!ts.AtEndOfStream) {
								line = ts.ReadLine();
								var lineArray = line.split(";");
								var startID = trim(lineArray[0]);
								var gender = trim(lineArray[1]);
								var startLabel = trim(lineArray[2]);
								var allowedAges = lineArray[4].split("-");
								var minAge = toInt(trim(allowedAges[0]));
								var maxAge = toInt(trim(allowedAges[1]));
								var ageLabel = toString(minAge) + "-" + toString(maxAge) + " &aring;r";
								if(
									minAge <= swimmer_age &&
									maxAge >= swimmer_age &&
									(
										gender=="X" ||
										(gender=="D" && womanChosen) ||
										(gender=="H" && !womanChosen)
									)
								) {
									if(arrayContains(swimmerStarts, startID)) { 
										%><input type="checkbox" onclick="changeStart(<%=startID%>, 'remove')" checked="checked"/><b><%=startLabel%></b> (<%=ageLabel%>)<br/><%
									} else {
										%><input type="checkbox" onclick="changeStart(<%=startID%>, 'add')"/><%=startLabel%> (<%=ageLabel%>)<br/><% 
									}
								}
							}
						}
						%>
						<br/>
					</div>
				</div>
			</div>
			<div id="rightColumn">
				<%
				sql = "SELECT distinct swimmer FROM eventstart WHERE event_id=" + event_id;
				query.open(sql,connect,1,1);
				var swimmerStarts = "";
				while(!query.EOF) {
					swimmerStarts = swimmerStarts + query("swimmer") + ",";
					query.MoveNext();
				}
				query.close();
				if(swimmerStarts.length > 0) {
					swimmerStarts = swimmerStarts.substr(0, swimmerStarts.length-1);
					%>
					<div class="box">
						<div class="header">.: Redan anm&auml;lda :.</div>
						<div class="content">
							<%
							sql = "SELECT IDnummer, namn, efternamn, klass, fodelsear FROM Medlem WHERE IDNummer IN ("+swimmerStarts+") ORDER BY namn, efternamn";
							//sql = "SELECT a.Aktivitetsgruppnamn, m.medlemsnummer, m.förnamn, m.efternamn FROM medlemmar m, [Kopplingar medlemmar och aktivitetsgrupper] k, aktivitetsgrupper a WHERE k.medlemsnummer = m.medlemsnummer and k.aktivitetsgruppID = a.aktivitetsgruppID and k.period = "+termin+" and m.medlemsnummer IN ("+swimmerStarts+") ORDER BY a.Aktivitetsgruppnamn, m.förnamn, m.efternamn";
							query.open(sql,grodan,1,1);
							while(!query.EOF) {
								%>
								<a href="?event=<%=event_id%>&swimmer=<%=query("IDNummer")%>"><%=query("namn")%>&nbsp;<%=query("efternamn")%></a><br/>
								<%
								query.MoveNext();
							}
							query.close();
							%>
						</div>
					</div>
				<% } %>
			</div>
			<div id="footer">&nbsp;</div>
		</div>
	</div>
	</body>
</html>
