#Communication between NSI2000 script and PNA-controlling script through local area network.

import netsock
import sys

CONTROLLER_HOSTNAME = "192.168.6.10"
CONTROLLER_PORT = 8888

def main():

    query = ""
    for i in range(1, len(sys.argv)):
        if(i != 0):
            query = query + " "
        query = query + sys.argv[i]

    sock = netsock.NetClient(CONTROLLER_HOSTNAME, CONTROLLER_PORT)

    sock.send(query)
    res = sock.sock.recv(1024)
    print(repr(res))
    sock.close()
   
main()
