# Example makefile for CPE464 program 1
#
# 

CC = gcc
CFLAGS = -g -Wall 
#CFLAGS = -g

all:  trace

trace: trace.c
	$(CC) $(CFLAGS) -o trace trace.c checksum.c -lpcap 

clean:
	rm -f trace

exec: 
	clear
#	ARP & ICMP
	./trace ./testcases/ArpTest.pcap > ./outputs/ArpTest.pcap.me
	./trace ./testcases/PingTest.pcap > ./outputs/PingTest.pcap.me
#	TCP
	./trace ./testcases/Http.pcap > ./outputs/Http.pcap.me
	./trace ./testcases/smallTCP.pcap > ./outputs/smallTCP.pcap.me
	./trace ./testcases/TCP_bad_checksum.pcap > ./outputs/TCP_bad_checksum.pcap.me
#	UDP
	./trace ./testcases/UDPfile.pcap > ./outputs/UDPfile.pcap.me
#	MIX
	./trace ./testcases/largeMix.pcap > ./outputs/largeMix.pcap.me
	./trace ./testcases/largeMix2.pcap > ./outputs/largeMix2.pcap.me
	./trace ./testcases/mix_withIPoptions.pcap > ./outputs/mix_withIPoptions.pcap.me
#	IP
	./trace ./testcases/IP_bad_checksum.pcap > ./outputs/IP_bad_checksum.pcap.me


diff:
#	ARP & ICMP	
	diff -w -B ./testcases/ArpTest.pcap.out ./outputs/ArpTest.pcap.me
	diff -w -B ./testcases/PingTest.pcap.out ./outputs/PingTest.pcap.me
#	TCP
	diff -w -B ./testcases/Http.pcap.out ./outputs/Http.pcap.me
	diff -w -B ./testcases/smallTCP.pcap.out ./outputs/smallTCP.pcap.me
	diff -w -B ./testcases/TCP_bad_checksum.pcap.out ./outputs/TCP_bad_checksum.pcap.me
#	UDP
	diff -w -B ./testcases/UDPfile.pcap.out ./outputs/UDPfile.pcap.me

#	MIX
	diff -w -B ./testcases/largeMix.pcap.out ./outputs/largeMix.pcap.me
	diff -w -B ./testcases/largeMix2.pcap.out ./outputs/largeMix2.pcap.me
	diff -w -B ./testcases/mix_withIPoptions.pcap.out ./outputs/mix_withIPoptions.pcap.me
#	IP
	diff -w -B ./testcases/IP_bad_checksum.pcap.out ./outputs/IP_bad_checksum.pcap.me

test: exec diff