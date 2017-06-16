<%@ LANGUAGE = JScript %>
<!--#include file="cms/basicfuncs.asp" -->   
<!--#include file="cms/data/database.asp" -->
<!--#include file="cms/objects/Race.asp" -->
<!--#include file="cms/objects/SwimmerGroups.asp" -->
<!--#include file="cms/objects/ParentsManager.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
// handle request parameters
var p_race = toString(Request.QueryString("race"));
var p_action = toString(Request.QueryString("action"));
var p_swimmer = toString(Request.QueryString("swimmer"));
var p_role = toString(Request.QueryString("role"));
var p_participates = toString(Request.QueryString("participates"));
var swimmerFromMailResponse = toString(Request.QueryString("s"));
// handle response from email
if(swimmerFromMailResponse != "") {
	p_action = "update";
	p_swimmer = swimmerFromMailResponse; 
	p_participates = "1";
}

// initialize objects used in the page
var race = new Race(p_race);
var swimmerGroups = new SwimmerGroups();
var parentsManager = new ParentsManager(p_race);

// update database 
if (p_action != "") {
	parentsManager.updateDB(p_action, p_swimmer, p_role, p_participates)
}
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

				<h1>F�r�ldrahj�lp p� <%=race.name%>, <%=race.date.getDate() + " " + getShortMonth(race.date.getMonth())%></h1>
				<p>
					Till de t�vlingar Tyres� SS arrangerar s� beh�ver vi hj�lp fr�n alla f�r�ldrar. Hj�lpen �r f�rdelad p� ett antal roller:
					<ul>
						<li>
							<strong>Riggning</strong> - Man hj�lper till att plocka fram t�vlingsutrustning, linor, mm. Tids�tg�ng ca 30 min. Samling 45 min innan insim.
						</li>
						<li>
							<strong>Bakning</strong> - Man bakar till kafeterian. Tids�tg�ng ca 45 min, p� 200&deg; :-). Inl�mning i kafeterian innan insim.
						</li>
						<li>
							<strong>Avriggning</strong> - Man hj�lper till att plocka undan t�vlingsutrustning, linor, mm. Tids�tg�ng ca 30 min. Samling direkt efter avslutad t�vling.
						</li>
						<li>
							<strong>St�dning</strong> - Man hj�lper till att plocka undan skr�p samt spolar av golvet. Tids�tg�ng ca 30 min. Samling direkt efter avslutad t�vling.
						</li>
						<li>
							<strong>Funktion�r</strong> - Man hj�lper till som funktion�r. Detta kr�ver utbildning. Om du �r intresserad att vara funktion�r maila <a href="mailto:stefan.norman@home.se">funktion�rsansvarig</a>. Tids�tg�ng beror p� t�vling. Ca 2-4 timmar. Samling 45 min innan t�vlingsstart. <a href="volunteers.asp?race=<%=p_race%>">Aktuellt funktion�rsl�ge f�r <%=race.name%></a> 
						</li>
					</ul>
				</p>
				<p>
					F�r�ldrar till f�ljande simmare �r kallade att hj�lpa till p� t�vlingen.
				</p>
				<div class="box">
					<div class="content">
							<%
							for(var i = 0; i < parentsManager.roles.length; i++) {
							%>
							<table border="1" width="100%">
								<thead>
									<tr>
										<th colspan="2"><%=parentsManager.roles[i].label%></th>
									</tr>
									<tr>
										<th colspan="2">
											<% if(isAuthorized("admin")) { %>
												<form action="">
													<select name="swimmer" onchange="this.form.submit()">
														<option value="0">L�gg till simmare...</option>
														<%
														for(var j = 0; j < swimmerGroups.groups.length; j++) {
															%><option value="0" style="font-weight:bold;"> - - - <%=swimmerGroups.groups[j].name%> - - - </option><%
															for(var k = 0; k < swimmerGroups.groups[j].swimmers.length; k++) {
																var swimmer = swimmerGroups.groups[j].swimmers[k];
																%>
																<option	value="<%=swimmer.servetteID%>">
																	<%=swimmer.name%>
																</option>
																<%
															}
														}
														%>
													</select>
													<input type="hidden" name="action" value="add"/>
													<input type="hidden" name="race" value="<%=p_race%>"/>
													<input type="hidden" name="role" value="<%=parentsManager.roles[i].name%>"/>
												</form>
											<% } %>
										</th>
									</tr>
								</thead>
								<tbody>
									<%
									var parentsList = parentsManager.getParentsOfRole(parentsManager.roles[i].name);
									for(var j = 0; j < parentsList.length; j++) {
											var swimmer = swimmerGroups.findSwimmerByID(parentsList[j].swimmer);
											%>
											<tr>
												<td><%=swimmer.name%>, <%=swimmer.group%></td>
												<td style="background:<%=parentsList[j].participates ? "green" : "white"%>">
													<% if(isAuthorized("admin")) { %>
														<form action="">
															<select name="participates" onchange="if(this.selectedIndex == 2) { if(confirm('�r du s�ker p� att du vill radera?')) { location = 'parents.asp?action=delete&race=<%=p_race%>&swimmer=<%=swimmer.servetteID%>&role=<%=parentsManager.roles[i].name%>'}; return false; } this.form.submit()">
																<option value="1"<%=parentsList[j].participates ? " selected=\"selected\"" : ""%>>Deltar</option>
																<option value="0"<%=!parentsList[j].participates ? " selected=\"selected\"" : ""%>>Ej besked</option>
																<option value="delete">Radera</option>
															</select>
															<input type="hidden" name="action" value="update"/>
															<input type="hidden" name="swimmer" value="<%=swimmer.servetteID%>"/>
															<input type="hidden" name="race" value="<%=p_race%>"/>
														</form>
													<% } else {%>
														<%=parentsList[j].participates ? "Deltar" : "Ej svarat"%>
													<% } %>
												</td>
											</tr>
											<%
									}
									%>
								</tbody>
							</table>
							<br/><br/>
							<%
							}
							if(isAuthorized("admin")) {
								var parentsList = parentsManager.allParents;
								%>
								<h3>Skicka mail</h3>
								<script language="javascript">
									// array holding all users
									var mailList = new Array();
									<%
									for(var i = 0; i < parentsList.length; i++) {
										var parent = parentsList[i];
										var swimmer = swimmerGroups.findSwimmerByID(parent.swimmer);
										if(swimmer.email=="") {
											continue;
										}
										%>
										mailList[mailList.length] = {
											swimmerid: <%=parent.swimmer%>,
											email: "<%=swimmer.email%>",
											participates: <%=parent.participates ? "true" : "false"%>
										};
										<%
									}
									%>
									
									function sendEmails(theForm) {
										var choice = $("input[name=to]:radio:checked").val();
										var appendLinks = $("#appendlinks:checked").val() != undefined;
										var mailcounter = 0;
										for(var i = 0; i < mailList.length; i++) {
											if(
												(
													(choice == "all") ||
													(choice == "participates" && mailList[i].participates)
												)
											)
											{
												mailcounter++;
												var mailbody = theForm.mailbody.value;
												if(appendLinks) {
													mailbody += "\n\nJag kommer"+": http://www.tss.nu/parents.asp?s="+mailList[i].swimmerid+"&race=<%=p_race%>";
													mailbody += "\n\n";
												}
												//$("#sendstatus").append("Skickar till " + mailList[i].email + "...<br/>");

												$.post("/cms/sendemail.asp", {email: mailList[i].email, subject: escape(theForm.subject.value), mailbody: escape(mailbody)},
													function(data){
														$("#sendstatus").append(data + "<br/>");
													}
												);

											}
										}
										alert(mailcounter + " mail lagda i k�. Se status uppe till h�ger.\n\nST�NG INTE F�NSTRET!");
									}
								</script>
								<form action="cms/sendemail.asp" method="post">
									Skicka till:<br/>
									<input type="radio" name="to" value="all"/>Alla
									<input type="radio" name="to" value="participates"/>De som kommer
									<br/>
									<input type="checkbox" id="appendlinks" checked="checked"/>Skicka med svarsl�nk
									<br/>
									�mne:<br/>
									<input name="subject" size="60" value="F�r�ldrahj�lp <%=race.name%>, <%=race.date.getDate() + " " + getShortMonth(race.date.getMonth())%>"/>
									<br/>
									<textarea name="mailbody" rows="5" cols="60">
Hej simf�r�lder

Den <%=race.date.getDate() + " " + getShortMonth(race.date.getMonth())%> �r det dags f�r <%=race.name%>.
D�r vill vi ha din hj�lp. F�r att se din arbetsuppgift, g� hit: http://www.tss.nu/parents.asp?race=<%=p_race%>
  
V�nligen l�mna besked snarast att du n�rvarar. Anv�nd l�nken l�ngre ner.

Om du inte kan den h�r dagen s� byt med n�gon annan f�r�lder. Anm�l bytet till min mailadress: stefan.norman@home.se
Detta mail har skickats ut enligt f�r�ldralistan: http://www.tss.nu/F%C3%B6r%C3%A4ldrahj%C3%A4lp.html

Mvh
Stefan Norman
Funktion�rsansvarig TSS
									</textarea>
									<br/>
									<input type="button" name="reminder" value="Maila f�r�ldrar" onclick="sendEmails(this.form)"/>
								</form>
								
								<%
							} %>

					</div>
				</div>
			</div>
			<div id="rightColumn">
			<!-- TODO
				<div class="box">
					<div class="header">.: Kommande t�vlingar :.</div>
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
