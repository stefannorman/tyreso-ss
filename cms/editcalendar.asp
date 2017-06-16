
<%@ LANGUAGE = JScript %>
<!--#include file="check.inc" -->
<!--#include file="basicfuncs.asp" -->
<!--#include file="data/database.asp" -->   
<%
var aktion = toString(Request.QueryString("aktion"));
var id = toString(Request.QueryString("id"));

var groupArr = new Array("ES/E", "DM", "A", "B", "C", "D", "T", "TK", "SK", "SL");
 
var _name = "";
var _type = "info";
var _location = "";
var _description = "";
var _groups = "";
var _local = false;
var _startdate = getDateString(new Date());
var _stopdate = "";
var _registrationdate = "";
var _inbjudan = "";
var _grenfil = "";
var _startlista = "";
var _resultatlista = "";
var _resultatfil = "";
var _imagearchive = "";
var _sessions = 0;


if(aktion == "update" && id != "")
{
	var anEvent = Server.CreateObject("adodb.recordset");
	var sql = "SELECT * FROM calendar WHERE id = " + id;
	anEvent.open(sql,connect,1,1);
	if(!anEvent.EOF)
	{
		_name = anEvent("name").Value;
		_type = anEvent("type").Value;
		_location = anEvent("location").Value;
		_description = toString(anEvent("description").Value);
		_groups = toString(anEvent("groups").Value);
		_local = anEvent("local").Value;
		_startdate = anEvent("startdate").Value;
		_stopdate = anEvent("stopdate").Value;
		_registrationdate = anEvent("registrationdate").Value;
		_inbjudan = anEvent("inbjudan").Value;
		_grenfil = anEvent("grenfil").Value;
		_startlista = anEvent("startlista").Value;
		_resultatlista = anEvent("resultatlista").Value;
		_resultatfil = anEvent("resultatfil").Value;
		_imagearchive = toString(anEvent("imagearchive").Value);
		_sessions = anEvent("sessions").Value;
	}
	anEvent.close();
}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!--#include file="../includes/htmlhead.htm"-->
<title>Editering</title>

<link rel="stylesheet" type="text/css" media="all" href="jscalendar-1.0/skins/aqua/theme.css" title="Aqua" />

<!-- import the calendar script -->
<script type="text/javascript" src="jscalendar-1.0/calendar.js"></script>

<!-- import the language module -->
<script type="text/javascript" src="jscalendar-1.0/lang/calendar-en.js"></script>

<!-- the following script defines the Calendar.setup helper function, which makes
     adding a calendar a matter of 1 or 2 lines of code. -->
<script type="text/javascript" src="jscalendar-1.0/calendar-setup.js"></script>

<script type="text/javascript" src="/javascript/csshandling.js"></script>

<script language="javascript">
var uploadFileType = ""

function displayUploadForm(fileType)
{
	uploadFileType = fileType;
	document.getElementById("uploadIframe").src='uploadform.asp?Type='+fileType;
	document.getElementById("uploadDiv").style.display = "block";
}

function setFileUrl(fileUrl)
{
	document.getElementById(uploadFileType).value = fileUrl;
	document.getElementById("sp_"+uploadFileType).innerHTML = fileUrl;
	document.getElementById("link_"+uploadFileType).style.display = "none";
	document.getElementById("delete_"+uploadFileType).style.display = "block";
}

function deleteFile(field)
{
	document.getElementById(field).value = "";
	document.getElementById("sp_"+field).innerHTML = "";
	document.getElementById("link_"+field).style.display = "block";
	document.getElementById("delete_"+field).style.display = "none";
}

