<%@ LANGUAGE = JScript %>
<!--#include file="cms/basicfuncs.asp" -->   
<!--#include file="cms/data/database.asp" -->   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<!--#include file="includes/htmlhead.htm"-->
		<link rel="alternate" title="Tyresö SS" href="http://www.tss.nu/rss.asp" type="application/rss+xml"/>		
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
				<div class="box">
					<div class="header">.: Resultatarkiv :.</div>
					<div class="content">
						<%
						var results = Server.CreateObject("adodb.recordset");
						var sql = "SELECT * FROM calendar WHERE LEN(Resultatlista)>0 ORDER BY Startdate DESC";
						results.open(sql,connect,1,1);
						%>
						<table>
						<%	
						while(!results.EOF)
						{
							%>
							<tr>
								<td><%=results("Startdate")%></td>
								<td><%=results("Name")%></td>
								<td><a href="<%=results("Resultatlista")%>">Resultat >></a></td>
							</tr>
							<%
							results.movenext();
						}
						results.close();
						%>
						</table>
					</div>
				</div>
			</div>
			<div id="rightColumn">

				<div class="box">
					<!--#include file="includes/sponsors.html"-->
				</div>
				<span class="divider">&nbsp;</span>
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
