use strict;
use warnings;
use FindBin;

=head1 Lunar Lander

    A Lunar Lander Video game written in Perl/Tkx.

    perl lander.pl -h 

    will display help information.

=cut

# obtain modules from same directory that executable is in
use lib ($FindBin::Bin);

use Tkx;
# $Tkx::TRACE = 1;

use Getopt::Std;
use Math::Trig;

use Point;
use View;

# Autopilot interface is provided by an external module
use AutoPilot;

# see if AutoPilot has extension methods that we can call
my $AP_can_On = AutoPilot->can("On");
my $AP_can_Off = AutoPilot->can("Off");
my $AP_can_Initialize = AutoPilot->can("Initialize");

my $debug = 0;
my $autopilot_debug = 0;

my $version = "3.1, 2008-11-23";

# graphics canvas dimensions and coloration
my $width         = 400;
my $height        = 300;
my $background    = 'blue';
my $fill          = 'yellow';

# actual dimensions of the simulation environment
# the world goes from $x_min to $x_max, $y_min 0 up to $y_max
my $x_min     = -800; 
my $y_min     = 0;
my $x_max     = 800;
my $y_max     = 1600;

# default values for initial conditions
my $fuel_def = 100;
my $initialX_def = -400;
my $initialY_def = 500;
my $engine_thrust_def = 5;
my $initialVX_def = 0;
my $initialVY_def = 0;
my $gravity_def = 1.62;

# time delay between simulation steps
my $pause_time = 100;

# Lunder Lander State Variables

# force of gravity vector, always down
my $gravity;
# basic thrust vector of engine, rotated to take into account current
# orientation of lander.  A Point object
my $engine_thrust;

# initial lander position (center of gravity) in simulation coordinates
# as a Point object
my $LanderPosition;
# current velocity and acceleration vectors for lander, Point objects
my $LanderVelocity;
my $LanderAccel;

# lander dimensions, relative to 0,0 in lower left corner
my $lander_width = 60;
my $lander_height = 50;
my $lander_center_x = 30;
my $lander_center_y = 10;

# current attitude angle in degrees, from Y axis
# 0 is vertical,
# > 0 is to left (counter clockwise)
# < 0 is to the right (clockwise)
my $attitude = 0;

# current amount of fuel in terms of units of main engine firings
my $fuel;

# time per simulation cycle
my $delta_t = 1.0;  # 1 second
# current simulation time in $delta_t * clock ticks
my $simulation_time = 0;

# true when touched ground, false when in air
my $touched;

# safe landing maximums
my $crashSpeed       = 13.0;
my $crashSlope       = 0.2;

# target landing zone x coordinate
my $target_x = "any";

# true when autopilot is in control (you can still override)
my $autopilot_active = 1;

# a default terrain,
# the last and first points do not need to be the same, you can have a 
# floating island in space

my @Terrain = (
    Point->New(  -800,   20 ), 
    Point->New(  -600,   75 ),
    Point->New(  -500,   50 ), 
    Point->New(  -400,   50 ), 
    Point->New(  -300,  100 ), 
    Point->New(  -100,    0 ), 
    Point->New(   100,    0 ), 
    Point->New(   150,   75 ), 
    Point->New(   250,   75 ), 
    Point->New(   400,  300 ), 
    Point->New(   450,  100 ),
    Point->New(   500,   40 ), 
    Point->New(   800,   20 ), 
);

# slope of each line segment in the terrain
my @TerrainSlope = ();

# points that describe the lander
my @Lander = ();

# list of all the Tkx graphics objects that make up the lander image
my @lander_lines = ();
# line that describes the flame
my $flame_line = 6;
# object that is the flame
my $flame_object = 0;

