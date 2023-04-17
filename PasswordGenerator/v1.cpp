
#include <iostream>
#include <time.h>
#include <assert.h>
#include <vector>

using std::string;

class table {
	private:
		size_t *Array{nullptr};
		size_t Size{};
		
		void insert(size_t VAR) {
			size_t *OldArray = Array;
			Array = new size_t[++Size];
			
			int *i{Array},*ii{OldArray},*e{&Array[Size-1]};
			while (i != e) *i++ = *ii++;
			*i = VAR;
			
			delete [] OldArray;
			OldArray = nullptr;
		};
		
		size_t remove(int IDX) {
			size_t retVal{Array[IDX]}
			size_t *OldArray{Array};
			Array = new size_t[--Size];
			
			int *idx{Array},*oidx{OldArray};
			for(int i{}; i < Size; ++i) if(i!=IDX) *idx++ = *oidx++;
			
			delete [] OldArray;
			OldArray = nullptr;
			return ReturnVal;
		};
	
	public:	
		table(size_t len = 0) : Size(len) {
			if(len){
				Array = new size_t[len--];
				size_t *idx{Array};
				for (size_t i{}; i < len; *idx++ = i++);
			}
		}
		
		~table() {	
			delete [] Array;
			Array = nullptr;
			Size = int();
		}
		
		std::vector<size_t> RandomSequence(size_t len) const {
			table<size_t> LinearArray(len);	// Destructor implicitely deallocates this table
			std::vector<size_t> Seq(len);
			for (size_t &n : Seq) n = LinearArray.remove(rand()%len--);
			return Seq;
		};
};

const table Global();
const string Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!()?[]_`~;:@#$%^&*+=-."; // 84 characters

string Randomize(string String) {
	string Random(String.size(), char());
	
	string::iterator c = Random.begin();
	for (int i : Global.RandomSequence(String.size())) *c++ = String[i];
	 
	return Random;
};

string Password(int Length) {
	string Chars = Randomize(Alphabet),Random(Length, char{});
	for(char &c : Random) c = Chars[rand()%84];
	*Random.begin() = Alphabet[rand()%82]; // force valid starting character
	return Random;
};

int GetValue(string Type) {
	int Value = 5;
	while (Value < 6 || Value > 100) {
		std::cout << "Enter the " << Type << ": ";
		std::cin >> Value;
	};
	return Value;
};

int main() {		
	srand(time(0));	// Seed random generator from time_t *0
	
	std::cout << "Accepted input range: {6, 100}\n\n";
	int Length = GetValue("Length of each Password");
	int Quantity = GetValue("Quantity of Passwords");
	
	for (int i{0}; i++ != Quantity; std::cout << "\nPassword " << i << ":\t" << Password(Length)); 
	while (true); // dead loop
	return 0;
};
