<%@ LANGUAGE = JScript %>
<!--#include file="cms/basicfuncs.asp" -->   
<!--#include file="cms/data/database.asp" -->   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<!--#include file="includes/htmlhead.htm"-->
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
					<div class="header">.: Kalender :.<span style="float:right"><a target="_blank" href="http://www.google.com/calendar/render?cid=http%3A%2F%2Fwww.tss.nu%2Fical.asp"><img border="0" src="http://www.google.com/calendar/images/calendar_plus_sv.gif"></a></span></div>
					<div class="content">
						<!--#include file="cms/calendar.inc" -->
	      					<% if(editable) {%>
							<a href="cms/editcalendar.asp">Ny händelse</a><br>
							<hr class="line" />
						<% } %>
						<ul class="vcalendar">
						<%	
						var tmpMonth = -1;
						while(!events.EOF)
						{
							var eventStart = new Date(events("Startdate"));
							var eventEnd = new Date(events("Stopdate"));
							%>
							<li class="vevent">
								<a name="<%=events("id")%>"></a>
								<span class="date">
				          <abbr class="dtstart" title="<%=eventStart%>">
				            <span class="day"><%=eventStart.getDate()%></span> 
				            <span class="month"><%=getShortMonth(eventStart.getMonth())%></span>
				          </abbr>
				        </span>
								<% if(editable){%>
									<div class="cms_toolbar">
									<a href="/cms/editcalendar.asp?aktion=update&id=<%=events("id")%>"><img src="/cms/icons/edit.png" hspace="0" border="0" title="Ändra">Ändra</a>
										<a href="javascript:if(confirm('Är du säker på att du vill radera?')) location = 'calendar.asp?aktion=delete&id=<%=events("id")%>';"><img src="/cms/icons/delete.png" hspace="0" border="0" title="Radera">Radera</a>
									</div>
								<% }%>
				        <h3 class="summary"><%=events("Name")%></h3>
								<%if(eventStart.getDate() != eventEnd.getDate()){%>
									(<%=eventStart.getDate()%>/<%=eventStart.getMonth()+1%> -
									<%=eventEnd.getDate()%>/<%=eventEnd.getMonth()+1%>)
								<%}%>
								<p class="meta">
	                <span class="location"><%=events("location")%></span>
	              </p>
	              <p class="description">
									<% if(toString(events("groups"))!="") {%>
										Grupper: <%=events("groups")%><br/>
									<% } %>
									<% if(toString(events("description"))!="") {%>
										<%=events("description")%><br/>
									<% } %>
									<% if(toString(events("registrationdate"))!="") {%>
										Sista anmälningsdag: <%=events("registrationdate")%><br/>
									<% } %>
									
									<%if(toString(events("inbjudan"))!=""){%><a href="<%=events("inbjudan")%>">inbjudan</a>&nbsp;<%}%>
									<%if(toString(events("grenfil"))!=""){%><a href="<%=events("grenfil")%>">grenfil</a>&nbsp;<%}%>
									<%if(toString(events("startlista"))!=""){%><a href="<%=events("startlista")%>">startlista</a>&nbsp;<%}%>
									<%if(toString(events("resultatlista"))!=""){%><a href="<%=events("resultatlista")%>">resultat</a>&nbsp;<%}%>
									<%if(toString(events("resultatfil"))!=""){%><a href="<%=events("resultatfil")%>">resultatfil</a>&nbsp;<%}%>
									<%if(toString(events("imagearchive"))!=""){%><a href="imagearchive.asp?subFolder=<%=events("imagearchive")%>">bilder</a>&nbsp;<%}%>
									<% if(toString(events("type"))=="race" && toString(events("grenfil"))!="" && isAuthorized("racereg")) { %>
										<% if(events("registrationdate") < (new Date()).setHours(0,0,0,0)) { %>
											<span class="error">Anmälan stängd</span>
										<% } else { %>
											<a href="racereg.asp?event=<%=events("id")%>">Anmäl simmare</a>
										<% }%>
									<% } %>
									<% if(toString(events("registrationdate")) != "" && (toString(events("type"))=="info" || toString(events("type"))=="camp")) { %>
										<% if(events("registrationdate") < (new Date()).setHours(0,0,0,0)) { %>
											<span class="error">Anmälan stängd</span>
											<a href="campreg.asp?event=<%=events("id")%>">Visa anmälda</a>
										<% } else { %>
											<a href="campreg.asp?event=<%=events("id")%>">Anmälan</a>
										<% }%>
									<% } %>
									<% if(toInt(events("sessions")) > 0) { %>
											<a href="volunteers.asp?race=<%=events("id")%>">Funktionärer</a>
									<% } %>
									<% if(toBool(events("local"))) { %>
											<a href="checklist.asp?race=<%=events("id")%>">Checklista</a>
									<% } %>
								</p>
							</li>
							<%
							events.movenext();
						}
						events.close();
						%>
					</ul>
					</div>
				</div>
				<br>
				<center>
					<b>Kalendariumarkiv</b><br>
					<%
					var years = Server.CreateObject("adodb.recordset");
					var sql = "SELECT DISTINCT YEAR(Startdate) AS year FROM calendar";
					years.open(sql,connect,1,1);
					while(!years.EOF)
					{
					%>
					<a href="calendar.asp?year=<%=years("year")%>"<%=(_year==toString(years("year")))? " style=\"font-weight:bold\"" : ""%>><%=years("year")%></a>
					<%
						years.movenext();
						if(!years.EOF) {
						%>|<%
						}
					}
					years.close();
					%>
				</center>
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
