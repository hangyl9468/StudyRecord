#include<iostream>
#include"calc.h"

using namespace std;

int main(){
    float a = 20, b = 12;
    cout << "a = " << a << endl;
    cout << "b = " << b << endl;
    cout << "a + b = " << add(a, b) << endl;
    cout << "a - b = " << sub(a, b) << endl;
    cout << "a * b = " << mul(a, b) << endl;
    cout << "a / b = " << div(a, b) << endl;
}