import java.net.*;
import java.io.*;

public class Client {
    public static void main(String args[]) throws Exception {

        Socket s = new Socket("localhost", 7777);

        DataInputStream dis = new DataInputStream(System.in);
        DataOutputStream dos = new DataOutputStream(s.getOutputStream());
        
        String l = " ";
        DataInputStream d = new DataInputStream(s.getInputStream());
        String re = " ";
        
        while (!(l.equalsIgnoreCase("over"))) {
            System.out.println("Message:");
            l = dis.readLine();
            dos.writeUTF(l);
            re = d.readUTF();
            System.out.println("Server:" + re);
        }

        s.close();
        dos.close();
        d.close();
    }
}