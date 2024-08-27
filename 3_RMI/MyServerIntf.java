//function prototype
import java.rmi.*;

public interface MyServerIntf extends Remote		//remote interface
{	
	int add(int a, int b) throws RemoteException;
}
