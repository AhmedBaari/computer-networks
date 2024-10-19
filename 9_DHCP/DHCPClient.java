import java.net.*;
import java.util.Arrays;

public class DHCPClient {
    private static final int SERVER_PORT = 4900;
    private static final String SERVER_IP = "127.0.0.1"; // Change to your server's IP

    public static void main(String[] args) {
        try {
            DatagramSocket socket = new DatagramSocket();
            InetAddress serverAddress = InetAddress.getByName(SERVER_IP);

            // Create and send DHCP request
            byte[] requestData = createDHCPRequest("00:11:22:33:44:55"); // Replace with your MAC address
            DatagramPacket requestPacket = new DatagramPacket(requestData, requestData.length, serverAddress, SERVER_PORT);
            socket.send(requestPacket);

            // Receive DHCP response
            byte[] receiveData = new byte[1024];
            DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
            socket.receive(receivePacket);

            // Process and print DHCP response
            String response = new String(receivePacket.getData()).trim();
            System.out.println("Received DHCP Response: " + response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static byte[] createDHCPRequest(String macAddress) {
        // Simulate creating a DHCP request packet with the MAC address
        // In a real implementation, you'd construct a proper DHCP packet
        String request = "DHCP Request with MAC: " + macAddress;
        return request.getBytes();
    }
}
