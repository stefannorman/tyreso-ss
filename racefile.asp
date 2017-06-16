<%@ LANGUAGE = JScript %><%Response.ContentType = "text/plain";%>
<!--#include file="cms/check.inc" -->
<!--#include file="cms/basicfuncs.asp" -->   
<!--#include file="cms/data/database.asp" -->
<%
var event_id = toString(Request.QueryString("event"));
var swimmer_id = toString(Request.QueryString("swimmer"));
var start_id = toString(Request.QueryString("start"));
var action = toString(Request.QueryString("action"));
var sql;

var query = Server.CreateObject("adodb.recordset");
sql = "SELECT name, location, startdate, Date() as today, groups, grenfil FROM calendar WHERE id=" + event_id;
query.open(sql,connect,1,1);
var eventName = toString(query("name"));
var eventLocation = toString(query("location"));
var eventDate = toString(query("startdate"));
var today = toString(query("today"));
var grenfil = toString(query("grenfil"));
query.close();

// read grenfil
var fso = new ActiveXObject("Scripting.FileSystemObject");
var ts = fso.OpenTextFile(Server.MapPath(grenfil),1,false);
// skip first line
ts.skipLine();

var line;
var swimmerStarts = new Array();
while (!ts.AtEndOfStream) {
	line = ts.ReadLine();
	var lineArray = line.split(";");
	var gender = trim(lineArray[1]);
	var startID = trim(lineArray[0]);
	var startText = trim(lineArray[2]);
	var poolLength = trim(lineArray[3]);

	sql = "SELECT swimmer FROM eventstart WHERE event_id=" + event_id + " AND start = " + startID;
	query.open(sql,connect,1,1);
	while(!query.EOF) {
		var swimStart = new Object();
		swimStart.gender = gender;
		swimStart.startID = startID;
		swimStart.startText = startText;
		swimStart.poolLength = poolLength;
		swimStart.swimmer = toString(query("swimmer"));
		swimmerStarts.push(swimStart);
		query.MoveNext();
	}
	query.close();
}
%>
<%="25309"%>;<%=rfill("Tyresö Simsällskap", 30)%>;<%=eventDate%>;<%=rfill(eventName, 30)%>;<%=rfill(eventLocation, 20)%>;<%=rfill(today, 18)%><%="\r\n"%>
<%
for(var i = 0; i < swimmerStarts.length; i++) {
	var swimCode = 0;
	var startText = swimmerStarts[i].startText;
	
	// Fix the startText to match Grodan. Examples in Grodan: "100m Frisim", "25m Bröstsim"

	// fixing SummerGames grenfil in english
	startText = startText.replace(" abc", "");
	startText = startText.replace(" de", "");
	startText = startText.replace(" girls", "");
	startText = startText.replace(" gir", "");
	startText = startText.replace(" boys", "");
	startText = startText.replace(" boy", "");
	startText = startText.replace("free style", "frisim");
	startText = startText.replace("backstroke", "ryggsim");
	startText = startText.replace("butterfly", "fjärilsim");
	startText = startText.replace("breaststroke", "bröstsim");

	startText = startText.replace(" Herrar", "");
	startText = startText.replace(" Damer", "");
	startText = startText.replace(" Mixed", "");
	
	sql = "SELECT Simsatt"+swimmerStarts[i].poolLength+" as swimcode " + 
	      "FROM simsatt WHERE Ucase(Simsatt) = '" + startText.toUpperCase() + "'";
	query.open(sql,grodan,1,1);
	if(!query.EOF) {
		swimCode = toInt(query("swimcode"));
	}
	query.close();

	var pbTime = "";
	var pbDatum = "";
	var pbRace = "";
	if(swimCode > 0) {
		sql = "SELECT min(tid) as pbtid " + 
		      "FROM Tider WHERE val(simsettnr) = " + swimCode + " and IDNummer2 = " + swimmerStarts[i].swimmer;
		query.open(sql,grodan,1,1);
		if(!query.EOF) {
			pbTime = trim(toString(query("pbtid")));
		}
		query.close();
		if(pbTime.length > 0) {
			sql = "SELECT t.datum, r.tavling " + 
			      "FROM Tider t, Tavling r WHERE t.tavlingsnr = r.tavlingsnr and val(t.simsettnr) = " + swimCode + " and t.IDNummer2 = " + swimmerStarts[i].swimmer + " and t.tid = '" + pbTime + "'";
			query.open(sql,grodan,1,1);
			if(!query.EOF) {
				pbDatum = toString(query("datum"));
				pbRace = toString(query("tavling"));
			}
			query.close();
		}
	}
	if(pbTime == "") {
		pbTime = "00:00.00";
	}

	sql = "SELECT kod, fodelsear, IDNummer, namn, efternamn, klass " + 
	      "FROM Medlem WHERE IDNummer = " + swimmerStarts[i].swimmer;
	query.open(sql,grodan,1,1);
	var swimmerName = query("namn") + " " + query("efternamn");
	%>
	<%=rfill(toString(query("kod")), 6)%>;<%=rfill(toString(query("IDNummer")), 6)%>;<%=rfill(swimmerName, 25)%>;<%=query("fodelsear")%>;<%=rfill(query("klass"), 2)%>;<%=formatNumber(toInt(swimmerStarts[i].startID))%>;<%=formatNumber(swimCode)%>;<%=rfill(pbDatum, 10)%>;<%=pbTime%>;<%=rfill(pbRace, 20)%>;<%=rfill("", 10)%>;<%=rfill("", 11)%><%="\r\n"%>
	<%
	query.close();
}
%>
