library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sensePhase is
  port (
    -- Clock and reset lines
    CLK    : in std_logic;
    RST    : in std_logic;

    -- Single clock-cycle flags to signal the edge transition of the input signals
    SENSE_A_RISING_EDGE  : in std_logic;
    SENSE_A_FALLING_EDGE : in std_logic;
    SENSE_B_RISING_EDGE  : in std_logic;
    SENSE_B_FALLING_EDGE : in std_logic;

    -- Relative phase of the input signals 
    -- 0 = A leads B
    -- 1 = B leads A
    REL_PHASE : out std_logic;

    -- Phase updated
    NEW_PHASE : out std_logic
  );
end sensePhase;

architecture arch_imp of sensePhase is

  -- The state machine
  type phaseStates is (WAITING, FOUND_A_FIRST, FOUND_B_FIRST, FOUND_A_SECOND, FOUND_B_SECOND);
  
  signal machine_cs : phaseStates;
  signal machine_ns : phaseStates;

  signal phase_n : std_logic;
  signal phase_c : std_logic;

  signal phase_update_n : std_logic;
  signal phase_update_c : std_logic;

begin

  REL_PHASE <= phase_c;
  NEW_PHASE <= phase_update_c;

  -- Determine the timer max
  combProc : process ( machine_cs, phase_c, SENSE_A_RISING_EDGE, SENSE_A_FALLING_EDGE, SENSE_B_RISING_EDGE, SENSE_B_FALLING_EDGE )
  begin
    -- Latch the registers
    phase_n <= phase_c;
    phase_update_n <= phase_update_c;
    machine_ns <= machine_cs;

    -- Logic to choose the next state
    case machine_cs is
    when WAITING =>
      phase_update_n <= '0';

      -- Detect the first rising edge
      if ( SENSE_A_RISING_EDGE = '1') then
        machine_ns <= FOUND_A_FIRST;
      elsif ( SENSE_B_RISING_EDGE = '1') then
        machine_ns <= FOUND_B_FIRST;
      end if;

    when FOUND_A_FIRST =>
      phase_update_n <= '0';

      if (SENSE_B_RISING_EDGE = '1') then
        machine_ns <= FOUND_B_SECOND;
      elsif ( (SENSE_B_FALLING_EDGE = '1') OR (SENSE_A_FALLING_EDGE = '1') ) then
        -- If a falling edge is detected, restart the state machine
        machine_ns <= WAITING;
      end if;

    when FOUND_B_SECOND =>
      -- Set the phase to A leading B
      phase_n <= '0';
      phase_update_n <= '1';

      -- Go to waiting
      machine_ns <= WAITING;

    when FOUND_B_FIRST =>
      phase_update_n <= '0';

      if ( (SENSE_B_FALLING_EDGE = '1') OR (SENSE_A_FALLING_EDGE = '1') ) then
        -- If a falling edge is detected, restart the state machine
        machine_ns <= WAITING;
      elsif (SENSE_A_RISING_EDGE = '1') then
        -- If A is found, transition to A found second
        machine_ns <= FOUND_A_SECOND;
      end if;

    when FOUND_A_SECOND =>
      -- Set the phase to B leading A
      phase_n <= '1';
      phase_update_n <= '1';

      -- Go to waiting
      machine_ns <= WAITING;


  end case;


  end process;

  -- Latch in the timer and counter
  seqProc : process ( CLK, RST )
  begin

    if (RST = '1') then
      -- Reset the state machine
      machine_cs <= WAITING;
      phase_c <= '0';
      phase_update_c <= '0';

    elsif ( rising_edge( CLK ) ) then

      -- Latch the state
      machine_cs <= machine_ns;

      -- Latch the phase
      phase_c <= phase_n;
      phase_update_c <= phase_update_n;

    end if;

  end process;

end arch_imp;
