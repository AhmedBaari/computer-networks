import java.io.*;
import java.net.*;

class ServerTCP {
    public static void main(String args[]) throws Exception {
        ServerSocket ss = new ServerSocket(7777);
        System.out.println("Connecting.....");
        Socket s = ss.accept();
        System.out.println("connected");
        DataOutputStream dos = new DataOutputStream(s.getOutputStream());
        BufferedReader dis1 = new BufferedReader(new InputStreamReader(System.in));

        System.out.println("Enter the path of the File:");
        String path = dis1.readLine();
        FileReader fr = new FileReader(path);
        int ch;

        while ((ch = fr.read()) != -1) {
            dos.writeUTF((char) ch + "");
        }
        dos.writeUTF("end");

        FileWriter fw = new FileWriter("ServerTXT.txt");
        DataInputStream dis = new DataInputStream(s.getInputStream());
        String data;

        while (!(data = dis.readUTF()).equalsIgnoreCase("end")) {
            fw.write(data);
        }

        fw.close();
        dos.close();
        dis.close();
        s.close();
        ss.close();
    }
}
