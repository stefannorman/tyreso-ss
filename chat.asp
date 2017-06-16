<%@ LANGUAGE = JScript %>
<!--#include file="cms/basicfuncs.asp" -->   
<!--#include file="cms/data/database.asp" -->   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<!--#include file="includes/htmlhead.htm"-->
		<script type="text/javascript" src="cms/FCKeditor/fckeditor.js"></script>
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
					<div class="header">.: TSS chat :.</div>
					<div class="content">
						<a href="#postMessage">Skriv inlägg</a><br>
						<hr class="line" />
						<!--#include file="cms/chat.inc" -->
						<%	
						while(!messages.EOF)
						{
							if(editable)
							{
								%>
								<div class="cms_toolbar">
									<a href="javascript:if(confirm('Är du säker på att du vill radera?')) location = 'chat.asp?aktion=delete&id=<%=messages("id")%>';"><img src="/cms/icons/delete.png" hspace="0" border="0" title="Radera">Radera inlägg</a>
								</div>
								<br>
								<% 
							}
							%>
							<span class="newsdate"><%=messages("created")%></span>
							<span class="newsheader"><%=messages("name")%></span>
							<br>
							<%=messages("text")%>
							<hr class="line" />
							<%
							messages.movenext();
						}
						messages.close();
						%>
					</div>
				</div>
				<br>
				<a name="postMessage">
				<div class="box">
					<div class="header">.: Skriv inlägg :.</div>
					<div class="content">
						<form action="chat.asp" method="post">
						Namn
						<input name="name"><br>
						<script type="text/javascript">
						<!--
						var oFCKeditor = new FCKeditor( 'text' ) ;
						oFCKeditor.BasePath	= '/cms/FCKeditor/' ;
						oFCKeditor.Config["DefaultLanguage"]    = "sv" ;
						oFCKeditor.ToolbarSet = 'Chat';

						oFCKeditor.Create() ;
						//-->
						function checkForm(theForm)
						{
							if(theForm.elements["name"].value.length == 0)
								alert("Du måste fylla i namn!");
							else
								theForm.submit();
						}
						</script>
						<input type="button" name="save" value="Skicka meddelande" onclick="checkForm(this.form)">
						<input type="hidden" name="aktion" value="save">
						</form>
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