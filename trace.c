// TODO: build TCP psuedo header then pass that + TCP PDU (Header + Payload) into checksum

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <pcap/pcap.h>
#include <arpa/inet.h>
#include <string.h>

#include "checksum.h"

#define SIX_BYTES 6
#define FOUR_BYTES 4
#define TWO_BYTES 2
#define TCPMAXPDU 1600
#define ETHHeaderLen 14

struct pkt_header
{
    unsigned int pktNum;
    unsigned int frameLen;

    struct eth_header* eth_header;

}__attribute__((packed));

struct eth_header
{
    uint8_t destMAC[SIX_BYTES];
    uint8_t srcMAC[SIX_BYTES];
    uint16_t type;

    struct arp_header* arp_header;
    struct ip_header* ip_header;

}__attribute__((packed));   //tech to byte align structs

struct arp_header
{
    uint16_t opcode;
    uint8_t senderMAC[SIX_BYTES];
    uint8_t senderIP[FOUR_BYTES];
    uint8_t targetMAC[SIX_BYTES];
    uint8_t targetIP[FOUR_BYTES];

}__attribute__((packed));

struct ip_header
{
    uint8_t headerLen;
    uint8_t tos;    //type of service => 3rd Byte (2 Bytes Wide)
    uint8_t ttl;    //time to live
    uint16_t ipPDULen;
    uint8_t protocol;
    uint8_t checksum[TWO_BYTES]; 
    char* validChecksum;
    uint8_t senderIP[FOUR_BYTES];
    uint8_t destIP[FOUR_BYTES];

    struct tcp_pseudo_header* tcp_pseudo_header;
    struct tcp_header* tcp_header;
    struct icmp_header* icmp_header;
    struct udp_header* udp_header;

}__attribute__((packed));

struct tcp_pseudo_header
{
    uint8_t senderIP[FOUR_BYTES];
    uint8_t destIP[FOUR_BYTES];
    uint8_t reserved;
    uint8_t protocol;
    uint16_t tcpPDULen;

}__attribute__((packed));

struct tcp_header
{
    uint16_t PDULen;
    uint16_t srcPort;
    uint16_t destPort;
    uint32_t seqNum;
    uint32_t ackNum;
    uint8_t flags;
    uint16_t windowSize;
    uint8_t checksum[TWO_BYTES];
    char* validChecksum;

}__attribute__((packed));

struct icmp_header
{
    uint8_t type;

}__attribute__((packed));

struct udp_header
{
    uint16_t srcPort;
    uint16_t destPort;

}__attribute__((packed));

// calculates the header length in bytes
int calcHeaderBytes(uint8_t headerLen)
{
    int bytesperword = 4;
    return headerLen * bytesperword;
}

void printChecksum(uint8_t* checksum, int isIP)
{
    int i;
    printf("(0x");

    switch(isIP)
    {
        case 1:
            i = TWO_BYTES-1;
            if(checksum[i] != 0)
            {
                printf("%x", checksum[i]);
            }
            i--;
            printf("%02x) \n", checksum[i]);
            break;

        case 0:
            i = 0;
            if(checksum[i] != 0)
            {
                printf("%x", checksum[i]);
            }
            i++;
            printf("%02x) \n", checksum[i]);
            break;

        default:
            perror("#Error: printChecksum Failed!!!!");
            printf("isIP: %s \n", isIP ? "true":"false");
            exit(1);
            break;

    }
}

// char* ipChecksum(const u_char* pcap_data, struct ip_header* ip_header)
// char* isValidChecksum(const u_char* pcap_data, uint16_t headerLenBytes, int start)
char* isValidChecksum(unsigned short* buffer, uint16_t headerLenBytes)
{
    char* result = "null";
    // printf("Checksum: Header Len: %u (bytes) \n", headerLenBytes);

    unsigned short checksum_results = in_cksum(buffer, headerLenBytes);
    // printf("checksum results = 0x%04x \n", checksum_results);

    if(!checksum_results)
    {
        result = "Correct";
    }
    else
    {
        result = "Incorrect";
    }

    return result;
}

