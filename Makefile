# Makefile for CPE464 tcp and udp test code
# updated by Hugh Smith - April 2023

# all target makes UDP test code
# tcpAll target makes the TCP test code


CC= gcc
CFLAGS= -g -Wall
LIBS = 

OBJS = networks.o gethostbyname.o pollLib.o safeUtil.o pdu.o window.o

#uncomment next two lines if your using sendtoErr() library
LIBS += libcpe464.2.21.a -lstdc++ -ldl
CFLAGS += -D__LIBCPE464_


all: udpAll

udpAll: rcopy server

rcopy: rcopy.c $(OBJS) 
	$(CC) $(CFLAGS) -o rcopy rcopy.c $(OBJS) $(LIBS)

server: server.c $(OBJS) 
	$(CC) $(CFLAGS) -o server server.c  $(OBJS) $(LIBS)

.c.o:
	gcc -c $(CFLAGS) $< -o $@ $(LIBS)

cleano:
	rm -f *.o

clean:
	rm -f myServer myClient rcopy server *.o

serverfrom:
	./server 0 5455

clientsmallfrom:
	./rcopy ./testcases/smallfrom.txt ./testcases/smallto.txt 5 10 0 localhost 5455

clientfrom:
	./rcopy ./testcases/from.txt ./testcases/to.txt 5 50 0.3 localhost 5455
#	./rcopy ./testcases/from.txt ./testcases/to.txt 5 50 0.3 localhost 5455

clientbigfrom:
	./rcopy ./testcases/bigfrom.txt ./testcases/bigto.txt 112 1000 0.1 localhost 5455

servermid:
	./server 0.4 5455

clientmid:
	./rcopy ./testcases/mid ./testcases/midto 10 1000 0.4 localhost 5455

serverbig50:
	./server 0.1 5454

clientbig50:
	./rcopy ./testcases/big ./testcases/big50to 50 1000 0.1 localhost 5454

serverbig5:
	./server 0.15 5453

clientbig5:
	./rcopy ./testcases/big ./testcases/big5to 5 1000 0.15 localhost 5453

clientempty:
	./rcopy ./testcases/empty.txt ./testcases/emptyto.txt 5 14 0 localhost 5453

clientfile1:
	./rcopy ./testcases/file1 ./testcases/file1to 10 1000 0 localhost 5455


