<%@ LANGUAGE = JScript %>
<!--#include file="cms/basicfuncs.asp" -->   
<!--#include file="cms/data/database.asp" -->   
<!--#include file="cms/objects/News.asp" -->   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
var years = new NewsYears("notis");

var _year = "1999";
if(toString(Request.QueryString("year"))!="") {
	_year = Request.QueryString("year");
} else {
	_year = years[years.length-1];
}
var newsList = new NewsList("notis", _year);
newsList.showBoxes = true;
%>
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
				<center>
					<b>Arkiv</b><br>
					<%
					for(var i = 0; i < years.length; i++) {
						%>
						<a href="archive.asp?year=<%=years[i]%>"<%=(_year==years[i])? " style=\"font-weight:bold\"" : ""%>><%=years[i]%></a>
						<%=(i < years.length-1) ? "|" : ""%>
						<%
					}
					%>
				</center>
				<br>
				<!--#include file="cms/newsList.asp" -->
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
