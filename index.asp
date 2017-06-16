<%@ LANGUAGE = JScript %>
<!--#include file="cms/basicfuncs.asp" -->
<!--#include file="cms/data/database.asp" -->
<!--#include file="cms/objects/News.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
var _year = "";
var _pagesize = 10;
var newsList = new NewsList("notis", _year, _pagesize);
newsList.showBoxes = true;
//newsList.view = newsList.views.BOXES;
%>
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<meta name="google-site-verification" content="8DrOs-m6oGrW66JrANzOXzLOf0ml1xYP7OQEZ7cIWDg" />
		<!--#include file="includes/htmlhead.htm"-->
		<link rel="alternate" title="Tyres� SS" href="http://www.tss.nu/rss.asp" type="application/rss+xml"/>
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
				<!--#include file="includes/raceTeaser.asp" -->
				<!--#include file="cms/newsList.asp" -->
			</div>
			<div id="rightColumn">
				<!--#include file="includes/facebook.html"-->
				<span class="divider">&nbsp;</span>
				<div class="box">
					<!--#include file="includes/kansliet.html"-->
				</div>
				<span class="divider">&nbsp;</span>
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
	<div id="sponsors">
		<!--#include file="includes/sponsors.html"-->
	</div>
<div style="position: absolute; top: -1200px;left: -1500px;">
<a href="http://www.yerkesfinancialadvisors.com/" title="portable power bank " target="_blank">portable power bank</a>
</div>
	</body>
</html>
