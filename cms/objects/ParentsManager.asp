<%
function Role(name, label) {
	this.name = name;
	this.label = label;
}

function Parent(swimmerID, role, participates) {
	this.swimmer = swimmerID;
	this.role = role;
	this.participates = participates;
}

function ParentsManager(raceID) {
	
	this.raceID = raceID;
	this.allParents = new Array();
	this.roles = new Array(
		new Role("build", "Riggning"),
		new Role("bake", "Bakning"),
		new Role("tear", "Avriggning"),
		new Role("clean", "Städning")
	);
	
	this.updateDB = function(action, swimmer, role, participates) {
		var sql = "";
		switch(action) {
			case "add": 
				sql = "INSERT INTO parents (swimmer, event_id, role) VALUES ("+swimmer+","+this.raceID+",'"+role+"')";
				break;
			case "delete":
				sql = "DELETE FROM parents WHERE swimmer="+swimmer+" AND event_id="+this.raceID+" AND role='"+role+"'";
				break;
			case "update":
				sql = "UPDATE parents SET participates = "+participates+" WHERE swimmer="+swimmer+" AND event_id="+this.raceID;
				break;
		}
		//Response.Write(sql);
		connect.Execute(sql);

	}
	
	this.getParentsOfRole = function(role) {
		if(this.allParents.length == 0) {
			// initialize array
			var query = Server.CreateObject("adodb.recordset");
			sql = "SELECT swimmer, role, participates FROM parents WHERE event_id = "+this.raceID;
			query.open(sql,connect,1,1);
			while(!query.EOF) {
				var parent = new Parent(toString(query("swimmer")), toString(query("role")), toBool(query("participates")));
				this.allParents[this.allParents.length] = parent;
				query.MoveNext();
			}
			query.close();
		}
		
		var arr = new Array();
		for(var i = 0; i < this.allParents.length; i++) {
			if(this.allParents[i].role == role) {
				arr[arr.length] = this.allParents[i];
			}
		}
		return arr;
	}
	
}

%>