char* parseEthType(struct eth_header* eth_header)
{
    switch(eth_header->type)
    {
        case 0x0800:
            return "IP";
            break;

        case 0x86DD:
            return "IP";
            break;

        case 0x0806:
            return "ARP";
            break;

        default:
            perror("#Error: parseEthType Failed!!!!");
            printf("Eth Type: %04x \n", eth_header->type);
            exit(1);
            break;
    }
}

char* parseArpOpcode(struct arp_header* arp_header)
{
    switch(arp_header->opcode)
    {
        case 0x0001:
            return "Request";
            break;

        case 0x0002:
            return "Reply";
            break;

        default:
            perror("#Error: parseArpType Failed!!!!");
            printf("Arp Opcode: %04x \n", arp_header->opcode);
            exit(1);
            break;
    }
}

// char* parseIPProtocol(struct ip_header* ip_header)
char* parseIPProtocol(uint8_t protocol)
{
    // switch(ip_header->protocol)
    switch(protocol)
    {
        case 0x01:
            return "ICMP";
            break;

        case 0x06:
            return "TCP";
            break;

        case 0x11:
            return "UDP";
            break; 

        default:
            return "Unknown";
            break;
    }

    perror("#Error: parseIPProtocol Failed!!!!");
    printf("IP Protocol: %02x \n", protocol);
    exit(1);
}

char* parseICMPType(struct icmp_header* icmp_header)
{
    switch(icmp_header->type)
    {
        case 0x08:
            return "Request";
            break;

        case 0x00:
            return "Reply";
            break;

        default:
            return "";
            break;
    }

    perror("#Error: parseICMPType Failed!!!!");
    printf("ICMP Type: %02x \n", icmp_header->type);
    exit(1);
}

char* parseTcpFlags(struct tcp_header* tcp_header, uint8_t mask)
{
    uint8_t flags = 0;
    memcpy(&flags, &(tcp_header->flags), sizeof(flags));

    if(&(tcp_header->flags) == NULL)
    {
        perror("#Error: parseTcpFlags flags Empty!!!!");
        printf("Flags: %02x \n", flags);
        exit(1); 
    }

    switch(flags & mask)
    {
        case 0x10: case 0x02: case 0x04: case 0x01: 
            return "Yes";
            break;

        default:
            return "No";
            break;
    }
}

void printPkt(struct pcap_pkthdr* pcap_header, const u_char* pcap_data)
{
    int i;

    if(pcap_header == NULL)
    {
        perror("#ERROR: pcap_header NULL!!!!");
        exit(1);
    }
    if(pcap_data == NULL)
    {
        perror("#ERROR: pcap_data NULL!!!!");
        exit(1);
    }

    printf("pkt_caplen = %d \t\t pkt_len = %d \n", pcap_header->caplen, pcap_header->len);

    for(i = 0; i < pcap_header->len; i++)
    {
        if(i % 4 == 0  && i != 0)
        {
            printf("\n");

            if(i % 8 == 0)
                printf("\n");
        }

        printf("[%02d] pcap_data: 0x%0X \t\t", i, (uint8_t)pcap_data[i]);
    }
}

void printBuffer(uint8_t buffer[], int length)
{
    int i;

    if(buffer == NULL)
    {
        perror("#ERROR: buffer empty!!!!");
        exit(1);
    }

    for(i = 0; i < length; i++)
    {
        if(i % 4 == 0  && i != 0)
        {
            printf("\n");

            if(i % 8 == 0)
                printf("\n");
        }

        printf("[%02d] buffer: 0x%0X \t\t", i, buffer[i]);
    }
}

void printPkt_header(struct pkt_header* pkt_header)
{
    if(pkt_header == NULL)
    {
        perror("#ERROR: NULL pkt_header from printPkt_header!!!! \n");
        exit(1);
    }
    
    printf("\nPacket number: %-2u\tFrame Len: %-2u \n\n", pkt_header->pktNum, pkt_header->frameLen);
}

void printMACAddr(uint8_t addr[])
{
    int i = 0;
    for(i = 0; i < SIX_BYTES-1; i++)
    {
        printf("%x:", addr[i]);
    }
    printf("%x \n", addr[i]);
}

void printIPAddr(uint8_t addr[])
{
    int i = 0;
    for(i = 0; i < FOUR_BYTES-1; i++)
    {
        printf("%u.", addr[i]);
    }
    printf("%u \n", addr[i]);
}

