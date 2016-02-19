# [[[ HEADER ]]]
package MathPerl::Fractal::MandelbrotRenderer2D;
use strict;
use warnings;
use RPerl::AfterSubclass;
our $VERSION = 0.003_000;

# [[[ OO INHERITANCE ]]]
use parent qw(RPerl::CompileUnit::Module::Class);    # no non-system inheritance, only inherit from base class
use RPerl::CompileUnit::Module::Class;

# [[[ CRITICS ]]]
## no critic qw(ProhibitUselessNoCritic ProhibitMagicNumbers RequireCheckedSyscalls) # USER DEFAULT 1: allow numeric values & print operator
## no critic qw(RequireInterpolationOfMetachars)  # USER DEFAULT 2: allow single-quoted control characters & sigils

# [[[ INCLUDES ]]]
use MathPerl::Fractal::Mandelbrot;
use Time::HiRes qw(time);
use SDL;
use SDL::Event;
use SDL::Video;
use SDLx::App;
use SDLx::Text;

# [[[ OO PROPERTIES ]]]
our hashref $properties = {
    mandelbrot_set  => my integer_arrayref_arrayref $TYPED_mandelbrot_set = undef,
    iterations_max  => my integer $TYPED_iterations_max                   = undef,
    window_title    => my string $TYPED_window_title                      = undef,
    window_width    => my integer $TYPED_window_width                     = undef,
    window_height   => my integer $TYPED_window_height                    = undef,
    x_min           => my number $TYPED_x_min                             = undef,
    x_max           => my number $TYPED_x_max                             = undef,
    y_min           => my number $TYPED_y_min                             = undef,
    y_max           => my number $TYPED_y_max                             = undef,
    move_factor     => my number $TYPED_move_factor                       = 0.1,      # NEED FIX: remove hard-coded values?
    zoom_factor     => my number $TYPED_zoom_factor                       = 0.2,
    iterations_inc  => my integer $TYPED_iterations_inc                   = 25,
    iterations_init => my integer $TYPED_iterations_init                  = undef,
    automatic       => my boolean $TYPED_automatic                        = 0,
    app             => my SDLx::App $TYPED_app                            = undef,
};

# [[[ OO METHODS & SUBROUTINES ]]]

our void::method $init = sub {
    ( my MathPerl::Fractal::MandelbrotRenderer2D $self, my integer $x_pixel_count, my integer $y_pixel_count, my integer $iterations_max ) = @_;
    $self->{window_title}   = 'Mandelbrot Fractal Generator';
    $self->{window_width}   = $x_pixel_count;
    $self->{window_height}  = $y_pixel_count;
    $self->{iterations_max} = $iterations_max;
    $self->{iterations_init} = $iterations_max;

    $self->{x_min} = MathPerl::Fractal::Mandelbrot->new()->X_SCALE_MIN();
    $self->{x_max} = MathPerl::Fractal::Mandelbrot->new()->X_SCALE_MAX();
    $self->{y_min} = MathPerl::Fractal::Mandelbrot->new()->Y_SCALE_MIN();
    $self->{y_max} = MathPerl::Fractal::Mandelbrot->new()->Y_SCALE_MAX();

    # PERLOPS_PERLTYPES only
    #    $self->{x_min}          = MathPerl::Fractal::Mandelbrot::X_SCALE_MIN();
    #    $self->{x_max}          = MathPerl::Fractal::Mandelbrot::X_SCALE_MAX();
    #    $self->{y_min}          = MathPerl::Fractal::Mandelbrot::Y_SCALE_MIN();
    #    $self->{y_max}          = MathPerl::Fractal::Mandelbrot::Y_SCALE_MAX();

    SDL::init(SDL_INIT_VIDEO);

    $self->{app} = SDLx::App->new(
        title  => $self->{window_title},
        width  => $self->{window_width},
        height => $self->{window_height},
        depth  => 32,                       # 32-bit color
        delay  => 25,                       # don't let SDL overload the CPU
    );
};

