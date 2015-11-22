package sql;

import java.sql.SQLException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.mysql.jdbc.Driver;


public class MySQLDriver {
	private static Connection con;
	//private final static String selectName = "SELECT * FROM FACTORYORDERS WHERE NAME=?";
	private final static String addOrganization = "INSERT INTO Organization (UID, nameOrganization) VALUES (?, ?)";
	private final static String addMeeting = "INSERT INTO Meeting (creatorID, deadline, idOrganization, meetingName) VALUES (?, ?, ?, ?)";
	private final static String addUser = "INSERT INTO UserNames (userName) VALUES (?)";
	private final static String exists = "SELECT idMeetingOpt FROM MeetingOpt WHERE UID = ? AND meetingID = ?";
	private final static String addMeetingOpt = "INSERT INTO MeetingOpt (UID, meetingID, opt) VALUES (?, ?, ?)";
	private final static String updateMeetingOpt = "UPDATE MeetingOpt SET opt = ? WHERE UID = ? AND meetingID = ?";
	private final static String getMeetings = "SELECT meetingName, deadline, idMeeting FROM Meeting WHERE idOrganization = ?"; 
	private final static String deleteMeeting = "DELETE FROM Meeting WHERE idMeeting = ?"; 
	private final static String getOptInners = "SELECT UID FROM MeetingOpt WHERE meetingID = ? AND opt = ?";
	private final static String getOrgID = "SELECT idOrganization FROM Organization WHERE UID = ? AND nameOrganization = ?";
	private final static String getAllOrgs = "SELECT idOrganization, nameOrganization FROM Organization";
	
	
	public MySQLDriver() {
		try {
			new Driver();
		} catch(SQLException e) {
			e.printStackTrace();
		}
	}
	public void connect() {
		try {
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/PlanitSchema?user=root&password=");
			System.out.println("connection made");
		} catch (SQLException e){
			System.out.println("connection not made");
			e.printStackTrace();
		}
	}
	
	public static void createOrganization(String orgStringName, int orgCreatorID){
		
		//TODO: Add stuff do the data base
		//TODO: make array for meetings as part of org data as well
		
	}
	
	public static void addOrganization(Integer UID, String nameOrganization) {
		try{
			PreparedStatement ps = con.prepareStatement(addOrganization);
			ps.setInt(1, UID);
			ps.setString(2, nameOrganization);
			ps.executeUpdate();
		} catch (SQLException e) {e.printStackTrace();}
	}
	
	public static void addMeeting(Integer UID, Date date, Integer idOrganization, String meetingName) {
		try{
			PreparedStatement ps = con.prepareStatement(addMeeting);
			ps.setInt(1, UID);
			ps.setDate(2, date);
			ps.setInt(3, UID);
			ps.setString(4, meetingName);
			ps.executeUpdate();
		} catch (SQLException e) {e.printStackTrace();}
	}
	
	public static void addUser(String userName) {
		try{
			PreparedStatement ps = con.prepareStatement(addUser);
			ps.setString(1, userName);
			ps.executeUpdate();
		} catch (SQLException e) {e.printStackTrace();}
	}
	
	public void stop() {
		try {con.close();} catch (SQLException e) {e.printStackTrace();}
	}
	public static void opt(int UID, int meetingID, int optPref) {
		ResultSet result = null;
		try{
			PreparedStatement ps = con.prepareStatement(exists);
			ps.setInt(1, UID);
			ps.setInt(2, meetingID);
			result = ps.executeQuery();
		} catch (SQLException e) {e.printStackTrace();}
		try {
			if (!result.next()) { //not found
				try{
					System.out.println("adding to db");
					PreparedStatement ps = con.prepareStatement(addMeetingOpt);
					ps.setInt(1, UID);
					ps.setInt(2, meetingID);
					ps.setInt(3, optPref);
					ps.executeUpdate();
					System.out.println("added to db");
				} catch (SQLException e) {e.printStackTrace();}
			}
			else { //found it, so we now update
				try{
					PreparedStatement ps = con.prepareStatement(updateMeetingOpt);
					ps.setInt(1, optPref);
					ps.setInt(2, UID);
					ps.setInt(3, meetingID);
					ps.executeUpdate();
					System.out.println("updated db");
				} catch (SQLException e) {e.printStackTrace();}
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public static ResultSet getMeetings(int idOrganization) {
		ResultSet resultSet = null;
		try{
			PreparedStatement ps = con.prepareStatement(addMeeting);
			ps = con.prepareStatement(getMeetings);
			ps.setInt(1, idOrganization);
			resultSet = ps.executeQuery();
		} catch (SQLException e) {e.printStackTrace();}
		
		return resultSet;
	}
	
	
	public static void deleteMeeting(int idMeeting) {
		try{
			PreparedStatement ps = con.prepareStatement(deleteMeeting);
			ps.setInt(1, idMeeting);
			ps.executeUpdate();
		} catch (SQLException e) {e.printStackTrace();}
	}
	
	public static ResultSet getOptInners(int idMeeting) {
		ResultSet rs = null;
		try{
			PreparedStatement ps = con.prepareStatement(getOptInners);
			ps.setInt(1, idMeeting);
			ps.setInt(2, 1);
			rs = ps.executeQuery();
		} catch (SQLException e) {e.printStackTrace();}
		return rs;
	}
	
	public static ResultSet getOrgId(int UID, String nameOrganization) {
		ResultSet rs = null;
		try{
			PreparedStatement ps = con.prepareStatement(getOrgID);
			ps.setInt(1, UID);
			ps.setString(2, nameOrganization);
			rs = ps.executeQuery();
		} catch (SQLException e) {e.printStackTrace();}
		return rs;
	}
	
	public static ResultSet getOrganizations() {
		ResultSet rs = null;
		try{
			PreparedStatement ps = con.prepareStatement(getAllOrgs);
			rs = ps.executeQuery();
		} catch (SQLException e) {e.printStackTrace();}
		return rs;
	}
	
	
	
}

