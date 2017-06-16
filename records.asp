<%@ LANGUAGE = JScript %>
<!--#include file="cms/basicfuncs.asp" -->   
<!--#include file="cms/data/database.asp" -->   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<!--#include file="includes/htmlhead.htm"-->
	</head>
	<body onload="showBanner()">
	<%
	var _stroke = "";	
	var _sex = Request.QueryString("sex");
	var _pool = Request.QueryString("pool");
	%>
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
					<div class="header">.: Klubbrekord :.</div>
					<div class="content">
						<center>
						<a href="records.asp?sex=M&pool=25"<%=(_sex=="M" && _pool == "25")? " style=\"font-weight:bold\"" : ""%>>Män 25m</a> |
						<a href="records.asp?sex=M&pool=50"<%=(_sex=="M" && _pool == "50")? " style=\"font-weight:bold\"" : ""%>>Män 50m</a> |
						<a href="records.asp?sex=W&pool=25"<%=(_sex=="W" && _pool == "25")? " style=\"font-weight:bold\"" : ""%>>Kvinnor 25m</a> |
						<a href="records.asp?sex=W&pool=50"<%=(_sex=="W" && _pool == "50")? " style=\"font-weight:bold\"" : ""%>>Kvinnor 50m</a>
						</center>
						<%
						var p_sex = Request.QueryString("sex");
						var p_pool = Request.QueryString("pool");
						var records = Server.CreateObject("adodb.recordset");
						var sql = "";
						if(toString(Request.QueryString("save"))!="") {
							sql = "UPDATE individual SET " +
								"name = '" + Request.QueryString("name") + "'," +
								"[time] = " + Request.QueryString("time") + "," +
								"race = '" + Request.QueryString("race") + "'," +
								"[date] = '" + Request.QueryString("date") + "'" +
								" WHERE Id = "+Request.QueryString("id");
							connect.Execute(sql);
						} 
						sql = "SELECT * FROM individual WHERE Sex = '"+p_sex+"' AND Pool = "+p_pool+" ORDER BY Stroke, Distance";
						records.open(sql,connect,1,1);
						%>
						<table>
						<%
						while(!records.EOF)
						{
							if(_stroke != records("Stroke")) {
								%>
								<tr><td><b><%=records("Stroke")%></b></td></tr>
								<%
							}
							if(!isAuthorized("records")) {
							%>
							<tr>
								<td align="right"><%=records("Distance")%>m</td>
								<td><%=records("Name")%></td>
								<td align="right"><b><%=formatTime(records("time"))%></b></td>
								<td><%=records("Race")%></td>
								<td><%=records("Date")%></td>
							</tr>
							<%
							} else {
							%>
							<form>
								<input type="hidden" name="id" value="<%=records("id")%>"/>
								<input type="hidden" name="sex" value="<%=records("sex")%>"/>
								<input type="hidden" name="pool" value="<%=records("pool")%>"/>
								<tr>
									<td align="right"><%=records("Distance")%>m</td>
									<td><input name="name" value="<%=records("Name")%>" size="15"/></td>
									<td><input name="time" value="<%=records("time")%>" size="6"/></td>
									<td><input name="race" value="<%=records("race")%>" size="15"/></td>
									<td><input name="date" value="<%=records("date")%>" size="10"/></td>
									<td><input type="submit" name="save" value="Spara"/></td>
								</tr>
							</form>
							<%
							}
							_stroke = toString(records("Stroke"));
							records.movenext();
						}
						records.close();
						%>
						</table>
					</div>
				</div>
			</div>
			<div id="rightColumn">

				<div class="box">
					<!--#include file="includes/nextrace.asp"-->
				</div>
				<span class="divider">&nbsp;</span>
				<div class="box">
					<%
					var _showOnlyGroup = "";
					%>
					<!--#include file="includes/nextcalendar.asp" -->
				</div>
				<span class="divider">&nbsp;</span>
				<div class="box">
					<!--#include file="includes/latestresults.asp" -->
				</div>
				<span class="divider">&nbsp;</span>
				<div class="box">
					<!--#include file="includes/latestrecords.asp" -->
				</div>

			</div>
			<div id="footer">&nbsp;</div>
		</div>
	</div>
	</body>
</html>