our void::method $events = sub {
    ( my MathPerl::Fractal::MandelbrotRenderer2D $self, my SDL::Event $event, my SDLx::App $app ) = @_;
    if ( $event->type() == SDL_QUIT ) { $app->stop(); }
    elsif ( $event->type == SDL_KEYDOWN ) {
        my $key_name  = SDL::Events::get_key_name( $event->key_sym );
        my $mod_state = SDL::Events::get_mod_state();

        #        print $key_name . "\n";

        if ( $key_name eq 'q' ) {    # QUIT
            $app->stop();
            return;
        }
        elsif ( $key_name eq 'up' ) {    # MOVE UP
            my number $y_move = ( $self->{y_max} - $self->{y_min} ) * $self->{move_factor};
            $self->{y_min} -= $y_move;
            $self->{y_max} -= $y_move;
        }
        elsif ( $key_name eq 'down' ) {    # MOVE DOWN
            my number $y_move = ( $self->{y_max} - $self->{y_min} ) * $self->{move_factor};
            $self->{y_min} += $y_move;
            $self->{y_max} += $y_move;
        }
        elsif ( $key_name eq 'left' ) {    # MOVE LEFT
            my number $x_move = ( $self->{x_max} - $self->{x_min} ) * $self->{move_factor};
            $self->{x_min} -= $x_move;
            $self->{x_max} -= $x_move;
        }
        elsif ( $key_name eq 'right' ) {    # MOVE RIGHT
            my number $x_move = ( $self->{x_max} - $self->{x_min} ) * $self->{move_factor};
            $self->{x_min} += $x_move;
            $self->{x_max} += $x_move;
        }
        elsif ( $key_name eq 'i' ) {        # ZOOM IN
            my number $x_zoom = ( $self->{x_max} - $self->{x_min} ) * $self->{zoom_factor};
            $self->{x_min} += $x_zoom;
            $self->{x_max} -= $x_zoom;
            my number $y_zoom = ( $self->{y_max} - $self->{y_min} ) * $self->{zoom_factor};
            $self->{y_min} += $y_zoom;
            $self->{y_max} -= $y_zoom;
        }
        elsif ( $key_name eq 'o' ) {        # ZOOM OUT
            my number $x_zoom = ( $self->{x_max} - $self->{x_min} ) * $self->{zoom_factor};
            $self->{x_min} -= $x_zoom;
            $self->{x_max} += $x_zoom;
            my number $y_zoom = ( $self->{y_max} - $self->{y_min} ) * $self->{zoom_factor};
            $self->{y_min} -= $y_zoom;
            $self->{y_max} += $y_zoom;
        }
        elsif ( ( $key_name eq '=' ) and ( $mod_state & KMOD_SHIFT ) ) {    # INCREASE ITERATIONS
            $self->{iterations_max} += $self->{iterations_inc};
        }
        elsif ( ( $key_name eq '-' ) and not( $mod_state & KMOD_SHIFT ) ) {    # DECREASE ITERATIONS
            if ( $self->{iterations_max} > $self->{iterations_inc} ) {
                $self->{iterations_max} -= $self->{iterations_inc};
            }
        }
        elsif ( $key_name eq 'r' ) {                                           # RESET
            $self->{automatic} = 0;
            $self->{x_min}     = MathPerl::Fractal::Mandelbrot->new()->X_SCALE_MIN();
            $self->{x_max}     = MathPerl::Fractal::Mandelbrot->new()->X_SCALE_MAX();
            $self->{y_min}     = MathPerl::Fractal::Mandelbrot->new()->Y_SCALE_MIN();
            $self->{y_max}     = MathPerl::Fractal::Mandelbrot->new()->Y_SCALE_MAX();
            $self->{iterations_max} = $self->{iterations_init};

            #            $self->{x_min}     = MathPerl::Fractal::Mandelbrot::X_SCALE_MIN();
            #            $self->{x_max}     = MathPerl::Fractal::Mandelbrot::X_SCALE_MAX();
            #            $self->{y_min}     = MathPerl::Fractal::Mandelbrot::Y_SCALE_MIN();
            #            $self->{y_max}     = MathPerl::Fractal::Mandelbrot::Y_SCALE_MAX();
        }
        elsif ( $key_name eq 'a' ) {    # AUTOMATIC ON
            $self->{automatic} = 1;
            return;
        }
        elsif ( $key_name eq 'space' ) {    # AUTOMATIC OFF
            $self->{automatic} = 0;
            return;
        }
        else { return; }                    # UNUSED KEYSTROKE

        $self->mandelbrot_escape_time_render($app);    # only render additional frames when a change occurs
        $app->update();
    }
};

