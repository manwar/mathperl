# [[[ HEADER ]]]
use RPerl;
package MathPerl::DataStructure::ColorRGB;
use strict;
use warnings;
our $VERSION = 0.001_000;

# [[[ OO INHERITANCE ]]]
use parent qw(MathPerl::DataStructure::Color);
use MathPerl::DataStructure::Color;

# [[[ INCLUDES ]]]
use MathPerl::DataStructure::ColorHSV;

# [[[ OO PROPERTIES ]]]
our hashref $properties = {
    red   => my number $TYPED_red   = undef,
    green => my number $TYPED_green = undef,
    blue  => my number $TYPED_blue  = undef,
};

# [[[ SUBROUTINES & OO METHODS ]]]

our MathPerl::DataStructure::ColorHSV $rgb_to_hsv = sub {
    ( my MathPerl::DataStructure::ColorRGB $rgb) = @ARG;
    return $rgb->to_hsv();
};

# OO interface wrapper
our MathPerl::DataStructure::ColorHSV::method $to_hsv = sub {
    ( my MathPerl::DataStructure::ColorRGB $self) = @ARG;
    return rgb_raw_to_hsv( [ $self->{red}, $self->{green}, $self->{blue} ] );
};

# procedural interface wrapper
our MathPerl::DataStructure::ColorHSV $rgb_raw_to_hsv = sub {
    ( my number_arrayref $rgb_raw) = @ARG;
    my MathPerl::DataStructure::ColorHSV $retval = MathPerl::DataStructure::ColorHSV->new();
    my number_arrayref $retval_raw  = rgb_raw_to_hsv_raw($rgb_raw);
    $retval->{hue}   = $retval_raw->[0];
    $retval->{saturation} = $retval_raw->[1];
    $retval->{value}  = $retval_raw->[2];
    return;
};

our number_arrayref $rgb_raw_to_hsv_raw = sub {
    ( my number_arrayref $rgb_raw) = @ARG;
    my number_arrayref $retval;

# START HERE: complete algorithm
# START HERE: complete algorithm
# START HERE: complete algorithm

    return $retval;
};

1;                         # end of class
