import java.rmi.*;

public interface myserverintf extends Remote {
    int add(int a, int b) throws RemoteException;
}