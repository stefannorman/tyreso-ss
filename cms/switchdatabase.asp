<%@ LANGUAGE = JScript %>
<!--#include file="basicfuncs.asp" -->
<%
Server.ScriptTimeout = 300;
var fso = new ActiveXObject("Scripting.FileSystemObject");
var ForReading = 1, ForWriting = 2, ForAppending = 8;

var aspFile;

aspFile = fso.OpenTextFile(Server.MapPath("/cms/data/database.asp"), ForReading);
var fileContent = aspFile.ReadAll();
aspFile.Close();

fileContent = fileContent.replace(/"\/cms\/data\/grodandb\(\d+\)\.mdb"/g, "\""+Request.QueryString("fileUrl")+"\"");

aspFile = fso.OpenTextFile(Server.MapPath("/cms/data/database.asp"), ForWriting, true);
aspFile.Write(fileContent);
aspFile.Close();
%>
Databasen utbytt!
