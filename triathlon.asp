<%@ LANGUAGE = JScript %>
<!--#include file="cms/basicfuncs.asp" -->   
<!--#include file="cms/data/database.asp" -->   
<!--#include file="cms/objects/News.asp" -->   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
var years = new NewsYears("triathlon");

var _year = "1999";
if(toString(Request.QueryString("year"))!="") {
	_year = Request.QueryString("year");
} else {
	_year = years[years.length-1];
}
var newsList = new NewsList("triathlon", _year);
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
				<div class="box">
					<div class="header">.: Nyheter/Resultat :.</div>
					<div class="content">
						<!--#include file="cms/newsList.asp" -->
					</div>
				</div>
				Arkiv:
				<%
				for(var i = 0; i < years.length; i++) {
					%>
					<a href="triathlon.asp?year=<%=years[i]%>"<%=(_year==years[i])? " style=\"font-weight:bold\"" : ""%>><%=years[i]%></a>
					<%=(i < years.length-1) ? "|" : ""%>
					<%
				}
				%>
			</div>
			<div id="rightColumn">
				<div class="box">
					<!--#include file="includes/triathlon/triathletes.html" -->
				</div>
				<span class="divider">&nbsp;</span>
				<div class="box">
					<!--#include file="includes/triathlon/training.html" -->
				</div>
				<span class="divider">&nbsp;</span>
				<div class="box">
					<!--#include file="includes/triathlon/tyresotri.html" -->
				</div>
				<span class="divider">&nbsp;</span>
				<div class="box">
					<!--#include file="includes/triathlon/contact.html" -->
				</div>
			</div>
			<div id="footer">&nbsp;</div>
		</div>
	</div>
	</body>
</html>