my %opts         = ();
getopts( 'W:H:T:b:f:F:g:x:y:X:Y:a:c:s:l:S:d:D:p:h:v', \%opts );
if( exists $opts{d} ) { $debug     = $opts{d}; }
if( exists $opts{W} ) { $width     = $opts{W} ; }
if( exists $opts{H} ) { $height     = $opts{H} ; }
if( exists $opts{T} ) { ReadTerrain($opts{T}) ; }
if( exists $opts{b} ) { $background     = $opts{b} ; }
if( exists $opts{f} ) { $fill         = $opts{f} ; }
if( exists $opts{c} ) { $crashSpeed     = $opts{c}; }
if( exists $opts{s} ) { $crashSlope     = $opts{s}; }
if( exists $opts{l} ) { $target_x     = $opts{l}; }
if( exists $opts{D} ) { $autopilot_debug     = $opts{D}; }
if( exists $opts{p} ) { 
    $pause_time     = $opts{p} if $opts{p} > 1;
    }
if( exists $opts{h} ) { usage(); exit;}
if( exists $opts{v} ) { print "Version: $version\n"; exit;}



my $mw = Tkx::widget->new(".");
$mw->g_wm_title("Lunar Lander");

my $can = $mw->new_canvas(
    -width => $width,
    -height=> $height,
    # -scrollregion => [0,$height,$width,0],
    -background => $background,
    );

$can->g_pack(
    -expand => 0,
    );

my $pi        = 4 * atan(1.0);

# divide the circle into 1 degree intervals
my $attitude_resolution = 360;
my $phi     = 2 * $pi/$attitude_resolution;

my $cosphi     = cos ( $phi );
my $sinphi     = sin ( $phi );

# map from model coordinate onto the drawing canvas
my $vp     = View->New($width, $height);

# mape the keyboard events into simulation primatives

$mw->g_bind( '<Key-k>',  \&FireMainEngine );
$mw->g_bind( '<Key-l>',  \&RotateCW );
$mw->g_bind( '<Key-j>',  \&RotateCCW );
$mw->g_bind( '<Key-r>',  \&RestartGame );
$mw->g_bind( '<Key-q>',  \&Quit );
$mw->g_bind( '<Key-a>',  \&AutoPilotOn );
$mw->g_bind( '<Key-s>',  \&AutoPilotOff );

# set up window
InitializeLander();
DrawTerrain();
ScheduleNextSimulation();

# start the game
Tkx::MainLoop;


#
#   Autopilot Interface
#


sub GetTargetLandingZoneX {
    # returns
    # string "any" if any safe landing site will do
    # number x if that the desired landing site has the given x-coordinate.

    return $target_x;
    }

sub GetAutopilotDebug {
    return $autopilot_debug;
    }

sub GetSpaceBoundaries {
    # return (x_min, y_min, x_max, y_max) the boundaries of the space region
    # lower left (x_min, y_min) and upper right (x_max, y_max)
    return ($x_min, $y_min, $x_max, $y_max);
    }

sub GetTime {
    return $simulation_time;
    }

sub GetGravity {
    return $gravity->GetY();
    }

sub GetEngineThrust {
    return $engine_thrust->GetY();
    }

sub GetLanderDimensions {
    return ($lander_width, $lander_height, $lander_center_x, $lander_center_y);
    }


sub GetLanderState {
    # return (x,y) position, angle of lander in degrees
    # 0 if upright, > 0 is to left, < 0 is to right
    # (x, y) velocity and net speed.
    
    my ($px, $py) = $LanderPosition->GetXY;
    
    my ($vx, $vy) = $LanderVelocity->GetXY();
    
    my $speed = sqrt($vx*$vx + $vy*$vy);
    
    return ($px, $py, $attitude, $vx, $vy, $speed);
}

sub GetFuel {
    # how much fuel is left as the number of remaining main
    # engine firings
    return $fuel;
}


