library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;


entity debounceSignal_tb is
end debounceSignal_tb;

architecture tb of debounceSignal_tb is
    constant T : time := 10 ps;

    signal clock, reset, enable : std_logic;
    
    signal senseLine : std_logic;

    signal sense_debounced   : std_logic;
    signal sense_fallingEdge : std_logic;
    signal sense_risingEdge  : std_logic;

begin
    UUT : entity work.debounceSignal
      generic map (

        -- The number of samples to use in the debounce register
        DEBOUNCE_LEN => 3
      )
      port map(
        -- Clock and reset lines
        CLK        => clock,
        RST        => reset,
        ENABLE     => enable,

        -- The signal line to measure edges on
        SENSE      => senseLine,

        -- Debounced version of SENSE
        SENSE_DB   => sense_debounced,

        -- Single clock-cycle flags for the falling and rising edges
        SENSE_FALL => sense_fallingEdge,
        SENSE_RISE => sense_risingEdge
      );

    -- Create the clock
    clk : process
    begin
        clock <= '1';
        wait for T/2;
        clock <= '0';
        wait for T/2;
    end process;

    -- Create the main test process
    test : process
    begin
        senseLine <= '0';

        -- Configure the core
        reset  <= '1';
        enable <= '0';
        
        wait for T;

        -- Enable the core
        reset  <= '0';
        enable <= '1';
        
        -- Run a test of rising -> falling
        wait for 5*T;
        senseLine <= '1';
        wait for 10*T;
        senseLine <= '0';
        wait for 10*T;
        senseLine <= '1';
        wait for 5*T;
        senseLine <= '0';
        wait for 10*T;


        reset <= '1';
        wait;
    end process;


end tb ;