void printEth_header(struct eth_header* eth_header)
{
    if(eth_header == NULL)
    {
        perror("#ERROR: NULL eth_header from printEth_header!!!! \n");
        exit(1);
    }

    printf("\tEthernet Header \n");

    printf("\t\tDest MAC: ");
    printMACAddr(eth_header->destMAC);

    printf("\t\tSource MAC: ");
    printMACAddr(eth_header->srcMAC);

    // printf("\t\tType: 0x%02x%02x \n", eth_header->type[0], eth_header->type[1]/*function to get string from type bytes*/);
    printf("\t\tType: %s \n\n", parseEthType(eth_header));
}

void printArp_header(struct arp_header* arp_header)
{
    if(arp_header == NULL)
    {
        perror("#ERROR: NULL arp_header from printArp_header!!!! \n");
        exit(1);
    }

    printf("\tARP header \n");
    
    printf("\t\tOpcode: %s \n", parseArpOpcode(arp_header));
    
    printf("\t\tSender MAC: ");
    printMACAddr(arp_header->senderMAC);

    printf("\t\tSender IP: ");
    printIPAddr(arp_header->senderIP);
    
    printf("\t\tTarget MAC: ");
    printMACAddr(arp_header->targetMAC);

    printf("\t\tTarget IP: ");
    printIPAddr(arp_header->targetIP);
}

void printIp_header(struct ip_header* ip_header)
{
    if(ip_header == NULL)
    {
        perror("#ERROR: NULL ip_header from printIp_header!!!! \n");
        exit(1);
    }

    printf("\tIP Header \n");
        
    printf("\t\tHeader Len: %d (bytes) \n", calcHeaderBytes(ip_header->headerLen));

    printf("\t\tTOS: 0x%x \n", ip_header->tos);

    printf("\t\tTTL: %u \n", ip_header->ttl);

    printf("\t\tIP PDU Len: %u (bytes)\n", ip_header->ipPDULen);

    printf("\t\tProtocol: %s \n", parseIPProtocol(ip_header->protocol));

    printf("\t\tChecksum: %s ", ip_header->validChecksum);
    printChecksum(ip_header->checksum, 1);

    printf("\t\tSender IP: ");
    printIPAddr(ip_header->senderIP);

    printf("\t\tDest IP: ");
    printIPAddr(ip_header->destIP);
}

void printIcmp_header(struct icmp_header* icmp_header)
{
    if(icmp_header == NULL)
    {
        perror("#ERROR: NULL icmp_header from printIcmp_header!!!! \n");
        exit(1);
    }

    printf("\n\tICMP Header \n");
    
    if(!strcmp(parseICMPType(icmp_header), ""))
        printf("\t\tType: %u \n", icmp_header->type);
    else
        printf("\t\tType: %s \n", parseICMPType(icmp_header));
}

void printTCPPseudo_header(struct tcp_pseudo_header* tcp_pseudo_header)
{
    printf("\tTCP Pseudo Header \n");
    printf("\t\tPseudo Header Len: %lu (bytes) \n", sizeof(*tcp_pseudo_header));
    printf("\t\tSender IP: ");
    printIPAddr(tcp_pseudo_header->senderIP);

    printf("\t\tDest IP: ");
    printIPAddr(tcp_pseudo_header->destIP);

    printf("\t\tReserved: 0x%x \n", tcp_pseudo_header->reserved);
    printf("\t\tProtocol: %s \n", parseIPProtocol(tcp_pseudo_header->protocol));
    printf("\t\tTCP PDU Len: %u (bytes) \n", tcp_pseudo_header->tcpPDULen);
}

void printACKNum(struct tcp_header* tcp_header)
{
    if(tcp_header->flags & 0x10)    // ACK Flag
    {
        printf("\t\tACK Number: %u \n", tcp_header->ackNum);
    }
    else
    {
        printf("\t\tACK Number: <not valid> \n");
    }
}