sub GetTerrainInfo {
    
    # returns data about the terrain immediately below the lander
    # end points of terrain segment, it's slope, and allowable
    # speed and slope to prevent a crash.

    # this is not quite correct, since it assumes no caves and you are actually
    # above the terrain!

    my ($px, $py) = $LanderPosition->GetXY();

    my ($x0, $y0) = $Terrain[0]->GetXY();
    my ($x1, $y1);

    my $seg;
    my $found = 0;
    # find what terrain segment the lander lies on (between what two points)
    GROUND: for ($seg = 0; $seg < @Terrain-1; $seg++) {

        ($x1, $y1) = $Terrain[$seg+1]->GetXY();
   
        if ( ($x0 <= $px) && ($px <= $x1) ) {
            $found = 1;
    last GROUND;
            }

        ($x0, $y0) = ($x1, $y1);
        }

    # no terrain below us, so return empty list.
    return () unless $found;
        
    my $slope = $TerrainSlope[$seg];
    
    return ($x0, $y0, $x1, $y1, $slope, $crashSpeed, $crashSlope);
    }

#
#   Simulator Methods
#


sub ScheduleNextSimulation {
    Tkx::after($pause_time, \&SimulatOneStep);
    }

sub CancelNextSimulation { 
    # remove next simulation events from queue
    my @l = Tkx::SplitList( Tkx::after_info() );
    print "Cancelling events @l\n";
    foreach my $e ( @l ) {
        Tkx::after_cancel($e);
        }
    }
    
sub SimulatOneStep {
    # if the restart event has occurred, stop playing current 
    # game, and initialize.  We have to process the restart here because 
    # we have a pending timer event for Play that has to be processed.

    # thruster is off after every simulation cycle
    HideThrusterFlame();

    $simulation_time += $delta_t;

    # simulation stops if landed or crashed
    return if $touched;

    my $rc = CheckLanded();
    if ( $rc == 0 ) {
        # not in contact with terrain, keep moving
        MoveLander();
        ScheduleNextSimulation();
        }
    elsif ( $rc < 0 ) {
        DrawCrash();

        $fuel = 0 if $fuel < 0;
        printf "Fuel = %6.2f\n", $fuel;
        print "CRASH!\n";

        $touched = 1;
    } else {
        printf "Fuel = %6.2f\n", $fuel;
        print "The eagle has landed!\n";

        $touched = 1;
        }
    }

sub RotateLanderClockwise {
    foreach my $v ( @Lander ) {
        $v = $v->rotate( $LanderPosition, $cosphi, -$sinphi );
        }
    $engine_thrust = $engine_thrust->rotate(
        Point->New(0, 0), $cosphi, -$sinphi);
    
    $attitude--;
    if ( $attitude <= - $attitude_resolution / 2 ) {
        $attitude = $attitude + $attitude_resolution;
        }
    }

sub RotateLanderCounterClockwise {
    foreach my $v ( @Lander ) {
        $v = $v->rotate( $LanderPosition, $cosphi, $sinphi );
        }
       
    $engine_thrust = $engine_thrust->rotate(
            Point->New(0, 0), $cosphi, $sinphi);
    
    $attitude++;
    if ( $attitude > $attitude_resolution / 2 ) {
        $attitude = $attitude - $attitude_resolution;
        }
    }

