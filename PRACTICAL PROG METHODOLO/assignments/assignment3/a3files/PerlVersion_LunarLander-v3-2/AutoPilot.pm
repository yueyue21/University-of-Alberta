package AutoPilot;
use strict;
use warnings;
#use diagnostics;

=head1 Lunar Lander Autopilot

This autopilot is called on every step of the lunar lander simulation.  It
can talk to the environment to obtain state information, and then is allowed
to issue a small number of course correction commands before returning.

The lander world takes the surface of the moon and maps it onto a rectangular
region.  On the x-axis, the lander will wrap around when it hits either the
left or right edge of the region.  On the y-axis it will not go below 0, but if
the lander is going fast enough it will go below the surface of the terrain.

The y-axis has normal gravitational physics, except when the lander starts to
get near the top edge of the world.  Then things get weird, it will stick at
the top of the world, even though the lander still has a vertical velocity.

=head2 Space and Lander Characteristics

The lander world is a square region with  a lower left corner at (-800,0) and
an upper right corner at (800, 1600).  These dimensions can be obtained with
the call
    my ($x_min, $y_min, $x_max, $y_max) = main::GetSpaceBoundaries();

The lander is 60 units wide, and 50 units high.  The x position is in the
center of the x axis.  The y position is at the midpoint of the y axis,
i.e. 25 units above the base of the lander legs.  These dimensions can be
obtained with the call
    my ($lander_width, $lander_height, $center_x, $center_y) =
        main::GetLanderDimensions();
which return the width and heigt of the lander, and the position of the
center relative to the lower left corner of the lander bounding box.  I.e.
for the default lander main::GetLanderDimensions() would return
    (60, 50, 30, 25)

=head2 Lander Measurement Methods

To obtain information about the current environment, the simulator provides the 
following functions:

The gravity in the vicinity of the lander is obtained by
    my $g = GetGravity();
In principle this could vary in a more sophisticated simulation.

To obtain the thrust exerted by the engine when fired, use
    my $thrust = GetEngineThrust();
In principle this could vary as the fuel load changes.

The simulation has a real time clock, in units, that is updated every 
simulation cycle.  If the similation is reset, the clock is reset to 0
    my $time = main::GetTime();

Obtain the target landing zone that the lander is supposed to land at:

    $target_x = main::GetTargetLandingZoneX();

which returns

    the string "any" if any safe landing site will do

    a number x if the desired landing site has the given x-coordinate.
    Note: no guarantee that x is actually a safe spot to land!

Obtain the remaining amount of fuel in the lander:

    $fuel = main::GetFuel();

Obtain the current position and velocity:

    ($px, $py, $attitude, $vx, $vy, $speed) = main::GetLanderState();

where
    $px - x position in the world, typically [-800, 800]
    $py - y position in the worlds, typicalll [0, 1600]
    $attitude - current attitude angle of lander body in unit degrees, 
    from y axis, where
        0 is vertical,
        > 0 is to left (counter clockwise)
        < 0 is to the right (clockwise)
    $vx - x velocity in m / sec  (< 0 is to left, > 0 is to right)
    $vy - y velocity in m / sec  (< 0 is down, >0 is up)
    $speed - m /sec, where $speed == sqrt($vx*$vx + $vy*$vy)

Obtain the current state of the terrain below the lander

    ($x0, $y0, $x1, $y1, $slope, $crashSpeed, $crashSlope) =
        main::GetTerrainInfo();
where
    ($x0, $y0) coordinate of the left edge of terrain segment
    ($x1, $y1) coordinate of the right edge of terrain segment
    $slope     left to righ slope of the segment (rise/run)
    $crashSpeed maximum landing speed to prevent a crash
    $crashSlope maximum ground slope to prevent a crash

NOTE: if there is no terrain under the lander, then main::GetTerrainInfo will
return an empty list.  This is possible if you have a floating island in the
sky!

=head2 Lander Control Methods

To control the lander you can make any of the following calls:

Rotate the lander 1 deg counter clock wise
    main::RotateCCW();  

Rotate the lander 1 deg clock wise
    main::RotateCW();

Fire one burst of the main engine, consuming one unit of fuel.
    main::FireMainEngine();

During any given invocation of autopilot you can make multiple calls of these 3
functions, just don't make too many (less than 30 is good). If you make too
many calls the simulation will slow down - it assume that calls to the
autopilot are cheap.

For example if you want to rotate 10 degrees clockwise, call
main::RotateCW() 10 times.  If you want a double burst of thrust
call main::FireMainEngine() twice.

=head2 Debugging interface

To control the output of debugging information, the simulator provides
this function to access the autopilot debug switch:
    $debug = main::GetAutopilotDebug();

=head1 Autopilot Interface from Simulator

When the simulation is initialized, AutoPilot::Initailize() is called.
When the autopilot is turned on by the simulator AutoPilot::On() is called.
When the autopilot is turned off by the simulator AutoPilot::Off() is called.
Every clock tick, AutoPilot::DoLanding() is called by the simulator.

=cut

# if you want to keep data between invocations of DoLanding, put
# the data in this part of the code.  Use Initialize() to handle simulation
# resets.

my $call_count = 0;
my $status = "off";

sub Initialize {
    $call_count = 0;
    $status = "off";
    }

sub On {
    $status = "on";
    }

sub Off {
    $status = "off";
    }

sub DoLanding {
    
    my $debug = main::GetAutopilotDebug();

    # fetch and update historical information
    $call_count++;
    
    my $target_x = main::GetTargetLandingZoneX();
    
    my $fuel = main::GetFuel();
    my ($px, $py, $attitude, $vx, $vy, $speed) =
        main::GetLanderState();

    my @terrain_info = main::GetTerrainInfo();

    if ( ! @terrain_info ) {
        # hmm, we are not above any terrain!  So do nothing.
        return;
        }

    my ($x0, $y0, $x1, $y1, $slope, $crashSpeed, $crashSlope) =
        @terrain_info;

    if ( $debug ) {
        printf "%5d ", $call_count;
        printf "%5s ", $target_x;
        printf "%4d, (%6.1f, %6.1f), %4d, ",
            $fuel, $px, $py, $attitude;
        printf "(%5.2f, %5.2f), %5.2f, ",
            $vx, $vy, $speed;
        printf "(%d %d %d %d, %5.2f), %5.2f, %5.2f\n",
          $x0, $y0, $x1, $y1, $slope, $crashSpeed, $crashSlope;
    }

    # reduce horizontal velocity
    if ( $vx < -1 && $attitude > -90 ) {
        # going to the left, rotate to right, but not past -90!
        main::RotateCW();
    } elsif ( 1 < $vx && $attitude < 90 ) {
        # going to the right, rotate to the left, but not past 90
        main::RotateCCW();
    }
  
    # update our physics info
    ($px, $py, $attitude, $vx, $vy, $speed) =
        main::GetLanderState();
        
        
    if ( abs($vx) < 3 ) {
        # make sure we are vertical - beware of an infinite
        # loop here, so only allow a few commands
        for (my $i=0; (abs($attitude) > 3) && $i < 50; $i++ ) {      

            main::RotateCCW() if $attitude < 0;
            main::RotateCW() if $attitude > 0;
            
            ($px, $py, $attitude, $vx, $vy, $speed) =
            main::GetLanderState();
        }
    }

    # reduce vertical velocity
    if ( $vy < -$crashSpeed + 10 ) {
        main::FireMainEngine();
    }
}

1; # package ends
