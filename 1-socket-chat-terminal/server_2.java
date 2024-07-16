import java.net.*;
import java.io.*;

public class server_2 {
    private Socket client = null;
    private ServerSocket server = null;

    // Incoming from client
    private DataInputStream client_in = null;

    // Outgoing from server
    private DataInputStream terminal_line = null;
    private DataOutputStream server_out = null;

    public server_2 (int port) {
        try {
            // Starting the server socket
            server = new ServerSocket();
            System.out.println("Server has started");
            System.out.println("Waiting for client...");

            // Accept the client
            client = server.accept();
            System.out.println("Client Accepted");

            // Initialize the Client Input Datastream
            client_in = new DataInputStream(new BufferedInputStream(client.getInputStream()));
            String incoming_line = ""; // Text





        }
        catch(IOException i) {

        }
    }
}
