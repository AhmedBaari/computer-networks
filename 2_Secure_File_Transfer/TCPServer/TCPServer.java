import java.io.*;
import java.net.*;
import java.util.*;

public class TCPServer {
	public static void main(String args[]) throws Exception {
		// if at least two argument are passed, consider the first one as directory path
		// and the second one as port number
		// If port number is not present, default it to 3333
		// If directory path is not present, show error
		if (args.length == 0) {
			System.out.println(
					"Please enter the server directory address as first argument while running from command line.");
		} else {
			int id = 1;
			System.out.println("Server started...");
			System.out.println("Waiting for connections...");

			ServerSocket welcomeSocket;

			// port number is passed by the user
			if (args.length >= 2) {
				welcomeSocket = new ServerSocket(Integer.parseInt(args[1]));
			} else {
				welcomeSocket = new ServerSocket(3333);
			}

			while (true) {
				Socket connectionSocket = welcomeSocket.accept();
				System.out.println("Client with ID " + id + " connected from "
						+ connectionSocket.getInetAddress().getHostName() + "...");
				Thread server = new ThreadedServer(connectionSocket, id, args[0]);
				id++;
				server.start();
			}
		}
	}
}

class ThreadedServer extends Thread {
	int n;
	int m;
	String name, f, ch, fileData;
	String filename;
	Socket connectionSocket;
	int counter;
	String dirName;

	public ThreadedServer(Socket s, int c, String dir) {
		connectionSocket = s;
		counter = c;

		// set dirName to the one that's entered by the user
		dirName = dir;
	}

	public void run() {
		try {
			BufferedReader in = new BufferedReader(new InputStreamReader(connectionSocket.getInputStream()));
			InputStream inFromClient = connectionSocket.getInputStream();
			PrintWriter outPw = new PrintWriter(connectionSocket.getOutputStream());
			OutputStream output = connectionSocket.getOutputStream();

			// Sending Initial Server Greeting and File List
			ObjectOutputStream oout = new ObjectOutputStream(output);
			oout.writeObject("Server says Hi!");

			File ff = new File(dirName); // directory
			ArrayList<String> names = new ArrayList<String>(Arrays.asList(ff.list())); // file list
			int len = names.size(); // number of files in the directory
			oout.writeObject(String.valueOf(names.size()));

			for (String name : names) {
				oout.writeObject(name); // iterate and send each file
			}

			/* HANDLING THE CLIENT REQUEST */
			name = in.readLine();
			ch = name.substring(0, 1);
			// * for download, anything else for upload

			// DOWNLOAD
			if (ch.equals("*")) {
				n = name.lastIndexOf("*");
				filename = name.substring(1, n);

				// Open the file
				FileInputStream file = null;
				BufferedInputStream bis = null;
				boolean fileExists = true;
				System.out.println("Request to download file " + filename + " recieved from "
						+ connectionSocket.getInetAddress().getHostName() + "...");
				filename = dirName + filename;
				// System.out.println(filename);
				try {
					file = new FileInputStream(filename);
					bis = new BufferedInputStream(file);
				} catch (FileNotFoundException excep) {
					fileExists = false;
					System.out.println("FileNotFoundException:" + excep.getMessage());
				}
				if (fileExists) {
					oout = new ObjectOutputStream(output);
					oout.writeObject("Success");
					System.out.println("Download begins");
					sendBytes(bis, output); // Send the data
					System.out.println("Completed");
					bis.close();
					file.close();
					oout.close();
					output.close();
				} else {
					oout = new ObjectOutputStream(output);
					oout.writeObject("FileNotFound");
					bis.close();
					file.close();
					oout.close();
					output.close();
				}
			} else {
				// UPLOADING FILE
				try {
					boolean not_complete = true;
					System.out.println("Request to upload file " + name + " recieved from "
							+ connectionSocket.getInetAddress().getHostName() + "...");
					File directory = new File(dirName);
					if (!directory.exists()) {
						System.out.println("Dir made");
						directory.mkdir();
					}

					int size = 9022386;
					byte[] data = new byte[size];

					File fc = new File(directory, name);
					File decrypted_fc = new File(directory, name + "_decrypted");

					FileOutputStream fileOut = new FileOutputStream(fc);
					DataOutputStream dataOut = new DataOutputStream(fileOut);

					FileOutputStream fileOut_decrypted = new FileOutputStream(decrypted_fc);

					while (not_complete) {
						// m = inFromClient.read(data, 0, data.length);
						// CHANGES
						m = inFromClient.read(); // not reading bitstream anymore

						if (m == -1) {
							not_complete = false;
							System.out.println("Completed");
						} else {
							// Changes
							System.out.print("CT: ");

							System.out.print(m);
							System.out.println("-" + (char) m);
							fileOut.write(m);
							fileOut.flush();

							m = (m - 3) % 256;
							fileOut_decrypted.write(m);
							fileOut_decrypted.flush();

							// instead of dataout

							// dataOut.write(data, 0, m);
							// dataOut.flush();
						}
					}

					fileOut.close();
					fileOut_decrypted.close();
				} catch (Exception exc) {
					System.out.println(exc.getMessage());
				}
			}
		} catch (Exception ex) {
			System.out.println(ex.getMessage());
		}
	}

	// Send file data in bytes
	private static void sendBytes(BufferedInputStream in, OutputStream out) throws Exception {
		int c;
		System.out.println("Ciphertext");
		while ((c = in.read()) != -1) {
			System.out.print("PT: ");
			System.out.print(c);
			System.out.println("-" + (char) c);
			// this line was commented.
			c = (c + 3) % 256; // for CAESAR cipher - encryption
			// COMMENTED?!!?
			out.write(c);
			out.flush();
			System.out.print("CT: ");
			System.out.print(c);
			System.out.println("-" + (char) c);

		}
	}
}
