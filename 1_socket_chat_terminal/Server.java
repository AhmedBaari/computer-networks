import java.net.*;
import java.io.*;

public class Server {
    public static void main(String args[]) throws Exception {

        ServerSocket ss = new ServerSocket(7777);
        System.out.println("Server Started");
        System.out.println("Waiting for Connection.....");
        
        Socket s = ss.accept();
        System.out.println("Connecton established with Client...");

        DataInputStream dat = new DataInputStream(System.in);
        DataInputStream dis = new DataInputStream(s.getInputStream());
        DataOutputStream dos = new DataOutputStream(s.getOutputStream());

        String clientMessage = " ";
        String my_reply = " ";

        while (!(clientMessage.equalsIgnoreCase("over"))) {
            clientMessage = dis.readUTF();
            System.out.println("Client:" + clientMessage);
            System.out.println("Message:");
            my_reply = dat.readLine();
            dos.writeUTF(my_reply);

        }
    }
}
