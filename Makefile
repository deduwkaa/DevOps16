# Compiler
CXX = g++

# Compiler flags (add -pthread for Boost.Asio threading and signal handling)
CXXFLAGS = -Wall -g -pthread

# Executable name
TARGET = my_program

# Source files excluding main.cpp and httpServerTests.cpp
SRCS = $(wildcard *.cpp)
SRCS := $(filter-out main.cpp httpServerTests.cpp, $(SRCS))

# Object files
OBJS = $(SRCS:.cpp=.o)

# Default target to build the program
all: $(TARGET)

# Link the object files into the final executable
$(TARGET): $(OBJS)
	$(CXX) $(OBJS) -o $(TARGET) -pthread

# Compile the .cpp files into .o object files
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Clean up compiled files
clean:
	rm -f $(OBJS) $(TARGET)

# Rebuild everything
rebuild: clean all
