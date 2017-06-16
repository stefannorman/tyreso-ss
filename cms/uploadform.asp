<%@ LANGUAGE = JScript %>
<!--#include file="basicfuncs.asp" -->
<html>
<head>
	<title>Ladda upp fil</title>
	<style type="text/css">
	@import url("/css/tss.css");
	</style>
</head>
<body>
	<form action="/cms/FCKeditor/editor/filemanager/upload/asp/upload.asp?Type=<%=Request.QueryString("Type")%><%=toString(Request.QueryString("UploadPath")) != "" ? "&UploadPath=" + Request.QueryString("UploadPath") : ""%>"
		enctype="multipart/form-data" method="post">
		<input type="file" name="NewFile"><br>
		<input type="submit" value="Ladda upp">
	</form>

</body>
</html>