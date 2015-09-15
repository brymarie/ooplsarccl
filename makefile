INCDIRS:=/Users/bryan/Desktop/training_class/googletest/googletest/include
LIBDIRS:=/Users/bryan/Desktop/training_class/googletest/googletest/make

FILES :=                              \
    .travis.yml                       \
    collatz-tests/EID-RunCollatz.in   \
    collatz-tests/EID-RunCollatz.out  \
    collatz-tests/EID-TestCollatz.c++ \
    collatz-tests/EID-TestCollatz.out \
    Collatz.c++                       \
    Collatz.h                         \
    Collatz.log                       \
    html                              \
    RunCollatz.c++                    \
    RunCollatz.in                     \
    RunCollatz.out                    \
    TestCollatz.c++                   \
    TestCollatz.out                   \
    ColalatzBundle.c++

# Call gcc and gcov differently on Darwin
ifeq ($(shell uname), Darwin)
  CXX      := g++
  GCOV     := gcov
  VALGRIND := echo Valgrind not available on Darwin
else
  CXX      := g++-4.8
  GCOV     := gcov-4.8
  VALGRIND := valgrind
endif

CXXFLAGS   := -pedantic -std=c++11 -Wall -I$(INCDIRS)
LDFLAGS    := -lgtest -lgtest_main -pthread -L$(LIBDIRS)
GCOVFLAGS  := -fprofile-arcs -ftest-coverage
GPROF      := gprof
GPROFFLAGS := -pg

clean:
	rm -f *.gcda
	rm -f *.gcno
	rm -f *.gcov
	rm -f RunCollatz
	rm -f RunCollatz.tmp
	rm -f TestCollatz
	rm -f TestCollatz.tmp
	rm -f CollatzBundle

config:
	git config -l

bundle:
	cat Collatz.h Collatz.c++ RunCollatz.c++ | sed -e "s/#include \"Collatz.h\"//g" > CollatzBundle.c++
	$(CXX) $(CXXFLAGS) $(GCOVFLAGS) CollatzBundle.c++ -o CollatzBundle

scrub:
	make  clean
	rm -f  Collatz.log
	rm -rf collatz-tests
	rm -rf html
	rm -rf latex

status:
	make clean
	@echo
	git branch
	git remote -v
	git status

test: RunCollatz.tmp TestCollatz.tmp

RunCollatz: Collatz.h Collatz.c++ RunCollatz.c++
	$(CXX) $(CXXFLAGS) $(GCOVFLAGS) Collatz.c++ RunCollatz.c++ -o RunCollatz

RunCollatz.tmp: RunCollatz
	./RunCollatz < RunCollatz.in > RunCollatz.tmp
	diff RunCollatz.tmp RunCollatz.out

TestCollatz: Collatz.h Collatz.c++ TestCollatz.c++
	$(CXX) $(CXXFLAGS) $(GCOVFLAGS) Collatz.c++ TestCollatz.c++ -o TestCollatz $(LDFLAGS)

TestCollatz.tmp: TestCollatz
	./TestCollatz                                                   >  TestCollatz.tmp 2>&1
	$(VALGRIND) ./TestCollatz                                       >> TestCollatz.tmp
	$(GCOV) -b Collatz.c++     | grep -A 5 "File 'Collatz.c++'"     >> TestCollatz.tmp
	$(GCOV) -b TestCollatz.c++ | grep -A 5 "File 'TestCollatz.c++'" >> TestCollatz.tmp
	cat TestCollatz.tmp
