TARGET = DevOps16
CXX = g++
CXXFLAGS = -Wall -std=c++11

SRCS = main.cpp FuncA.h
OBJS = $(SRCS:.cpp=.o)

$(TARGET): $(OBJS)
	$(CXX) $(OBJS) -o $(TARGET)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)