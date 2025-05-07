#include "FuncA.h"
#include <cassert>
#include <iostream>
#include <cmath>

// Допустима похибка
const double EPSILON = 1e-6;

bool approxEqual(double a, double b, double epsilon = EPSILON) {
    return std::fabs(a - b) < epsilon;
}

int main() {
    FuncA f;

    // Тест 1: ln(1 + 0.5)
    double x1 = 0.5;
    double expected1 = std::log(1 + x1);
    double result1 = f.calculate(50, x1); // більше членів для кращої точності
    assert(approxEqual(result1, expected1));

    // Тест 2: ln(1 + 1) = ln(2)
    double x2 = 1.0;
    double expected2 = std::log(2);
    double result2 = f.calculate(100, x2); // ще більше членів
    assert(approxEqual(result2, expected2));

    // Тест 3: ln(1 + 0) = 0
    assert(approxEqual(f.calculate(10, 0.0), 0.0));

    std::cout << "All FuncA tests passed successfully." << std::endl;
    return 0;
}
