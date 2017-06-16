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
					<%
					var news = Server.CreateObject("adodb.recordset");
					var sql = "SELECT * FROM news WHERE id = " + toString(Request.QueryString("id"));
					news.open(sql,connect,1,1);

					if(!news.EOF)
					{%>
					<div class="header">.: <h1><%=news("title")%></h1> :.</div>
					<div class="content">
						<% if(isAuthorized("editor")) { %>
						<div class="cms_toolbar">
							<a href="/cms/edit.asp?id=<%=news("id")%>"><img src="/cms/icons/edit.png" hspace="0" border="0" title="Ändra">Ändra</a>
							<a href="javascript:if(confirm('Är du säker på att du vill radera?')) location = '/cms/delete.asp?id=<%=news("id")%>';"><img src="/cms/icons/delete.png" hspace="2" border="0" title="Radera">Radera</a>
						</div>
						<% } %>
						<span class="newsdate"><%=news("created")%></span>
						<br>
						<%=news("text")%>
					</div>
					<%
					}
					news.Close();
					%>
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