sub MoveLander {
    # The Physics: after one time unit (1 sec)
    #     x[t+1] = x[t] + v[t] * t + 1/2 * a[t] * t**2
    #     v[t+1] = v[t] + a * t 
    #       a  = gravity + engine thrust for this time interval
    
    if ($debug & 1 ) {
        print "move: p ", $LanderPosition->string(), 
                   " v ", $LanderVelocity->string(),
                   " a ", $LanderAccel->string(), 
                   " angle ", $attitude,
                   " thrust ", $engine_thrust->string(),
                   "\n";
        }

    # update lander position
    my $u = $LanderVelocity * $delta_t +
            $LanderAccel *  0.5 * $delta_t * $delta_t;
    foreach my $v ( @Lander ) {
        $v->incr( $u );
        }
    $LanderPosition->incr( $u );

    # update velocity by 1 second of time
    my $deltav = $LanderAccel * $delta_t;
    $LanderVelocity->incr ( $deltav );
   
    # reset acceleration to just gravity
    $LanderAccel->SetXY( $gravity->GetXY() );
  
    my ($px, $py) = $LanderPosition->GetXY;
    
    # if falls off end of simluation region, wrap around
    if($px < $x_min ){
        my $delta = $x_max - $x_min;
        foreach my $p (@Lander) {
            $p->SetX( $p->GetX() + $delta);
            }
        $LanderPosition->SetX( $LanderPosition->GetX() + $delta);
        }
    elsif($px > $x_max){
        my $delta =  $x_min - $x_max;
        foreach my $p (@Lander) {
            $p->SetX( $p->GetX() + $delta);
            }
        $LanderPosition->SetX( $LanderPosition->GetX() + $delta);
        }
    
    # if it falls off the bottom or top, make it stick there, and kill the
    # y velocity and acceleration component
    if ( $py < $y_min + $lander_center_y ) {
        my $delta =  $y_min + $lander_center_y - $py;
        foreach my $p (@Lander) {
            $p->SetY($p->GetY() + $delta);
            }
        $LanderPosition->SetY( $LanderPosition->GetY() + $delta);
        $LanderVelocity->SetY( 0 );
        $LanderAccel->SetY( 0 );
        }
    elsif ( $py > $y_max - $lander_height ) {
        my $delta =  $y_max - $lander_height - $py;
        foreach my $p (@Lander) {
            $p->SetY($p->GetY() + $delta);
            }
        $LanderPosition->SetY( $LanderPosition->GetY() + $delta);
        $LanderVelocity->SetY( 0 );
        $LanderAccel->SetY( 0 );
        }

    DrawLander();

    AutoPilot::DoLanding() if
        $autopilot_active  && $fuel > 0 && !$touched;
           
    }

sub InitializeLander {

    $fuel            = $fuel_def;
    $LanderPosition  = Point->New($initialX_def, $initialY_def);
    $LanderVelocity  = Point->New($initialVX_def, $initialVY_def);

    $engine_thrust   = Point->New(0, $engine_thrust_def);
    $gravity         = Point->New(0, -$gravity_def);
    $LanderAccel    = Point->New(0, 0);
  
    if( exists $opts{F} ) { $fuel = $opts{F} ; }
    if( exists $opts{x} ) { $LanderPosition->SetX($opts{x}); }
    if( exists $opts{y} ) { $LanderPosition->SetY($opts{y}); }
    if( exists $opts{g} ) { $gravity->SetY (-$opts{g}) ; }
    if( exists $opts{a} ) { $engine_thrust->SetY ($opts{a}) ; }
    if( exists $opts{X} ) { $LanderVelocity->SetX ($opts{X}) ; }
    if( exists $opts{Y} ) { $LanderVelocity->SetY ($opts{Y}) ; }
    
    # The lander is 60 units wide and 50 units high.  
    # x position is in the middle of the lander width, 
    # y position is in the middle of the lander height
    my ($initialX, $initialY) = $LanderPosition->GetXY();

    @Lander = (
        Point->New(-30 + $initialX,   0 + $initialY), #pt 0
        Point->New(-20 + $initialX,   0 + $initialY), #pt 1
        Point->New(-25 + $initialX,   0 + $initialY), #pt 2
        Point->New(-20 + $initialX,  10 + $initialY), #pt 3
        Point->New(-10 + $initialX,  20 + $initialY), #pt 4
        Point->New( 10 + $initialX,  20 + $initialY), #pt 5
        Point->New( 20 + $initialX,  10 + $initialY), #pt 6
        Point->New( 25 + $initialX,   0 + $initialY), #pt 7
        Point->New( 20 + $initialX,   0 + $initialY), #pt 8
        Point->New( 30 + $initialX,   0 + $initialY), #pt 9
        Point->New( 25 + $initialX,  30 + $initialY), #pt 10
        Point->New( 25 + $initialX,  40 + $initialY), #pt 11
        Point->New( 10 + $initialX,  50 + $initialY), #pt 12
        Point->New(-10 + $initialX,  50 + $initialY), #pt 13
        Point->New(-25 + $initialX,  40 + $initialY), #pt 14
        Point->New(-25 + $initialX,  30 + $initialY), #pt 15
        Point->New(  0 + $initialX, -40 + $initialY), #thruster flame pt 16
        # Point->New(  0 + $initialX,  25 + $initialY), #center of gravity pt 17
    );
        
    # not touched down on terrain
    $touched = 0;
    $attitude  = 0;

    # simulator clock
    $simulation_time = 0;
    
    # initial acceleration is just gravity
    $LanderAccel->SetXY( $gravity->GetXY() );
    
    $vp->SetView($x_min, $y_min, $x_max, $y_max);

    DeleteCrash();
    DrawLander();

    $AP_can_Initialize and AutoPilot::Initialize();

    AutoPilotOn();
}

