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
import org.json.simple.parser.ParseException;

public class PublicDNS {

	private boolean debug;
	String extDnsName;
	String myHostName;

	PublicDNS() {
		debug = false;
		extDnsName = null;
		myHostName = null;
	}

	public void setDebug(boolean b) {
		debug = b;
	}

	public String getPublicDns() {
		return extDnsName;
	}

	public String getMyHostName() {
		return myHostName;
	}

	/**
	 * This method is used to get the hostname of the machine on which 
	 * this code is running.
	 * @return  the host name.  May be null if there was a problem
	 */
	String determineHostName() {
		BufferedReader br = null;
		String host = null;
		try { 
			Process p = Runtime.getRuntime().exec("hostname"); 
			p.waitFor(); 
			br = new BufferedReader(new InputStreamReader(p.getInputStream(),"UTF-8")); 
			String line = br.readLine();
			if (null == line) {
				return null;
			}
			host = line;
			/*
			 * strip away starting at the first dot, through the end of the string
			 */
			int n = line.indexOf('.');
			if ( n > -1 ) {
				host = line.substring(0, n);
			} else {
				host = line;
			}

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
	 * This routine actually does the parsing of the input. If
	 * the supplied filename is non-null, it will be opened and its
	 * contents will be parsed. If it is null, we parse from stdin
	 * 
	 * @return 0 on success
	 *         -1  = failure, go no further
	 */
	public int doParse(String filename) {
		boolean hasName = true;
		Object obj = null;
		/*
		 *  get hostname of this box. It will be the internal DNS
		 *  name.  Match it up to one of the instances in the reservations list
		 */
		myHostName = determineHostName();
		hasName = (null != myHostName);
		if (null != myHostName) {
			if (0 == myHostName.trim().length()) {
				hasName = false;
			}
		}
		if (!hasName) {
			System.err.println("ERROR: Could not determine hostname!");
			return -1;
		}  

		if (debug) {
			System.out.println("hostname: " + myHostName );
			System.out.println("Working Directory = " + System.getProperty("user.dir"));
		}

		JSONParser parser = new JSONParser();
		try {
			if (filename != null) {
				obj = parser.parse(new InputStreamReader(new FileInputStream(filename),"UTF-8"));
			} else {
				obj = parser.parse(new InputStreamReader(System.in,"UTF-8"));
			}
		} catch (IOException | ParseException e) {
			System.err.println("Exception: " + e );
			e.printStackTrace();
		}

		if (null == obj) {
			System.err.println("json parser was unable to process input");
			return -1;
		}
		JSONObject jo = (JSONObject) obj;
		JSONArray reservationList = (JSONArray) jo.get("Reservations");
		if (null == reservationList) {
			System.err.println("json input does not contain Reservations");
			return -1;
		}
		for (int i = 0; i < reservationList.size() && null == extDnsName; i++ ) {
			JSONObject res = (JSONObject) reservationList.get(i);
			JSONArray instances = (JSONArray) res.get("Instances");
			for (int j = 0; j < instances.size() && null == extDnsName; j++ ) {
				JSONObject inst = (JSONObject) instances.get(j);
				String publicDnsName =  (String) inst.get("PublicDnsName");
				String privateDnsName = (String) inst.get("PrivateDnsName");
				/*
				 * The private host name does not come back with any other part of the domain.
				 * But the data from `hostname` comes back in this form: 
				 * 		ip-172-31-40-16.ec2.internal
				 * So, we need to examine everything up to the first dot (.)
				 */
				{ 
					int n = privateDnsName.indexOf('.');
					if ( n > -1 ) {
						String s = privateDnsName.substring(0, n);
						if (debug) {
							System.out.print("found " + s);
						}
						if (myHostName.equals(s)) {
							extDnsName = publicDnsName;
						}
						if (debug) {
							System.out.printf(" %s %s%n", 
									(extDnsName != null) ? "MATCHED" : "does not match", 
											myHostName);
						}
					}
				}
			}
		}
		return 0;
	}

	/**
	 * The main routine expects the name of file containing json to 
	 * be passed in as the first argument.
	 * 
	 * @param args  1 arg required:  the name of the file to parse
	 */
	public static void main(String[] args) {
		PublicDNS jr = new PublicDNS();
		String filename = null;
		boolean debug = false;
		boolean exitEarly = false;

		for (int i = 0; i < args.length; i++ ) {
			if (args[i].charAt(0) == '-') {
				switch (args[i].charAt(1)) {
				case 'v':
					System.out.println("publicdns - version 1.0");
					exitEarly = true;
					break;
				case 'd':
					debug = true;
					break;
				default:
					System.err.println("Unrecognized option: " + args[i].charAt(1) );
					break;
				}
			} else {
				filename = args[i];
			}
		}

		if (!exitEarly ) {
			jr.setDebug(debug);
			if (0 == jr.doParse(filename)) {
				if (null != jr.getPublicDns()) {
					System.out.println( "public dns name: " + jr.getPublicDns());
				} else {
					System.out.println( "could not find \"" + jr.getMyHostName() + "\" in the json input");
				}
			}
		}
	}
}

