import java.net.*;

public class DHCPClient {
    public static void main(String[] args) {
        try (DatagramSocket socket = new DatagramSocket()) {
            // Request to server
            InetAddress serverAddress = InetAddress.getByName("127.0.0.1"); //⭐
            byte[] requestData = ("DHCP Request with MAC: 00:11:22:33:44:55").getBytes();
            DatagramPacket requestPacket = new DatagramPacket(requestData, requestData.length, serverAddress, 4900);
            socket.send(requestPacket);

            // Receive
            byte[] receiveData = new byte[1024];
            DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
            socket.receive(receivePacket);

            // Display
            String response = new String(receivePacket.getData()).trim();
            System.out.println("Received DHCP Response: " + response);

            socket.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}