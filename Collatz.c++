// ----------------------------
// projects/collatz/Collatz.c++
// Copyright (C) 2015
// Glenn P. Downing
// ----------------------------

// --------
// includes
// --------

#include <cassert>  // assert
#include <iostream> // endl, istream, ostream
#include <sstream>  // istringstream
#include <string>   // getline, string
#include <utility>  // make_pair, pair

#include "Collatz.h"

using namespace std;

// ------------
// collatz_read
// ------------

pair<int, int> collatz_read (const string& s) {
    istringstream sin(s);
    int i;
    int j;
    sin >> i >> j;
    return make_pair(i, j);}

// ------------
// collatz_eval
// ------------

int collatz_eval (int i, int j) {

    int workingvalue;			// intermediate value for the calculation iterations
    int cyclecount;			// number of cycles for the reduction
    int maxcyclecount = 0;		// maximum cyclecount value encountered
    int swapvalue;			// temp variable if we have to swap the inputs

// cout << "INITIAL VALUES: " << i << " " << j << "\n";

    if (i > j) {
// cout << "backwards...\n";
	swapvalue = j;
        j = i;
        i = swapvalue;
    }

// cout << "FIXED INITIAL VALUES: " << i << " " << j << "\n";

    while (i <= j) {			// for each value between the limits i and j
// cout << "Starting on value " << i << "\n";
	workingvalue = i;
	cyclecount = 1;			// minimum cyclecount is 1 according to the spoj example
        while (workingvalue != 1) {	// if we get to one we're done with this value

// cout << workingvalue << " ";

	    if ((workingvalue % 2)==0) {	// even so divide by 2
// cout << "workingvalue was even\n";
		    workingvalue=workingvalue/2;
		    cyclecount++;
            }
            else {			// otherwise odd so multiple by 3 and add 1
// cout << "workingvalue was odd\n";
		    workingvalue=((workingvalue * 3) + 1);
		    cyclecount++;
            }
        }

// cout << workingvalue << "\n";

// cout << "FINAL CYCLECOUNT FOR VALUE " << i << " IS " << cyclecount << "\n";

	if (maxcyclecount < cyclecount) {
		maxcyclecount = cyclecount;
        }
// cout << "MAX CYCLE COUNT IS " << maxcyclecount << "\n";

	i++;				// go to the next value

// cout << "starting next value " << i << "\n";

    }
		
    return maxcyclecount;
}

// -------------
// collatz_print
// -------------

void collatz_print (ostream& w, int i, int j, int v) {
    w << i << " " << j << " " << v << endl;}

// -------------
// collatz_solve
// -------------

void collatz_solve (istream& r, ostream& w) {
    string s;
    while (getline(r, s)) {
        const pair<int, int> p = collatz_read(s);
        const int            i = p.first;
        const int            j = p.second;
        const int            v = collatz_eval(i, j);
        collatz_print(w, i, j, v);}}