void printTcp_header(struct tcp_header* tcp_header)
{
    if(tcp_header == NULL)
    {
        perror("#ERROR: NULL tcp_header from printTcp_header!!!! \n");
        exit(1);
    }

    printf("\n\tTCP Header \n");

    if(tcp_header->srcPort == 80)
        printf("\t\tSource Port: %s \n", "HTTP");
    else
        printf("\t\tSource Port: : %u \n", tcp_header->srcPort);

    if(tcp_header->destPort == 80)
        printf("\t\tDest Port: %s \n", "HTTP");
    else
        printf("\t\tDest Port: : %u \n", tcp_header->destPort);

    printf("\t\tSequence Number: %u \n", tcp_header->seqNum);

    printACKNum(tcp_header);

    printf("\t\tACK Flag: %s \n", parseTcpFlags(tcp_header, 0x10));
    printf("\t\tSYN Flag: %s \n", parseTcpFlags(tcp_header, 0x02));
    printf("\t\tRST Flag: %s \n", parseTcpFlags(tcp_header, 0x04));
    printf("\t\tFIN Flag: %s \n", parseTcpFlags(tcp_header, 0x01));

    printf("\t\tWindow Size: %d \n", tcp_header->windowSize);

    printf("\t\tChecksum: %s ", tcp_header->validChecksum);
    printChecksum(tcp_header->checksum, 0);
}

void printUDP_header(struct udp_header* udp_header)
{
    if(udp_header == NULL)
    {
        perror("#ERROR: NULL udp_header from printUDP_header!!!! \n");
        exit(1);
    }

    printf("\n\tUDP Header \n");

    if(udp_header->srcPort == 80)
        printf("\t\tSource Port: %s \n", "HTTP");
    else
        printf("\t\tSource Port: : %u \n", udp_header->srcPort);

    if(udp_header->destPort == 80)
        printf("\t\tDest Port: %s \n", "HTTP");
    else
        printf("\t\tDest Port: : %u \n", udp_header->destPort);
}

//ARP: Type = ARP (0x0806)  || IP: Type = IPv4 (0x0800)
//  Next => if(Type == IPv4){ check if ICMP || TCP  || UDP based on: Protocol value }
                                // ICMP: Protocol = ICMP (1 = 0x01)
                                // TCP:  Protocol = TCP  (6 = 0x06)       also HTTP
                                // UDP:  Protocol = UDP  (17 = 0x11
void printEthHeaders(struct pkt_header* pkt_header)
{
    printPkt_header(pkt_header);
    printEth_header(pkt_header->eth_header);

    switch(pkt_header->eth_header->type)
    {
        case 0x0806:    //ARP
            printArp_header(pkt_header->eth_header->arp_header);
            printf("\n");
            break;

        case 0x0800:    //IPv4
            printIp_header(pkt_header->eth_header->ip_header);

            switch(pkt_header->eth_header->ip_header->protocol)
            {
                case 0x01:      // ICMP
                    printIcmp_header(pkt_header->eth_header->ip_header->icmp_header);
                    break;

                case 0x06:      // TCP
                    printTcp_header(pkt_header->eth_header->ip_header->tcp_header);
                    break;

                case 0x11:      // UDP
                    printUDP_header(pkt_header->eth_header->ip_header->udp_header);
                    break;

                default:
                    break;
            }
            break;

        default:
            perror("#Error: ethTypeOutput Failed!!!!");
            printf("Eth Header Type: %04x \n", pkt_header->eth_header->type);
            exit(1);
            break;
    } 
}

void initPktHeader(struct pkt_header** pkt_header, int pktNum, struct pcap_pkthdr* pcap_header)
{
   *pkt_header = malloc(sizeof(struct pkt_header));

    (*pkt_header)->eth_header = malloc(sizeof(struct eth_header));

    (*pkt_header)->eth_header->arp_header = malloc(sizeof(struct arp_header));
    (*pkt_header)->eth_header->ip_header = malloc(sizeof(struct ip_header));

    (*pkt_header)->eth_header->ip_header->tcp_pseudo_header = malloc(sizeof(struct tcp_pseudo_header));
    (*pkt_header)->eth_header->ip_header->tcp_header = malloc(sizeof(struct tcp_header));
    (*pkt_header)->eth_header->ip_header->icmp_header = malloc(sizeof(struct icmp_header));
    (*pkt_header)->eth_header->ip_header->udp_header = malloc(sizeof(struct udp_header));

    (*pkt_header)->pktNum = pktNum;
    (*pkt_header)->frameLen = pcap_header->caplen;
}

