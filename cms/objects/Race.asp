<%
/**
 * Get a single Race
 */
function Race(raceID) {
	
	this.id = 0;
	this.name = "";
	this.date = new Date();
	this.sessions = 0;
	this.registrationDate = new Date();
	this.checklist = 0;
	
	// initialize object
	if(raceID != "") {
		var query = Server.CreateObject("adodb.recordset");
		var sql = "SELECT * FROM calendar WHERE id = " + raceID;
		query.open(sql,connect,1,1);
		if(!query.EOF) {
			this.id = toInt(query("Id"));
			this.name = toString(query("Name"));
			this.date = new Date(query("Startdate"));
			this.sessions = toInt(query("Sessions").Value);
			this.registrationDate = new Date(query("registrationdate"));
			this.checklist = toInt(query("Checklist"));
		}
		query.close();
	}
}

%>
