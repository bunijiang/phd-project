#Script using PyVISA to remotely control precision network analyzer (PNA) and export S11 data to a CSV file.

import pyvisa
import time
import netsock
import threading

INCOMING_PORT = 8888
INPUT_DIR = "input/"
PHASE_OFFSET = 0

# Number of sweep points
nofp = 1601

rm = pyvisa.ResourceManager()
myPna = rm.open_resource('TCPIP0::192.168.6.5::inst0::INSTR')
print(myPna.query('*IDN?'))
myPna.write("CALC:PAR:SEL 'CH1_S11_1'")
X = []
Y = []

class controllerThread(threading.Thread):
    def __init__(self, sock):
        self.sock = sock

    def run(self):
        #read something from the socket
        data = self.sock.receive()
        print("GOT DATA: " + data)
        data = data.strip()
        args = data.split(" ")
		
        if(args[0] == "StartTransm"):
            #sleep 3 seconds for measurement/sweep
            time.sleep(3)
            y = myPna.query('CALC:DATA? FDATA')
            X.append(y)

            self.sock.send("SUCC")
            self.sock.close()
        elif(args[0] == "WriteCSV"):
            res = open("file path (save CSV)","w")
            for i in X:
                res.write(i)
            res.close()
            self.sock.send("SUCC")
            self.sock.close()
        else:
            print("Error: unrecognized command")
            self.sock.send("FAIL")
            self.sock.close()


def main():
    server = netsock.NetServer(INCOMING_PORT, controllerThread)
    server.run()
	
	
main()
