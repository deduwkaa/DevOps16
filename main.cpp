#include <iostream>
#include "FuncA.h"

int main() {
    FuncA func;
    int n;
    double x;
    std::cout << "Enter the number of terms (n): ";
    std::cin >> n;
    std::cout << "Enter the value of x: ";
    std::cin >> x;

    std::cout << "Function result: " << func.calculate(n, x) << std::endl;
    return 0;
}
// TIP See CLion help at <a
// href="https://www.jetbrains.com/help/clion/">jetbrains.com/help/clion/</a>.
//  Also, you can try interactive lessons for CLion by selecting
//  'Help | Learn IDE Features' from the main menu.