sub DeleteCrash {
    $can->delete( 'Crash' );
    }

sub DrawCrash {
    my ($px, $py) = $vp->XY( $LanderPosition->GetXY );

    for ( my $radius = 20; $radius < 60; $radius+=10) {
        my $crash_object = 
        $can->create_oval($px-$radius, $py-$radius, $px+$radius, $py+$radius,
            # -fill => 'red',
            -outline => 'red',
            -width => 3,
            -tag => 'Crash',
            );
        }
    }

sub GetSpeed {
    return sqrt( $LanderVelocity->GetX() * $LanderVelocity->GetX() +
                 $LanderVelocity->GetY() * $LanderVelocity->GetY() );
    }

sub CheckLanded {

    # get the bounding box of the lander and indicate what other objects 
    # overlap with it.

    my @l1 = Tkx::SplitList($can->find_overlapping(
            Tkx::SplitList($can->bbox("Lander"))));

    if ( $debug & 4 ) {
        print "Lander overlaps object ids @l1\n";
        print "Tags are:\n";
        }

    # now determine which terrain segments intersect with the lander
    my $hit_terrain = 0;
    my @segment_nums;

    foreach my $oid ( @l1 ) {
        my @l2 = Tkx::SplitList($can->gettags($oid));

        if ( $debug & 4 ) {
            print "tags of object $oid are: @l2\n";
            }

        foreach my $tag ( @l2 ) {
            # extract segment num from tag
            if ( $tag =~ /^Terrain_(.+)$/ ) {
                $hit_terrain = 1;
                push @segment_nums, $1;
                }
            }
        }

    # no contact with terrain, keep flying
    return 0 unless $hit_terrain;

    # obtain the slope of the each line segment encountered and
    # check that every one is within acceptable limits

    print "Lander has intersected terrain\n";

    # assume landing ok, check if meet constraints
    my $result = 1;

    # get landing stats
    my ($px, $py, $attitude, $vx, $vy, $speed) = GetLanderState();

    printf 
    "Landing position (center of lander) is (%6.2f, %6.2f), attitude %6.2f\n", 
        $px, $py, $attitude;

    printf "Landing vx is %6.2f, vy is %6.2f, speed is %6.2f\n", 
        $vx, $vy, $speed;

    foreach my $seg ( @segment_nums ) {
        my $slope = $TerrainSlope[$seg];

        print "Contact with segment $seg, from\n", 
            $Terrain[$seg]->string(), 
            " to ",
            $Terrain[$seg+1]->string(), 
            "\n";
        printf "with slope %6.2f\n", $slope;

        if ( abs($slope) > $crashSlope ) {
            printf "Segment $seg exceeds maximum landing slope %6.2f\n",
                $crashSlope;
            $result = -1;
            }
        }

    AutoPilotOff();
    HideThrusterFlame();
       
    if ( $speed >= $crashSpeed ) {
        printf "Speed %6.2f exceeds maximum landing speed %6.2f\n",
            $speed, $crashSpeed;
        $result = -1;
        }

    return $result;
    }

sub DrawThrusterFlame {
    $flame_object = drawLanderLine($flame_line, 4, 16, 5);

    $can->itemconfigure($flame_object, 
        '-state' => 'normal',
        '-width' => 5,
        '-fill' => 'orange',
        );    

    ($debug & 2 ) and
        print "Flame on, object line $flame_line, id $flame_object\n";

}

