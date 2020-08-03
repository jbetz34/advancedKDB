// q trade.q -p 5030
// l32: gcc -o readCSV ../c/c/readCSV.cpp c.o -lpthread -ldl
// s32: /usr/local/gcc-3.3.2/bin/gcc ../c/c/c.c c.o -lsocket -lnsl -lpthread
// w32: cl  ../c/c/c.c c.lib ws2_32.lib

#include "k.h"
#include <iostream>
#include <fstream>
#include <vector>
#include <sstream>

// declare variables
std::string filepath,table;

// declare functions
char * stringToCharArray(char *a, std::string s);
int attemptConnection(std::string host,int port,std::string user,std::string pass,int tmput);
int connection();


// define functions
char * stringToCharArray(char *a, std::string s) {
        for (int i=0;i<=s.length();i++){
                *(a+i)=s[i];
        }
        return a;
}

int attemptConnection(std::string host,int port,std::string user,std::string pass,int tmout) {
	std::string upass=user+":"+pass;
	char *hostname,*userpass;
	char tmpHOST[host.length()],tmpUPASS[upass.length()];
	hostname = stringToCharArray(&tmpHOST[0],host);
	userpass = stringToCharArray(&tmpUPASS[0],upass);

	int h = khpun(hostname,port,userpass,tmout); // connect
	switch (h) {
		case -2:
			std::cout << "Connection cannot be established: `timeout" << std::endl;
			exit(0);
		case -1:
			std::cout << "Connection cannot be established: `error" << std::endl;
			exit(0);
		case 0:
			std::cout << "Connection cannot be established: `access" << std::endl;
			exit(0);
		default:
			std::cout << "Connection established!" << std::endl << std::endl;
	}
	return h;
}

int connection(){
	std::string host,user,pass;
	int port,tmout=3000;

	std::cout<< "Please enter connection details.\nHostname: ";
	std::cin >> host;
	std::cout<< "Port: ";
	std::cin >> port;
	std::cout<< "Username: ";
	std::cin >> user;
	std::cout<< "Password: ";
	std::cin >> pass;

	return attemptConnection(host,port,user,pass,tmout);
}

int main() {
	
	int handle=connection();

	// get file information
	std::cout << "Enter location of file to read: ";
	std::cin >> filepath;
	std::cout << "Enter the name of the table: ";
	std::cin >> table;
	// attempt to open file
	std::ifstream myFile(filepath);
	if(!myFile.is_open()) throw std::runtime_error("Could not open file");


	std::string line,col_name;
	std::vector <std::string> columns;
	std::vector <std::string> types;

	if(myFile.good()) {
		std::getline(myFile,line);
		//std::cout << "Columns: " << line<< std::endl;
		std::stringstream sstream(line);
		while (std::getline(sstream,col_name,',')) {
			columns.push_back(col_name);
		}
	}
	/*
	std::cout << "Please enter q/kdb+ types for each column: " << std::endl;
	for (int i=0;i<columns.size();i++){
		std::cout << "	" << columns.at(i) << " : ";
		std::string col_type;
		std::cin >> col_type;
		types.push_back(col_type);
	}

	std::cout << "q/kdb+ column types: " <<std::endl;
	for (int i=0;i<types.size();i++){
		std::cout << "	" << columns.at(i) << " : " << types.at(i) << std::endl;
	}
	*/
	while (std::getline(myFile,line)) {
		std::vector <std::string> values;
		std::stringstream s_stream(line);
		while (s_stream.good()){
			std::string subst;
			std::getline(s_stream, subst, ',');
			values.push_back(subst);
		}
		std::string row;
		if (values.size() != columns.size()) continue;
		
		for (int i=0;i<values.size();i++){
			std::string d= (i==0)?"(":";";
			row+=d+values.at(i);
		}
		std::string cmd;
		cmd= "value (.u.upd;`"+table+";"+row+"))";
		// convert cmd string to char array
		char char_array[cmd.length()];
		for (int i=0;i<=cmd.length(); i++){
			char_array[i]=cmd[i];
		}

		k(-handle,char_array,(K)0); //upsert
	}
	k(handle,"",(K)0); //flush
	myFile.close();
	kclose(handle);
	return 0;
}

/*
int main(){
  k(-c,"`trade insert(0D14:34:56.789;`IBM;99.54;300)",(K)0);//insert
  k(c,"",(K)0); // flush                              
  return 0;}
*/
/*
#define Q(e,s) {if(e)return printf("%s\n",s),-1;}      //error
int main(){K x,y;int c=khpu("localhost",5001,"usr:pwd");
 Q(c<0,"connect")Q(!c,"access")
 Q(!k(-c,"`trade insert(12:34:56.789;`xx;93.5;300)",(K)0),"err") // statement insert
 Q(!(x=k(c,"select sum size by sym from trade",0)),"err")    // statement select
 Q(!(x=ktd(x)),"type")                   // flip from keyedtable(dict)
  y=x->k;                                // dict from flip
  y=kK(y)[1],printf("%d cols:\n",y->n);  // data from dict
  y=kK(y)[0],printf("%d rows:\n",y->n);  // column 0
  printf("%s\n",kS(y)[0]);               // sym 0 
  r0(x);                                 // release memory
 x=knk(4,kt(1000*(time(0)%86400)),ks("xx"),kf(93.5),ki(300)); // data record
// DO(10000,Q(!k(-c,"insert",ks((S)"trade"),r1(x),(K)0),es)) // 10000 asynch inserts
// k(c,"",(K)0); // synch chase
// return 0;
 Q(!k(-c,"insert",ks("trade"),x,(K)0),"err")                           // parameter insert
 Q(!(x=k(c,"{[x]select from trade where size>x}",ki(100),(K)0)),"err") // parameter select
  r0(x);
 close(c);
 return 0;}
*/
