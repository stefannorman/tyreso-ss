<%
/*
Hade problem med 80004005 errors. Hittade l?sning h?r
http://tutorials.aspfaq.com/8000xxxxx-errors/80004005-errors.html
http://access.databases.aspfaq.com/why-does-access-give-me-unspecified-error-messages.html
La till connect.Mode = 3; s? funkade det.
*/
var connect;
connect = Server.CreateObject("ADODB.Connection");
connect.Mode = 3;  /* adModeReadWrite */
connect.Open("filedsn=" + Server.MapPath("/cms/data/access.dsn") + ";DBQ=" + Server.MapPath("/cms/data/cms.mdb") +";;;");

var servette;
servette = Server.CreateObject("ADODB.Connection");
servette.Mode = 3;
servette.Open("filedsn=" + Server.MapPath("/cms/data/access.dsn") + ";DBQ=" + Server.MapPath("/cms/data/servette.mdb") +";;;");

var grodan;
grodan = Server.CreateObject("ADODB.Connection");
grodan.Mode = 3;
grodan.Open("filedsn=" + Server.MapPath("/cms/data/access.dsn") + ";DBQ=" + Server.MapPath("/cms/data/grodandb.mdb") +";;;");
//grodan.Open("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + Server.MapPath("/cms/data/grodandb.mdb") + ";Jet OLEDB:Database Password=grodan;;");

%>