our void::method $mandelbrot_escape_time_render = sub {
    ( my MathPerl::Fractal::MandelbrotRenderer2D $self, my SDLx::App $app ) = @_;
    SDL::Video::fill_rect( $app, SDL::Rect->new( 0, 0, $app->w(), $app->h() ), 0 );  # black background

    $self->{mandelbrot_set} = MathPerl::Fractal::Mandelbrot::mandelbrot_escape_time(
        $self->{window_width},
        $self->{window_height},
        $self->{iterations_max},
        $self->{x_min}, $self->{x_max}, $self->{y_min}, $self->{y_max}
    );

    my $x = 0;
    my $y = 0;
    foreach my integer_arrayref $row ( @{ $self->{mandelbrot_set} } ) {
        foreach my integer $pixel ( @{$row} ) {
            $app->[$x][$y] = [ 0, 0, 0, $pixel ]; # blue on black background
#            $app->[$x][$y] = [ 255, 255, $pixel, $pixel ]; # red on white background
            $x++;
        }
        $x = 0;
        $y++;
    }

# START HERE: enable text display; auto mode via $auto_moves
# START HERE: enable text display; auto mode via $auto_moves
# START HERE: enable text display; auto mode via $auto_moves

    my string $status = q{};
    my string $status_tmp;
    $status_tmp = ::number_to_string((MathPerl::Fractal::Mandelbrot->new()->X_SCALE_MAX() - MathPerl::Fractal::Mandelbrot->new()->X_SCALE_MIN()) / ($self->{x_max} - $self->{x_min}));
    if ($status_tmp !~ m/[.]/xms) { $status_tmp .= '.00'; }  # add 2 significant digits after decimal, if missing
    $status_tmp =~ s/([.]..).*/$1/xms;  # limit to exactly 2 significant digits after decimal
    $status .= 'Zoom:       ' . $status_tmp . 'x' . "\n";
    $status .= 'Iterations: ' . ::integer_to_string($self->{iterations_max}) . "\n";

    # NEED FIX: remove hard-coded font path
    SDLx::Text->new(
        font    => 'fonts/VeraMono.ttf',
        size    => 15,
        color   => [255, 255, 255],  # white text
#        color   => [0, 0, 0],  # black text
        text    => $status,
        x       => 10,
        y       => 10,
    )->write_to($app);

};

our void::method $move = sub {
    ( my MathPerl::Fractal::MandelbrotRenderer2D $self, my number $dt, my SDLx::App $app, my number $t ) = @_;

    my string_arrayref $auto_moves
        = [qw(up up up right right i i i right right i i up i i i i i i i i i i + i i down down + i i i i i i i i down down i i + i i i + down down left left i i i i + + up up i i i i i i i i i i i r)];

    if ( $self->{automatic} ) {

        # check for SPACE keystroke both in events() and here in move(), double keystroke checking is standard practice
        SDL::Events::pump_events();
        my $keys_ref = SDL::Events::get_key_state();
        if ( $keys_ref->[SDLK_SPACE] ) { $self->{automatic} = 0; }

        my number $x_zoom = ( $self->{x_max} - $self->{x_min} ) * $self->{zoom_factor};
        $self->{x_min} += $x_zoom;
        $self->{x_max} -= $x_zoom;
        my number $y_zoom = ( $self->{y_max} - $self->{y_min} ) * $self->{zoom_factor};
        $self->{y_min} += $y_zoom;
        $self->{y_max} -= $y_zoom;

        $self->mandelbrot_escape_time_render($app);    # only render additional frames when a change occurs
        $app->update();
    }
};

our void::method $render2d_video = sub {
    ( my MathPerl::Fractal::MandelbrotRenderer2D $self ) = @_;
    $self->mandelbrot_escape_time_render( $self->{app} );    # render first frame
    $self->{app}->update();

    $self->{app}->add_event_handler( sub { $self->events(@_) } );
    $self->{app}->add_move_handler( sub  { $self->move(@_) } );

    #    $self->{app}->add_show_handler( sub { $self->{app}->update() } );

    #    $self->{app}->fullscreen();
    $self->{app}->run();
};

1;    # end of class