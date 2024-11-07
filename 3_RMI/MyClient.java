import java.net.*;
import java.rmi.*;

public class MyClient
{
	public static void main(String[] arg)
	{
		try 	
		{
		String sName = "rmi://localhost/RMServer";
		
		// requesting remote objects on // the server
		MyServerIntf asif = (MyServerIntf)Naming.lookup(sName);  
			
		int d1=2000,d2=500;

		System.out.println("Addition: "+asif.add(d1,d2));

		}
		catch(Exception e)
		{
			System.out.println("Exception: "+e);
		}
	}
}
