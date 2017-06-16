<%@ LANGUAGE = JScript %>
<!--#include file="cms/basicfuncs.asp" -->   
<!--#include file="cms/data/database.asp" -->
<%
var event_id = toString(Request.QueryString("event"));
var swimmer_id = toString(Request.QueryString("swimmer"));
var participants = toString(Request.QueryString("participants"));
var action = toString(Request.QueryString("action"));
var sql;

var query = Server.CreateObject("adodb.recordset");
sql = "SELECT name, location, startdate, registrationdate, groups, type FROM calendar WHERE id=" + event_id;
query.open(sql,connect,1,1);
var eventName = toString(query("name") + ", " + query("location"));
var eventDate = toString(query("startdate"));
var type = toString(query("type"));
var registrationIsClosed = query("registrationdate") < (new Date()).setHours(0,0,0,0);
var allowedGroups = toString(query("groups")).split(", ");
var allowedGroupsStr = toString(query("groups"));
query.close();

if (action == "add" && swimmer_id != "0"){
	sql = "SELECT * FROM eventstart WHERE event_id=" + event_id + " AND swimmer=" + swimmer_id;
	query.open(sql,connect,1,1);
	if(query.EOF) {
		connect.Execute("INSERT INTO eventstart (event_id, swimmer, participants) VALUES ("+event_id+","+swimmer_id+","+participants+")");
	}
}
if (action == "paid" || action == "unpaid"){
	var paidValue = (action == "paid") ? 1 : 0;
	connect.Execute("UPDATE eventstart SET paid = "+paidValue+" WHERE event_id="+event_id+" AND swimmer="+swimmer_id);
}
if (action == "remove"){
	connect.Execute("DELETE FROM eventstart WHERE event_id="+event_id+" AND swimmer="+swimmer_id);
}
if (action != ""){
	Response.Redirect("campreg.asp?event="+event_id);
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
				location.href = "?event=<%=event_id%>&swimmer=" + chosenValue;
			}
		}
		function changeStart(start, action) {
			location.href = "?event=<%=event_id%>&swimmer=<%=swimmer_id%>&start=" + start + "&action=" + action;
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
					<div class="header">.: Anmäl till <%=eventName%>&nbsp;<%=eventDate%> :.</div>
					<div class="content">
						Här kan du anmäla simmare till <b><%=eventName%>&nbsp;<%=eventDate%></b>.<br/><br/>
						Välj simmare nedan och
						<% if(type=="info") { %>
						antalet deltagare (inkl simmaren) och
						<% } %>
						klicka på <i>Anmäl simmare</i>.
						Kansliet markerar sedan när betalning kommit in.
						Anmälan gäller först när betalning kommit in.
						<p>
						<a href="/uploaded/File/TSSstandardavtallagerverksamhet.doc">TSS:s regler vid lägerverksamhet</a>
						</p>

						<% if(registrationIsClosed) { %>
							<br/><br/>
							<span class="error centered">Anmälan stängd</span>
						<% } else { %>
							<form action="campreg.asp">
								<br/>
								<b>Anmäl simmare</b><br/>
								<select name="swimmer" id="swimmer">
									<option value="0">Välj simmare...</option>
									<%
									sql = "SELECT a.Aktivitetsgruppnamn, m.medlemsnummer, m.förnamn, m.efternamn, m.kvinna " +
									      "FROM medlemmar m, [Kopplingar medlemmar och aktivitetsgrupper] k, aktivitetsgrupper a " +
									      "WHERE k.medlemsnummer = m.medlemsnummer and k.period = "+termin+" and k.aktivitetsgruppID = a.aktivitetsgruppID " +
									      (type=="camp" ? "and a.InstruktörsID > 0 " : " ") +
									      "ORDER BY a.Aktivitetsgruppnamn, m.förnamn, m.efternamn";
									query.open(sql,servette,1,1);
									var gruppNamn = "";
									while(!query.EOF) {
										var group = toString(query("Aktivitetsgruppnamn"));
										if(group.indexOf("TK")==0) {
											group = "TK";
										} else if(group.indexOf("T")==0) {
											group = "T";
										} else if(group.indexOf("D ")==0) {
											group = "D";
										} else if(group.indexOf("SK")==0) {
											group = "SK";
										}
										} else if(group.indexOf("SL")==0) {
											group = "SL";
										}
										if(arrayContains(allowedGroups, group)) {
											if(gruppNamn != query("Aktivitetsgruppnamn")) {
												gruppNamn = toString(query("Aktivitetsgruppnamn"));
												%>
												<option value="0" style="font-weight:bold;"> - - - <%=gruppNamn%> - - - </option>
												<%
											}
											%>
											<option
												value="<%=query("medlemsnummer")%>"
												<%=(swimmer_id == query("medlemsnummer")) ? "selected=\"selected\"" : ""%>>
												<%=query("förnamn")%>&nbsp;<%=query("efternamn")%>
											</option>
											<%
										}
										query.MoveNext();
									}
									query.close();
									%>
								</select>
								<br/>
								<% if(type="info") { %>
								Antal deltagare (inkl simmaren)
								<br/>
								<select name="participants">
								<option>1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
								</select>
								<br/>
								<% } %>
								<br/>
								<input type="hidden" name="event" value="<%=event_id%>"/>
								<input type="hidden" name="action" value="add"/>
									<input type="submit" value="Anmäl simmare"/>
							</form>
						<% }%>
						<br/>
					</div>
				</div>
				<br/>
				<%
				sql = "SELECT swimmer, participants, paid FROM eventstart WHERE event_id=" + event_id;
				query.open(sql,connect,1,1);
				var swimmers = new Array();
				var payees = new Array();
				var participantsArr = new Array();
				while(!query.EOF) {
					swimmers.push(toString(query("swimmer")));
					payees.push(toString(query("paid")));
					participantsArr.push(toString(query("participants")));
					query.MoveNext();
				}
				query.close();
				if(swimmers.length > 0) {
					%>
					<div class="box">
						<div class="header">.: Redan anmälda :.</div>
						<div class="content">
							<table border="0">
							<%
							var commasepSwimmers = "";
							for(var i = 0; i < swimmers.length; i++) {
								commasepSwimmers += swimmers[i];
								if(i < swimmers.length-1)
									commasepSwimmers += ",";
							}
							sql = "SELECT a.Aktivitetsgruppnamn, m.medlemsnummer, m.förnamn, m.efternamn FROM medlemmar m, [Kopplingar medlemmar och aktivitetsgrupper] k, aktivitetsgrupper a WHERE k.medlemsnummer = m.medlemsnummer and k.period = "+termin+" and k.aktivitetsgruppID = a.aktivitetsgruppID and m.medlemsnummer IN ("+commasepSwimmers+") ORDER BY a.Aktivitetsgruppnamn, m.förnamn, m.efternamn";
							query.open(sql,servette,1,1);
							var gruppNamn = "";
							while(!query.EOF) {
								var group = toString(query("Aktivitetsgruppnamn"));
								if(group.indexOf("TK")==0) {
									group = "TK";
								} else if(group.indexOf("T")==0) {
									group = "T";
								} else if(group.indexOf("D ")==0) {
									group = "D";
								} else if(group.indexOf("SK")==0) {
									group = "SK";
								}
								} else if(group.indexOf("SL")==0) {
									group = "SL";
								}
								if(arrayContains(allowedGroups, group)) {
									if(gruppNamn != query("Aktivitetsgruppnamn")) {
										gruppNamn = toString(query("Aktivitetsgruppnamn"));
										%>
										<tr><td colspan="4"><u><b>Grupp <%=gruppNamn%></b></u><br/></td></tr>
										<%
									}
									var paid = false;
									var participantsValue = "1";
									for(var i = 0; i < swimmers.length; i++) {
										if(swimmers[i] == query("medlemsnummer")) {
											paid = (payees[i] == "True");
											participantsValue = participantsArr[i];
											break;
										}
									}
									%>
									<tr>
									<td>
										<%=query("förnamn")%>&nbsp;<%=query("efternamn")%>
										<% if(type="info") { %>
										(<%=participantsValue%> personer) 
										<% } %>
									</td>
									<% if (paid) {%>
										<td class="ok">BETALD</td>
									<% } else { %>
										<td class="error">EJ BETALD</td>
									<% } %>
									<% if(isAuthorized("kansli")) { %>
										<% if (paid) {%>
											<td><a href="?event=<%=event_id%>&swimmer=<%=query("medlemsnummer")%>&action=unpaid">ej betald</a></td>
										<% } else { %>
											<td><a href="?event=<%=event_id%>&swimmer=<%=query("medlemsnummer")%>&action=paid">betald</a></td>
										<% } %>
										<td><a href="?event=<%=event_id%>&swimmer=<%=query("medlemsnummer")%>&action=remove">radera</a></td>
									<% } %>
									</tr>
									<%
								}
								query.MoveNext();
							}
							query.close();
							%>
							</table>
						</div>
					</div>
				<% } %>
			</div>
			<div id="rightColumn">
			</div>
			<div id="footer">&nbsp;</div>
		</div>
	</div>
	</body>
</html>