function OnUploadCompleted( errorNumber, fileUrl, fileName, customMsg )
{
	switch ( errorNumber )
	{
		case 0 :	// No errors
			setFileUrl(fileUrl);
			alert( 'Filen har laddats upp' ) ;
			break ;
		case 1 :	// Custom error
			alert( customMsg ) ;
			break ;
		case 10 :	// Custom warning
			setFileUrl(fileUrl);
			alert( customMsg ) ;
			break ;
		case 201 :
			setFileUrl(fileUrl);
			alert( 'Det fanns redan en fil med det namnet. Den uppladdade filen döptes om till "' + fileName + '"' ) ;
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
	document.getElementById("uploadDiv").style.display = "none";
	return;
}



function displayFields() {
	var allFields = document.getElementsByTagName("INPUT");
	var checkedType = "";
	for(var i = 0; i <= allFields.length; i++) {
		if(allFields[i].type == "radio" && allFields[i].name == "type") {
			if(allFields[i].checked) {
				checkedType = allFields[i].value;
				break;
			}
		}
	}
	document.getElementById("local").style.display = (checkedType == "race") ? "block" : "none";
	document.getElementById("sessions").style.display = (checkedType == "race") ? "block" : "none";
	document.getElementById("registrationdate").style.display = "block";
	document.getElementById("racefiles").style.display = (checkedType == "race") ? "block" : "none";
}
</script>
</head>
<body onload="showBanner();displayFields();">
	<div id="wrapper">
		<div id="header">
			<!--#include file="../includes/header.htm"-->
		</div>
		<div id="main">
			<div id="menuColumn">
				<!--#include file="../includes/menu.asp"-->
			</div>
			<div id="contentColumn">
				<div class="box">
					<div class="header">.: Editera kalendariehändelse:.</div>
					<div class="content">
						<form action="savecalendar.asp" method="post">
							<b>Vilken sorts händelse</b><br>
							<input type="radio" name="type" value="info"<%=(_type == "info" ? "checked=\"checked\"" : "")%> onclick="displayFields()">Information
							<input type="radio" name="type" value="race"<%=(_type == "race" ? "checked=\"checked\"" : "")%> onclick="displayFields()">Tävling
							<input type="radio" name="type" value="camp"<%=(_type == "camp" ? "checked=\"checked\"" : "")%> onclick="displayFields()">Läger
							<br><br>
							<b>Titel</b> (T ex namn på tävling)<br>
							<input type="text" name="name" size="60" maxlength="255" value="<%=_name.replace(/\"/g, "&quot;")%>"><br>
							<br>
							<b>Plats</b><br>
							<input type="text" name="location" size="60" maxlength="255" value="<%=_location.replace(/\"/g, "&quot;")%>"><br>
							<br>
							<b>Grupper</b> (vilka gruppsidor ska händelsen visas på)<br>
							<%
							for (var i = 0; i < groupArr.length; i++) {
								var checked = _groups.indexOf(groupArr[i]) > -1;
								if(groupArr[i] == "T") {
									var cleanFromTK = _groups.replace("TK", "");
									checked = cleanFromTK.indexOf("T") > -1
								}
							%>
								<%=groupArr[i]%><input type="checkbox" name="groups" value="<%=groupArr[i]%>" <%=checked ? "CHECKED" : ""%>>&nbsp;&nbsp;
							<% } %>
							<br>
							<br>
							<b>Kommentar</b><br>
							<input type="text" name="description" size="60" maxlength="255" value="<%=_description.replace(/\"/g, "&quot;")%>"><br>
							<br>
							<b>Katalognamn i bildarkivet</b> (bilderna till bildarkiv laddas inte upp här)<br>
							<input type="text" name="imagearchive" size="50" maxlength="50" value="<%=_imagearchive.replace(/\"/g, "&quot;")%>"><br>
							<br>
							<b>Startdatum</b><br>
							<input type="text" name="startdate" id="f_startdate" size="10" maxlength="10" value="<%=_startdate%>">
							<button type="reset" id="f_trigger_a">...</button><br>
							<script type="text/javascript">
								Calendar.setup({
									inputField     :    "f_startdate",      // id of the input field
									ifFormat       :    "%Y-%m-%d",       // format of the input field
									showsTime      :    false,            // will NOT display a time selector
									button         :    "f_trigger_a",   // trigger for the calendar (button ID)
									singleClick    :    true,           // single-click mode
									step           :    1                // show all years in drop-down boxes (instead of every other year as default)
								});
							</script>
							<br>
							<b>Slutdatum</b><br>
							<input type="text" name="stopdate" id="f_stopdate" size="10" maxlength="10" value="<%=_stopdate%>">
							<button type="reset" id="f_trigger_b">...</button><br>
							<script type="text/javascript">
								Calendar.setup({
									inputField     :    "f_stopdate",      // id of the input field
									ifFormat       :    "%Y-%m-%d",       // format of the input field
									showsTime      :    false,            // will NOT display a time selector
									button         :    "f_trigger_b",   // trigger for the calendar (button ID)
									singleClick    :    true,           // single-click mode
									step           :    1                // show all years in drop-down boxes (instead of every other year as default)
								});
							</script>
							<br>
							<b>Inbjudan</b><br>
							<span id="sp_inbjudan"><%=_inbjudan%></span>
							<a id="link_inbjudan" style="display:<%=toString(_inbjudan)==""?"block":"none"%>"
								href="javascript:displayUploadForm('inbjudan')">Ladda upp inbjudan</a>
							<a id="delete_inbjudan" style="display:<%=toString(_inbjudan)==""?"none":"block"%>"
								href="javascript:deleteFile('inbjudan')"><img src="/cms/icons/delete.png" hspace="0" border="0" title="Radera">Radera</a>
							<input type="hidden" name="inbjudan" id="inbjudan" value="<%=_inbjudan%>">
							<br>
							<div id="local">
								<b>Hemmatävling?</b> (TSS arrangerar)<br>
								<input type="checkbox" value="true" name="local" <%=_local ? "CHECKED" : ""%>><br>
								<br>
							</div>
							<div id="sessions">
								<b>Funktionärer krävs</b> (ange antal pass)<br>
								<select name="sessions">
									<% for (var i=0; i<=4; i++) { %>
										<option<% if (i==_sessions) {%> selected="selected"<%}%> value="<%=i%>"><%=(i==0) ? "inga funktionärer krävs" : i + " pass"%></option>
									<% } %>
								</select>
								<br/><br/>
							</div>
							<div id="registrationdate">
								<b>Sista anmälningsdatum</b> (om ifyllt öppnar anmälan)<br>
								<input type="text" name="registrationdate" id="f_registrationdate" size="10" maxlength="10" value="<%=_registrationdate%>">
								<button type="reset" id="f_trigger_c">...</button><br>
								<script type="text/javascript">
									Calendar.setup({
										inputField     :    "f_registrationdate",      // id of the input field
										ifFormat       :    "%Y-%m-%d",       // format of the input field
										showsTime      :    false,            // will NOT display a time selector
										button         :    "f_trigger_c",   // trigger for the calendar (button ID)
										singleClick    :    true,           // single-click mode
										step           :    1                // show all years in drop-down boxes (instead of every other year as default)
									});
								</script>
								<br>
							</div>
							<div id="racefiles">
								<b>Grenfil</b> (aktiverar anmälningsfunktion)<br>
								<span id="sp_grenfil"><%=_grenfil%></span>
								<a id="link_grenfil" style="display:<%=toString(_grenfil)==""?"block":"none"%>"
									href="javascript:displayUploadForm('grenfil')">Ladda upp grenfil</a>
								<a id="delete_grenfil" style="display:<%=toString(_grenfil)==""?"none":"block"%>"
									href="javascript:deleteFile('grenfil')"><img src="/cms/icons/delete.png" hspace="0" border="0" title="Radera">Radera</a>
								<input type="hidden" name="grenfil" id="grenfil" value="<%=_grenfil%>">
								<br>
								<b>Startlista</b><br>
								<span id="sp_startlista"><%=_startlista%></span>
								<a id="link_startlista" style="display:<%=toString(_startlista)==""?"block":"none"%>"
									href="javascript:displayUploadForm('startlista')">Ladda upp startlista</a>
								<a id="delete_startlista" style="display:<%=toString(_startlista)==""?"none":"block"%>"
									href="javascript:deleteFile('startlista')"><img src="/cms/icons/delete.png" hspace="0" border="0" title="Radera">Radera</a>
								<input type="hidden" name="startlista" id="startlista" value="<%=_startlista%>">
								<br>
								<b>Resultatlista</b><br>
								<span id="sp_resultatlista"><%=_resultatlista%></span>
								<a id="link_resultatlista" style="display:<%=toString(_resultatlista)==""?"block":"none"%>"
									href="javascript:displayUploadForm('resultatlista')">Ladda upp resultatlista</a>
								<a id="delete_resultatlista" style="display:<%=toString(_resultatlista)==""?"none":"block"%>"
									href="javascript:deleteFile('resultatlista')"><img src="/cms/icons/delete.png" hspace="0" border="0" title="Radera">Radera</a>
								<input type="hidden" name="resultatlista" id="resultatlista" value="<%=_resultatlista%>">
								<br>
								<b>Resultatfil</b><br>
								<span id="sp_resultatfil"><%=_resultatfil%></span>
								<a id="link_resultatfil" style="display:<%=toString(_resultatfil)==""?"block":"none"%>"
									href="javascript:displayUploadForm('resultatfil')">Ladda upp resultatfil</a>
								<a id="delete_resultatfil" style="display:<%=toString(_resultatfil)==""?"none":"block"%>"
									href="javascript:deleteFile('resultatfil')"><img src="/cms/icons/delete.png" hspace="0" border="0" title="Radera">Radera</a>
								<input type="hidden" name="resultatfil" id="resultatfil" value="<%=_resultatfil%>">
							</div>

							<br><br>
							<input type="submit" value="Spara">
							<input type="button" value="Avbryt" onclick="location='<%=Request.ServerVariables("HTTP_REFERER")%>'">
							<input type="hidden" name="id" value="<%=id%>">
							<input type="hidden" name="referer" value="<%=Request.ServerVariables("HTTP_REFERER")%>">
						</form>					</div>				</div>			</div>
			<div id="rightColumn"></div>
			<div id="footer">&nbsp;</div>
		</div>
	</div>	<div id="uploadDiv">	<iframe id="uploadIframe" src="uploadform.asp" scrolling="no"></iframe>	</div></body></html>