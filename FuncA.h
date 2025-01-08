#ifndef FUNCA_H
#define FUNCA_H

#include <cmath>

class FuncA {
public:
    // Функція calculate для обчислення суми перших n елементів ряду
    /*
     * Class FuncA
     * Function calculate(int n, double x)
     * Parameters:
     *   n - кількість елементів ряду
     *   x - аргумент функції ln(1+x)
     */
    double calculate(int n, double x) {
        double result = 0;
        for (int i = 1; i <= n; ++i) {
            result += pow(-1, i - 1) * pow(x, i) / i;
        }
        return result;
    }
};

#endif
