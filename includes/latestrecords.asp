		<div class="header">.: Senaste klubbrekorden :.</div>
		<div class="content">
			<%
			var records = Server.CreateObject("adodb.recordset");
			var sql = "SELECT TOP 5 * FROM individual ORDER BY Date DESC";
			records.open(sql,connect,1,1);
			while(!records.EOF)
			{
				%>
				<span class="newsdate"><%=records("Date")%></span>
				<b><%=records("Name")%></b><br/>
				<%=records("Race")%>,
				<%=records("Distance")%>m <%=records("Stroke")%>
				(<%=records("Pool")%>m)
				<b><%=formatTime(records("Time"))%></b>
				<hr class="line" />
				<%
				records.movenext();
			}
			records.close();
			%>
			<center>
				<a href="records.asp?sex=M&amp;pool=25">alla rekord &#155;&#155;</a>
			</center>
		</div>
