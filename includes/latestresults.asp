		<div class="header">.: Resultat :.</div>
		<div class="content">
			<%
			var results = Server.CreateObject("adodb.recordset");
			var sql = "SELECT TOP 5 * FROM calendar WHERE LEN(Resultatlista)>0 ORDER BY Startdate DESC";
			results.open(sql,connect,1,1);
			while(!results.EOF)
			{
			%>
			<span class="newsdate"><%=results("Startdate")%></span>
				<a href="<%=results("Resultatlista")%>">
				<b><%=results("Name")%></b> &#155;&#155;</a>
				<%if(toString(results("resultatfil"))!=""){%>
				<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- <a href="<%=results("resultatfil")%>">RE-fil</a></li>
				<%}%>
				<hr class="line" />
			<%
			results.movenext();
			}
			results.close();
			%>
			<center>
				<a href="results.asp">äldre resultat &#155;&#155;</a>
			</center>
		</div>
