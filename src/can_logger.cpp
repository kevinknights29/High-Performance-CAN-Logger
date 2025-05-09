#include <linux/can.h>  // CAN data structures (e.g., can_frame)
#include <sys/socket.h> // Socket functions (socket, bind, etc.)
#include <unistd.h>     // System calls (close)
#include <cstring>      // For strcpy
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

    // Read frames
    struct can_frame frame;
    while (true)
    {
        int nbytes = read(sock, &frame, sizeof(frame));
        if (nbytes > 0)
        {
            // Log frame data (e.g., to file)
            printf("ID: %03X | Data: ", frame.can_id);
            for (int i = 0; i < frame.can_dlc; i++)
                printf("%02X ", frame.data[i]);
            printf("\n");
        }
    }
    close(sock);
    return 0;
}