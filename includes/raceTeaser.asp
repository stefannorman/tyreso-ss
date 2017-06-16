<%
var events = Server.CreateObject("adodb.recordset");
var sql = "SELECT TOP 2 * FROM calendar WHERE local = 1 AND DateAdd('m','-1',Startdate) <= Date() AND Stopdate >= Date() ORDER BY Startdate";
events.open(sql,connect,1,1);
while(!events.EOF)
{
	var eventStart = new Date(events("Startdate"));
	%>
	<div class="box">
		<div class="header">.: N&auml;sta TSS t&auml;vling - <%=events("Name")%> :.</div>
		<div class="content">
			<%
			var raceImg = asciify(events("Name")) + ".png";
			if(toString(events("Name")).indexOf("Knatte") > 0) {
				raceImg = "Tyreso_Knatte.png";
			}
			if(toString(events("Name")).indexOf("Seriesim") == 0) {
				raceImg = "Seriesim.png";
			}
			if(toString(events("Name")).indexOf("September") >= 0) {
				raceImg = "Septembersim.png";
			}
			if(toString(events("Name")).indexOf("KM") > 0) {
				raceImg = "KM.png";
			}
			if(toString(events("Name")).indexOf("Mini") > 0) {
				raceImg = "MiniMax.png";
			}
			%>
			<img src="images/race/<%=raceImg%>"/>
			<ul class="vcalendar">
				<li class="vevent">
					<span class="date">
						<abbr class="dtstart" title="<%=eventStart%>">
						  <span class="day"><%=eventStart.getDate()%></span>
						  <span class="month"><%=getShortMonth(eventStart.getMonth())%></span>
						</abbr>
					</span>
					<p class="description">
						<table>
						<tr valign="top"><td>
						<ul>
							<%if(toString(events("inbjudan"))!=""){%>
								<li><a href="<%=events("inbjudan")%>">Inbjudan</a></li>
		                                        <%}%>
							<%if(toString(events("grenfil"))!=""){%>
							  <li><a href="<%=events("grenfil")%>">Grenfil</a></li>
							<%}%>
							<%if(toString(events("startlista"))!=""){%>
							  <li><a href="<%=events("startlista")%>">Startlista</a></li>
							<%}%>
						</ul>
						</td><td>
						<ul>
							<%if(toString(events("grenfil"))!="" && isAuthorized("racereg") && events("registrationdate") >= (new Date()).setHours(0,0,0,0)){%>
							  <li><a href="racereg.asp?event=<%=events("id")%>">Anmäl simmare</a></li>
		                                        <%}%>
							<li><a href="volunteers.asp?race=<%=events("id")%>">Funktion&auml;rer</a></li>
							<li><a href="checklist.asp?race=<%=events("id")%>">Checklista</a></li>
						</ul>
						</td></tr>
						</table>
					</p>
				</li>
			</ul>
		</div>
	</div>
	<%
	events.movenext();
}
%>

