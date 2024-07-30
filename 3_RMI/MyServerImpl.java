//definition of MyServerIntf
import java.rmi.*;
import java.rmi.server.*;
import java.util.Scanner;

// UnicastRemoteObject supports for point-to-point active object references (invocations, parameters, and // results) using TCP streams.

public class MyServerImpl extends UnicastRemoteObject implements MyServerIntf
{
	
	MyServerImpl() throws RemoteException
	{}

	public int add(int a, int b) throws RemoteException
	{
		return(a+b);
	}	

	public String sendChatMessage(String msg) {
		Scanner scanIn = new Scanner(System.in);
		System.out.println("Client: " + msg);
		
		System.out.print("Server: ");
       	String reply = scanIn.nextLine();
		//scanIn.close(); 
		return reply;
	}
}
