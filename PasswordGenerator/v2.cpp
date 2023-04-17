#include <iostream> // can be swapped with fstream if you so desire
#include <ctime>
#include <memory>
#include <forward_list>

using std::string;

struct node{ // struct for easy access
	std::shared_ptr<node> next{nullptr};
	size_t key{};
	node(const size_t &val = 0) : key(val){}
};

class linked_list{ // not a practical linked list implementation
	private:
		std::shared_ptr<node> head = std::make_shared<node>(); // shared_pointer for easy deallocation
		size_t len{};
		
		size_t remove(size_t idx){
			if(!idx){ // idx == 0
				size_t retVal{head->key};
				head = head->next;
				return retVal;
			}
			auto temp{head};
			for(size_t key{}; ++key != idx; temp = temp->next); // traverse like an array
			
			size_t retVal{temp->next->key}; // get return value of idx-node
			temp->next = temp->next->next; // deallocate middle node
			temp = nullptr; // deallocate hanging pointer (idk if this happens implicitely)
			
			return retVal;
		}
	
	public:
		linked_list(size_t size) : len(size){
			auto temp{head}; // fill linked_list as a linear array
			for(size_t idx{}; ++idx < size; temp = temp->next) temp->next = std::make_shared<node>(idx);
			temp = nullptr;
		}
		
		~linked_list(){head = nullptr;}
	
		std::forward_list<size_t> randSeq(){
			std::forward_list<size_t> seq(len);
			for(size_t &key : seq) key = remove(rand()%len--); // removes the node and returns the val at the node
			return seq; // random sequence
		}
};

// the alphabet follows guidelines for characters allowed in general passwords
const string Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!()?[]_`~;:@#$%^&*+=-."; // 84 chars

string randAlphabet(){
	string temp(Alphabet);
	string::iterator c{temp.end()};
	for(size_t idx : linked_list(84).randSeq()) *c-- = Alphabet[idx];
	return temp;
}

string password(size_t len){
	string pass(len,char{}),ABCs{randAlphabet()};
	for(char &c : pass) c = ABCs[rand()%84];
    pass[0] = Alphabet[rand()%82]; // forces valid starting character
	return pass;
}

template<typename TYPE> 
TYPE getVal(string cast, TYPE temp = TYPE{}){
	while(temp<=0){
		std::cout << cast;
		std::cin >> temp;
	};
	return temp;
}

int main(){
	srand(time(0));
	
	int num{getVal<int>("(positive) Quantity of passwords to generate: ")};
	size_t len{getVal<size_t>("(positive) Length of each password: ")};
	
	for(int i{0}; i != num; std::cout << "\nPassword " << ++i << ":\t" << password(len));
	// while(1); // keeps the terminal open from an executable file call
}