sub HideThrusterFlame {
    if ( $flame_object ) {
        $can->itemconfigure($flame_object, '-state' => 'hidden');    

        ($debug & 2 ) and
            print "Flame off, object line $flame_line, id $flame_object\n";
        }
    }

sub ReadTerrain {
    my ($file_name) = @_;

    open(LAND, "<$file_name") ||
        die "Cannot open landscape file name '$file_name'";

    @Terrain = ();
    while ( my $line = <LAND> ) {
        my ($x, $y) =  split(/\s+/, $line);
        ( $debug & 8 ) and 
            print "Input '$x' '$y'\n";
        push @Terrain, Point->New( $x, $y);
        }

    if ( $debug & 8 ) {
        print "Terrain points:\n";
        foreach my $p ( @Terrain ) {
            print $p->string(), "\n"; 
            }
        }
    }

sub ComputeTerrainSlope {
    @TerrainSlope = ();

    return unless @Terrain;

    my ($x0, $y0) = $Terrain[0]->GetXY();

    for (my $seg = 1; $seg < @Terrain; $seg++ ) {

        my ($x1, $y1) = $Terrain[$seg]->GetXY();

        my $slope;
        if ( abs($x1-$x0) > 0.0001 ) {
            $slope = ($y1 - $y0)/($x1 - $x0);
            }
        else {
            $slope = 10000;
            }

        push @TerrainSlope, $slope;

        ($x0, $y0) = ($x1, $y1);
        }
    }

sub DrawTerrain {
    # delete any existing terrain
    $can->delete( 'Terrain' );

    ComputeTerrainSlope();

    # each segment becomes a line.  All segments are tagged with
    # tags Terrain and Terrain_n where n is the segment number
    
    for (my $i=0; $i < @Terrain-1; $i++) {

        $can->create_line(
            $vp->X($Terrain[$i]->GetX()),
            $vp->Y($Terrain[$i]->GetY()),
            $vp->X($Terrain[$i+1]->GetX()),
            $vp->Y($Terrain[$i+1]->GetY()),
            -fill => $fill,
            -tag  => [ 'Terrain', "Terrain_$i" ],
            );
        }
    }


sub drawLanderLine {
    my ($line_num, @indexes) = @_;

    my $object_id;

    # obtain the list of coordinates
    my @coords;

    if ($debug & 2) {
        if ( defined($lander_lines[$line_num]) ) {
            print "Updating ";
            }
        else {
            print "Creating ";
            }
        print "Lander line $line_num: @indexes\n";
        }

    foreach my $i ( @indexes ) {
        push @coords, 
            $vp->X($Lander[$i]->GetX()),
            $vp->Y($Lander[$i]->GetY());
        }

    if ( $debug & 2 ) {
        print "Coords:";
        print map { sprintf(" %7.2f", $_) } @coords;
        print "\n";
        }

    if ( ! defined($lander_lines[$line_num]) ) {
        # create a new line and remember it
        $lander_lines[$line_num] = 
            $can->create_line(@coords,
                -fill => $fill,
                # -fill => 'red',
                -tag  => 'Lander'
                );
        if ( $debug & 2 ) {
            print "Created Line object id: $lander_lines[$line_num]\n";
            }
        }
    else {
        # update the existing line
        if ( $debug & 2 ) {
            print "Updating Line object id: $lander_lines[$line_num] from:";
            print $can->coords($lander_lines[$line_num]);
            print "\n";
            }
        $can->coords($lander_lines[$line_num], 
            @coords);
        }

    $object_id = $lander_lines[$line_num];

    if ( $debug & 2 ) {
        print "Line object id: $object_id\n";
        }

    return $object_id;
    }

         
sub DrawLander {
    my $line_num = 0;
    drawLanderLine($line_num, 0, 1);
    $line_num++;
    drawLanderLine($line_num, 2, 3, 4, 5, 6, 7);
    $line_num++;
    drawLanderLine($line_num, 8, 9);
    $line_num++;
    drawLanderLine($line_num, 5, 10, 11, 12, 13, 14, 15, 4);
    }

