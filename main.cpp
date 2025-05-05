#include <iostream>
#include "FuncA.h"

int main() {
    FuncA func;
    std::cout << "FuncA result: " << func.calculate(5, 1.0) << std::endl;
    return 0;
}
