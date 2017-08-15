# countEdges.tcl
# This TCL script runs in ModelSim and will count the number of edges in a signal
# (the probe signal) in relation to a reference signal. This will tell how many rising/falling
# edges occur during the high/low times of the reference signal.
#
# Note: This requires several variables defined to say which signals to explore
#   set stopSignal  /path/to/signal     -- The signal whose low-to-high transition stops the analysis
#   set refSignal   /path/to/signal     -- The signal to use as the reference
#   set probeSignal /path/to/signal     -- The signal to count transitions on

echo "Loading count edges script"
set ref_high_rising  0
set ref_high_falling 0
set ref_low_rising   0
set ref_low_falling  0

set refPolarity 0

set runAnalysis 0

# Detect a rising edge on the stop signal
echo "Creating event handler for rising edge of " $stopSignal
when -label count_stop_watch "$stopSignal = '1'" {
  set runAnalysis 0
  echo "Stopping analysis at " $Now
  edgeCounts
}

# Detect a rising edge on the reference signal
echo "Creating event handler for rising edge of " $refSignal
when -label count_ref_rising_watch "$refSignal = '1'" {
  # If the analysis is not running, start it
  if {$runAnalysis == 0} {
    set runAnalysis 1

    # Reset the counters
    set ref_high_rising  0
    set ref_high_falling 0
    set ref_low_falling  0
    set ref_low_rising   0

    echo "Starting edge count at " $Now
  }
  # The reference had a rising edge
  set refPolarity 1
}

# Detect a falling edge on the reference signal
echo "Creating event handler for falling edge of " $refSignal
when -label count_ref_falling_watch "$refSignal = '0'" {
  # The reference had a falling edge
  set refPolarity 0
}

# Detect a rising edge on the probe signal
echo "Creating event handler for rising edge of " $probeSignal
when -label count_probe_rising_watch "$probeSignal = '1'" {
  if {$runAnalysis == 1} {
    if {$refPolarity == 1} {
      # Increment the rising edge counter in the high period
      set ref_high_rising [expr $ref_high_rising+1]
    } else {
      # Increment the rising edge counter in the low period
      set ref_low_rising [expr $ref_low_rising+1]
    }
  }
}

# Detect a falling edge on the probe signal
echo "Creating event handler for falling edge of " $probeSignal
when -label count_probe_falling_watch "$probeSignal = '0'" {
  if {$runAnalysis == 1} {
    if {$refPolarity == 1} {
      # Increment the falling edge counter in the high period
      set ref_high_falling [expr $ref_high_falling+1]
    } else {
      # Increment the falling edge counter in the low period
      set ref_low_falling [expr $ref_low_falling+1]
    }
  }
}

# This procedure will reset all the counters
echo "Creating count reset procedure"
proc resetCount {} {
  global ref_high_falling
  global ref_high_rising
  global ref_low_rising
  global ref_low_falling
  global runAnalysis
  global refPolarity

  set ref_high_rising  0
  set ref_high_falling 0
  set ref_low_falling  0
  set ref_low_rising   0

  set runAnalysis      0
  set refPolarity      0
}

# This procedure will display all the counters
echo "Creating count display procedure"
proc edgeCounts {} {
  global ref_high_rising
  global ref_high_falling
  global ref_low_rising
  global ref_low_falling

  echo "Count Statistics"
  echo "Reference high:"
  echo "  Rising:  " $ref_high_rising
  echo "  Falling: " $ref_high_falling
  echo ""
  echo "Reference low:"
  echo "  Rising:  " $ref_low_rising
  echo "  Falling: " $ref_low_falling
}

echo "Loaded count edges script"
