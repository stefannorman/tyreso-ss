<div class="header">.: På gång :.</div>
<div class="content">
	<ul class="vcalendar">
	<%
	var events = Server.CreateObject("adodb.recordset");
	var groupClause = "AND local = 0";
	if(toString(_showOnlyGroup) != "")
		groupClause = " AND groups LIKE '%" + _showOnlyGroup + "%'";
	var sql = "SELECT TOP 4 * FROM calendar WHERE Stopdate >= Date() " + groupClause + " ORDER BY Startdate";
	events.open(sql,connect,1,1);
	while(!events.EOF)
	{
		var eventStart = new Date(events("Startdate"));
		%>
		<li class="vevent">
			<span class="date">
        <abbr class="dtstart" title="<%=eventStart%>">
          <span class="day"><%=eventStart.getDate()%></span> 
          <span class="month"><%=getShortMonth(eventStart.getMonth())%></span>
        </abbr>
      </span>
			<h3 class="summary"><a href="calendar.asp#<%=events("id")%>"><b><%=events("Name")%></a></h3>
			<p class="description">
				<%if(toString(events("inbjudan"))!=""){%>- <a href="<%=events("inbjudan")%>">inbjudan</a><br/><%}%>
				<%if(toString(events("grenfil"))!=""){%>- <a href="<%=events("grenfil")%>">grenfil</a><br/><%}%>
				<%if(toString(events("type"))=="race" && toString(events("grenfil"))!="" && isAuthorized("racereg") && events("registrationdate") > (new Date()).setHours(0,0,0,0)) { %>
					- <a href="racereg.asp?event=<%=events("id")%>">Anmäl simmare</a><br/>
				<%}%>
				<%if(toString(events("type"))=="camp" && events("registrationdate") > (new Date()).setHours(0,0,0,0)) { %>
					- <a href="campreg.asp?event=<%=events("id")%>">Anmäl till läger</a><br/>
				<%}%>
				<%if(toString(events("startlista"))!=""){%>- <a href="<%=events("startlista")%>">startlista</a><br/><%}%>
			</p>
		</li>
		<%
		events.movenext();
	}
	%>
	</ul>
</div>
