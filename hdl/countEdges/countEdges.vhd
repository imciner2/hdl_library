library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity countEdges is
  generic (
    -- The bitwidth of the counter register
    CNT_SIZE   : integer := 32;

    -- The bitwidth of the timer register
    TIME_SIZE  : integer := 32
  );
  port (
    -- Clock and reset lines
    CLK    : in std_logic;
    RST    : in std_logic;

    -- Single clock-cycle flag to signal the edge transition of the input signal
    SENSE_EDGE : in std_logic;

    -- The edge counter output and single clock-cycle flag saying the value has been updated
    COUNT   : out std_logic_vector(CNT_SIZE-1 downto 0);
    NEW_CNT : out std_logic;

    -- The timer value to count up to
    TIME_END : in std_logic_vector(TIME_SIZE-1 downto 0)
  );
end countEdges;

architecture arch_imp of countEdges is

  -- The counter register
  signal counter     : unsigned(CNT_SIZE-1 downto 0);

  -- The timer register
  signal timer       : unsigned(TIME_SIZE-1 downto 0);
  
  -- Signal to reset the registers
  signal reset_regs : std_logic;

  -- Latch for a counter value flag
  signal cnt_new_c : std_logic;
  signal cnt_new_n : std_logic;
  signal cnt_out_n : std_logic_vector(CNT_SIZE-1 downto 0);
  signal cnt_out_c : std_logic_vector(CNT_SIZE-1 downto 0);

begin
  -- Send out the buffered counter
  COUNT   <= cnt_out_c;
  NEW_CNT <= cnt_new_c;

  -- Determine the timer max
  combProc : process ( timer, TIME_END, counter, cnt_out_c )
  begin
    -- Default to preserving the output counter
    cnt_out_n <= cnt_out_c;
    cnt_new_n <= '0';
    reset_regs <= '0';

    -- If the timer is at the end, then prepare to latch the count
    if (timer >= unsigned(TIME_END) ) then
      cnt_out_n <= std_logic_vector(counter);
      cnt_new_n <= '1';
      reset_regs <= '1';
    end if;

  end process;

  -- Latch in the timer and counter
  seqProc : process ( CLK, RST )
  begin

    if (RST = '1') then
      -- Reset the counter and timer
      counter <= to_unsigned(0, CNT_SIZE);
      timer   <= to_unsigned(0, TIME_SIZE);
      cnt_out_c <= (others => '0');
      cnt_new_c <= '0';

    elsif ( rising_edge( CLK ) ) then

      if (reset_regs = '1') then
        -- Reset the counter when requested
        counter <= to_unsigned(0, CNT_SIZE);
      elsif (SENSE_EDGE = '1') then
        -- Count when an edge occurs
        counter <= counter + 1;
      end if;

      if ( reset_regs = '1') then
        -- Reset the timer when at max
        timer   <= to_unsigned(0, TIME_SIZE);
      else
        timer <= timer + 1;
      end if;

      -- Latch registers for the output
      cnt_out_c <= cnt_out_n;
      cnt_new_c <= cnt_new_n;

    end if;

  end process;

end arch_imp;
