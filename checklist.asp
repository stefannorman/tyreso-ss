<%@ LANGUAGE = JScript %>
<!--#include file="cms/basicfuncs.asp" -->
<!--#include file="cms/data/database.asp" -->
<!--#include file="cms/objects/Race.asp" -->
<%
//connect.Execute("ALTER TABLE calendar ADD COLUMN checklist integer null");

// get race from db
var race = new Race(toString(Request.QueryString("race")));
var choice = race.checklist;

// if checkbox is clicked update db
if(toString(Request.QueryString("task")) != "") {
	choice = 0;
	var reqEnumerator = new Enumerator(Request.QueryString("task"));
	while(!reqEnumerator.atEnd()) {
	    choice = choice + toInt(toString(reqEnumerator.item()));
	    reqEnumerator.moveNext();
	}
	connect.Execute("UPDATE calendar SET checklist=" + choice + " WHERE id = " + race.id);
}

// all tasks
// OBS om ordningen ?ndras s? blir redan sparat data felaktigt
var tasks = [
	["Boka Västerås Tidtagning", 120],
	["Boka simhallen", 60],
	["Ladda upp inbjudan på hemsida", 30],
	["Gör grenfil", 30],
	["Skicka ut inbjudan", 30],
	["Utskick till föräldrarna", 30],
	["Kalla funktionärer", 30],
	["Hyr podiet", 30],
	["Beställ pokaler/medaljer", 20],
	["Boka tävlingsledare", 20],
	["Boka starter", 20],
	["Beställ nyttopriser", 20],
	["Ordna fram minimaxmedaljer", 20],
	["Beställ fika av Medley", 20],
	["Kolla ev funktionärsbrist", 10],
	["Gör deltagarlista", 3],
	["Fixa tävlingsdator", 2]
];

var now = new Date();
%>
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
				<h1>Checklista <%=race.name%></h1>
				<form>
				<% for (var i = 0; i < tasks.length; i++) {
					var val = (i==0 ? 1 : val*2);
					var isChecked = ((choice | val) == choice);
					var dueDays = toInt(tasks[i][1]);
					var dueDate = new Date(race.date.getTime()-dueDays*24*60*60*1000);
					var panic = now.getTime() > dueDate.getTime() && !isChecked;
					%>
					<span style="background:<%=panic ? "red" : "none"%>">
					<input
						name="task"
						type="checkbox"
						onclick="this.form.submit()"
						value="<%=val%>"
						<%=isChecked ? "checked=\"checked\"" : ""%>
						<%=isAuthorized("admin") ? "" : "disabled=\"disabled\""%>
					/><%=tasks[i][0]%> (senast <%=dueDays%> dagar innan, dvs <%=getDateString(dueDate)%>)
					</span><br/>
				<% } %>
				<input type="hidden" name="race" value="<%=race.id%>"/>
				</form>
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
