CXX = g++ 
CXXFLAGS = -O3 -Wall -funroll-loops -g -pg
OBJS = Data_Structure.o Solver.o
TARGET = SWM.exe
RM = rm -rf 

all: $(OBJS)
	$(CXX) SWM.cpp -o $(TARGET) $(OBJS) $(CXXFLAGS)

$(OBJS):%o:%cpp
	$(CXX) -c $(CXXFLAGS) $< -o $@

clean:
	$(RM) $(TARGET) $(OBJS)

