
#include <iostream> // can be swapped with fstream if you so desire
#include <time.h>

using std::string;

// the alphabet follows guidelines for characters allowed in general passwords
const string Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!()?[]_`~;:@#$%^&*+=-."; // 84 chars
const int sz = Alphabet.size();

string randAlphabet(){
	string rbet(sz, char{}),temp(Alphabet);
	string::iterator i;
	
	for(auto &c : rbet){
		i = begin(temp) + rand()%temp.size();
		c = *i;
		temp.erase(i);
	}
	
	return rbet;
}

string password(size_t len){
	string pass(len, char{}),ABCs{randAlphabet()};
	for(char &c : pass) c = ABCs[rand()%sz];
    pass[0] = Alphabet[rand()%82]; // forces valid starting character
	return pass;
}

int getVal(string cast, int temp = 0){
	while(temp<=0){
		std::cout << cast;
		std::cin >> temp;
	};
	return temp;
}

int main(){
	srand(time(NULL));
	
	int num{getVal("(positive) Quantity of passwords to generate: ") + 1};
	int len{getVal("(positive) Length of each password: ")};
	
	//while(--num) std::cout << password(len) << '\n';
	for(int i{}; --num; std::cout << "\nPassword " << ++i << ":\t" << password(len));
	while(1); // keeps the terminal open from an executable file call
}
