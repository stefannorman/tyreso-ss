<%@ LANGUAGE = JScript %>
<!--#include file="cms/basicfuncs.asp" -->   
<!--#include file="cms/data/database.asp" -->   
<!--#include file="cms/objects/News.asp" -->   
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
var group = toString(Request.QueryString("group"));
var groupName = "";
var groupQuery = Server.CreateObject("adodb.recordset");
var sql = "SELECT aktivitetsgruppnamn FROM aktivitetsgrupper WHERE aktivitetsgruppID = " + group;
groupQuery.open(sql,servette,1,1);
if(!groupQuery.EOF) {
	groupName = toString(groupQuery("aktivitetsgruppnamn"));
}
groupQuery.close();

var newsList = new NewsList(group, toString(Request.QueryString("year")));
%>
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<!--#include file="includes/htmlhead.htm"-->
		<link rel="alternate" title="Tyresö SS - <%=groupName%>" href="http://www.tss.nu/rss.asp?category=<%=group%>&title=<%=Server.URLEncode('Tyresö SS - ' + groupName)%>" type="application/rss+xml"/>
		<script src="javascript/kanslietonline.js"></script>
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
					<div class="header">.: Nyheter/Resultat f&ouml;r Grupp <%=groupName%> :.</div>
					<div class="content">
						<!--#include file="cms/newsList.asp" -->
						<% if(newsList.articles.length == 0) { %>
							<span class="newsheader">Inget skrivet ännu</span>
							<br/>
							Här är det tänkt att tränaren/lagledaren ska skriva notiser om gruppen.<br/>
							Om du är tränare så <a href="/admin.asp">logga in</a> och skriv. Funderingar? Maila <a href="mailto:webmaster@tss.nu">webbmastern</a>.
							<hr class="line" />
						<% } %>
					</div>
				</div>
			</div>
			<div id="rightColumn">
				<%

				var query = Server.CreateObject("adodb.recordset");
				var sql = "SELECT id, name, startdate, registrationdate, groups FROM calendar WHERE len(grenfil) > 0 AND startdate >= Date() AND registrationdate < Date() ORDER BY startdate";
				query.open(sql,connect,1,1);
				if(!query.EOF) {
				%>
					<div class="box">
						<div class="header">.: Startlistor för tävlingar :.</div>
						<div class="content">
							<table width="100%">
							<%
							while(!query.EOF) {
								%>
								<tr>
									<td><b><%=query("name")%></b></td>
									<td><%=query("startdate")%></td>
									<td><a href="raceday.asp?event=<%=query("id")%>&group=<%=group%>">Hämta startlista</a></td>
								</tr>
								<%
								query.MoveNext();
							}
							query.close();
							%>
							</table>
						</div>
					</div>
					<span class="divider">&nbsp;</span>
				<%
				}
				%>
				<%
                                var kanslietOnlineGroupURL = "http://tss.nu.preview.binero.se/sektion/";
				switch(group) {
                                case "113": // ES
                                  kanslietOnlineGroupURL += "tavlingsgrupper/elitgruppen/1-6/grupp/6-161/";
                                  break;
                                case "163": // DM
                                  kanslietOnlineGroupURL += "";
                                  break;
                                case "4": // A
                                  kanslietOnlineGroupURL += "tavlingsgrupper/a-gruppen/1-1/grupp/1-159/";
                                  break;
                                case "90": // B
                                  kanslietOnlineGroupURL += "tavlingsgrupper/b-gruppen/1-3/grupp/3-160/";
                                  break;
                                case "89": // C
                                  kanslietOnlineGroupURL += "tavlingsgrupper/c-gruppen/1-7/grupp/7-162/";
                                  break;
                                case "109": // D-Röd
                                  kanslietOnlineGroupURL += "tavlingsgrupper/d-grupper/1-9/grupp/9-164/";
                                  break;
                                case "85": // D-Blå
                                  kanslietOnlineGroupURL += "tavlingsgrupper/d-grupper/1-9/grupp/8-163/";
                                  break;
                                case "31": // UG
                                  kanslietOnlineGroupURL += "traningsgrupper/traningsgrupper/6-13/grupp/16-108/";
                                  break;
                                case "131": // T-41
                                  kanslietOnlineGroupURL += "teknikskola/tekniknivaer/3-4/grupp/15-141/";
                                  break;
                                case "35": // T-71
                                  kanslietOnlineGroupURL += "teknikskola/tekniknivaer/3-4/grupp/15-144/";
                                  break;
                                case "34": // T-72
                                  kanslietOnlineGroupURL += "teknikskola/tekniknivaer/3-4/grupp/15-142/";
                                  break;
                                case "76": // T-73
                                  kanslietOnlineGroupURL += "teknikskola/tekniknivaer/3-4/grupp/15-143/";
                                  break;
                                case "44": // TK-41
                                  kanslietOnlineGroupURL += "teknikskola/tekniknivaer/3-4/grupp/5-171/";
                                  break;
                                case "45": // TK-42
                                  kanslietOnlineGroupURL += "teknikskola/tekniknivaer/3-4/grupp/5-172/";
                                  break;
                                case "114": // TK-71
                                  kanslietOnlineGroupURL += "teknikskola/tekniknivaer/3-4/grupp/5-173/";
                                  break;
                                case "132": // TK-72
                                  kanslietOnlineGroupURL += "teknikskola/tekniknivaer/3-4/grupp/5-174/";
                                  break;
                                case "42": // SK-71
                                  kanslietOnlineGroupURL += "teknikskola/tekniknivaer/3-4/grupp/4-137/";
                                  break;
                                case "141": // SK-72
                                  kanslietOnlineGroupURL += "teknikskola/tekniknivaer/3-4/grupp/4-138/";
                                  break;
                                case "166": // SK-73
                                  kanslietOnlineGroupURL += "teknikskola/tekniknivaer/3-4/grupp/4-168/";
                                  break;
                                case "167": // SK-74
                                  kanslietOnlineGroupURL += "teknikskola/tekniknivaer/3-4/grupp/4-169/";
                                  break;
                                case "168": // SK-75
                                  kanslietOnlineGroupURL += "teknikskola/tekniknivaer/3-4/grupp/4-139/";
                                  break;
                                case "169": // SK-76
                                  kanslietOnlineGroupURL += "teknikskola/tekniknivaer/3-4/grupp/4-140/";
                                  break;
				}
				/* saknade grupper i Servette
                                  SK-41 "teknikskola/tekniknivaer/3-4/grupp/4-107/"
                                */

				var objSrvHTTP;
				objSrvHTTP = Server.CreateObject("Msxml2.ServerXMLHTTP.6.0");
				objSrvHTTP.open ("GET",kanslietOnlineGroupURL, false);
				objSrvHTTP.send ();
				Response.Write (objSrvHTTP.responseText);
				%>
