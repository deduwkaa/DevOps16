# Основна програма та тест
TARGET = my_program
TEST = testFuncA

# Компілятор і флаги
CXX = g++
CXXFLAGS = -Wall -std=c++11

# Файли
SRCS = main.cpp
OBJS = $(SRCS:.cpp=.o)

# Збірка основної програми
all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) $(OBJS) -o $(TARGET)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Збірка юніт-тесту
test: $(TEST)

$(TEST): testFuncA.cpp FuncA.h
	$(CXX) $(CXXFLAGS) testFuncA.cpp -o $(TEST)

# Очистка
clean:
	rm -f $(OBJS) $(TARGET) $(TEST)

# Повна перебудова
rebuild: clean all