void initEthHeader(struct eth_header** eth_header, const u_char* pcap_data)
{    
    int start = 0;
    memcpy(&((*eth_header)->destMAC), &pcap_data[start], sizeof((*eth_header)->destMAC));

    start = 6;
    memcpy(&((*eth_header)->srcMAC), &pcap_data[start], sizeof((*eth_header)->srcMAC));
 
    start = 12;
    memcpy(&((*eth_header)->type), &pcap_data[start], sizeof((*eth_header)->type));
}

void initArpHeader(struct arp_header** arp_header, const u_char* pcap_data)
{
    int start = 20;     //20th Byte = Start of Opcode Bytes
    memcpy(&((*arp_header)->opcode), &pcap_data[start], sizeof((*arp_header)->opcode));
    (*arp_header)->opcode = ntohs((*arp_header)->opcode);

    start += TWO_BYTES;
    memcpy(&((*arp_header)->senderMAC), &pcap_data[start], sizeof((*arp_header)->senderMAC));

    start += SIX_BYTES;
    memcpy(&((*arp_header)->senderIP), &pcap_data[start], sizeof((*arp_header)->senderIP));

    start += FOUR_BYTES;
    memcpy(&((*arp_header)->targetMAC), &pcap_data[start], sizeof((*arp_header)->targetMAC));

    start += SIX_BYTES;
    memcpy(&((*arp_header)->targetIP), &pcap_data[start], sizeof((*arp_header)->targetIP));
}

void initIpHeader(struct ip_header** ip_header, const u_char* pcap_data)
{
    int start = ETHHeaderLen;     //14th Byte = Start of IPv4 Bytes
    int headerStart = start;
    // printf("pcap_data[%02d] = 0x%02X \n", start, (uint8_t)pcap_data[start]);
    (*ip_header)->headerLen = (uint8_t)(pcap_data[start++] & 0x0F);
    // printf("headerLen = 0x%02X \n", (*ip_header)->headerLen);

    // printf("pcap_data[%02d] = 0x%02X \n", start, (uint8_t)pcap_data[start]);
    (*ip_header)->tos = (uint8_t)pcap_data[start++];
    // printf("tos = 0x%02X \n", (*ip_header)->tos);
    
    memcpy(&((*ip_header)->ipPDULen), &pcap_data[start], sizeof((*ip_header)->ipPDULen));
    (*ip_header)->ipPDULen = ntohs((*ip_header)->ipPDULen);
    // printf("ipPDULen = 0x%04X (%d)\n", (*ip_header)->ipPDULen, (*ip_header)->ipPDULen);

    //skip Ident(2B), Flags(2B)
    start += FOUR_BYTES + TWO_BYTES;
    // printf("pcap_data[%02d] = 0x%02X \n", start, (uint8_t)pcap_data[start]);
    (*ip_header)->ttl = (uint8_t)pcap_data[start++];
    // printf("ttl = 0x%02X \n", (*ip_header)->ttl); 

    // printf("pcap_data[%02d] = 0x%02X \n", start, (uint8_t)pcap_data[start]);
    (*ip_header)->protocol = (uint8_t)pcap_data[start++];
    // printf("protocol = 0x%02X \n", (*ip_header)->protocol);

    memcpy(&((*ip_header)->checksum), &pcap_data[start], sizeof((*ip_header)->checksum));
    // printf("\t\tChecksum: %x \n", (*ip_header)->checksum);

    (*ip_header)->validChecksum = isValidChecksum((unsigned short*)&(pcap_data[headerStart]), calcHeaderBytes((*ip_header)->headerLen));

    start += sizeof((*ip_header)->checksum);
    memcpy(&((*ip_header)->senderIP), &pcap_data[start], sizeof((*ip_header)->senderIP));

    start += FOUR_BYTES;
    memcpy(&((*ip_header)->destIP), &pcap_data[start], sizeof((*ip_header)->destIP));

    // initialize TCP Header Length w/ IPv4 Total Length – IPv4 Header Length
    (*ip_header)->tcp_header->PDULen = (*ip_header)->ipPDULen - calcHeaderBytes((*ip_header)->headerLen);
    // printf("TCP Header Len: %u (%u - %u)\n", (*ip_header)->tcp_header->PDULen, (*ip_header)->ipPDULen, calcHeaderBytes((*ip_header)->headerLen));
}

