<script language="VBscript" runat="server">
	function toString(contents)
		toString = CStr(""&contents)
	end function

	function toInt(contents)
		If toString(contents) = "" Then
			toInt = 0
		Else
			toInt = CInt(contents)
		End If
	end function

	function toBool(contents)
		toBool = CBool(""&contents)
	end function

</script>
<%
//var termin = "1"; // v�r
var termin = "2"; // h�st
//var termin = "3"; // v�r 2011
//var termin = "4"; // h�st 2011
//var termin = "5"; // v�r 2012

function getDateString(aDate){
   var dateStr;
   dateStr = "" + aDate.getFullYear() + "-";
   if (aDate.getMonth() < 9)
       dateStr += "0";
   dateStr +=  (aDate.getMonth() + 1);
   dateStr += "-";
   if (aDate.getDate() < 10)
       dateStr += "0";
   dateStr += aDate.getDate();
   return dateStr;
}
function getDateString2(aDate){
   var dateStr;
   dateStr = "" + aDate.getFullYear();
   if (aDate.getMonth() < 9)
       dateStr += "0";
   dateStr +=  (aDate.getMonth() + 1);
   if (aDate.getDate() < 10)
       dateStr += "0";
   dateStr += aDate.getDate();
   return dateStr;
}
function getRFC822DateString(aDate){
	var dateStr = "";
	var s = "" + aDate;
	var weekday = s.substring(0, s.indexOf(" "));
	s = s.substring(s.indexOf(" ")+1);
	var month = s.substring(0, s.indexOf(" "));
	s = s.substring(s.indexOf(" ")+1);
	s = s.substring(s.indexOf(" ")+1);
	var time = s.substring(0, s.indexOf(" "));
	dateStr = weekday + ", " + aDate.getDate() + " " + month + " " + aDate.getFullYear() + " " + time + " GMT";
	return dateStr;
}
function getShortMonth(monthInt) {
	var month = "";
	switch (monthInt) {
		case 0 : month = "jan"; break;
		case 1 : month = "feb"; break;
		case 2 : month = "mar"; break;
		case 3 : month = "apr"; break;
		case 4 : month = "maj"; break;
		case 5 : month = "jun"; break;
		case 6 : month = "jul"; break;
		case 7 : month = "aug"; break;
		case 8 : month = "sep"; break;
		case 9 : month = "okt"; break;
		case 10 : month = "nov"; break;
		case 11 : month = "dec"; break;
	}
	return month;
}

function formatTime(x){
	if(x<1000) return "";
	var s = "" + x;
	var sec = s.substring(s.length-2);
	var min = s.substring(s.length-4, s.length-2);
	var tim = s.length<5 ? "" : s.substring(0, s.length-4);

	return tim + (tim.length>0 ? "." : "") + min + ":" + sec;

}

function formatPBTime(str) {
	if(str=="")
		return "00:00.00";

	// remove fraction
	str = str.substring(0, str.length-1);

	var secInt = toInt(str.substring(0, str.length-2));
	var minutes = toString(Math.floor(secInt/60));
	var seconds = toString(secInt%60);
	var hundreds = str.substring(str.length-2);
	if(minutes.length == 0)
		minutes = "00";
	else if (minutes.length == 1)
		minutes = "0" + minutes;
	if(seconds.length == 0)
		seconds = "00";
	else if (seconds.length == 1)
		seconds = "0" + seconds;

	return minutes + ":" + seconds + "." + hundreds;
}

function obfuscateEmail(s) {
	var r = toString(s);
	r = r.replace("@","_KEFF_");
	r = r.replace(".","_KOFF_");
	return r;
}

function asciify(s) {
	var r = toString(s);
	r = r.replace("�","A");
	r = r.replace("�","A");
	r = r.replace("�","O");
	r = r.replace("�","a");
	r = r.replace("�","a");
	r = r.replace("�","o");
	r = r.replace(" ","_");
	return r;
}

function ltrim(str) {
    return str.replace(/^[ ]+/, '');
}

function rtrim(str) {
    return str.replace(/[ ]+$/, '');
}

function trim(str) {
    return ltrim(rtrim(str));
}

function rfill(str, j) {
	if(str.length >= j) {
		return str.substring(0, j);
	}
	var newStr = str;
	for(var i = str.length; i < j; i++) {
		newStr += ' ';
	}
	return newStr;
}

function formatNumber(num) {
	if(num >= 10) {
		return "" + num;
	}
	return "0" + num;
}

function arrayContains(arr, str) {
	for(var i = 0; i < arr.length; i++) {
		if(arr[i]==str)
			return true;
	}
	return false;
}

/**
 * Send an email through an smtp server using cdo.message.
 */
function sendEmail(toAddress, subject, message) {

	/*
	// Home settings
	var fromAddress = "stefan.norman@home.se";

	var smtp_server = "smtp.home.se"; // For TDC "customer-relay.tdc.se"
	var smtp_port = 25;
	var smtp_user = "stefan.norman@home.se";
	var smtp_pwd = "XXX";
	var smtp_ssl = false;
	*/

	// GMail settings
	var fromAddress = "funkisansvarig@tss.nu";

	var smtp_server = "smtp.gmail.com";
	var smtp_port = 465; // 587 funkar med PHPMailer;
	var smtp_user = "funkisansvarig@tss.nu";
	var smtp_pwd = "XXX";
	var smtp_ssl = true;

	var emailObj = Server.CreateObject("cdo.message");

	emailObj.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2;
	emailObj.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = smtp_server;
	emailObj.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = smtp_port;
	emailObj.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = smtp_user;
	emailObj.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = smtp_pwd;

	emailObj.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1;
	emailObj.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60;
	emailObj.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = smtp_ssl;


	emailObj.Configuration.Fields.Update();

	emailObj.From = fromAddress;
	emailObj.To = toAddress;
	emailObj.Subject = subject;
	emailObj.TextBody = message;
	emailObj.Send();
	emailObj = null;
}

function User(id, name, roles) {
    this.id = id;
    this.name = name;
    this.roles = roles;
}
function isAuthorized(role) {
	var _user = Session("AuthUser");
	if(_user == null)
		return false;
	return _user.roles.indexOf(role) >= 0;
}
%>
