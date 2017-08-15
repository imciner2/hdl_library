# waveStatistics.tcl
# This TCL script runs in ModelSim and will analyze a given signal in the simulation
# to record the high and low times. It then performs statistics on the recorded times.
#
# Note: To set the variable to do the stats for run
#   set statsSignal /path/to/signal       -- This signal is the one analyzed

# The stats variables
set high_avg 0
set high_lst 0
set high_cnt 0

set low_avg 0
set low_lst 0
set low_cnt 0

set prev_time $Now

echo "Loading wave statistics script"

# Run this whenever the signal goes to 1
echo "Creating event handler for rising edge of " $statsSignal
when -label stats_rising_watch "$statsSignal = '1'" {
  # Figure out the time since the last transition
  set lastTime [subTime $Now $prev_time]

  # Add the value to the list
  if {$low_lst == 0} {
    set low_lst [list $lastTime]
  } else {
    lappend low_lst $lastTime
  }

  # Compute the average time
  if { [eqTime $low_avg [RealToTime 0.0]] } {
    set low_avg $lastTime
  } else {
    set low_avg [scaleTime [addTime $low_avg $lastTime] 0.5]
  }

  # Store this edge time
  set prev_time $Now

  # Increment the edge counter
  set high_cnt [expr $high_cnt+1]
}

# Run this whenever the signal goes to 0
echo "Creating event handler for falling edge of " $statsSignal
when -label stats_falling_watch "$statsSignal = '0'" {
  # Figure out the time since the last transition
  set lastTime [subTime $Now $prev_time]

  # Add the value to the list
  if {$high_lst == 0} {
    set high_lst [list $lastTime]
  } else {
    lappend high_lst $lastTime
  }

  # Compute the average time
  if { [eqTime $high_avg [RealToTime 0.0]] } {
    set high_avg $lastTime
  } else {
    set high_avg [scaleTime [addTime $high_avg $lastTime] 0.5]
  }

  # Store this edge time
  set prev_time $Now

  # Increment the edge counter
  set low_cnt [expr $low_cnt+1]
}

# This procedure will reset the statistics
echo "Creating statistics reset function"
proc waveReset {} {
  echo "Resetting wave statistics"
  global low_avg
  global low_lst
  global low_cnt
  global high_avg
  global high_lst
  global high_cnt
  global prev_time
  global Now

  set low_avg  0
  set low_lst  0
  set low_cnt  0
  set high_avg 0
  set high_lst 0
  set high_cnt 0

  set prev_time $Now
}

# This procedure will calculate/display the statistics of the signal
echo "Creating statistics analysis function"
proc waveStats {} {
  # Import the stats variables
  global high_avg
  global high_lst
  global high_cnt

  global low_avg
  global low_lst
  global low_cnt

  # Sort the lists
  lsort high_lst
  lsort low_lst

  # Figure out the median values for the low pulses
  set len [llength $low_lst]
  set center [expr $len/2]
  if { [expr round($center)] != $center } {
    list low_med [lrange $low_lst [expr $center-0.5] [expr $center+0.5]]
  } else {
    set low_med [lindex $low_lst $center]
  }

  # Figure out the median values for the high pulses
  set len [llength $high_lst]
  set center [expr $len/2]
  if { [expr round($center)] != $center } {
    list high_med [lrange $high_lst [expr $center-0.5] [expr $center+0.5]]
  } else {
    set high_med [lindex $high_lst $center]
  }

  # Display everything
  echo "High Pulse Stats:"
  echo "Min:     " [lindex $high_lst 0]
  echo "Average: " $high_avg
  echo "Median:  " $high_med
  echo "Max:     " [lindex $high_lst end]
  echo ""
  echo "Low Pulse Stats"
  echo "Min:     " [lindex $low_lst 0]
  echo "Average: " $low_avg
  echo "Median:  " $low_med
  echo "Max:     " [lindex $low_lst end]
  echo ""
  echo "Number of Rising Edges:  " $high_cnt
  echo "Number of Falling Edges: " $low_cnt
}

echo "Loaded wave statistics script"
