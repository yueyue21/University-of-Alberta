package View;
use strict;
use warnings;

our $debug = 0;

=head1 New, SetView, X, Y

A view is a mapping from a Cartesian coordinate model system onto a canvas
drawing system.

The model uses normal (x,y) Cartesian coordinates, while the canvas uses the
normal screen coordinate system in which y increases in the downward direction.

To create a view and specify teh canvas dimensions do:

    my $view=View->New($canvas_width, $canvas_height);

then to establish the relationship to the model do

    $view->SetView($Xmin, $Ymin, $Xmax, $Ymax);

sets the region in the model that is mapped onto the canvas.

Then 
    $xv = $view->X($model_x);
    $yv = $view->Y($model_y);
    ($xv, $yv) = $view->XY($model_x, $model_y);


return the canvas coodinates of the model (x, y) in individual coorindate
or a pair form.
=cut

sub New  {
    # permit Class-> or $object-> form of constructor
    my $invocant = shift @_;
    my $Class = ref($invocant) || $invocant;

    my ($width, $height) = @_;

    # create the instance
    my $I = { };
    bless $I, $Class;

    # set the fields
    $I->{_xmin} =   0;
    $I->{_ymin} =   0;
    $I->{_xmax} =  $width;
    $I->{_ymax} =  $height;
    $I->{_xorigin} =  0;
    $I->{_yorigin} =  0;
    $I->{_xscale} =  1;
    $I->{_yscale} =  1;

    return $I;
    }

sub SetView {
    my ($I, $Xmin, $Ymin, $Xmax, $Ymax) = @_;
    
    $I->{_xorigin} = $Xmin;
    $I->{_yorigin} = $Ymin;
    
    $I->{_xscale} =
        ($I->{_xmax} - $I->{_xmin}) / ($Xmax - $Xmin);
    $I->{_yscale} =
        ($I->{_ymax} - $I->{_ymin})/ ($Ymax - $Ymin) ;
        
    $debug and
        print "viewport: $Xmin, $Ymin, $Xmax, $Ymax; ",
        join(", ", map {"$_ => " . $I->{$_}} sort(keys(%$I))),
        "\n";

    return;
    }

sub X {
    my ($I, $x) = @_;
    
    return $I->{_xmin} + (($x - $I->{_xorigin}) * $I->{_xscale});
    }

sub Y {
    my ($I, $y) = @_;
    
    # canvases draw increasing y downwards
    return $I->{_ymax} - (($y - $I->{_yorigin}) * $I->{_yscale});
    }

sub XY {
    my ($I, $x, $y) = @_;
    return ( $I->X($x), $I->Y($y) );
    }

1; # package end
