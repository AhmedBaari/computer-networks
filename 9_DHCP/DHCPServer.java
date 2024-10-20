// Optimized by Baari
import java.net.*;
import java.util.*;

public class DHCPServer {
    private static final int SERVER_PORT = 4900;
    private static List<String> availableIpAddresses = new ArrayList<>();
    private static Map<String, String> ipAllocations = new HashMap<>();

    public static void main(String[] args) {
        initializeIpAddresses();

        try (DatagramSocket socket = new DatagramSocket(SERVER_PORT)) {
            while (true) {
                byte[] receiveData = new byte[1024];
                DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
                socket.receive(receivePacket);

                InetAddress clientAddress = receivePacket.getAddress();
                String macAddress = extractMacAddress();
                String allocatedIp = allocateIpAddress(macAddress);

                byte[] responseData = ("Allocated IP: " + allocatedIp).getBytes();
                DatagramPacket responsePacket = new DatagramPacket(responseData, responseData.length,
                        clientAddress, receivePacket.getPort());
                socket.send(responsePacket);

                System.out.println("Allocated IP " + allocatedIp + " to MAC " + macAddress);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void initializeIpAddresses() {
        for (int i = 2; i <= 254; i++) {
            availableIpAddresses.add("192.168.1." + i);
        }
    }

    private static String extractMacAddress() {
        return "00:11:22:33:44:55"; // Simplified placeholder MAC
    }

    private static String allocateIpAddress(String macAddress) {
        if (availableIpAddresses.isEmpty())
            return "No available IP addresses";
        return availableIpAddresses.remove(0); // Allocate first available IP
    }
}
