#include "swap.hpp"

void swap(int &val1, int &val2){
    int temp;
    temp = val1;
    val1 = val2;
    val2 = temp;
}