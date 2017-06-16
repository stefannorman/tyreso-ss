<%
if(Session("AuthUser") == null) {
  Response.Redirect ("/admin.asp");
}
%>