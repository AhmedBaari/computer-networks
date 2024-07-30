import java.net.*;
import java.rmi.*;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.*;

public class MyServer
{
	public static void main(String[] arg)
	{
		try 	
		{
			MyServerImpl asi = new MyServerImpl();

			Registry registry = LocateRegistry.createRegistry(1099);

			System.setProperty("java.rmi.server.hostname","192.168.72.71");
			Naming.rebind("RMServer",asi);	//remote object associate with name 
			System.out.println("\nServer Started...");
			
		}
		catch(Exception e)
		{
			System.out.println("Exception: "+e);
		}
	}
}
