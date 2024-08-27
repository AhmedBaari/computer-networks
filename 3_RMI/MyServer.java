import java.net.*;
import java.rmi.*;

public class MyServer
{
	public static void main(String[] arg)
	{
		try 	
		{
			MyServerImpl myserver = new MyServerImpl();
			Naming.rebind("RMServer",myserver);	//remote object associate with name 
			System.out.println("\nServer Started...");
		}
		catch(Exception e)
		{
			System.out.println("Exception: "+e);
		}
	}
}
