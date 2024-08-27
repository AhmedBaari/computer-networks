import java.rmi.*;
import java.rmi.server.*;

public class myserverimpl extends UnicastRemoteObject implements myserverintf {
    myserverimpl() throws RemoteException {}

    public int add(int a, int b) throws RemoteException {
        return (a+b);
    }
}