import java.net.*;
import java.rmi.*;

public class myclient {
    public static void main (String args[]) {
        try {
            String sName = "rmi://localhost/RMServer";

            MyServerIntf asif = (MyServerIntf) Naming.lookup(sName);

            int a = 100, b = 200;

            System.out.println("Addition: " + asif.add(a,b));
        } catch (Exception e) {
            System.out.println("Exception: " + e);
        }
    }
}