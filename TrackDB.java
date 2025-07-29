import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Date;
import java.util.Scanner;
import java.sql.PreparedStatement;
import java.sql.Types;
import java.math.BigDecimal;

public class TrackDB {

	public static void main(String args[]) throws Exception {

		Class.forName("com.mysql.cj.jdbc.Driver");

		try {
			String user = "root";
			String password = "secret";
			String myURL = "jdbc:mysql://localhost/dbVanderwerfTrack?autoReconnect=true&useSSL=false&allowMultiQueries=true";

			Connection conn = DriverManager.getConnection(myURL, user, password);
			Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, 						ResultSet.CONCUR_UPDATABLE);

			String menu = "Please select an option:\n1: To add a new Athlete\n2: To enter a new result\n3: To get the results for an event\n4: To score an event(make sure all events are scored before scoring the meet)\n5: To disqualify an athlete for one event\n6: To disqualify an athlete for the meet\n7: To score the meet\n8: Disqualify athlete(s) who competed in more than 4 events (do before scoring the meet)\n9: TO QUIT";

		
				int input;
				Scanner scan = new Scanner(System.in);

			do{
				System.out.println(menu);

				input = scan.nextInt();

				switch(input) {
				case 1:

				//get athleteName, gender, schoolId
				System.out.println("Enter athlete's name: ");
				String athleteName = scan.nextLine();
				athleteName = scan.nextLine();
				System.out.println("Enter gender (m or f): ");
				String gender = scan.nextLine();
				System.out.println("Enter SchoolId (1-5): ");
				int schoolId = scan.nextInt();

				//create query
				String qry = "insert into athletes" + " (athleteName, gender, schoolId) " + " values (?, ?, ?)";
				PreparedStatement state = conn.prepareStatement(qry);

				//enter values into query
				state.setString(1, athleteName);
				state.setString(2, gender);
				state.setInt(3, schoolId);
				state.executeUpdate();
				break;


				case 2:
				//to enter a new result
				//get user input for compNumber
				System.out.println("Enter competitor number: ");
				int compNumber = scan.nextInt();

				//get user input for gender (m or f)
				System.out.println("Enter gender (m or f): ");
				gender = scan.nextLine();
				gender = scan.nextLine();

				//get user input for points
				System.out.println("Enter points (0 if not scored yet): ");
				int points = scan.nextInt();

				//get user input for disqualified (yes or no or unknown)
				System.out.println("Yes or no for disqualified: ");
				String disqualified = scan.nextLine();
				disqualified = scan.nextLine();

				//get user input for place
				System.out.println("Enter place: ");
				int place = scan.nextInt();

				//get user input for time
				System.out.println("Enter time: ");
				BigDecimal time = scan.nextBigDecimal();

				//get user input for distance
				System.out.println("Enter distance: ");
				BigDecimal distance = scan.nextBigDecimal();

				//get user input for eventId
				System.out.println("Enter event ID: ");
				int eventId = scan.nextInt();

				//get user input for schoolId
				System.out.println("Enter school ID: ");
				schoolId = scan.nextInt();



				//create query
				qry = "insert into results" + " (compNumber, gender, points, disqualified, place, time, distance, eventId, schoolId) " + " values (?, ?, ?, ?, ?, ?, ?, ?, ?)";

				state = conn.prepareStatement(qry);

				state.setInt(1, compNumber);
				state.setString(2, gender);
				state.setInt(3, points);
				state.setString(4, disqualified);
				state.setInt(5, place);
				state.setBigDecimal(6, time);
				state.setBigDecimal(7, distance);
				state.setInt(8, eventId);
				state.setInt(9, schoolId);

				state.executeUpdate();
				break;


				case 3:
				//get results for an event

				//get eventId
				System.out.println("Enter event ID: ");
				eventId = scan.nextInt();

				//get gender
				System.out.println("Enter gender (m or f): ");
				gender = scan.nextLine();
				gender = scan.nextLine();
			
				qry = "select r.eventId, e.eventName, r.gender, a.athleteName, r.place, r.points, r.disqualified, r.time, r.distance, s.name as schoolname from events as e, results as r, athletes as a, schools as s where r.eventid = ? and r.gender = ? and r.compNumber = a.competitorNumber and r.eventid = e.Id and r.schoolId = a.schoolId and a.schoolId = s.Id;";


				state = conn.prepareStatement(qry);

				state.setInt(1, eventId);
				state.setString(2, gender);

				ResultSet rs = state.executeQuery();
				

				System.out.printf("%-15s%-20s%-26s%-26s%-10s%-10s%-20s%-20s%-20s%-15s\n", "eventId", "eventName", "athleteName", "school name", "gender", "place", "disqualified", "time", "distance", "points");
					
					System.out.println("---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");


				while (rs.next()) {
					eventId = rs.getInt("eventId");
					String eventName = rs.getString("eventName");
					athleteName = rs.getString("athleteName");
					String schoolName = rs.getString("schoolName");
					gender = rs.getString("gender");
					place = rs.getInt("place");
					disqualified = rs.getString("disqualified");
					time = rs.getBigDecimal("time");
					distance = rs.getBigDecimal("distance");
					points = rs.getInt("points");
						
						System.out.printf("%-15d%-20s%-26s%-26s%-10s%-10s%-20s%-20.2f%-20.2f%-15d\n", eventId, eventName, athleteName, schoolName, gender, place, disqualified, time, distance, points);
					
					}

					break;


				case 4:
				//score an event
				//get eventId
				System.out.println("Enter event ID: ");
				eventId = scan.nextInt();

				//get gender
				System.out.println("Enter gender (m or f): ");
				gender = scan.nextLine();
				gender = scan.nextLine();

				qry = " update results set points = 10 where place = 1 and eventId = ? and gender = ?;update results set points = 8 where place = 2 and eventId = ? and gender = ?;update results set points = 6 where place = 3 and eventId = ? and gender = ?;update results set points = 4 where place = 4 and eventId = ? and gender = ?;update results set points = 2 where place = 5 and eventId = ? and gender = ?;update results set points = 1 where place = 6 and eventId = ? and gender = ?";
				state = conn.prepareStatement(qry);
				state.setInt(1, eventId);
				state.setString(2, gender);
				state.setInt(3, eventId);
				state.setString(4, gender);
				state.setInt(5, eventId);
				state.setString(6, gender);
				state.setInt(7, eventId);
				state.setString(8, gender);
				state.setInt(9, eventId);
				state.setString(10, gender);
				state.setInt(11, eventId);
				state.setString(12, gender);

				state.executeUpdate();
				break;


				case 5:
				//disqualify athlete for one event

				System.out.println("Enter competitor number: ");
				compNumber = scan.nextInt();

				System.out.println("Enter event ID: ");
				eventId = scan.nextInt();

				qry = "update results set disqualified = 'yes' where compNumber = ? and eventId = ?";

				state = conn.prepareStatement(qry);
				state.setInt(1, compNumber);
				state.setInt(2, eventId);
				state.executeUpdate();
				break;


				case 6:
				//To disqualify an athlete for the whole meet

				//get compNumber from user
				System.out.println("Enter competitor number: ");
				compNumber = scan.nextInt();
				
				//prepare statement with qry
				qry = "update results set disqualified = 'yes' where compNumber = ?";

				state = conn.prepareStatement(qry);
				state.setInt(1, compNumber);
				state.executeUpdate();
				
				break;


				case 7:
				//score the meet


				//score for everyone
				qry = "update schools set points = (select sum(points) from results where schoolid = 1) where id = 1;update schools set points = (select sum(points) from results where schoolid = 2) where id = 2;update schools set points = (select sum(points) from results where schoolid = 3) where id = 3;update schools set points = (select sum(points) from results where schoolid = 4) where id = 4;update schools set points = (select sum(points) from results where schoolid = 5) where id = 5;";
				state = conn.prepareStatement(qry);
				state.executeUpdate();
				

				String qry1 = "select row_number()over(order by points desc) place, name, points from schools order by points desc;";

				state = conn.prepareStatement(qry1);
				rs = state.executeQuery();

				System.out.printf("%-15s%-30s%-10s\n", "place", "school name", "points");
				System.out.println("-------------------------------------------------------------------");

				while (rs.next()) {
					place = rs.getInt("place");
					String name = rs.getString("name");
					points = rs.getInt("points");

					System.out.printf("%-15d%-30s%-10d\n", place, name, points);
				}

				System.out.println();
				System.out.println();


				//score just women's
				qry = "update femaleresults set points = (select sum(points) from results where schoolid = 1 and gender = 'f') where id = 1;update femaleresults set points = (select sum(points) from results where schoolid = 2 and gender = 'f') where id = 2;update femaleresults set points = (select sum(points) from results where schoolid = 3 and gender = 'f') where id = 3;update femaleresults set points = (select sum(points) from results where schoolid = 4 and gender = 'f') where id = 4;update femaleresults set points = (select sum(points) from results where schoolid = 5 and gender = 'f') where id = 5;";
				state = conn.prepareStatement(qry);
				state.executeUpdate();

				qry1 = "select row_number()over(order by points desc) place, name, points from femaleresults order by points desc;";
				state = conn.prepareStatement(qry1);
				rs = state.executeQuery();

				System.out.println("Womens Results");
				System.out.printf("%-15s%-30s%-10s\n", "place", "school name", "points");
				System.out.println("-------------------------------------------------------------------");
				while (rs.next()) {
					place = rs.getInt("place");
					String name = rs.getString("name");
					points = rs.getInt("points");

					System.out.printf("%-15d%-30s%-10d\n", place, name, points);
				}


				System.out.println();
				System.out.println();


				//score just mens
				qry = "update maleresults set points = (select sum(points) from results where schoolid = 1 and gender = 'm') where id = 1;update maleresults set points = (select sum(points) from results where schoolid = 2 and gender = 'm') where id = 2;update maleresults set points = (select sum(points) from results where schoolid = 3 and gender = 'm') where id = 3;update maleresults set points = (select sum(points) from results where schoolid = 4 and gender = 'm') where id = 4;update maleresults set points = (select sum(points) from results where schoolid = 5 and gender = 'm') where id = 5;";
				state = conn.prepareStatement(qry);
				state.executeUpdate();

				qry1 = "select row_number()over(order by points desc) place, name, points from maleresults order by points desc;";
				state = conn.prepareStatement(qry1);
				rs = state.executeQuery();

				System.out.println("Mens Results");
				System.out.printf("%-15s%-30s%-10s\n", "place", "school name", "points");
				System.out.println("-------------------------------------------------------------------");
				while (rs.next()) {
					place = rs.getInt("place");
					String name = rs.getString("name");
					points = rs.getInt("points");

					System.out.printf("%-15d%-30s%-10d\n", place, name, points);
				}
				break;


				case 8:
				//disqualify athletes in more than 4 events

				qry = "select compNumber from results group by compNumber having count(compNumber) > 4;";
				state = conn.prepareStatement(qry);
				rs = state.executeQuery();

				while (rs.next()) {
					compNumber = rs.getInt("compNumber");	
					qry1 = "update results set disqualified = 'yes', points = 0 where compNumber = ?;";
					state = conn.prepareStatement(qry1);

					state.setInt(1, compNumber);
					state.executeUpdate();

				}
				break;
					

				case 9:
				//exit out of menu
				System.exit(0);
				break;

				default:
				System.out.println(input + " is not a valid menu option. Please choose another.");
			}

		}while (input != 9);
	
			



			conn.close();

		} catch (SQLException ex) {
			System.out.println("SQLException: " + ex.getMessage());
			System.out.println("SQLState: " + ex.getSQLState());
			System.out.println("VendorError: " + ex.getErrorCode());
			ex.printStackTrace();
		}
	}
}

