import java.net.*;
import java.rmi.*;

public class MyServer {
    public static void main(String[] args) {
        try {
            myserverimpl server = new myserverimpl();
            Naming.rebind("RMServer", server);

            System.out.println("\nserver is up");


        } catch (Exception e) {
            System.out.println("Exception: "+ e)
        }
    }
}