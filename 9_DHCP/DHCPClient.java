// Optimized by Baari
import java.net.*;

public class DHCPClient {
    private static final int SERVER_PORT = 4900;
    private static final String SERVER_IP = "127.0.0.1"; // Change to server's IP

    public static void main(String[] args) {
        try (DatagramSocket socket = new DatagramSocket()) {
            InetAddress serverAddress = InetAddress.getByName(SERVER_IP);

            byte[] requestData = ("DHCP Request with MAC: 00:11:22:33:44:55").getBytes();
            DatagramPacket requestPacket = new DatagramPacket(requestData, requestData.length, serverAddress,
                    SERVER_PORT);
            socket.send(requestPacket);

            byte[] receiveData = new byte[1024];
            DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
            socket.receive(receivePacket);

            String response = new String(receivePacket.getData()).trim();
            System.out.println("Received DHCP Response: " + response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
