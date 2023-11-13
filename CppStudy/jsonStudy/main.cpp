#include<iostream>
#include"swap.hpp"

using namespace std;

int main(){
    int val1 = 10, val2 = 20;
    cout << "val1 = " << val1 << endl;
    cout << "val2 = " << val2 << endl;
    swap(val1,val2);
    cout << "val1 = " << val1 << endl;
    cout << "val2 = " << val2 << endl;
}