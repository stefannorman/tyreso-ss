<%
/**
 * Newslist view.
 *
 * @param newsList Object holding articles to be listed
 */

var editable = isAuthorized("editor");
var articleList = newsList.articles;

if(editable)
{
	%>
	<div class="cms_toolbar">
		<a href="/cms/edit.asp?category=<%=newsList.category%>"><img src="/cms/icons/new.png" hspace="0" border="0" title="Skapa nytt">Skapa nytt</a>
	</div>
	<br/>
	<% 
}
for(var i = 0; i < articleList.length; i++) {
	if(newsList.showBoxes) {
	%>
		<div class="box">
			<div class="header">.: <%=articleList[i].title%> :.</div>
			<div class="content">
				<% if(editable) { %>
				<div class="cms_toolbar">
					<a href="/cms/edit.asp?id=<%=articleList[i].id%>"><img src="/cms/icons/edit.png" hspace="0" border="0" title="Ändra">Ändra</a>
					<a href="javascript:if(confirm('Är du säker på att du vill radera?')) location = '/cms/delete.asp?id=<%=articleList[i].id%>';"><img src="/cms/icons/delete.png" hspace="2" border="0" title="Radera">Radera</a>
				</div>
				<% } %>
				<span class="newsdate"><%=articleList[i].created%></span>
				<br/>
				<%=articleList[i].text%>
			</div>
		</div>
		<br/>
	<%
	} else {
	%>
		<% if(editable) { %>
		<div class="cms_toolbar">
			<a href="/cms/edit.asp?id=<%=articleList[i].id%>"><img src="/cms/icons/edit.png" hspace="0" border="0" title="Ändra">Ändra</a>
			<a href="javascript:if(confirm('Är du säker på att du vill radera?')) location = '/cms/delete.asp?id=<%=articleList[i].id%>';"><img src="/cms/icons/delete.png" hspace="2" border="0" title="Radera">Radera</a>
		</div>
		<% } %>
		<span class="newsdate"><%=articleList[i].created%></span>
		<span class="newsheader"><%=articleList[i].title%></span>
		<br/>
		<%=articleList[i].text%>
		<hr class="line" />
	<%
	}
}
%>

