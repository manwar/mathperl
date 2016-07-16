//!/usr/bin/rperl
// [[[ HEADER ]]]
#include <rperlstandalone.h>
#ifndef __CPP__INCLUDED__MathPerl__LinearAlgebra__gauss_seidel_cpp
#define __CPP__INCLUDED__MathPerl__LinearAlgebra__gauss_seidel_cpp 0.001_000
# ifdef __CPP__TYPES



int main() {
    // [[[ OPERATIONS HEADER ]]]
    integer i;
    integer j;
    integer t;

// [[[ OPERATIONS ]]]
    const integer t_big = 5;
    const integer n_big = 10;
    number_arrayref_arrayref arr(n_big, number_arrayref(n_big));
    for ( i = 0; i < n_big; i++ ) {
        for ( j = 0; j < n_big; j++ ) {
            arr[i][j] = i * i + j * j;
        }
    }
#pragma scop
    for ( t = 0; t <= t_big - 1; t++ ) {
        for ( i = 1; i <= n_big - 2; i++ ) {
            for ( j = 1; j <= n_big - 2; j++ ) {
                arr[i][j] = (arr[i - 1][j - 1] + arr[i - 1][j] + arr[i - 1][j + 1] + arr[i][j - 1] + arr[i][j] + arr[i][j + 1] + arr[i + 1][j - 1] + arr[i + 1][j] + arr[i + 1][j + 1]) / 9.0;
            }
        }
    }
#pragma endscop
    print "Have final answer, final element $arr->[" << (n_big - 2) << "]->[" << (n_big - 2) << "] = " << arr[(n_big - 2)][(n_big - 2)] << endl;



    // [[[ OPERATIONS FOOTER ]]]
    return 0;
}

// [[[ FOOTER ]]]
# elif defined __PERL__TYPES
Purposefully_die_from_a_compile-time_error,_due_to____PERL__TYPES_being_defined.__We_need_to_define_only___CPP__TYPES_in_this_file!
# endif
#endif
