/**
 * This program looks at the output from the command 'aws ec2 describe-instances'.
 * In particular, it lists pairs of public and private dns names. In order for an
 * instance to be aware of its public dns, we need to pull this information from 
 * AWS and this looked like a good method for doing so.
 * @author sman
 *
 */

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.IOException;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class PublicDNS {

	/**
	 * This method is used to get the hostname of the machine on which 
	 * this code is running.
	 * @return  the host name.  May be null if there was a problem
	 */
	String getHostName() {
		BufferedReader br = null;
		String host = null;
		try { 
			Process p = Runtime.getRuntime().exec("hostname"); 
			p.waitFor(); 
			br = new BufferedReader(new InputStreamReader(p.getInputStream(),"UTF-8")); 
			String line = br.readLine();
			host = line;
		} catch (Exception e) {
			System.err.println("Exception:" + e);
			e.printStackTrace();
		} finally {
			if (null != br) {
				try {
					br.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return host;
	}	

	/**
	 * The main routine expects the name of file containing json to 
	 * be passed in as the first argument.
	 * 
	 * @param args  1 arg required:  the name of the file to parse
	 */
	public static void main(String[] args) {
		PublicDNS jr = new PublicDNS();
		Object obj = null;
		String extDnsName = null;
		boolean hasName = true;

		// get hostname of this box. It will be the internal DNS
		// name.  Match it up to one of the instances in the reservations list
		String myHostName = jr.getHostName();
		hasName = (null != myHostName);
		if (null != myHostName) {
			if (0 == myHostName.trim().length()) {
				hasName = false;
			}
		}
		if (!hasName) {
			System.err.println("ERROR: Could not determine hostname!");
			System.exit(1);
		}  
	
		System.out.println("hostname: " + myHostName );
		System.out.println("Working Directory = " + System.getProperty("user.dir"));
		
		JSONParser parser = new JSONParser();
		try {
			if (args.length > 0) {
				obj = parser.parse(new InputStreamReader(new FileInputStream(args[0]),"UTF-8"));
			} else {
				obj = parser.parse(new InputStreamReader(System.in,"UTF-8"));
			}
			
			JSONObject jo = (JSONObject) obj;
			JSONArray reservationList = (JSONArray) jo.get("Reservations");
			for (int i = 0; i < reservationList.size() && null == extDnsName; i++ ) {
				JSONObject res = (JSONObject) reservationList.get(i);
				JSONArray instances = (JSONArray) res.get("Instances");
				for (int j = 0; j < instances.size() && null == extDnsName; j++ ) {
					JSONObject inst = (JSONObject) instances.get(j);
					String publicDnsName =  (String) inst.get("PublicDnsName");
					String privateDnsName = (String) inst.get("PrivateDnsName");
					if (myHostName.equals(privateDnsName)) {
						extDnsName = publicDnsName;
					}
				}
			}
		} catch (Exception e) {
			System.err.println("Exception: " + e);
			e.printStackTrace();
		}
		
		if (null != extDnsName) {
			System.out.println( "public dns name: " + extDnsName);
		} else {
			System.out.println( "could not find \"" + myHostName + "\" in the json input");
		}
		
		
	}
}

