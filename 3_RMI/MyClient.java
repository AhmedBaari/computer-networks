import java.net.*;
import java.rmi.*;

public class MyClient
{
	public static void main(String[] arg)
	{
		try 	
		{
		String sName = "rmi://"+arg[0]+"/RMServer";
		
		MyServerIntf asif = (MyServerIntf)Naming.lookup(sName);  // requesting remote objects on 							            // the server
			
		int d1=2000,d2=500;

		System.out.println("Addition: "+asif.add(d1,d2));

		}
		catch(Exception e)
		{
			System.out.println("Exception: "+e);
		}
	}
}
