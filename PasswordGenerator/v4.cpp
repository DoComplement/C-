
#include <iostream>
#include <vector>
#include <fstream>
#include <queue>
#include <time.h>
#include <cstring>

using std::string;
using std::priority_queue;

class rand_cmp {
	public:
		bool operator () (const int &a, const int &b){
			return rand()&1;
		}
};

// the alphabet follows guidelines for characters allowed in general passwords
const string Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!()?[]_`~;:@#$%^&*+=-."; // 84 chars
const size_t sz = Alphabet.size();

priority_queue<int, std::vector<int>, rand_cmp> pq{};

string rand_alphabet(){
	string xbet(sz, '\0');
	
	for(int i = sz; i--; pq.push(i));    // make random permutation
	
	for(auto &c : xbet){				// fill set		
		c = Alphabet[pq.top()];
		pq.pop();
	}
	
	return xbet;
}

string password(size_t len){
	string pass(len, '\0'), abc{rand_alphabet()};
	
	for(char &c : pass) 
		c = abc[rand()%sz];
		
    pass[0] = Alphabet[rand()%82]; // forces valid starting character
    
	return pass;
}

int getVal(string cast, int temp = 0){
	while(temp <= 0){
		std::cout << cast;
		std::cin  >> temp;
	}
	
	return temp;
}

string get_filename(){
	string x{};
	std::cout << "\nwould you like to store the passwords in a file? (y/n): ";
	std::cin >> x;
	
	if(x[0]&1){  // y/Y indicate odd ascii numbers
		std::cout << "\nplease enter a filename without any extension: ";
		std::cin >> x;
		x.append(".txt");
		return x;
	}
	return string{};
}

int main(){
	srand(time(NULL));
	
	int num{getVal("(positive) Quantity of passwords to generate: ") + 1};
	int len{getVal("(positive) Length of each password: ")};
	
	string filename{get_filename()};
	
	if(filename.size()){
		std::ofstream out(filename);
		for(int i{}; --num; out << "\nPassword " << ++i << ":\t" << password(len));
		out.close();
	} else {
		for(int i{}; --num; std::cout << "\nPassword " << ++i << ":\t" << password(len));
		while(1); // keeps the terminal open from an executable file call
	}
}
