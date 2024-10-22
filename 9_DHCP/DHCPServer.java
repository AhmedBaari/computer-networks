import java.net.*;
import java.util.*;

public class DHCPServer {
    private static List<String> availableIpAddresses = new ArrayList<>();

    public static void main(String[] args) {

        for (int i = 2; i <= 254; i++)
            availableIpAddresses.add("192.168.1." + i);

        try (DatagramSocket socket = new DatagramSocket(4900)) {
            while (true) {
                // Receive
                byte[] receiveData = new byte[1024];
                DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
                socket.receive(receivePacket);

                // Extract
                InetAddress clientAddress = receivePacket.getAddress();
                String allocatedIp = availableIpAddresses.remove(0);
                byte[] responseData = ("Allocated IP: " + allocatedIp).getBytes();

                // Response 
                DatagramPacket responsePacket = new DatagramPacket(responseData, responseData.length, clientAddress,
                        receivePacket.getPort());
                socket.send(responsePacket);

                // Display
                System.out.println("Allocated IP " + allocatedIp + " to MAC " + "00:11:22:33:44:55");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}