
//function prototype
import java.rmi.*;

public interface MyServerIntf extends Remote // remote interface
{
	int i = 0; // ????

	int add(int a, int b) throws RemoteException;

	String sendChatMessage(String msg) throws RemoteException;
}
