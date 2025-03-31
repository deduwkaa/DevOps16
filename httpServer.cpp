#include <crow_all.h>
#include <cmath>
#include <vector>
#include <algorithm>
#include <chrono>
#include <iostream>
#include "FuncA.h"

class TrigonometricFunctions {
public:
    TrigonometricFunctions() : funcA() {}

    // Calculate sin(x) using its series expansion
    double calculate_sin(double x, int n) {
        double result = 0;
        for (int i = 0; i < n; ++i) {
            double power_x = pow(x, 2 * i + 1);
            double factorial_term = 1.0;
            for (int j = 1; j <= (2 * i + 1); ++j) {
                factorial_term *= j;
            }
            result += pow(-1, i) * power_x / factorial_term;
        }
        return result;
    }

    // Calculate cos(x) using its series expansion
    double calculate_cos(double x, int n) {
        double result = 0;
        for (int i = 0; i < n; ++i) {
            double power_x = pow(x, 2 * i);  // x^(2i)
            double factorial_term = 1.0;
            for (int j = 1; j <= (2 * i); ++j) {
                factorial_term *= j;
            }
            result += pow(-1, i) * power_x / factorial_term;
        }
        return result;
    }

private:
    FuncA funcA;  // Instance of your FuncA class
};

// HTTP Request Handler
void handle_calculation(crow::response& res) {
    TrigonometricFunctions trig;
    auto start = std::chrono::high_resolution_clock::now();

    // We assume we want to calculate sin(x) and cos(x) for x = 1.0
    double x = 1.0;
    int n = 10;  // Number of terms to use in the series expansion

    // Calculate sin(x) and cos(x)
    double sin_value = trig.calculate_sin(x, n);
    double cos_value = trig.calculate_cos(x, n);

    // Sort the results
    std::vector<double> results = {sin_value, cos_value};
    std::sort(results.begin(), results.end());

    // Measure elapsed time
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> elapsed_time = end - start;

    // Prepare the response
    std::string response = "{\"sorted_values\": [";
    for (size_t i = 0; i < results.size(); ++i) {
        response += std::to_string(results[i]);
        if (i < results.size() - 1) {
            response += ",";
        }
    }
    response += "], \"elapsed_time\": " + std::to_string(elapsed_time.count()) + "}";

    res.set_header("Content-Type", "application/json");
    res.write(response);
}

int main() {
    crow::SimpleApp app;

    // Handle GET request at '/calculate'
    CROW_ROUTE(app, "/calculate").methods("GET"_method)(handle_calculation);

    // Start the server on port 8080
    app.port(8080).run();

    return 0;
}
