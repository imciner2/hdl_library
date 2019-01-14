library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;


entity timeEdges_tb is
    generic (
        CNT_SIZE : integer := 32
    );
end timeEdges_tb;

architecture tb of timeEdges_tb is
    constant T : time := 10 ps;

    signal clock, reset : std_logic;
    
    signal sense_fallingEdge : std_logic;
    signal sense_risingEdge  : std_logic;

    signal cnt : std_logic_vector( CNT_SIZE-1 downto 0 );
    signal newCntFlag : std_logic;

    signal startEdgeType : std_logic;
    signal stopEdgeType  : std_logic;

begin
    UUT : entity work.timeEdges
      generic map (
        -- The bitwidth of the counter register
        CNT_SIZE     => CNT_SIZE
      )
      port map(
        -- Clock and reset lines
        CLK        => clock,
        RST        => reset,

        -- Single clock-cycle flags to signal the edge transitions of the input signal
        SENSE_FALL => sense_fallingEdge,
        SENSE_RISE => sense_risingEdge,

        -- The edge counter output and single clock-cycle flag saying the value has been updated
        COUNT      => cnt,
        NEW_CNT    => newCntFlag,

        -- The edge type to trigger the counter on
        -- 1 = rising
        -- 0 = falling
        START_EDGE => startEdgeType,
        STOP_EDGE  => stopEdgeType
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
        sense_fallingEdge <= '0';
        sense_risingEdge  <= '0';

        -- Test with rising to start, then falling to stop
        startEdgeType <= '1';
        stopEdgeType  <= '0';

        -- Configure the core
        reset  <= '1';
        
        wait for T;

        -- Enable the core
        reset  <= '0';
        
        -- Test a falling edge (shouldn't run)
        sense_fallingEdge <= '1';
        wait for T;
        sense_fallingEdge <= '0';
        wait for 5*T;

        -- Run a test of rising -> falling
        wait for 5*T;
        sense_risingEdge <= '1';
        wait for T;
        sense_risingEdge <= '0';
        wait for 19*T;
        sense_fallingEdge <= '1';
        wait for T;
        sense_fallingEdge <= '0';
        -- This should be 20 counts
        wait for 10*T;

        -- Test with falling to start, then rising to stop
        startEdgeType <= '0';
        stopEdgeType  <= '1';

        -- Test a rising edge (shouldn't run)
        sense_risingEdge <= '1';
        wait for T;
        sense_risingEdge <= '0';
        wait for 5*T;

        -- Run a test of falling -> rising
        wait for 5*T;
        sense_fallingEdge <= '1';
        wait for T;
        sense_fallingEdge <= '0';
        wait for 14*T;
        sense_risingEdge <= '1';
        wait for T;
        sense_risingEdge <= '0';
        -- This should be 20 counts
        wait for 10*T;

        -- Test of rising to start, rising to stop
        startEdgeType <= '1';
        stopEdgeType  <= '1';

        -- Run a test of rising -> rising
        wait for 5*T;
        sense_risingEdge <= '1';
        wait for T;
        sense_risingEdge <= '0';
        wait for 19*T;
        sense_fallingEdge <= '1';
        wait for T;
        sense_fallingEdge <= '0';
        wait for 9*T;
        sense_risingEdge <= '1';
        wait for T;
        -- This should be 30 counts

        sense_risingEdge <= '0';
        wait for 4*T;
        sense_fallingEdge <= '1';
        wait for T;
        sense_fallingEdge <= '0';
        wait for 4*T;
        sense_risingEdge <= '1';
        wait for T;
        sense_risingEdge <= '0';
        -- This should be 10 counts

        wait for 5*T;
        reset <= '1';
        wait;
    end process;


end tb ;
