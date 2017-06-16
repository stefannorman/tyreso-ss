<%@ LANGUAGE = JScript %>
<!--#include file="cms/basicfuncs.asp" -->
<!--#include file="cms/data/database.asp" -->
<!--#include file="cms/objects/Race.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
// handle request parameters
var p_race = toString(Request.QueryString("race"));

// initialize objects used in the page
var race = new Race(p_race);

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

				<% if(p_race != "") { %>
					<h1>Funktionärer <%=race.name%></h1>
					<p>
						Aktuellt funktionärsläge till tävlingen.
					</p>
				<% } else { %>
					<h1>Bonuskonton</h1>
					<p>
						Bonuskontot fylls på när man är tävlingsfunktionär eller kafetereiapersonal vid en av våra tävlingar, eller vid tävling där TSS ställer upp med funktionärer.
						Man får 100 kr per tävlingspass.
						Bonuskontot kan användas vid betalning av träningsläger. Max upp till 20% av lägeravgiften.<br/>
						Klicka på ditt namn för att se aktuellt saldo.
					</p>
				<% } %>
				<div class="box">
					<div class="content">
							<%
							var action_update = (toString(Request.QueryString("p"))!="");
							var action_reminder = (toString(Request.QueryString("reminder"))!="");

							if (action_update) {
								var p_participates = toString(Request.QueryString("p"));
								var p_user = toString(Request.QueryString("u"));
								var p_session = toString(Request.QueryString("s"));
								var sql = "";
								if(p_participates=="-1") {
									sql = "DELETE FROM volunteers WHERE user_id="+p_user+" AND event_id="+p_race+" and session = "+p_session;
								}
								else {
									var check = Server.CreateObject("adodb.recordset");
									check.open("SELECT * FROM volunteers WHERE event_id = "+p_race+" and session = "+p_session+" and user_id = "+p_user,connect,1,1);
									var record_exists = !check.EOF;
									check.close();
									if(record_exists)
										sql = "UPDATE volunteers SET participates="+toBool(p_participates)+" WHERE user_id="+p_user+" AND event_id="+p_race+" and session = "+p_session;
									else
										sql = "INSERT INTO volunteers (participates, user_id, event_id, session) VALUES ("+toBool(p_participates)+", "+p_user+","+p_race+","+p_session+")";
								}
								//Response.Write(sql);
								connect.Execute(sql);
							}
							var users = Server.CreateObject("adodb.recordset");
							users.open("SELECT user.id, user.name, user.email, user.phone, user.mobile, user.roles FROM user WHERE roles like '%DF%' OR roles like '%TF%' OR roles like '%sekreteriat%' OR roles like '%kafeterian%' OR roles like '%UF%'OR roles like '%XF%' ORDER BY Name",connect,1,1);

							var roles = new Array("DF", "TF", "sekreteriat", "UF", "XF");
							if(p_race != "") {
								// visa inte fd funkisar p? enskild t?vling
								roles = new Array("DF", "TF", "sekreteriat", "UF");
							}
							for(var i = 0; i < roles.length; i++) {
							%>
							<table border="1" width="100%">
								<thead>
									<tr>
										<% if(isAuthorized("admin")) { %>
											<th><input type="checkbox" onclick="$('input[name=recipient_<%=roles[i]%>]').attr('checked', this.checked)"/></th>
										<% } %>
										<th colspan="<%=(isAuthorized("admin")?2:1)+race.sessions%>">
											<%
											switch (roles[i]) {
												case "DF": %>Distriktsfunktionärer<% break;
												case "TF": %>Tävlingsfunktionärer<% break;
												case "sekreteriat": %>Sekreteriat<% break;
												case "UF": %>Ungdomsfunktionärer<% break;
												case "XF": %>Fd funktionärer<% break;
											}
											%>
										</th>
									</tr>
									<tr>
										<th colspan="<%=(isAuthorized("admin")?3:1)%>"></th>
										<% for(var sessionLoop=1; sessionLoop<=race.sessions; sessionLoop++) { %>
											<th>Pass <%=sessionLoop%></th>
										<% } %>
									</tr>
								</thead>
								<tbody>
									<%
									var volunteer_count = 0;
									var response_count = 0;
									var ok_counts = new Array(race.sessions);
									for(var sessionLoop=1; sessionLoop<=race.sessions; sessionLoop++) {
										ok_counts[sessionLoop-1] = 0;
									}

									users.MoveFirst();
									while(!users.EOF) {
										if (toString(users("roles")).indexOf(roles[i])>=0) {
											var has_responded = false;
											%>
											<tr>
												<% if(isAuthorized("admin")) { %>
													<td><input type="checkbox" name="recipient_<%=roles[i]%>" value="<%=users("id")%>"/></td>
												<% } %>
												<td>
													<a href="volunteerhome.asp?id=<%=users("id")%>"><%=users("name")%></a>
													<% if (toString(users("roles")).indexOf("praktik")>=0) { %>(praktik)<% } %>
												</td>
												<% if(isAuthorized("admin")) { %>
													<td>
														<% if (toString(users("phone"))!="") {%><br/>Tel: <%=users("phone")%><%}%>
														<% if (toString(users("mobile"))!="") {%><br/>Mobil: <%=users("mobile")%><%}%>
													</td>
												<% } %>
												<% for(var sessionLoop=1; sessionLoop<=race.sessions; sessionLoop++) {
													var check = Server.CreateObject("adodb.recordset");
													check.open("SELECT participates FROM volunteers WHERE event_id = "+p_race+" and session = "+sessionLoop+" and user_id = "+users("id"),connect,1,1);
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
																<input type="hidden" name="race" value="<%=p_race%>"/>
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
									if(p_race != "") {
									%>
									<tr>
										<td colspan="<%=(isAuthorized("admin")?2:1)%>"><b>Summering</b> <%=response_count%> av <%=volunteer_count%> har svarat</td>
										<% for(var sessionLoop=1; sessionLoop<=race.sessions; sessionLoop++) { %>
											<td><b><%=ok_counts[sessionLoop-1]%> funktionärer deltar</b></td>
										<% } %>
									</tr>
									<%
									}
									%>
								</tbody>
							</table>
							<br/><br/>
							<%
							}
							if(p_race != "" && isAuthorized("admin")) {
							%>
								<h3>Skicka mail</h3>
								<script language="javascript">
									var sessions = <%=race.sessions%>;
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
										check.open("SELECT participates FROM volunteers WHERE event_id = "+p_race+" and user_id = "+users("id"),connect,1,1);
										var participates = !check.EOF ? toBool(check("participates")) : null;
										check.close();
										%>
										{
											userid: <%=users("id")%>,
											email: "<%=users("email")%>",
											name: "<%=users("name")%>",
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
                                        if (sessions < 1) {
                                          alert("Inga pass hittades på tävlingen. Fixa i kalendern.");
                                          return;
                                        }
										var choice = $("input[name=to]:radio:checked").val();
										var mailcounter = 0;
										var appendLinks = $("#appendlinks:checked").val() != undefined;
										for(var i = 0; i < userArr.length; i++) {
											if(!$("input[value=" + userArr[i].userid + "]").is(":checked")) {
												continue;
											}
											if(
												(
													(choice == "all") ||
													(choice == "participates" && userArr[i].participates) ||
													(choice == "declined" && !userArr[i].participates) ||
													(choice == "unanswered" && !userArr[i].hasResponded)
												)
											)
											{
												mailcounter++;
												var mailbody = "(Det här mailet skickades till " + userArr[i].name + ")\n\n";
												mailbody += theForm.mailbody.value;
												if(appendLinks) {
													for(var sessionLoop=1; sessionLoop<=sessions; sessionLoop++) {
														mailbody += "\n\nJag kan ställa upp"+(sessions>1 ? (" på pass " + sessionLoop) : "")+": http://www.tss.nu/volunteers.asp?p=1&u="+userArr[i].userid+"&s="+sessionLoop+"&race=<%=p_race%>";
														mailbody += "\n\nJag kan EJ ställa upp "+(sessions>1 ? (" på pass " + sessionLoop) : "")+": http://www.tss.nu/volunteers.asp?p=0&u="+userArr[i].userid+"&s="+sessionLoop+"&race=<%=p_race%>";
														mailbody += "\n\n";
													}
												}
												//$("#sendstatus").append("Skickar till " + userArr[i].email + "...<br/>");

												$.post("/cms/sendemail.asp", {
														email: userArr[i].name + "<" + userArr[i].email + ">",
														subject: escape(theForm.subject.value),
														mailbody: escape(mailbody)
													},
													function(data){
														$("#sendstatus").append(data + "<br/>");
													}
												);

											}
										}
										alert(mailcounter + " mail lagda i kö. Se status uppe till höger.\n\nSTÄNG INTE FÖNSTRET!");
									}
								</script>
								<form action="cms/sendemail.asp" method="post">
									Skicka till:<br/>
									<input type="radio" name="to" value="all"/>Alla
									<input type="radio" name="to" value="participates"/>De som kommer
									<input type="radio" name="to" value="declined"/>De som INTE kommer
									<input type="radio" name="to" value="unanswered" checked="checked"/>De som ej svarat
									<br/>
									<input type="checkbox" id="appendlinks" checked="checked"/>Skicka med svarslänkar
									<br/>
									Ämne:<br/>
									<input name="subject" size="60" value="Funktionär <%=race.name%>, <%=race.date.getDate() + " " + getShortMonth(race.date.getMonth())%>"/>
									<br/>
									<textarea name="mailbody" rows="20" cols="80">
Hej
Det här är en påminnelse till dig som inte lämnat besked om att vara funktionär på <%=race.name%>, <%=race.date.getDate() + " " + getShortMonth(race.date.getMonth())%>.
Vänligen lämna besked snarast om du kan eller inte. Använd länkarna här nedan.

Mvh
Jonas Nilsson
Funktionärsansvarig TSS
									</textarea>
									<br/>
									<input type="button" name="reminder" value="Maila funktionärer" onclick="sendEmails(this.form)"/>
								</form>

								<%
								users.close();
							} %>

					</div>
				</div>
			</div>
			<div id="rightColumn">
			<!-- TODO
				<div class="box">
					<div class="header">.: Kommande t?vlingar :.</div>
					<div class="content">
					</div>
				</div>
			-->
				<span id="sendstatus" class="ok"></span><br/>
			</div>
			<div id="footer">&nbsp;</div>
		</div>
	</div>
	</body>
</html>
