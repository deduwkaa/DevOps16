# Назва основної програми
TARGET = my_program
TEST = testFuncA

# Компiлятор та флаги
CXX = g++
CXXFLAGS = -Wall -std=c++11

# Основні файли
SRCS = main.cpp funcA.cpp
OBJS = $(SRCS:.cpp=.o)

# Збірка основної програми
all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) $(OBJS) -o $(TARGET)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Збірка юніт-тесту
test: $(TEST)

$(TEST): testFuncA.cpp funcA.o
	$(CXX) $(CXXFLAGS) testFuncA.cpp funcA.o -o $(TEST)

# Очистка
clean:
	rm -f $(OBJS) $(TARGET) $(TEST)

# Перезбірка
rebuild: clean all
