#include <boost/beast.hpp>
#include <boost/asio.hpp>
#include <boost/algorithm/string.hpp>
#include <iostream>
#include <string>
#include <vector>
#include <cmath>
#include <chrono>
#include <algorithm>
#include "FuncA.h"

namespace beast = boost::beast;     // For HTTP
namespace asio = boost::asio;       // For Asio
using tcp = asio::ip::tcp;          // TCP socket

class LogarithmicFunctions {
public:
    LogarithmicFunctions() : funcA() {}

    // Use FuncA to calculate ln(1 + x) using the series expansion
    double calculate_ln(double x, int n) {
        // x should be within the domain for ln(1 + x), i.e., x > -1.
        if (x <= -1) {
            std::cerr << "Invalid input: x must be greater than -1 for ln(1+x)" << std::endl;
            return 0.0;  // Return 0 for invalid input
        }
        return funcA.calculate(n, x); // Use FuncA's calculate method
    }

private:
    FuncA funcA;  // Instance of FuncA classs
};

// Function to handle HTTP requests
void handle_request(beast::http::request<beast::http::string_body>& req, beast::http::response<beast::http::string_body>& res) {
    LogarithmicFunctions logFunc;
    auto start = std::chrono::high_resolution_clock::now();

    // We assume we want to calculate ln(1 + x) for x = 0.5 (just as an example)
    double x = 0.5;  // Example input for ln(1 + x)
    int n = 10;  // Number of terms to use in the series expansion

    // Calculate ln(1 + x)
    double ln_value = logFunc.calculate_ln(x, n);

    // Measure elapsed time
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> elapsed_time = end - start;

    // Prepare JSON response
    std::string response = "{\"ln_value\": " + std::to_string(ln_value) + ", \"elapsed_time\": " + std::to_string(elapsed_time.count()) + "}";

    // Set the response body and content type
    res.body() = response;
    res.set(beast::http::field::content_type, "application/json");
    res.prepare_payload();
}

// Simple HTTP server using Boost.Asio and Boost.Beast
void do_session(tcp::socket& socket) {
    try {
        beast::flat_buffer buffer;

        // Receive the HTTP request
        beast::http::request<beast::http::string_body> req;
        beast::http::read(socket, buffer, req);

        // Prepare HTTP response
        beast::http::response<beast::http::string_body> res{beast::http::status::ok, req.version()};

        // Handle the request and send response
        handle_request(req, res);

        // Send the HTTP response
        beast::http::write(socket, res);
    } catch (const beast::system_error& e) {
        std::cerr << "Error in session: " << e.what() << std::endl;
    }
}

// Main function to start the HTTP server
int main() {
    try {
        asio::io_context ioc;

        // Create an acceptor to listen for connections
        tcp::acceptor acceptor{ioc, {asio::ip::make_address("0.0.0.0"), 8080}};
        std::cout << "Server running on port 8080..." << std::endl;

        // Main server loop
        while (true) {
            tcp::socket socket{ioc};
            acceptor.accept(socket);
            std::thread{std::bind(&do_session, std::move(socket))}.detach();
        }
    } catch (const std::exception& e) {
        std::cerr << "Error in server: " << e.what() << std::endl;
    }

    return 0;
}
