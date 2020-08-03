#include <iostream> 
#include <fstream>
#include <time.h>

// variables
std::string file;

// functions
std::string createRow();

int main() {
	std::cout << "Please enter name of file: ";
	std::cin >> file;
	std::ofstream MyFile(file);
		
	MyFile << "Time,Sym,Price,Size\n";
	
	int x = 0,y = 1;
	std::string response;

	while (x == 0) {
		std::cout << std::endl << "Please enter data for row[" << y << "]:" << std::endl;
		MyFile << createRow();
		std::cout << "\nDo you want to add another row? ";
		std::cin >> response;
		x = (response == "yes") ? 0 : 1;
		y++;
	}
	MyFile.close();

	return 0;
}

std::string createTime() {
	time_t now;
	struct tm ts;
	char buf[80];
	std::string ntime;

	//Get current time
	time(&now);

	// Format time "0D hh:mm:ss.zzz"
	ts = *localtime(&now);
	strftime(buf, sizeof(buf),"0D%H:%M:%S.000000",&ts);
	ntime = ("%s\n", buf);
	return ntime;
}


std::string createRow() {
	std::string time;
	std::string sym;
	std::string price;
	std::string volume;

	time = createTime();	

	std::cout << "	Sym: ";
	std::cin >> sym;
	//std::cout << *sym[0] << std::endl;
	//if (sym[0] == "h" ) { std::cout << "Yoooo" <<  std::endl; }
	/*
	for (int i=0;i<=sym.length();i++){
		std::cout << sym[i] << std::endl;
	}*/

	std::cout << "	Price: ";
	std::cin >> price;

	std::cout << "	Size: ";
	std::cin >> volume;

	return time+","+sym+","+price+"f,"+volume+"\n";
}
