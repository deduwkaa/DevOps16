# Compiler
CXX = g++
# Compiler flags
CXXFLAGS = -Wall -g
# Executable name
TARGET = my_program
# Source files
SRCS = $(wildcard *.cpp)
# Object files
OBJS = $(SRCS:.cpp=.o)

# Default target to build the program
all: $(TARGET)

# Link the object files into the final executable
$(TARGET): $(OBJS)
	$(CXX) $(OBJS) -o $(TARGET)

# Compile the .cpp files into .o object files
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Clean up compiled files
clean:
	rm -f $(OBJS) $(TARGET)

# Rebuild everything
rebuild: clean all