void initICMPHeader(struct icmp_header** icmp_header, const u_char* pcap_data, int firstByte)
{
    int start = firstByte;
    
    (*icmp_header)->type = (uint8_t)pcap_data[start];
    // printf("type = 0x%02X \n", (*icmp_header)->type);
    // printf("1st Byte = %i \n", firstByte);
}

void initTCPChecksumBuffer(struct ip_header** ip_header, const u_char* pcap_data, int firstByte)
{
    int start = firstByte;      // Start of TCP Bytes

    // temp checksum buffer for TCP Psuedo Header + TCP PDU
    uint8_t psuedoTCPBuffer[TCPMAXPDU] = {'\0'};
    int checksumLen = sizeof(*((*ip_header)->tcp_pseudo_header)) + ntohs((*ip_header)->tcp_pseudo_header->tcpPDULen);

    memcpy(&(psuedoTCPBuffer), &(*(*ip_header)->tcp_pseudo_header), sizeof(*((*ip_header)->tcp_pseudo_header)));
    memcpy(&(psuedoTCPBuffer[sizeof(*((*ip_header)->tcp_pseudo_header))]), &(pcap_data[start]), ntohs((*ip_header)->tcp_pseudo_header->tcpPDULen));
    (*ip_header)->tcp_header->validChecksum = isValidChecksum((unsigned short*)&(psuedoTCPBuffer), checksumLen);

    // printTCPPseudo_header((*ip_header)->tcp_pseudo_header);
    // printf(" ChecksumLen: %i \n", checksumLen);
    // printBuffer(psuedoTCPBuffer, checksumLen);
}

void initTCPPseudoHeader(struct ip_header** ip_header, const u_char* pcap_data, int firstByte)
{
    memcpy(&((*ip_header)->tcp_pseudo_header->senderIP), &((*ip_header)->senderIP), sizeof((*ip_header)->tcp_pseudo_header->senderIP));

    memcpy(&((*ip_header)->tcp_pseudo_header->destIP), &((*ip_header)->destIP), sizeof((*ip_header)->tcp_pseudo_header->destIP));

    (*ip_header)->tcp_pseudo_header->reserved = 0x0;

    memcpy(&((*ip_header)->tcp_pseudo_header->protocol), &((*ip_header)->protocol), sizeof((*ip_header)->tcp_pseudo_header->protocol));

    memcpy(&((*ip_header)->tcp_pseudo_header->tcpPDULen), &((*ip_header)->tcp_header->PDULen), sizeof((*ip_header)->tcp_pseudo_header->tcpPDULen));
    (*ip_header)->tcp_pseudo_header->tcpPDULen = htons((*ip_header)->tcp_pseudo_header->tcpPDULen);

    // initTCPChecksumBuffer(ip_header, pcap_data, (*ip_header)->headerLen);
    initTCPChecksumBuffer(ip_header, pcap_data, firstByte);
}

void initTCPHeader(struct tcp_header** tcp_header, const u_char* pcap_data, int firstByte)
{
    int start = firstByte;      // Start of TCP Bytes

    memcpy(&((*tcp_header)->srcPort), &pcap_data[start], sizeof((*tcp_header)->srcPort));
    (*tcp_header)->srcPort = ntohs((*tcp_header)->srcPort);
    // printf("srcPort = 0x%02X \n", (*tcp_header)->srcPort);

    start += TWO_BYTES;
    memcpy(&((*tcp_header)->destPort), &pcap_data[start], sizeof((*tcp_header)->destPort));
    (*tcp_header)->destPort = ntohs((*tcp_header)->destPort);

    start += TWO_BYTES;
    memcpy(&((*tcp_header)->seqNum), &pcap_data[start], sizeof((*tcp_header)->seqNum));
    (*tcp_header)->seqNum = ntohl((*tcp_header)->seqNum);
    // printf("seqNum = 0x%08X \n", (*tcp_header)->seqNum);

    start += FOUR_BYTES;
    memcpy(&((*tcp_header)->ackNum), &pcap_data[start], sizeof((*tcp_header)->ackNum));
    (*tcp_header)->ackNum = ntohl((*tcp_header)->ackNum);
    // printf("ackNum = 0x%08X \n", (*tcp_header)->ackNum);

    start += 5;
    memcpy(&((*tcp_header)->flags), &pcap_data[start++], sizeof((*tcp_header)->flags));
    // printf("\nflags = 0x%04X \n", (*tcp_header)->flags);
    // printf("x0%04X", pcap_data[start]);

    memcpy(&((*tcp_header)->windowSize), &pcap_data[start], sizeof((*tcp_header)->windowSize));
    (*tcp_header)->windowSize = ntohs((*tcp_header)->windowSize);

    start += TWO_BYTES;
    memcpy(&((*tcp_header)->checksum), &pcap_data[start], sizeof((*tcp_header)->checksum));
    // (*tcp_header)->checksum = ntohs((*tcp_header)->checksum);
    // printf("\t\tChecksum: %x \n", (*ip_header)->checksum);
}

