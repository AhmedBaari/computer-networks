
// A Java program for a Server
import java.net.*;
import java.io.*;

public class Server {
	// initialize socket and input stream
	private Socket socket = null;
	private ServerSocket server = null;
	private DataInputStream in = null;

	// BACK INITIALIZATIONS
	private DataInputStream BACK_input = null;
	private DataOutputStream BACK_out = null;

	// constructor with port
	public Server(int port) {
		// starts server and waits for a connection
		try {
			server = new ServerSocket(port);
			System.out.println("Server started");

			System.out.println("Waiting for a client ...");

			socket = server.accept();
			System.out.println("Client accepted");

			// takes input from the client socket
			in = new DataInputStream(
					new BufferedInputStream(socket.getInputStream()));

			String line = "";

			// BACK DECLARATIONS
			BACK_input = new DataInputStream(System.in);
			BACK_out = new DataOutputStream(
					socket.getOutputStream());
			String BACK_line = "";

			// reads message from client until "Over" is sent
			while (!line.equals("over") || !BACK_line.equals("over")) {
				try {
					line = in.readUTF();
					if (line.equals("over"))
					break;
					System.out.print("Client: ");
					System.out.println(line);

					// OUT
					System.out.print("Server: ");
					BACK_line = BACK_input.readLine();
		
					BACK_out.writeUTF(BACK_line);
					if (BACK_line.equals("over"))
					break;			

				} catch (IOException i) {
					System.out.println(i);
				}
			}
			System.out.println("Closing connection");

			// close connection
			socket.close();
			in.close();
		} catch (IOException i) {
			System.out.println(i);
		}
	}

	public static void main(String args[]) {
		Server server = new Server(5000);
	}
}
