import socket
from pyq import q

server_host=input("Server name: ")
server_port=int(input("Port number: "))

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((server_host,server_port))

s.send(bytes("Administrator:password\0","utf-8"))
s.settimeout(1)
try: 
    s.recv(1)
    print("connection established")
except socket.timeout: 
    print("connection failed")

#msg_type=int(input("Enter msg type: \n[0] async\n[1] sync\n[2] response\n"))
#sync_type=chr(msg_type)

#header = f"\x01{sync_type}\x00\x00\x14\x00\x00\x00\x0a\x00\x06\x00\x00\x00"
#msg = "hello2"

table=input("Name of table to publish: ")
q.table=(table)
print(q.table)

s.send(bytes(q.table,"utf-8"))
if ( 1 == msg_type ):
    reply=s.recv(1024)
    reply=reply.decode("utf-8")
    print(f"Reply from server: {reply}")

