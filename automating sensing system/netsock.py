import socket
import select


MAX_CONNECTIONS = 4
MAX_READ = 16384
SOCKET_TIMEOUT = 10.0	#timeout in seconds


def sockSend(sock, data):
	bytes = data.encode(encoding='utf-8')
	totalsent = 0
	while totalsent < len(bytes):
		sent = sock.send(bytes[totalsent:])
		if(sent == 0):
			print("socket connection broken")
			return -1
		totalsent = totalsent + sent
	return totalsent

def sockReceive(sock):
	data = ''
	while True:
		readyToRead, readyTowrite, inError = select.select([sock], [], [], SOCKET_TIMEOUT)

		if(len(readyToRead) > 0):
			chunk = readyToRead[0].recv(MAX_READ)
			if(len(chunk) == 0):
                                break
			data = data + chunk.decode("utf-8")
		else:
			break
	return data


class NetClient():
	def __init__(self, hostname, port):
		#create an INET, STREAMing socket
		self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)		

		#now connect to the server
		self.sock.connect((hostname, port))

	def send(self, data):
		return sockSend(self.sock, data)

	def receive(self):
		return sockReceive(self.sock)
		
	def close(self):
		self.sock.close()


class NetServerClient():
	def __init__(self, sock):
		self.sock = sock

	def send(self, data):
		return sockSend(self.sock, data)

	def receive(self):
		return sockReceive(self.sock)
		
	def close(self):
		self.sock.close()
	
	
class NetServer():
	def __init__(self, port, serverthread):
		#create an INET, STREAMing socket
		self.serversock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

		self.serverthread = serverthread
		
		#bind the socket to a public host, and a well-known port
		#self.serversock.bind((socket.gethostname(), port))
		self.serversock.bind(("", port))
		#become a server socket
		self.serversock.listen(MAX_CONNECTIONS)
	

	def run(self):
		while True:
			#accept connections from outside
			(clientsocket, address) = self.serversock.accept()
			
			#now do something with the clientsocket
			#in this case, we'll pretend this is a threaded server
			ct = self.serverthread(NetServerClient(clientsocket))
			ct.run()


