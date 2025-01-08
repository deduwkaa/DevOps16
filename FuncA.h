#ifndef FUNCA_H
#define FUNCA_H

#include <cmath>

class FuncA {
public:
    // Реалізація для 3 елементів
    double calculate() {
        double result = 0;
        double x = 1; // Встановіть x для прикладу
        for (int i = 1; i <= 3; ++i) {
            result += pow(-1, i - 1) * pow(x, i) / i;
        }
        return result;
    }
};

#endif
