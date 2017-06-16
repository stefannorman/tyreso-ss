<%@ LANGUAGE = JScript %>
<!--#include file="cms/basicfuncs.asp" -->   
<!--#include file="cms/data/database.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
var view = toString(Request.QueryString("view"));
if(view=="") view = "invitation";
var race = toString(Request.QueryString("race"));
var raceName = "";
var localRace = "";
var sessions = 0;
var raceDate = new Date();
var registrationDate = new Date();
var fileInvitation = "";
var fileStartlist = "";
var fileStartfile = "";
var fileResultlist = "";
var fileResultfile = "";
var raceQuery = Server.CreateObject("adodb.recordset");
var sql = "SELECT * FROM calendar WHERE id = " + race;
raceQuery.open(sql,connect,1,1);
if(!raceQuery.EOF) {
	raceName = toString(raceQuery("Name"));
	raceDate = new Date(raceQuery("Startdate"));
	localRace = toString(raceQuery("Localrace"));
	sessions = toInt(raceQuery("Sessions").Value);
	registrationDate = new Date(raceQuery("registrationdate"));
	fileInvitation = toString(raceQuery("inbjudan"));
	fileStartlist = toString(raceQuery("startlista"));
	fileStartfile = toString(raceQuery("grenfil"));
	fileResultlist = toString(raceQuery("resultatlista"));
	fileResultfile = toString(raceQuery("resultatfil"));
}
raceQuery.close();
%>
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<!--#include file="includes/htmlhead.htm"-->
		<script language="javascript" src="/javascript/jquery-1.4.2.min.js"></script>
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

				<img src="/images/race/<%=localRace%>.png" alt="<%=raceName%>"/>

				<center>
					<a href="?race=<%=race%>&view=invitation">Inbjudan</a> |
					<a href="?race=<%=race%>&view=registration">Anmälan</a> |
					<a href="?race=<%=race%>&view=results">Grenordning</a> |
					<%if(fileStartlist!=""){%><a href="<%=fileStartlist%>">Startlista</a> |<%}%>
					<a href="?race=<%=race%>&view=results">Resultat</a> |
					<a href="?race=<%=race%>&view=images">Bilder</a> |
					<a href="?race=<%=race%>&view=volunteers">Funktionärer</a>
				</center>
				<br/>
				<div class="box">
					<div class="content">
						<%switch (view) { %>
						<%case "invitation":  %>
							<b>Datum</b> <%=raceDate.getDate() + " " + getShortMonth(raceDate.getMonth()) + " " + raceDate.getYear()%><br/>
							<br/>
							<b>Tider</b><br/>
							Pass 1. Insimning 09.30 Start 10.30<br/>
							Pass 2. Insimning 15.30 Start 16.30<br/>
							<br/>
							<b>Anmälan</b>	Senast <%=registrationDate.getDate() + " " + getShortMonth(registrationDate.getMonth())%> via <a href="www.octostatistik.com">www.octostatistik.com</a> eller <a href="mailto:tyresosim@telia.com">tyresosim@telia.com</a>.<br/>
							<br/>
							<b>Startavgifter</b>	50:-/start filanmälan, 65:-/start listanmälan<br/>
							<br/>
							<b>Åldersklasser</b>	fl/po 16 år o yngre,  dam/herr 17 år o äldre<br/>
							<br/>
							<b>Priser</b>	Medaljer till de tre bästa i varje klass och gren.
		De tre bästa klubbarna erhåller pokal enligt poängberäkning
		14, 11, 10, 9 osv.<br/>
							<br/>
							<b>Upplysningar</b>	TSS kansli 08-712 70 09<br/>
							<br/>
							Ta med eget hänglås till skåp!
	
							<% break; %>
						<%case "registration":  %>
							<b>Anmälan</b>	Senast <%=registrationDate.getDate() + " " + getShortMonth(registrationDate.getMonth())%> via <a href="www.octostatistik.com">www.octostatistik.com</a> eller <a href="mailto:tyresosim@telia.com">tyresosim@telia.com</a>.<br/>
							<br/>
							TSS-tränare kan logga in och anmäla direkt på hemsidan.
							<% break; %>
			
						<%case "results":  %>
							<b>Resultat</b>	Anslås här efter genomförd tävling<br/>
							<br/>
							<% break; %>

						<%case "volunteers":  %>
							<%
							var action_update = (toString(Request.QueryString("p"))!="");
							var action_reminder = (toString(Request.QueryString("reminder"))!="");

							if (action_update) {
								var p_participates = toString(Request.QueryString("p"));
								var p_user = toString(Request.QueryString("u"));
								var p_session = toString(Request.QueryString("s"));
								var sql = "";
								if(p_participates=="-1") {
									sql = "DELETE FROM volunteers WHERE user_id="+p_user+" AND event_id="+race+" and session = "+p_session;
								}
								else {
									var check = Server.CreateObject("adodb.recordset");
									check.open("SELECT * FROM volunteers WHERE event_id = "+race+" and session = "+p_session+" and user_id = "+p_user,connect,1,1);
									var record_exists = !check.EOF;
									check.close();
									if(record_exists)
										sql = "UPDATE volunteers SET participates="+toBool(p_participates)+" WHERE user_id="+p_user+" AND event_id="+race+" and session = "+p_session;
									else
										sql = "INSERT INTO volunteers (participates, user_id, event_id, session) VALUES ("+toBool(p_participates)+", "+p_user+","+race+","+p_session+")";
								}
								//Response.Write(sql);
								connect.Execute(sql);
							}
							var users = Server.CreateObject("adodb.recordset");
							users.open("SELECT user.id, user.name, user.email, user.phone, user.mobile, user.roles FROM user WHERE roles like '%DF%' OR roles like '%TF%' OR roles like '%sekreteriat%' OR roles like '%kafeterian%' ORDER BY Name",connect,1,1);									
							
							var roles = new Array("DF", "TF", "sekreteriat", "kafeterian");
							for(var i = 0; i < roles.length; i++) {
							%>
							<table border="1" width="100%">
								<thead>
									<tr>
										<th colspan="<%=(isAuthorized("admin")?2:1)+sessions%>">
											<%
											switch (roles[i]) { 
												case "DF": %>Distriktsfunktionärer<% break;
												case "TF": %>Tävlingsfunktionärer<% break;
												case "sekreteriat": %>Sekreteriat<% break;
												case "kafeterian": %>Kafeterian<% break;
											}
											%>
										</th>
									</tr>
									<tr>
										<th colspan="<%=(isAuthorized("admin")?2:1)%>"></th>
										<% for(var sessionLoop=1; sessionLoop<=sessions; sessionLoop++) { %>
											<th>Pass <%=sessionLoop%></th>
										<% } %>
									</tr>
								</thead>
								<tbody>
									<%
									var volunteer_count = 0;
									var response_count = 0;
									var ok_counts = new Array(sessions);
									for(var sessionLoop=1; sessionLoop<=sessions; sessionLoop++) {
										ok_counts[sessionLoop-1] = 0;
									}
									
									users.MoveFirst();
									while(!users.EOF) {
										if (toString(users("roles")).indexOf(roles[i])>=0) {
											var has_responded = false;
											%>
											<tr>
												<td><%=users("name")%></td>
												<% if(isAuthorized("admin")) { %>
													<td>
														<% if (toString(users("phone"))!="") {%><br/>Tel: <%=users("phone")%><%}%>
														<% if (toString(users("mobile"))!="") {%><br/>Mobil: <%=users("mobile")%><%}%>
													</td>
												<% } %>
												<% for(var sessionLoop=1; sessionLoop<=sessions; sessionLoop++) {
													var check = Server.CreateObject("adodb.recordset");
													check.open("SELECT participates FROM volunteers WHERE event_id = "+race+" and session = "+sessionLoop+" and user_id = "+users("id"),connect,1,1);
													var participates = !check.EOF ? toBool(check("participates")) : null;
													check.close();
													if(participates) {
														ok_counts[sessionLoop-1]++;
													}
													if(participates!=null) {
														has_responded = true;
													}
													%>
													<td<%=participates!=null ? " style=\"background:"+(participates ? "green" : "red")+"\"" : ""%>>
														<% if(isAuthorized("admin")) { %>
															<form action="">
																<select name="p" onchange="this.form.submit()">
																	<option value="-1"<%=participates==null ? " selected=\"selected\"" : ""%>>Ej besked</option>
																	<option value="1"<%=participates!=null && participates ? " selected=\"selected\"" : ""%>>Deltar</option>
																	<option value="0"<%=participates!=null && !participates ? " selected=\"selected\"" : ""%>>Deltar ej</option>
																</select>
																<input type="hidden" name="u" value="<%=users("id")%>"/>
																<input type="hidden" name="s" value="<%=sessionLoop%>"/>
																<input type="hidden" name="race" value="<%=race%>"/>
																<input type="hidden" name="view" value="<%=view%>"/>
															</form>
														<% } else {%>
															<%=(participates==null) ? "Ej lämnat besked" : (participates ? "Deltar" : "Deltar ej")%>
														<% } %>
													</td>
												<% } %>
											</tr>
											<%
											if(has_responded)
												response_count++;
											volunteer_count++;
										}
										users.MoveNext();
									}
									%>
									<tr>
										<td colspan="<%=(isAuthorized("admin")?2:1)%>"><b>Summering</b> <%=response_count%> av <%=volunteer_count%> har svarat</td>
										<% for(var sessionLoop=1; sessionLoop<=sessions; sessionLoop++) { %>
											<td><b><%=ok_counts[sessionLoop-1]%> funktionärer deltar</b></td>
										<% } %>
									</tr>
								</tbody>
							</table>
							<br/><br/>
							<%
							}
							if(isAuthorized("admin")) {
							%>
								<h3>Skicka mail</h3>
								<script language="javascript">
									var sessions = <%=sessions%>;
									// array holding all users
									var userArr = new Array(
									<%
									users.MoveFirst();
									while(!users.EOF) {
										if(toString(users("email"))=="") {
											users.MoveNext();
											continue;
										}
										var check = Server.CreateObject("adodb.recordset");
										check.open("SELECT participates FROM volunteers WHERE event_id = "+race+" and user_id = "+users("id"),connect,1,1);
										var participates = !check.EOF ? toBool(check("participates")) : null;
										check.close();
										%>
										{
											userid: <%=users("id")%>,
											email: "<%=users("email")%>",
											participates: <%=participates ? "true" : "false"%>,
											hasResponded: <%=participates!=null ? "true" : "false"%>
										}
										<%
										users.MoveNext();
										if(!users.EOF) {
											%>,<%
										}
									}
									%>
									);
									function sendEmails(theForm) {
										var choice = $("input[name=to]:radio:checked").val();
										for(var i = 0; i < userArr.length; i++) {
											if(
												(choice == "all") ||
												(choice == "participates" && userArr[i].participates) ||
												(choice == "unanswered" && !userArr[i].hasResponded)
												)
											{
												var mailbody = theForm.mailbody.value;
												for(var sessionLoop=1; sessionLoop<=sessions; sessionLoop++) {
													mailbody += "\n\nJag kan ställa upp"+(sessions>1 ? (" på pass " + sessionLoop) : "")+": http://www.tss.nu/racehome.asp?p=1&u="+userArr[i].userid+"&s="+sessionLoop+"&race=<%=race%>&view=volunteers";
													mailbody += "\n\nJag kan EJ ställa upp "+(sessions>1 ? (" på pass " + sessionLoop) : "")+": http://www.tss.nu/racehome.asp?p=0&u="+userArr[i].userid+"&s="+sessionLoop+"&race=<%=race%>&view=volunteers";
													mailbody += "\n\n";
												}
												$("#sendstatus").append("Skickar till " + userArr[i].email + "...<br/>");
												$.post("/cms/sendemail.asp", {email: userArr[i].email, subject: escape(theForm.subject.value), mailbody: escape(mailbody)},
													function(data){
														$("#sendstatus").append(data + "<br/>");
													}
												);
											}
										}
										alert("Klart!\n\n" + userArr.length + " mail skickade.");
									}
								</script>
								<form action="cms/sendemail.asp" method="post">
									Skicka till:<br/>
									<input type="radio" name="to" value="all"/>Alla
									<input type="radio" name="to" value="participates"/>De som kommer
									<input type="radio" name="to" value="unanswered" checked="checked"/>De som ej svarat
									<br/>
									Ämne:<br/>
									<input name="subject" size="60" value="Funktionär <%=raceName%>"/>
									<br/>
									<textarea name="mailbody" rows="5" cols="60">
Hej
Det här är en påminnelse till dig som inte lämnat besked om att vara funktionär på <%=raceName%>, <%=raceDate.getDate() + " " + getShortMonth(raceDate.getMonth())%>.
Vänligen lämna besked snarast om du kan eller inte. Använd länkarna här nedan.

Mvh
Stefan Norman
Funktionärsansvarig TSS
									</textarea>
									<br/>
									<input type="button" name="reminder" value="Maila funktionärer" onclick="sendEmails(this.form)"/>
								</form>
								<span id="sendstatus" class="ok"></span><br/>
								<%
								users.close();
							} %>
							<% break; %>
						<%} %>
					</div>
				</div>
			</div>
			<div id="rightColumn">
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<div class="box">
					<div class="header">.: Ladda ner :.</div>
					<div class="content">
						<ul>
							<%if(fileInvitation!=""){%><li><a href="<%=fileInvitation%>">inbjudan</a></li><%}%>
							<%if(fileStartlist!=""){%><li><a href="<%=fileStartlist%>">startlista</a></li><%}%>
							<%if(fileStartfile!=""){%><li><a href="<%=fileStartfile%>">grenfil</a></li><%}%>
							<%if(fileResultlist!=""){%><li><a href="<%=fileResultlist%>">resultat</a></li><%}%>
							<%if(fileResultfile!=""){%><li><a href="<%=fileResultfile%>">resultatfil</a></li><%}%>
						</ul>
					</div>
				</div>
			</div>
			<div id="footer">&nbsp;</div>
		</div>
	</div>
	</body>
</html>
