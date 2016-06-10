# [[[ HEADER ]]]
use RPerl;
package MathPerl::DataStructure::Vector;
#package MathPerl::DataStructure::NumberVectorFree;  # DEV NOTE: Vector is really NumberVectorFree; shortened for convenience; contrasted with VectorBound which is really NumberVectorBound
use strict;
use warnings;
our $VERSION = 0.001_000;

# [[[ OO INHERITANCE ]]]
use parent qw(MathPerl::DataStructure);
use MathPerl::DataStructure;

# [[[ OO PROPERTIES ]]]
our hashref $properties = {
    head => my number_arrayref $TYPED_head = []
};

1;    # end of class