package Point;
use strict;
use warnings;

# create some overloaded operations between Point objects
use overload
      "-"    => \&minus,
      "+"    => \&plus,
      "*"    => \&scale,
      "bool" => \&bool;

sub New  {
    # permit Class-> or $object-> form of constructor
    my $invocant = shift @_;
    my $Class = ref($invocant) || $invocant;

    my ($x, $y) = @_;

    # create the instance
    my $I = { };
    bless $I, $Class;

    # set the fields
    $I->{_x} = $x;
    $I->{_y} = $y;

    return $I;
    }

sub GetX { return $_[0]->{_x}; }
sub GetY { return $_[0]->{_y}; }
sub SetX { my ($I, $v) = @_; $I->{_x} = $v; }
sub SetY { my ($I, $v) = @_; $I->{_y} = $v; }

sub GetXY { 
    my $I = shift @_; 
    return ( $I->GetX(), $I->GetY() );
}

sub SetXY { 
    my ($I, $x, $y) = @_;
    $I->SetX($x);
    $I->SetY($y);
    return $I;
}

sub plus {
    my ($u, $v) = @_;
    return Point->New ( 
        $u->GetX() + $v->GetX(),
        $u->GetY() + $v->GetY()
    );
}

sub minus {
    my ($u, $v) = @_;
    return Point->New ( 
        $u->GetX() - $v->GetX(),
        $u->GetY() - $v->GetY()
    );
}

sub scale {
    my ($u, $c) = @_;
    return Point->New ( 
        $c * $u->GetX(),
        $c * $u->GetY()
    );
}

sub bool { return defined( $_[0] ); }

sub incr {
    my ($I, $v) = @_;
    $I->SetX($I->GetX() + $v->GetX() );
    $I->SetY($I->GetY() + $v->GetY() );
    return $I;
}

sub decr {
    my ($I, $v) = @_;
    $I->SetX($I->GetX() - $v->GetX() );
    $I->SetY($I->GetY() - $v->GetY() );
    return $I;
}

# rotate point $I counter clockwise around point $v by $cosphi, $sinphi 
sub rotate {
    my ($I, $v, $cosphi, $sinphi) = @_;
    my $dx = $I->GetX() - $v->GetX();
    my $dy = $I->GetY() - $v->GetY();

    $I->SetX( $v->GetX() + $dx * $cosphi - $dy * $sinphi );
    $I->SetY( $v->GetY() + $dx * $sinphi + $dy * $cosphi );

    return $I;
    }

sub string {
    my ($I) = @_;
    return 
        "(" . 
        ( defined($I->GetX()) ? sprintf("%6.2f", $I->GetX()) : 'undef' ) . 
        ", " .
        ( defined($I->GetY()) ? sprintf("%6.2f", $I->GetY()): 'undef' ) . 
        ")";
    }


1; # package end
