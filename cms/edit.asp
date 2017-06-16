<%@ LANGUAGE = JScript %>
<!--#include file="check.inc" -->
<!--#include file="basicfuncs.asp" -->   
<!--#include file="data/database.asp" -->
<%
var id = toString(Request.QueryString("id"));
 
var _title = "";
var _text = "";
var _created = getDateString(new Date());
var _category = toString(Request.QueryString("category"));


if(id != "")
{
	var news = Server.CreateObject("adodb.recordset");
	var sql = "SELECT * FROM news WHERE id = " + id;
	news.open(sql,connect,1,1);
	if(!news.EOF)
	{
		_title = news("title").Value;
		_text = news("text").Value;
		_created = news("created").Value;
		_category = toString(news("category"));
	}
	news.close();
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<!--#include file="../includes/htmlhead.htm"-->
		<title>Editering</title>
		<link rel="stylesheet" type="text/css" media="all" href="jscalendar-1.0/skins/aqua/theme.css" title="Aqua" />
		<!-- import the editor script -->
		<script type="text/javascript" src="ckeditor/ckeditor.js"></script>
		<!--
		<script type="text/javascript" src="FCKeditor/fckeditor.js"></script>
		-->
		<script type="text/javascript" src="ckfinder/ckfinder.js"></script>
		<script type="text/javascript">
			function setupCKFinder() {
				CKFinder.setupCKEditor( null, '/cms/ckfinder/' );
				var editor = CKEDITOR.replace( 'ckeditor' );
			}
		</script>
		<!-- import the calendar script -->
		<script type="text/javascript" src="jscalendar-1.0/calendar.js"></script>

		<!-- import the language module -->
		<script type="text/javascript" src="jscalendar-1.0/lang/calendar-en.js"></script>

		<!-- the following script defines the Calendar.setup helper function, which makes
			adding a calendar a matter of 1 or 2 lines of code. -->
		<script type="text/javascript" src="/cms/jscalendar-1.0/calendar-setup.js"></script>
	</head>
	<body onload="showBanner();setupCKFinder();">
		<div id="wrapper">
			<div id="header">
				<!--#include file="../includes/header.htm"-->
			</div>
			<div id="main">
				<div id="menuColumn">
					<!--#include file="../includes/menu.asp"-->
				</div>
				<div id="contentColumn" class="ckeditorColumn">
					<div class="box">
						<div class="header">.: Editera :.</div>
						<div class="content">
							<form action="save.asp" method="post">
								Rubrik<br>
								<input type="text" name="title" size="60" maxlength="255" value="<%=_title.replace(/\"/g, "&quot;")%>"><br>
								Text<br>
								<textarea class="ckeditor" id="ckeditor" name="text"><%=_text%></textarea>
								<!--
								<script type="text/javascript">
								var oFCKeditor = new FCKeditor( 'text' ) ;
								oFCKeditor.BasePath	= '/cms/FCKeditor/' ;
								oFCKeditor.Config["DefaultLanguage"]    = "sv" ;
								oFCKeditor.Value	= '<%=_text.replace(/\r\n/g, "\\n").replace(/\'/g, "\\'")%>' ;
								oFCKeditor.Create() ;
								</script>
								//-->
								Datum<br>
								<input type="text" name="created" id="f_created" size="10" maxlength="10" value="<%=_created%>">
								<button type="reset" id="f_trigger_a">...</button><br>
								<script type="text/javascript">
									Calendar.setup({
										inputField     :    "f_created",      // id of the input field
										ifFormat       :    "%Y-%m-%d",       // format of the input field
										showsTime      :    false,            // will NOT display a time selector
										button         :    "f_trigger_a",   // trigger for the calendar (button ID)
										singleClick    :    true,           // single-click mode
										step           :    1                // show all years in drop-down boxes (instead of every other year as default)
									});
								</script>
								<br>
								<input type="submit" value="Spara">
								<input type="button" value="Avbryt" onclick="location='<%=Request.ServerVariables("HTTP_REFERER")%>'">
								
								<input type="hidden" name="category" value="<%=_category%>">
								<input type="hidden" name="id" value="<%=id%>">
								<input type="hidden" name="referer" value="<%=Request.ServerVariables("HTTP_REFERER")%>">
							</form>
						</div>
					</div>
				</div>
				<div id="rightColumn">
				</div>
				<div id="footer">&nbsp;</div>
			</div>
		</div>
	</body>
</html>