void initUDPHeader(struct udp_header** udp_header, const u_char* pcap_data, int firstByte)
{
    int start = firstByte;      // Start of UDP Bytes

    memcpy(&((*udp_header)->srcPort), &pcap_data[start], sizeof((*udp_header)->srcPort));
    (*udp_header)->srcPort = ntohs((*udp_header)->srcPort);

    start += TWO_BYTES;
    memcpy(&((*udp_header)->destPort), &pcap_data[start], sizeof((*udp_header)->destPort));
    (*udp_header)->destPort = ntohs((*udp_header)->destPort);
} 

void initEthHeaders(struct eth_header** eth_header, struct pcap_pkthdr* pcap_header, const u_char* pcap_data, int pktNum)
{
    int firstByte = 0;
    initEthHeader(eth_header, pcap_data);
    (*eth_header)->type = ntohs((*eth_header)->type);

    switch((*eth_header)->type)
    {
        case 0x0806:    //ARP
            initArpHeader(&((*eth_header)->arp_header), pcap_data);
            break;

        case 0x0800:    //IPv4
            //pkt_header->eth_header->ip_header->protocol
            initIpHeader(&((*eth_header)->ip_header), pcap_data);
            firstByte = (ETHHeaderLen + calcHeaderBytes((*eth_header)->ip_header->headerLen));

            switch((*eth_header)->ip_header->protocol)
            {
                case 0x01:  //ICMP
                    initICMPHeader(&((*eth_header)->ip_header->icmp_header), pcap_data, firstByte);
                    break;

                case 0x06:  //TCP
                    initTCPHeader(&((*eth_header)->ip_header->tcp_header), pcap_data, firstByte);
                    initTCPPseudoHeader(&((*eth_header)->ip_header), pcap_data, firstByte);
                    break;
                
                case 0x11:
                    initUDPHeader(&((*eth_header)->ip_header->udp_header), pcap_data, firstByte);
                    break;

                default:
                    break;
            }
            // printf("IN IP = %u size = %lu \n", (*eth_header)->ip_header->protocol, sizeof((*eth_header)->ip_header->protocol));
            break;

        default:
            perror("#Error: initHeaders eth_header->type Failed!!!!");
            printf("Eth Header Type: %04x \n", (*eth_header)->type);
            exit(1);
            break;
    } 
}

int main(int argc, char* argv[])
{
    if(argc <= 1)
    {
        perror("Missing argument!!!!");
        exit(1);
    }

    char* filepath = argv[argc-1];
    char errbuf[50];
    struct pcap_pkthdr* pcap_header = NULL;      //pcap header size info
    const u_char* pcap_data = NULL;              //pcap data = Frame Header
    struct pkt_header* pkt_header = NULL;

    pcap_t* fpcap = pcap_open_offline(filepath, errbuf);
    
    int pktReadRet = 1;
    int pktNum = 1;
    for(pktNum = 1; (pktReadRet = pcap_next_ex(fpcap, &pcap_header, &pcap_data) != PCAP_ERROR_BREAK); pktNum++)
    {
        if(pktReadRet == 0)
        {
            perror("Parse pcap failed!!!!");
            exit(1);
        }
        // printPkt(pcap_header, pcap_data);

        initPktHeader(&pkt_header, pktNum, pcap_header);
        initEthHeaders(&(pkt_header->eth_header), pcap_header, pcap_data, pktNum);
        printEthHeaders(pkt_header);
    }

    if(fpcap != NULL)
        pcap_close(fpcap);

    return 0;
}
