# [[[ HEADER ]]]
use RPerl;
package MathPerl::LinearAlgebra;
use strict;
use warnings;
our $VERSION = 0.001_000;

# [[[ OO INHERITANCE ]]]
use parent qw(RPerl::CompileUnit::Module::Class);  # no non-system inheritance, only inherit from base class
use RPerl::CompileUnit::Module::Class;

# [[[ INCLUDES ]]]
use MathPerl::LinearAlgebra::AddVectorVector;

# [[[ OO PROPERTIES ]]]
our hashref $properties = {};

1;    # end of class
