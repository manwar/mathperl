# [[[ HEADER ]]]
use RPerl;
package MathPerl::Fractal;
use strict;
use warnings;
our $VERSION = 0.000_001;

# [[[ OO INHERITANCE ]]]
use parent qw(RPerl::CompileUnit::Module::Class);  # no non-system inheritance, only inherit from base class
use RPerl::CompileUnit::Module::Class;

# [[[ INCLUDES ]]]
#use MathPerl::Fractal::Mandelbrot;  # ERROR ECOCODE01: circular dependency
#use MathPerl::Fractal::Julia;

# [[[ OO PROPERTIES ]]]
our hashref $properties = {};

1;    # end of class
