
// A Java program for a Client
import java.io.*;
import java.net.*;

public class Client {
	// initialize socket and input output streams
	private Socket socket = null;
	private DataInputStream input = null;
	private DataOutputStream out = null;

	// BACK INITIALIZATIONS
	private DataInputStream BACK_in = null;

	// constructor to put ip address and port
	public Client(String address, int port) {
		// establish a connection
		try {
			socket = new Socket(address, port);
			System.out.println("Connected");

			// takes input from terminal
			input = new DataInputStream(System.in);

			// sends output to the socket
			out = new DataOutputStream(
					socket.getOutputStream());

			// BACK DECLARATIONS
			BACK_in = new DataInputStream(
					new BufferedInputStream(socket.getInputStream()));

		} catch (UnknownHostException u) {
			System.out.println(u);
			return;
		} catch (IOException i) {
			System.out.println(i);
			return;
		}

		// string to read message from input
		String line = "";
		String BACK_line = "";
		// keep reading until "Over" is input
		while (!line.equals("over") || !BACK_line.equals("over")) {
			try {
				System.out.print("Client: ");
				line = input.readLine();
				
				out.writeUTF(line);
				if (line.equals("over"))
					break;

				// BACK IN
				BACK_line = BACK_in.readUTF();
				if (BACK_line.equals("over")) {
				System.out.println("Closing Connection");
				break;				
				}	
				System.out.print("Server: ");
				System.out.println(BACK_line);
			} catch (IOException i) {
				System.out.println(i);
			}
		}

		// close the connection
		try {
			input.close();
			out.close();
			socket.close();
		} catch (IOException i) {
			System.out.println(i);
		}
	}

	public static void main(String args[]) {
		Client client = new Client("127.0.0.1", 5000);
	}
}
