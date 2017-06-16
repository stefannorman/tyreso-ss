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
					<div class="header">.: SHOP :.</div>
					<div class="content">
					<a href="http://www.swimstore.se">SWIMSTORE.SE</a><br/>

					Som &auml;r v&aring;ran leverant&ouml;rer utav simprodukter d&auml;r man loggar in med anv&auml;ndar namn samt l&ouml;sen som har mailat ut sedan tidigare.<br/>

					S&aring; kommer man automatiskt till v&aring;ran kollektion f&ouml;r TSS.<br/>
					</div>
				</div>
				<!--
						<iframe height="2000" width="680" src="http://tyreso-ss.spreadshirt.se/" name="Spreadshop" id="Spreadshop" frameborder="0" onload="window.scrollTo(0, 0);"></iframe>
					-->
			</div>
			<div id="footer">&nbsp;</div>
		</div>
	</div>
	</body>
</html>
