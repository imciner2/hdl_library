library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timeEdges is
  generic (
    -- The bitwidth of the counter register
    CNT_SIZE   : integer := 32
  );
  port (
    -- Clock and reset lines
    CLK    : in std_logic;
    RST    : in std_logic;

    -- Single clock-cycle flags to signal the edge transitions of the input signal
    SENSE_FALL : in std_logic;
    SENSE_RISE : in std_logic;

    -- The edge counter output and single clock-cycle flag saying the value has been updated
    COUNT   : out std_logic_vector(CNT_SIZE-1 downto 0);
    NEW_CNT : out std_logic;

    -- The edge type to trigger the counter on
    -- 1 = rising
    -- 0 = falling
    START_EDGE : in std_logic;
    STOP_EDGE  : in std_logic
  );
end timeEdges;

architecture arch_imp of timeEdges is

  -- States to control the timer
  type timer_states is (WAITING_START, FOUND_START, WAITING_STOP, FOUND_STOP);
  signal timer_ps : timer_states;
  signal timer_ns : timer_states;

  -- The counter registers
  signal counter     : unsigned(CNT_SIZE-1 downto 0);

  -- Counter controls
  signal cnt_run : std_logic;
  signal cnt_rst : std_logic;

  -- Latch for a counter value flag
  signal cnt_new_c : std_logic;
  signal cnt_new_n : std_logic;
  signal cnt_out_n : std_logic_vector(CNT_SIZE-1 downto 0);
  signal cnt_out_c : std_logic_vector(CNT_SIZE-1 downto 0);

  -- Edge detection signals
  signal e_start : std_logic;
  signal e_stop  : std_logic;

begin
  -- Send out the buffered counter
  COUNT   <= cnt_out_c;
  NEW_CNT <= cnt_new_c;

  -- Figure out if the start and stop edges are present
  e_start <= (START_EDGE AND SENSE_RISE) OR ( (NOT START_EDGE) AND SENSE_FALL);
  e_stop  <= (STOP_EDGE  AND SENSE_RISE) OR ( (NOT STOP_EDGE)  AND SENSE_FALL);

  -- Determine the timer state
  timeCombProc : process ( timer_ps, e_start, e_stop, START_EDGE, STOP_EDGE )
  begin
    timer_ns <= timer_ps;

    -- Default the counter to no operation
    cnt_rst <= '0';
    cnt_run <= '0';

    -- Update the new counter value flag
    cnt_new_n <= '0';

    -- Hold the counter output
    cnt_out_n <= cnt_out_c;

    -- Choose the timer operation
    case timer_ps is
    when WAITING_START =>

      -- If a start is detected, change state to start counter
      if (e_start = '1') then
        timer_ns <= FOUND_START;
      end if;

    when FOUND_START =>
      -- Reset the counter when start is found
      cnt_rst <= '1';
      timer_ns <= WAITING_STOP;

    when WAITING_STOP =>
      -- Run the counter when waiting for stop
      cnt_run <= '1';

      -- If a stop is detected, change state
      if (e_stop = '1') then
        timer_ns <= FOUND_STOP;
      end if;

    when FOUND_STOP =>
      if (STOP_EDGE = START_EDGE) then
        -- If the start and stop edges are the same, bypass starting stage and go immediately to waiting for stop
        cnt_rst <= '1';
        timer_ns <= WAITING_STOP;
      else
        -- Otherwise wait for the start again
        timer_ns <= WAITING_START;
      end if;

      -- Signal to latch in new counter output
      cnt_new_n <= '1';
      cnt_out_n <= std_logic_vector(counter);
  end case;

  end process;

  -- Latch in the timer state and counter
  timeSeqProc : process ( CLK, RST )
  begin

    if (RST = '1') then
      -- Reset the counter and state machine
      counter <= to_unsigned(1, CNT_SIZE);
      cnt_out_c <= (others => '0');
      timer_ps <= WAITING_START;

    elsif ( rising_edge( CLK ) ) then

      -- Decide to either count or reset the counter
      if (cnt_rst = '1') then
        -- The state machine introduces a 1 cycle counting delay
        counter <= to_unsigned(1, CNT_SIZE);
      elsif (cnt_run = '1') then
        counter <= counter + 1;
      end if;

      -- Latch registers
      cnt_out_c <= cnt_out_n;
      cnt_new_c <= cnt_new_n;
      timer_ps <= timer_ns;

    end if;

  end process;

end arch_imp;
