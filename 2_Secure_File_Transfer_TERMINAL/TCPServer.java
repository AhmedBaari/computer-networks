import java.io.*;
import java.net.*;
import java.util.*;

public class TCPServer {
    public static void main(String args[]) throws Exception {
        if (args.length == 0) {
            System.out.println("Please enter the server directory address as the first argument.");
            return;
        }

        int port = (args.length >= 2) ? Integer.parseInt(args[1]) : 3333;
        String dirName = args[0];

        System.out.println("Server started...");
        System.out.println("Waiting for connections...");

        try (ServerSocket welcomeSocket = new ServerSocket(port)) {
            int id = 1;
            while (true) {
                Socket connectionSocket = welcomeSocket.accept();
                System.out.println("Client with ID " + id + " connected from " +
                        connectionSocket.getInetAddress().getHostName() + "...");
                Thread server = new ThreadedServer(connectionSocket, id, dirName);
                id++;
                server.start();
            }
        }
    }
}

class ThreadedServer extends Thread {
    private Socket connectionSocket;
    private String dirName;

    public ThreadedServer(Socket s, int c, String dir) {
        this.connectionSocket = s;
        this.dirName = dir;
    }

    public void run() {
        try (BufferedReader in = new BufferedReader(new InputStreamReader(connectionSocket.getInputStream()));
                OutputStream output = connectionSocket.getOutputStream();
                PrintWriter out = new PrintWriter(output, true)) {

            File directory = new File(dirName);
            if (!directory.exists() || !directory.isDirectory()) {
                System.out.println("Invalid directory specified.");
                return;
            }

            // Send file list to the client
            String[] fileList = directory.list();
            out.println(fileList.length);
            for (String file : fileList) {
                out.println(file);
            }

            String request = in.readLine();
            if (request == null)
                return;

            if (request.startsWith("*")) { // Download
                String filename = request.substring(1);
                File file = new File(dirName, filename);
                if (file.exists() && file.isFile()) {
                    out.println("Success");
                    try (FileInputStream fileInput = new FileInputStream(file)) {
                        sendBytes(fileInput, output);
                    }
                } else {
                    out.println("FileNotFound");
                }
            } else { // Upload
                String filename = request;
                File file = new File(dirName, filename);
                try (FileOutputStream fileOut = new FileOutputStream(file)) {
                    receiveBytes(in, fileOut);
                }
                out.println("UploadSuccess");
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

    private static void receiveBytes(BufferedReader in, OutputStream out) throws IOException {
        int c;
        while ((c = in.read()) != -1) {
            out.write((c - 3 + 256) % 256); // Caesar cipher decryption
        }
        out.flush();
    }
}