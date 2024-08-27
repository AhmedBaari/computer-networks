import java.io.*;
import java.net.*;

class ClientTCP {
    public static void main(String args[]) throws Exception {
        Socket s = new Socket("localhost", 7777);
        FileWriter fw = new FileWriter("ClientTXT.txt");
        DataInputStream dis = new DataInputStream(s.getInputStream());
        String data;

        while (!(data = dis.readUTF()).equalsIgnoreCase("end")) {
            fw.write(data);
        }
        fw.close();

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

        fr.close();
        dos.close();
        dis.close();
        s.close();
    }
}