# Basic simulation primatives that are bound to the GUI keyboard

sub RestartGame { 
    # to restart the game, remove all scheduled simluation events from 
    # the event queue, and then initialize.
    print "Restart Game\n";
    CancelNextSimulation(); 
    InitializeLander();
    ScheduleNextSimulation();
}

sub FireMainEngine { 
    #Draw Thruster Flame
    if ( $fuel-- > 0 ) {
        DrawThrusterFlame();
        $LanderAccel->incr( $engine_thrust );
    } else {
        HideThrusterFlame();
        print "Out of gas!!!!\n";
    }
}

sub RotateCCW { # Rotate counter clockwise
    RotateLanderCounterClockwise();
}

sub RotateCW { # Rotate clockwise
    RotateLanderClockwise();
}


sub AutoPilotOn { # autopilot on
    $autopilot_active = 1;
    $AP_can_On and AutoPilot::On();
}

sub AutoPilotOff { # autopilot off
    $autopilot_active = 0;
    $AP_can_Off and AutoPilot::Off();
}

sub Quit { # Quit
    exit;
}

sub usage {
print <<USAGE
Lunar Lander Game

perl lander.pl [options] ...

Options:
    -W <canvas width>    Default is $width
    -H <canvas height>    Default is $height
    -T <terrain file>   Terrain, see below
    -b <background color>    Default is $background
    -f <foreground color>    Default is $fill
    -F <fuel>        Default is $fuel_def
    -x <initial x position>    Default is $initialX_def
    -y <initial y position>    Default is $initialY_def
    -g <gravity>        Default is $gravity_def
    -a <engine thrust>    Default is $engine_thrust_def
    -X <initial X velocity> Default is $initialVX_def
    -Y <initial Y velocity> Default is $initialVY_def
    -c <crash velocity>     Default is $crashSpeed
    -s <landing slope tolerance> Default is $crashSlope
    -l <target landing zone x coordinate>     Default is $target_x,
        the string 'any' means any safe spot will do.
    -d <debug value>  Set lander debug switch. Default is $debug
    -D <debug value>  Set autopilot debug switch. Default is $autopilot_debug
    -p <clock pause value> Delay between visual update of simulation steps, 
       reduce to get a faster simulation but with the same physics, i.e. 
       simulation time is unchanged.  Default is $pause_time
    -h print this message
    -v print version

    The terrain file consists of lines of pairs of (x, y) points that range from
    the left edge (-800, 0) of the terrain to the right edge (+800, 0)
    
    The lander world is a square region from the lower left ($x_min, $y_min) to
    upper right ($x_max, $y_max).  The lander will wrap around when it hits 
    either the left or right edge.  It will not go below 0 on the y axis, but 
    if going fast enough it will go below the terrain.  As the lander rises, if
    it starts to get near the edge of the screen the display will be rescaled 
    (unless -S is chosen above).  At some point it will simply stick to the
    top, but the vertical velocity will not be diminished.

    Values for the debug switch (bitmask)
    1 - display current state information: position, velocity, acceleration
    2 - display graphic drawing information
    4 - display terrain intersection information
    8 - display terrain file load information

How to play:

    First: Make sure that you click the mouse in the lander window in order
    to set focus to the window and ensure that the key presses you make are 
    sent to the lander.

    pressing 'a' turns on autopilot
    pressing 's' turns off autopilot

    pressing 'k' fires main thruster.
    pressing 'j' rotates lander counter-clockwise
    pressing 'l' rotates lander clockwise
    pressing 'r' restarts the game.
    pressing 'q' stops the game.

    Place     g in m/sec2  
    -----    -----------
    Moon             1.62
    Mercury         3.58
    Venus             8.87
    Earth        9.8
    Mars             3.74
    Jupiter        26.01
    Saturn         11.17
    Uranus         10.49
    Neptune        13.25
    Pluto           0.73
    
Try the autopilot with:
    perl lander.pl -F 1000 -x -400 -y 1000 -X 50 -Y 10

USAGE
}
