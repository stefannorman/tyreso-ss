<%@ LANGUAGE = JScript %><%Response.ContentType="text/calendar";%><%response.Charset="UTF-8"%><%response.addHeader('Content-Disposition', 'inline; filename=ical.ics')%> <!--#include file="cms/basicfuncs.asp" --><!--#include file="cms/data/database.asp" --><!--#include file="cms/calendar.inc" -->BEGIN:VCALENDAR
PRODID:-//stefan/imcal//NONSGML v1.0//EN
VERSION:2.0
CALSCALE:GREGORIAN
X-LOTUS-CHARSET:UTF-8
METHOD:PUBLISH
X-WR-CALNAME:Tyresö SS
X-WR-TIMEZONE:Europe/Rome<%

while(!events.EOF) {
  var eventStart = new Date(events("Startdate"));
  var eventEnd = new Date(events("Stopdate"));
  // add 1 day to end date of fullday events according to RFC-2445
  eventEnd.setDate( eventEnd.getDate()+1 );
%>

BEGIN:VEVENT
DTSTAMP:20090222T044240Z
DTSTART;VALUE=DATE:<%=getDateString2(eventStart)%>
DTEND;VALUE=DATE:<%=getDateString2(eventEnd)%>
SUMMARY:<%=events("Name")%>
LOCATION:<%=events("location")%>
DESCRIPTION:<%=events("description")%>
ORGANIZER;CN="TSS":mailto:webmaster@tss.nu
END:VEVENT
<%
  events.movenext();
}
events.close();%>
END:VCALENDAR
