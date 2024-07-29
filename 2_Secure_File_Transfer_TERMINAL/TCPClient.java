import java.io.*;
import java.net.*;
import java.util.Scanner;

public class TCPClient {
    public static void main(String[] args) {
        if (args.length < 1) {
            System.out.println("Please enter the client directory address as the first argument.");
            return;
        }

        String dirName = args[0];
        String host = (args.length >= 2) ? args[1] : "localhost";
        int port = (args.length >= 3) ? Integer.parseInt(args[2]) : 3333;

        try (Socket clientSocket = new Socket(host, port);
                InputStream inFromServer = clientSocket.getInputStream();
                BufferedReader in = new BufferedReader(new InputStreamReader(inFromServer));
                PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true)) {

            // Receive file list from the server
            int fileCount = Integer.parseInt(in.readLine());
            System.out.println("Files available on the server:");
            for (int i = 0; i < fileCount; i++) {
                System.out.println(in.readLine());
            }

            Scanner scanner = new Scanner(System.in);
            System.out.print("Enter 'U' to upload or 'D' to download: ");
            String action = scanner.nextLine().trim().toUpperCase();

            if (action.equals("U")) { // Upload
                System.out.print("Enter the file name to upload: ");
                String filename = scanner.nextLine().trim();
                File file = new File(dirName, filename);
                if (file.exists() && file.isFile()) {
                    out.println(filename);
                    try (FileInputStream fileInput = new FileInputStream(file)) {
                        sendBytes(fileInput, clientSocket.getOutputStream());
                    }
                    System.out.println("Upload completed.");
                } else {
                    System.out.println("File not found.");
                }
            } else if (action.equals("D")) { // Download
                System.out.print("Enter the file name to download: ");
                String filename = scanner.nextLine().trim();
                out.println("*" + filename);
                String response = in.readLine();
                if ("Success".equals(response)) {
                    try (FileOutputStream fileOut = new FileOutputStream(new File(dirName, filename))) {
                        receiveBytes(inFromServer, fileOut);
                    }
                    System.out.println("Download completed.");
                } else {
                    System.out.println("File not found on the server.");
                }
            } else {
                System.out.println("Invalid action.");
            }

        } catch (IOException ex) {
            System.out.println("Exception: " + ex.getMessage());
        }
    }

    private static void sendBytes(InputStream in, OutputStream out) throws IOException {
        int c;
        while ((c = in.read()) != -1) {
            out.write((c + 3) % 256); // Caesar cipher encryption
        }
        out.flush();
    }

    private static void receiveBytes(InputStream in, OutputStream out) throws IOException {
        int c;
        while ((c = in.read()) != -1) {
            out.write((c - 3 + 256) % 256); // Caesar cipher decryption
        }
        out.flush();
    }

}