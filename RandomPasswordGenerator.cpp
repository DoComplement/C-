
#include <iostream>
#include <time.h>
#include <assert.h>
#include <vector>

using std::string;

template<typename TYPE>
class table {
	private:
		TYPE *Array = nullptr;
		int Size = int();	// empty integer = 0
		
		void insert(TYPE VAR) {
			TYPE *OldArray = Array;
			Array = new TYPE[++Size];
			
			int *i{Array},*ii{OldArray},*e{&Array[Size-1]};
			while (i != e) *i++ = *ii++;
			*i = VAR;
			
			delete [] OldArray;
			OldArray = nullptr;
		};
		
		TYPE remove(int Index) {
			TYPE *OldArray = Array;
			Array = new TYPE[--Size];
			TYPE ReturnVal;
			
			int *idx{Array},*oidx{OldArray};
			for (int i{-1}; i++ < Size; (i != Index) ? *idx++ = *oidx++ : ReturnVal = *oidx++);
			
			delete [] OldArray;
			OldArray = nullptr;
			return ReturnVal;
		};
	
	public:	
		table(int Quantity, bool Linear = true) : Size(Quantity) {
			assert(Quantity >= 0);
			Array = new TYPE[Quantity--];
			if (Linear == true) {
				int *idx{Array};
				for (int i{-1}; i++ < Quantity; *idx++ = i);
			};
		};
		
		~table() {	
			delete [] Array;
			Array = nullptr;
			Size = int();
		};
		
		int getn() const 
		{	return Size;	};
		
		std::vector<TYPE> RandomSequence(int Quantity) const {
			table<TYPE> LinearArray(Quantity);	// Destructor implicitely deallocates this table
			std::vector<TYPE> Seq(Quantity);
			for (TYPE &n : Seq) n = LinearArray.remove(rand()%LinearArray.getn());
			return Seq;
		};
};

const table<int> Global(0, false);
const string Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!()?[]_`~;:@#$%^&*+=-.";
const size_t Range = Alphabet.length();

int GetValue(string Type) {
	int Value = 5;
	while (Value < 6 || Value > 100) {
		std::cout << "Enter the " << Type << ": ";
		std::cin >> Value;
	};
	return Value;
};

string Randomize(string String) {
	string Random(String.size(), char());
	
	string::iterator c = Random.begin();
	for (int i : Global.RandomSequence(String.size())) *c++ = String[i];
	 
	return Random;
};

bool CheckInvalidStart(char c)
{	return c == '-' || c == '.';	}

string Password(int Length) {
	string Chars = Randomize(Alphabet);
	string Random(Length, char());
	
	for (char &c : Random) c = Chars[rand()%Range];
	if (CheckInvalidStart(Random[0])) Random[0] = Alphabet[rand()%(Range - 2)];
	
	return Random;
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
