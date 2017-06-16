<%
/**
 * Lists articles.
 *
 * @param _category String list articles of this category
 * @param _year String (optional) list articles of this year
 * @param _pagesize String (optional) number of articles to list
 */
function NewsList(_category, _year, _pagesize) {

	this.category = _category;

	// constant to show the list as boxes
	this.showBoxes = false;

	this.articles = new Array();
	
	var query = Server.CreateObject("adodb.recordset");
	var sql =
		"SELECT " + (_pagesize != undefined && _pagesize !="" ? " TOP " + _pagesize : "") +
		" id, title, created, text, category FROM news WHERE " +
		"category = '" + _category + "' " +
		(_year != undefined && _year != "" ? "AND year(created) = " + _year : "") +
		" ORDER BY created DESC";
	query.open(sql,connect,1,1);
	while(!query.EOF) {
		this.articles[this.articles.length] = new Article(
			toString(query("id")),
			toString(query("title")),
			toString(query("created")),
			toString(query("text")),
			toString(query("category"))
		);
		query.movenext();
	}
	query.close();
}

/**
 * List of years that has published articles
 * Used in archive listing
 *
 * @param _category String list articles of this category
 */
function NewsYears (_category) {
	var query = Server.CreateObject("adodb.recordset");
	var sql = "SELECT DISTINCT YEAR(created) AS year FROM news WHERE category ='" + _category + "'";
	query.open(sql,connect,1,1);
	var years = new Array();
	while(!query.EOF) {
		years[years.length] = toString(query("year"));
		query.movenext();
	}
	query.close();
	return years;
}

/**
 * Article object.
 *
 * @param _id String the article ID
 * @param _title String the article title
 * @param _created String the article creation date
 * @param _text String the article bodytext
 * @param _category String the category of the article
 */
function Article(_id, _title, _created, _text, _category) {
	this.id = _id;
	this.title = _title;
	this.created = _created;
	this.text = _text;
	this.category = _category;
}
%>