<!--
				<div class="box">
					<div class="header">.: Tr&auml;nare :.</div>
					<div class="content">
						<div class="coaches">
						<%
						var fso = new ActiveXObject("Scripting.FileSystemObject"); 						
						
						var coachQuery = Server.CreateObject("adodb.recordset");
						var sql = "SELECT m.medlemsnummer, m.förnamn, m.efternamn, m.epost FROM medlemmar m, aktivitetsgrupper a WHERE m.medlemsnummer in (a.instruktörsID, a.assistentID, a.assistentID_2)  and a.aktivitetsgruppID = " + group;
						coachQuery.open(sql,servette,1,1);
						while(!coachQuery.EOF) {
							var imageURL = "/images/members/" + toString(coachQuery("medlemsnummer")) + ".jpg";
							if(fso.FileExists(Server.MapPath(imageURL))) {
								%>
								<img src="<%=imageURL%>" /><br/>
								<%
							}
							%>
							<a href="" onclick="var em = '<%=obfuscateEmail(coachQuery("epost"))%>';this.href='mail'+'to'+':'+em.replace('_KEFF_', '@').replace('_KOFF_', '.');"><%=coachQuery("förnamn")%>&nbsp;<%=coachQuery("efternamn")%></a><br>
							<%
							coachQuery.MoveNext();
						}
						coachQuery.close();
						%>
						</div>
					</div>
				</div>
				<span class="divider">&nbsp;</span>
				<div class="box">
					<div class="header">.: Tr&auml;ningstider :.</div>
					<div class="content">
						<% switch(group) { %>
							<% case "113": // ES %>
								Måndag: 16:30-19:00<br />
								Tisdag: 06:00-08:00<br />
								Tisdag: 16:30-18:30<br />
								Onsdag: 06:00-08:00<br />
								Onsdag: 16:30-19:00<br />
								Torsdag: 06:00-08:00<br />
								Torsdag: 17:30-20:00<br />
								Söndag: 17:00-20:00<br />
							<% break; case "163": // DM %>
								Måndag: 16:30-19:00<br />
								Tisdag: 16:30-18:30<br />
								Onsdag: 06:00-08:00<br />
								Onsdag: 16:30-19:00<br />
								Torsdag: 06:00-08:00<br />
								Torsdag: 19:00-21:30<br />
								Söndag: 17:00-20:00<br />
							<% break; case "4": // A %>
								Måndag: 17:00-17:30 Landträning<br />
								Måndag: 17:30-19:00<br />
								Onsdag: 06:00-08:00<br />
								Onsdag: 17:00-17:30 Landträning<br />
								Onsdag: 17:30-19:00<br />
								Torsdag: 06:00-08:00<br />
								Torsdag: 19:00-19:30 Landträning<br />
								Torsdag: 19:30-21:30<br />
								Söndag: 16:30-17:00 Landträning<br />
								Söndag: 17:00-19:00<br />
							<% break; case "90": // B %>
								Måndag: 16:30-17:30<br />
								Måndag 17.30-18.00 Landträning<br />
								Onsdag: 06:00-08:00<br />
								Onsdag 16.00-16.30 Landträning<br />
								Onsdag: 16:30-17:30<br />
								Torsdag: 06:00-08:00<br />
								Torsdag 18.30-19.00 Landträning<br />
								Torsdag: 19:00-21:00<br />
								Söndag  16.30-17.00 Landträning<br />
								Söndag: 17:00-18:30<br />
							<% break; case "89": // C %>
								Måndag: 15:30-16:30 (inkl 30 min landträning)<br />
								Tisdag: 15:30-16:30<br />
								Onsdag: 15:30-16:30<br />
								Söndag: 16:00-17:00<br />
							<% break; case "109": // D-Röd %>
								Onsdag: 16:00-17:00<br />
								Torsdag: 17:45-19:00<br />
								Söndag: 15:45-17:00<br />
							<% break; case "85": // D-Blå %>
								Tisdag: 18:15-19:30<br />
								Onsdag: 16:00-17:00<br/>
								Söndag: 16:45-18:00
							<% break; case "31": // UG %>
								Torsdag: 20:00-21:30<br />
								Söndag: 18:45-20:00<br />
							<% break; case "131": // T-41 %>
								Torsdagar 17:45-19:00
							<% break; case "35": // T-71 %>
								Söndagar 16:45-18:00
							<% break; case "34": // T-72 %>
								Söndagar 15:45-17:00
							<% break; case "76": // T-73 %>
								Söndagar 17:45-19:00
							<% break; case "44": // TK-41 %>
								Torsdagar 18:45-20:00
							<% break; case "45": // TK-42 %>
								Torsdagar 18:45-20:00
							<% break; case "114": // TK-71 %>
								Söndagar 18:45-20:00
							<% break; case "132": // TK-72 %>
								Söndagar 18:45-20:00
							<% break; case "42": // SK-71 %>
								Söndagar 15:45-16:30
							<% break; case "141": // SK-72 %>
								Söndagar 15:45-16:30
							<% break; case "166": // SK-73 %>
								Söndagar 16:15-17:00
							<% break; case "167": // SK-74 %>
								Söndagar 16:15-17:00
						<% break; } %>
					</div>
				</div>
				<span class="divider">&nbsp;</span>
				<div class="box">
					<div class="header">.: Simmare :.</div>
					<div class="content" id="swimmerBoxContent">


						<%
						var emailAddresses = "";
						var missingEmail = "";
						var swimmersQuery = Server.CreateObject("adodb.recordset");
						var sql = "SELECT m.förnamn, m.efternamn, m.epost FROM medlemmar m, [Kopplingar medlemmar och aktivitetsgrupper] k WHERE k.medlemsnummer = m.medlemsnummer and k.period = "+termin+" and k.aktivitetsgruppID = " + group + " ORDER BY m.efternamn, m.förnamn";
						swimmersQuery.open(sql,servette,1,1);
						while(!swimmersQuery.EOF) {
							var name = toString(swimmersQuery("förnamn")) + " " + toString(swimmersQuery("efternamn"));
							var email = toString(swimmersQuery("epost"));
							if(email != "") {
								emailAddresses += email + ";";
							} else {
								missingEmail += name + "\\n";
							}
							if(email != "" && isAuthorized("coach")) {
								%><a href="mailto:<%=email%>"><%=name%></a><%
							} else {
								%><%=name%><%
							}
							%><br><%
							swimmersQuery.MoveNext();
						}
						swimmersQuery.close();
						if(isAuthorized("coach") && emailAddresses != "") {
							%>
							<br/>
							<img src="/images/mailicon.gif" class="mailicon"/>
							<a href="mailto:<%=emailAddresses%>"<%=(missingEmail != "")? " onclick=\"alert('OBS! En del simmare har ingen epostadress registrerad:\\n\\n"+missingEmail+"')\"" : ""%>>Maila alla simmarna</a>
							<%
						}
						%>
					</div>
				</div>
-->
				<span class="divider">&nbsp;</span>
				<div class="box">
					<%
					var _showOnlyGroup = groupName;
					if(_showOnlyGroup.indexOf("T")==0 || _showOnlyGroup.indexOf("UG")==0)
						_showOnlyGroup = "T"; // both T and TK...
					if(_showOnlyGroup.indexOf("D ")==0)
						_showOnlyGroup = "D"; // both D-röd and D-blå...
					%>
					<!--#include file="includes/nextcalendar.asp" -->
				</div>
			</div>
			<div id="footer">&nbsp;</div>
		</div>
	</div>
	</body>
</html>
