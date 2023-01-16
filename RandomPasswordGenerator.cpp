
#include <iostream>
#include <time.h>
#include <assert.h>
#include <vector>

using std::string;

template<typename TYPE>
class table {
	private:
		bool ValidateIndex(int Index) const {
			return (Index >= 0 && Index < Size);
		};
		
		bool ValidateQuantity(int Quantity) const {
			return (Quantity >= 0);
		};
	
	public:
		TYPE *Array = nullptr;
		int Size = int();	// empty integer = 0
	
		table(int Quantity) : Size(Quantity) {
			assert(ValidateQuantity(Quantity));
			Array = new TYPE[Quantity]();
		};
		table(int Quantity, TYPE VAR) : Size(Quantity) { // similar to table.create(Size, Value)
			assert(ValidateQuantity(Quantity));
			Array = new TYPE[Quantity];
			for (int Index = -1; Index++ != (Size - 1); Array[Index] = VAR);
		};
		
		~table() {	
			if (Array != nullptr) {
				delete [] Array;
				Array = nullptr;
			}
			Size = int();
		};
		
		int getn() const 
		{	return Size;	};
		
		void insert(TYPE VAR) {
			auto OldArray = Array;
			Array = new TYPE[Size + 1];
			
			int *i{&Array[0]},*ii{&OldArray[0]},*e{&Array[Size]};
			while (i != e) { *i++ = *i++; };
			Array[Size++] = VAR;
			
			delete [] OldArray;
			OldArray = nullptr;
		};
		
		table<TYPE> LinearTable(int Quantity) {
			assert(ValidateQuantity(Quantity));
			table<TYPE> LinearArray(Quantity);
			for (int i{-1},e{Quantity - 1}; i++ < e; LinearArray.set(i, i));
			return LinearArray;
		};
		
		std::vector<TYPE> Random(int Quantity) {
			assert(ValidateQuantity(Quantity));
			table<TYPE> LinearArray = LinearTable(Quantity);	// Destructor implicitely deallocates this table
			std::vector<TYPE> Seq(Quantity);
			for (TYPE *i{&Seq[0]},*e{&Seq.back()}; i <= e; *i++ = LinearArray.remove(rand()%LinearArray.getn()));
			return Seq;
		};
		
		TYPE remove(int Index) {
			assert(ValidateIndex(Index));
			auto OldArray = Array;
			Array = new TYPE[--Size];
			
			int *idx = &Array[0];
			for (int i = 0; i <= Size; i++) {
				if (i != Index) {
					*idx++ = OldArray[i];
				};
			};
			
			TYPE ReturnVal = OldArray[Index];
			delete [] OldArray;
			OldArray = nullptr;
			return ReturnVal;
			
		};
		
		void set(int Index, TYPE VAL) {
			assert(ValidateIndex(Index));
			Array[Index] = VAL;
		};
		
		TYPE operator[](int Index) const {
			assert(ValidateIndex(Index));
			return Array[Index];
		};
		
		void out() const {
			for (int i = -1; i++ < Size - 1; std::cout << Array[i] << ", ");
		}
};

// not sure if all the characters in this string are accepted in passwords
const string Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!()-.?[]_`~;:@#$%^&*+=";
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
	table<int> Array(String.length());
	string Randomized(Array.getn(), '\0');
	
	char *c = &Randomized[0];
	for (int Index : Array.Random(Array.getn())) *c++ = String[Index];
	 
	return Randomized;
};

string RandomString(int Quantity) {
	string Chars = Randomize(Alphabet);
	string String(Quantity, '\0');
	
	char *c{&String[0]},*e{&String[Quantity]};
	while (c != e) *c++ = Chars[rand()%Range];
	
	return String;
};



int main() {
	srand(time(0));	// Seed random generator from time_t *0
	
	std::cout << "Accepted input range: {6, 100}\n\n";
	int Length = GetValue("Length of each Password");
	int Quantity = GetValue("Quantity of Passwords") + 1;
	
	for (int i{1}; i != Quantity; i++) {
		string Password = RandomString(Length);
		while (Password[0] == '-' || Password[0] == '.')
		{	Password[0] = Alphabet[rand()%Range];	};
		std::cout << "\nPassword " << i << ":\t" << Password;
	};
	return 0;
};
