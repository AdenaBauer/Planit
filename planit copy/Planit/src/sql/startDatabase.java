package sql;

import java.sql.Date;

public class startDatabase {
	public static void main (String [] args) {
		MySQLDriver msql = new MySQLDriver();
		msql.connect();
		System.out.println("connected");
		msql.addOrganization(1, "Shparkd");
		msql.addMeeting(1, new Date(1990));
		msql.addUser("adenur");
		msql.opt(2, 1, 1);
		msql.stop();
	}
}
