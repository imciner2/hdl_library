library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounceSignal is
  generic (
    -- The number of samples to use in the debounce register
    DEBOUNCE_LEN : integer := 8
  );
  port (
    -- Clock and reset lines
    CLK    : in std_logic;
    RST    : in std_logic;
    ENABLE : in std_logic;

    -- The signal line to measure edges on
    SENSE : in std_logic;

    -- Debounced version of SENSE
    SENSE_DB   : out std_logic;

    -- Single clock-cycle flags for the falling and rising edges
    SENSE_FALL : out std_logic;
    SENSE_RISE : out std_logic
  );
end debounceSignal;

architecture arch_imp of debounceSignal is


  -- States to keep track of the current level of the signal
  type line_levels is (UNKNOWN, HIGH, FALLING, LOW, RISING);
  signal sense_cl : line_levels;
  signal sense_nl : line_levels;

  -- The debounce register
  signal debounceReg : std_logic_vector(DEBOUNCE_LEN-1 downto 0);

begin

  -- Latch the input into the debounce register
  inputDebounceProc: process (CLK, RST, SENSE)
  begin
    if ( RST = '1' ) then
      -- Reset the entire register to the current sense value
      debounceReg <= (others => SENSE);
    elsif ( rising_edge(CLK) ) then
      -- On the clock, shift the register and add the most recent sense value to the bottom
      debounceReg(DEBOUNCE_LEN-1 downto 1) <= debounceReg(DEBOUNCE_LEN-2 downto 0);
      debounceReg(0) <= SENSE;
    end if;
  end process;

  -- Test for a change in the input signal
  inputCombproc : process ( debounceReg, sense_cl )
  begin
    sense_nl <= sense_cl;
    SENSE_RISE <= '0';
    SENSE_FALL <= '0';

    -- Update the line state
    case sense_cl is
    when UNKNOWN =>
      -- If the level is unknown, read directly from the line
      if ( debounceReg(0) = '1' ) then
        sense_nl <= HIGH;
      else
        sense_nl <= LOW;
      end if;

      -- Just hold it low if the machine isn't latched in
      SENSE_DB <= '0';

    when HIGH =>
      -- Test for all values in the debounce register being low to say it has fallen
      if ( debounceReg = (debounceReg'range => '0') ) then
        sense_nl <= FALLING;
      end if;
      SENSE_DB <= '1';

    when FALLING =>
      sense_nl <= LOW;
      SENSE_FALL <= '1';
      SENSE_DB <= '1';

    when LOW =>
      -- Test for all values in the debounce register being high to say it has risen
      if ( debounceReg = (debounceReg'range => '1') ) then
        sense_nl <= RISING;
      end if;
      SENSE_DB <= '0';

    when RISING =>
      sense_nl <= HIGH;
      SENSE_RISE <= '1';
      SENSE_DB <= '0';

    end case;

  end process;

  -- Latch in the input level
  inputSeqProc : process ( CLK, RST, sense_nl)
  begin
    if ( RST = '1' ) then
      sense_cl <= UNKNOWN;
    elsif ( rising_edge(CLK) ) then
      sense_cl <= sense_nl;
    end if;
  end process;

end arch_imp;
