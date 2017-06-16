<%@ LANGUAGE = JScript %>
<!--#include file="cms/basicfuncs.asp" -->
<!--#include file="cms/data/database.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<!--#include file="includes/htmlhead.htm"-->
		<script type="text/javascript" src="/cms/lightbox-2.0.2/js/prototype.js"></script>
		<script type="text/javascript" src="/cms/lightbox-2.0.2/js/scriptaculous.js?load=effects"></script>
		<script type="text/javascript" src="/cms/lightbox-2.0.2/js/lightbox.js"></script>
		<link rel="stylesheet" href="/cms/lightbox-2.0.2/css/lightbox.css" type="text/css" media="screen" />
		<style type="text/css">
		body {
		margin:0px;
		}
		img {
		border:0px;
		}
		</style>
	</head>
	<body onload="showBanner()">
	<%
	var calendar = Server.CreateObject("adodb.recordset");
	var sql = "SELECT * FROM calendar WHERE imagearchive <> '' ORDER BY Startdate DESC";
	calendar.open(sql,connect,1,1);

	var subFolder = Request.QueryString("subFolder");
	if(toString(subFolder) == "") {
		subFolder = calendar("imagearchive").Value;
	}
	var folderPath = Server.MapPath("/imagearchive/"+subFolder+"/images");
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var folder = fso.GetFolder(folderPath);
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
					<div class="header">.: Bildarkiv :.</div>
					<div class="content">
						<%
						for (files = new Enumerator(folder.files); !files.atEnd(); files.moveNext())
						{
							var thisFile = files.item();
							%>
							<a href="/imagearchive/<%=subFolder%>/images/<%=thisFile.name%>" rel="lightbox[group]">
								<img src="/imagearchive/<%=subFolder%>/thumbnails/<%=thisFile.name%>" alt="" /></a>
							<%
						}
						%>
					</div>
				</div>
			</div>
			<div id="rightColumn">
				<div class="box">
					<div class="header">&nbsp;</div>
					<div class="content">
						<%
						while(!calendar.EOF)
						{
						%>
							<span class="newsdate"><%=calendar("Startdate")%></span>
							<% if(subFolder == calendar("imagearchive").Value) {%><b><%}%>
							<a href="imagearchive.asp?subFolder=<%=calendar("imagearchive")%>"><%=calendar("name")%>, <%=calendar("location")%></a><br>
							<% if(subFolder == calendar("imagearchive").Value) {%></b><%}%>
						<%
							calendar.movenext();
						}
						%>
					</div>
				</div>
			</div>
			<div id="footer">&nbsp;</div>
		</div>
	</div>
	</body>
</html>
