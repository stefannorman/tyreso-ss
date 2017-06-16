<%@ LANGUAGE = JScript %>
<!--#include file="cms/basicfuncs.asp" -->
<!--#include file="cms/data/database.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<!--#include file="includes/htmlhead.htm"-->
		<script language="javascript" src="/javascript/jquery-1.4.2.min.js"></script>
	</head>
	<body onload="showBanner()">
	<%
	var p_user = toString(Request.Form("username")).replace(/\'/g, "");
	var p_pwd = toString(Request.Form("pwd")).replace(/\'/g, "");
	var p_newpwd = trim(toString(Request.Form("newpwd")).replace(/\'/g, ""));
	var error = "";

	if(toString(Request.Form("login")) != "" && p_user != "" && p_pwd != "") {
		var auth = Server.CreateObject("adodb.recordset");
		var sql = "SELECT Id, Name, Roles FROM user WHERE username = '" + p_user + "' AND password = '" + p_pwd + "'";
		auth.open(sql,connect,1,1);
		if(!auth.EOF)
		{
			Session("AuthUser") = new User(toInt(auth("Id")), toString(auth("Name")), toString(auth("Roles")));
		}
		else
		{
			error = "Felaktig inloggning";
		}
		auth.close();
	}
	else if(Session("AuthUser") != null && toString(Request.Form("changepwd")) != "" && p_pwd != "" && p_newpwd != "") {

		var auth = Server.CreateObject("adodb.recordset");
		var sql = "SELECT Id FROM user WHERE id = " + Session("AuthUser").id + " AND password = '" + p_pwd + "'";
		auth.open(sql,connect,1,1);
		var correctPwd = !auth.EOF;
		auth.close();
		if(!correctPwd) {
			error = "Det gamla l&ouml;senordet var felaktigt"
		} else {
			error = "L&ouml;senordet har &auml;ndrats"
			sql = "UPDATE user SET password = '" + p_newpwd + "' WHERE id = " + Session("AuthUser").id + " AND password = '" + p_pwd + "'";
		}
		connect.Execute(sql);
	}
	else if(toString(Request.QueryString("logout")) != "")
	{
		Session("AuthUser") = null;
	}
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
				<% if(Session("AuthUser") == null) { %>
					<div class="box loginBox">
						<div class="header">.: Inloggning kr&auml;vs :.</div>
						<div class="content">

							<form action="admin.asp" method="post">

								<% if(error != "") { %>
									<span class="error"><%=error%></span><br/>
								<% } %>
								Anv&auml;ndarnamn<br/>

								<INPUT type="text" size="15" name="username"/><br/>
								L&ouml;senord<br/>

								<INPUT type="password" size="15" name="pwd"/><br/>

								<br/>
								<INPUT type="submit" name="login" value="Logga in"/>

								<br/>
								<a href="" onclick="var em = '<%=obfuscateEmail("webmaster@tss.nu")%>';this.href='mail'+'to'+':'+em.replace('_KEFF_', '@').replace('_KOFF_', '.')+'?subject=TSS forgot password';">Nytt konto/Gl&ouml;mt l&ouml;senord?</a><br>
							</form>
						</div>

					</div>

				<% } else { %>
					<div class="box">
						<div class="header">.: Adminstration f&ouml;r TSS hemsida :.</div>
						<div class="content">
							V&auml;lkommen!
							N&auml;r man &auml;r inloggad kan man skriva nyheter f&ouml;r sin grupp eller l&auml;gga in h&auml;ndelser i kalendariet.
							<br/>
							<a href="/cms/ManualTSSHemsida.doc">Manual f&ouml;r inskrivning av nyheter</a>
							<br/><br/>
						</div>
					</div>
					<span class="divider">&nbsp;</span>
					<%
					var query = Server.CreateObject("adodb.recordset");
					var sql = "SELECT id, name, startdate, registrationdate, groups FROM calendar WHERE len(grenfil) > 0 AND startdate >= Date() ORDER BY startdate";
					query.open(sql,connect,1,1);
					if(!query.EOF) {
					%>
						<div class="box">
							<div class="header">.: T&auml;vlingsanm&auml;lningar :.</div>
							<div class="content">
								<table width="100%">
								<%
								while(!query.EOF) {
									%>
									<tr>
										<td><b><%=query("name")%></b></td>
										<td><%=query("startdate")%></td>
										<td><%=query("groups")%></td>
										<td>
											<% if(query("registrationdate") < (new Date()).setHours(0,0,0,0)) { %>
												<span class="error">Anm&auml;lan st&auml;ngd</span>
											<% } else if (isAuthorized("racereg")) { %>
												<a href="racereg.asp?event=<%=query("id")%>">Anm&auml;l simmare</a>
											<% }%>
										</td>
										<td><a href="racefile.asp?event=<%=query("id")%>">Ladda ner anm.fil</a></td>
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
					<div class="box">
						<div class="header">.: Tr&auml;nardokument :.</div>
						<div class="content">
							<ul>
								<li><a href="/uploaded/File/inlarningsstege.pdf">Inl&auml;rningsstege</a></li>
								<li><a href="https://drive.google.com/file/d/0B967EhtWbu4TWG1xQWdZVFFzT2dPU1M5NXVDOXhhN2hNdmt3/view">Alla simskoleplaneringar</a></li>
								<li><a href="https://docs.google.com/document/d/1XTdKYtMsM400_3rrZtXG8Gri2NDnS4AuVgQqACyT5wQ/export?format=pdf">&Ouml;vningsbank simskola</a></li>
							</ul>
						</div>
					</div>
					<span class="divider">&nbsp;</span>
					<div class="box">
						<div class="header">.: Klubbdokument :.</div>
						<div class="content">
							<ul>
								<!--
								<li><a href="/uploaded/File/Narvarokort_2012.xls">N&auml;rvarokort 2012</a></li>
								<li><a href="/uploaded/File/N?RVAROKORT%202011%20-%20Tyres?%20kommun.xls">N&auml;rvarokort 2011</a></li>
								<li><a href="/uploaded/File/N?RVAROKORT2010-Tyres?kommun.xls">N?rvarokort 2010</a></li>
								<li><a href="/uploaded/File/N?RVAROKORT%202009%20-%20Tyres?%20kommun.xls">N?rvarokort 2009</a></li>
								-->
								<li><a href="/cms/ManualTSSHemsida.doc">Manual hemsida</a></li>

								<li><a href="/uploaded/File/tavling_strykningsblankett.html">Strykningslista</a></li>
								<li><a href="/uploaded/File/Strykning.doc">Enskild strykning</a></li>

								<li><a href="/uploaded/File/Efteranmalan.doc">Efteranm&auml;lan</a></li>

								<li><a href="/uploaded/File/Funktionarer_sokes.doc">Funktion&auml;rer s&ouml;kes</a></li>
							</ul>
						</div>

					</div>
				<% } %>
			</div>
			<div id="rightColumn">
				<% if(Session("AuthUser") != null) { %>
					<div class="box">
						<div class="header">.: V&auml;lkommen <%=Session("AuthUser").name%> :.</div>
						<div class="content">

							<ul>

								<li><a href="admin.asp?logout=true">Logga ut</a></li>

								<% if(isAuthorized("admin")) { %>
									<li><a href="cms/useradmin.asp?">Administrera anv&auml;ndare</a></li>

								<% } %>

							</ul>
						</div>

					</div>

					<span class="divider">&nbsp;</span>
					<div class="box">
						<div class="header">.: Byt l&ouml;senord :.</div>
						<div class="content">
							<% if(error != "") { %>

								<span class="error"><%=error%></span>
							<% } %>
							<form action="admin.asp" method="post">

								Gammalt l&ouml;senord<br/>

								<INPUT type="password" size="15" name="pwd"/><br/>

								Nytt l&ouml;senord<br/>
								<INPUT type="password" size="15" name="newpwd"/><br/>

								<br>

								<INPUT type="submit" name="changepwd" value="Byt"/>
							</form>

						</div>
					</div>

					<span class="divider">&nbsp;</span>

					<% if(isAuthorized("admin")) { %>
						<script language="javascript">

						function OnUploadCompleted( errorNumber, fileUrl, fileName, customMsg )
						{
							switch ( errorNumber )
							{
								case 0 :	// No errors
									switchServetteDB(fileUrl);
									//alert( 'Filen har laddats upp' ) ;
									break ;
								case 1 :	// Custom error
									alert( customMsg ) ;
									break ;
								case 10 :	// Custom warning
									setFileUrl(fileUrl);
									alert( customMsg ) ;
									break ;
								case 201 :
									switchServetteDB(fileUrl);
									//alert( 'Det fanns redan en fil med det namnet. Den uppladdade filen d?ptes om till "' + fileName + '"' ) ;
									break ;
								case 202 :
									alert( 'Invalid file' ) ;
									break ;
								case 203 :
									alert( "Security error. You probably don't have enough permissions to upload. Please check your server." ) ;
									break ;
								default :
									alert( 'Error on file upload. Error number: ' + errorNumber ) ;
									break ;
							}
							return;
						}
						function switchServetteDB( fileUrl ) {
							alert( 'Byter databasfil till den uppladdade: ' + fileUrl ) ;
							$.get("/cms/switchservette.asp?fileUrl="+fileUrl,
								function(data){
									alert(data);
								}
							);
						}

						</script>
						<div class="box">
							<div class="header">.: Ladda upp Grodan DB :.</div>
							<div class="content">
								<iframe id="uploadIframe" src="cms/uploadform.asp?type=File&UploadPath=/cms/data/"></iframe>
							</div>

						</div>

						<span class="divider">&nbsp;</span>
					<% } %>


				<% } %>

			</div>
			<div id="footer">&nbsp;</div>
		</div>
	</div>
	</body>
</html>
