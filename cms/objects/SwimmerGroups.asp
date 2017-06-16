<%

function Swimmer(servetteID, name, email, phone, mobile, group) {
	this.servetteID = servetteID;
	this.name = name;
	this.email = email;
	this.phone = phone;
	this.mobile = mobile;
	this.group = group;
}

function Group(name) {
	this.name = name;
	this.swimmers = new Array();
}

function SwimmerGroups() {
	
	this.groups = new Array();
	this.allSwimmers = new Array();
	
	this.findSwimmerByID = function(servetteID) {
		for(var i = 0; i < this.allSwimmers.length; i++) {
			if(this.allSwimmers[i].servetteID == servetteID) {
				return this.allSwimmers[i];
			}
		}
		return null;
	}
	
	// initialize object
	var query = Server.CreateObject("adodb.recordset");
	sql = "SELECT a.Aktivitetsgruppnamn, m.medlemsnummer, m.förnamn, m.efternamn, m.kvinna, m.epost, m.Telefonnummer, m.Mobilnr  " +
	      "FROM medlemmar m, [Kopplingar medlemmar och aktivitetsgrupper] k, aktivitetsgrupper a " +
	      "WHERE k.medlemsnummer = m.medlemsnummer and k.period = "+termin+" and k.aktivitetsgruppID = a.aktivitetsgruppID " +
	      "ORDER BY a.Aktivitetsgruppnamn, m.förnamn, m.efternamn";
	query.open(sql,servette,1,1);
	var groupName = "";
	while(!query.EOF) {
		if(groupName != query("Aktivitetsgruppnamn")) {
			groupName = toString(query("Aktivitetsgruppnamn"));
			this.groups[this.groups.length] = new Group(groupName);
		}
		var swimmer = new Swimmer(toString(query("medlemsnummer")), toString(query("förnamn")) + " " + toString(query("efternamn")), toString(query("epost")), toString(query("Telefonnummer")), toString(query("Mobilnr")), groupName);
		this.groups[this.groups.length-1].swimmers[this.groups[this.groups.length-1].swimmers.length] = swimmer;
		this.allSwimmers[this.allSwimmers.length] = swimmer;
		query.MoveNext();
	}
	query.close();
}

%>
