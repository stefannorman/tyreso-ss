<%@ LANGUAGE = JScript %><%Response.ContentType = "text/xml";%><?xml version="1.0" encoding="iso-8859-1"?>
<rss version="2.0">
<channel>
<!--#include file="cms/basicfuncs.asp" -->
<!--#include file="cms/data/database.asp" -->
<%
var title = "Tyresö Simsällskap";
if(toString(Request.QueryString("title")) != "")
  title = toString(Request.QueryString("title"));
var news = Server.CreateObject("adodb.recordset");
var category = "notis";
if(toString(Request.QueryString("category")) != "")
  category = toString(Request.QueryString("category"));
var sql = "SELECT TOP 10 * FROM news WHERE category = '"+category+"' ORDER BY created DESC";
news.open(sql,connect,1,1);
var lastBuildDate = getRFC822DateString(new Date(news("created")));
%>
<title><%=title%></title>
<link>http://www.tss.nu/</link>
<description>Nyheter på Tyresö SS hemsida</description>
<lastBuildDate><%=lastBuildDate%></lastBuildDate>
<language>sv-SE</language>
<image>
  <url>http://www.tss.nu/images/logo.jpg</url>
  <title><%=title%></title>
  <link>http://www.tss.nu/</link>
</image>
<%
while(!news.EOF)
{
	var created = new Date(news("created"));
	%>
	<item>
	<title><![CDATA[ <%=news("title")%> ]]></title>
	<link>http://www.tss.nu</link>
	<guid>http://www.tss.nu?id=<%=news("id")%></guid>
	<pubDate><%=getRFC822DateString(created)%></pubDate>
	<description><![CDATA[ <%=news("text")%> ]]></description>
	</item>
	<%
	news.movenext();
}
news.close();
%>
</channel>
</rss>
