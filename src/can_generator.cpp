#include <linux/can.h>  // CAN data structures (e.g., can_frame)
#include <sys/socket.h> // Socket functions (socket, bind, etc.)
#include <unistd.h>     // System calls (close)
#include <cstdlib>      // For rand() and srand()
#include <ctime>        // For time()
#include <cstring>      // For memset
#include <thread>       // For sleep_for
#include <chrono>       // For milliseconds
#include <cstdio>       // For printf
#include <net/if.h>     // For struct ifreq
#include <sys/ioctl.h>  // For ioctl()

int main()
{
    // Create socket
    //  Creates a raw CAN socket capable of sending/receiving raw CAN frames.
    //  - `PF_CAN`: Protocol family for CAN.
    //  - `SOCK_RAW`: Raw socket (no protocol-specific handling).
    //  - `CAN_RAW`: Use the raw CAN protocol (no filtering).
    int sock = socket(PF_CAN, SOCK_RAW, CAN_RAW);

    // Interface Configuration
    //  `ifreq` structure holds network interface details.
    struct ifreq ifr;

    // TODO: How to pass this as a CLI argument
    strcpy(ifr.ifr_name, "vcan0");   // Use virtual CAN interface "vcan0"
    ioctl(sock, SIOCGIFINDEX, &ifr); // Get interface index for "vcan0"

    // Socket Binding
    //  Binds the socket to the `vcan0` interface,
    //  ensuring it listens only to traffic on that interface.
    struct sockaddr_can addr;
    addr.can_family = AF_CAN;           // CAN address family
    addr.can_ifindex = ifr.ifr_ifindex; // Interface index from ioctl()
    bind(sock, (struct sockaddr *)&addr, sizeof(addr));

    // Write frames
    srand(time(nullptr)); // Seed random number generator
    struct can_frame frame;
    while (true)
    {
        // Generate random CAN ID (standard 11-bit)
        frame.can_id = rand() % 0x800; // 0x000 to 0x7FF

        // Generate random DLC (data length code)
        frame.can_dlc = rand() % 9; // 0 to 8

        // Fill data with random bytes
        for (int i = 0; i < frame.can_dlc; ++i)
        {
            frame.data[i] = rand() % 256;
        }

        // Send the frame to the CAN socket
        int nbytes = write(sock, &frame, sizeof(frame));
        if (nbytes != sizeof(frame))
        {
            perror("write");
        }

        // Optionally print what was sent
        printf("Sent ID: %03X | Data: ", frame.can_id);
        for (int i = 0; i < frame.can_dlc; ++i)
            printf("%02X ", frame.data[i]);
        printf("\n");

        // Wait a bit before sending the next frame
        std::this_thread::sleep_for(std::chrono::milliseconds(2000));
    }
    close(sock);
    return 0;
}
