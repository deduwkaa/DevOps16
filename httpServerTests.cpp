#include <gtest/gtest.h>
#include <curl/curl.h>
#include <json/json.h>
#include <string>

// Helper function to perform the HTTP GET request
std::string get_calculation_response() {
    CURL *curl;
    CURLcode res;
    std::string response_data;
    curl_global_init(CURL_GLOBAL_DEFAULT);
    curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, "http://localhost:8080/calculate");
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, +[](void* ptr, size_t size, size_t nmemb, void* data) -> size_t {
            ((std::string*)data)->append((char*)ptr, size * nmemb);
            return size * nmemb;
        });
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response_data);
        res = curl_easy_perform(curl);
        curl_easy_cleanup(curl);
    }
    curl_global_cleanup();
    return response_data;
}

// Unit Test
TEST(CalculateTest, ElapsedTimeTest) {
    std::string response = get_calculation_response();
    
    // Parse the response using JSON
    Json::CharReaderBuilder reader;
    Json::Value root;
    std::istringstream s(response);
    std::string errs;
    Json::parseFromStream(reader, s, &root, &errs);
    
    double elapsed_time = root["elapsed_time"].asDouble();

    // Check that elapsed time is between 5 and 20 seconds
    EXPECT_GE(elapsed_time, 5);
    EXPECT_LE(elapsed_time, 20);
}
