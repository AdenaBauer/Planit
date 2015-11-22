package servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import sql.MySQLDriver;
import org.json.*;

/**
 * Servlet implementation class addOrganization
 */

@WebServlet("/addOrganization")
public class addOrganization extends HttpServlet {
	private static final long serialVersionUID = 1L;
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {		
		System.out.println("Post Method being handled.....");
		
		response.setContentType("application/json");
		JSONObject object = translateToJSON(request);
		System.out.println(object);
		JSONArray elements = object.names();
		try {
			object = new JSONObject(elements.getString(0));
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String orgNameString = "";
		String orgCreator = "";
		
		try {
			orgNameString = object.getString("orgName");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			orgCreator = object.getString("nameCreatorID");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		System.out.println(orgNameString + " " + orgCreator);
		int orgCreatorID = Integer.parseInt(orgCreator);
		MySQLDriver msql = new MySQLDriver();
		msql.connect();
		System.out.println("connected");
		msql.addOrganization(orgCreatorID, orgNameString);
		msql.stop();
	}
	public JSONObject translateToJSON(HttpServletRequest request) {
		  JSONObject newObject = new JSONObject();
		  Map<String,String[]> parameterMap = request.getParameterMap();
		  Iterator<Map.Entry<String,String[]>> mapIt = parameterMap.entrySet().iterator();
		  
		  while(mapIt.hasNext()) {
			  Map.Entry<String,String[]> curr = mapIt.next();
			  String [] result = curr.getValue();
			  if(result.length != 1) {
				  Object addObject = result;
				  try {
					newObject.put(curr.getKey(), addObject);
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			  } else {
				  Object addObject = result[0];
				  try {
					newObject.put(curr.getKey(), addObject);
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			  }
		  }
		  return newObject;
	}

}
