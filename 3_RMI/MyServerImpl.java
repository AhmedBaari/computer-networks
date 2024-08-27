//definition of MyServerIntf
import java.rmi.*;
import java.rmi.server.*;

// UnicastRemoteObject supports for point-to-point active object references (invocations, parameters, and // results) using TCP streams.

public class MyServerImpl extends UnicastRemoteObject implements MyServerIntf
{
	MyServerImpl() throws RemoteException
	{}

	public int add(int a, int b) throws RemoteException
	{
		return(a+b);
	}	
}
