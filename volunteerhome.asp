<%@ LANGUAGE = JScript %>
<!--#include file="cms/basicfuncs.asp" -->   
<!--#include file="cms/data/database.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
var userID = toString(Request.QueryString("id"));
var action = toString(Request.QueryString("action"));
var userName = "";
var userBonus = 0;
var userQuery = Server.CreateObject("adodb.recordset");
var sql = "SELECT * FROM user WHERE id = " + userID;
userQuery.open(sql,connect,1,1);
if(!userQuery.EOF) {
	userName = toString(userQuery("name"));
	userBonus = toInt(userQuery("bonus_2007").Value);
}
userQuery.close();
if(action != "") {
	varsql = "";
	if(action == "add") {
		var camp = toString(Request.QueryString("camp"));
		var amount = toString(Request.QueryString("amount"));
		sql = "INSERT INTO bonus (user_id, event_id, amount) VALUES ("+userID+", "+camp+", "+amount+")";
        } else if(action == "delete") {
		var bonusid = toString(Request.QueryString("bonusid"));
		sql = "DELETE FROM bonus WHERE id = "+bonusid;
	}
	//Response.Write(sql);
	connect.Execute(sql);
}
%>
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<!--#include file="includes/htmlhead.htm"-->
		<script language="javascript" src="/javascript/jquery-1.4.2.min.js"></script>
	</head>
	<body onload="showBanner()">
	<div id="wrapper">
		<div id="header">
			<!--#include file="includes/header.htm"-->
		</div>
		<div id="main">
			<div id="menuColumn">
				<!--#include file="includes/menu.asp"-->
			</div>
			<div id="contentColumn">

				<h1>Bonuskonto <%=userName%></h1>
				<div class="box">
					<div class="header">.: Insättningar :.</div>
					<div class="content">
						<table border="1" width="100%">
						<tr>
							<td width="15%">2009-12-31</td>
							<td>Ingående saldo</td>
							<td width="10%" align="right" style="background:green"><%=userBonus%>:-</td>
						</tr>
						<%
						var raceQuery = Server.CreateObject("adodb.recordset");
						raceQuery.open("SELECT calendar.name, calendar.Startdate, volunteers.session FROM calendar, volunteers WHERE volunteers.participates = 1 and volunteers.event_id = calendar.id and volunteers.user_id = "+userID+" ORDER BY calendar.Startdate",connect,1,1);
						if(raceQuery.EOF) {
							%>Inga tävlingar registrerade efter 2009<%
						} else {
							%>
							<%
							while(!raceQuery.EOF) {
								%>
								<tr>
									<td width="15%"><%=getDateString(new Date(raceQuery("Startdate")))%></td>
									<td><%=raceQuery("name")%>, pass <%=raceQuery("session")%></td>
									<td width="10%" align="right" style="background:green">100:-</td>
								</tr>
								<%
								userBonus += 100;
								raceQuery.MoveNext();
							}
							raceQuery.close();
							%>
							<%
						}
						%>
						</table>
					</div>
				</div>
				<br/>
				<div class="box">
					<div class="header">.: Uttag :.</div>
					<div class="content">
						<%
						var campQuery = Server.CreateObject("adodb.recordset");
						campQuery.open("SELECT calendar.name, calendar.location, calendar.Startdate, bonus.amount, bonus.id FROM calendar, bonus WHERE bonus.event_id = calendar.id and bonus.user_id = "+userID+" ORDER BY calendar.Startdate",connect,1,1);
						if(campQuery.EOF) {
							%>Inga uttag registrerade efter 2009<%
						} else {
							%>
							<table border="1" width="100%">
							<%
							while(!campQuery.EOF) {
								%>
								<tr>
									<td width="15%"><%=getDateString(new Date(campQuery("Startdate")))%></td>
									<td><%=campQuery("name")%>, <%=campQuery("location")%></td>
									<% if(isAuthorized("admin")) { %>
										<td width="5%"><a href="?id=<%=userID%>&action=delete&bonusid=<%=campQuery("id")%>"><img src="/cms/icons/delete.png" border="0"/></a></td>
									<% } %>
									<td align="right" style="background:red" width="10%">-<%=campQuery("amount")%>:-</td>
								</tr>
								<%
								userBonus -= toInt(campQuery("amount"));
								campQuery.MoveNext();
							}
							campQuery.close();
							%>
							</table>
							<%
						}
						%>
					</div>
				</div>
				<br/>
				<b>Aktuellt saldo </b> <%=userBonus%> kr<br/><br/>
				<br/>
				<% if(userBonus > 0 && isAuthorized("admin")) { %>
				<div class="box">
					<div class="header">.: Registrera uttag :.</div>
					<div class="content">
						<form>
							Läger<br/>
							<%
							var campQuery = Server.CreateObject("adodb.recordset");
							campQuery.open("SELECT * FROM calendar WHERE calendar.type = 'camp' ORDER BY Startdate DESC",connect,1,1);
							%>
							<select name="camp">
								<%
								while(!campQuery.EOF) {
									%>
									<option value="<%=campQuery("id")%>"><%=campQuery("name")%>, <%=campQuery("location")%>&nbsp;<%=(new Date(campQuery("startDate"))).getYear()%> </option>		
									<%
									campQuery.MoveNext();
								}
								%>
							</select>
							<%
							campQuery.close();
							%>
							<br/>
							Summa<br/>
							<input name="amount" size="4"/>kr
							<br/>
							<input type="submit" value="Registrera"/>
							<input name="action" type="hidden" value="add"/>
							<input name="id" type="hidden" value="<%=userID%>"/>
						</form>
					</div>
				</div>
				<% } %>
				<br/>
			</div>
			<div id="rightColumn">

			</div>
			<div id="footer">&nbsp;</div>
		</div>
	</div>
	</body>
</html>
