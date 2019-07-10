library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;


entity countEdges_tb is
    generic (
        CNT_SIZE  : integer := 32;
        TIME_SIZE : integer := 32
    );
end countEdges_tb;

architecture tb of countEdges_tb is
    constant T : time := 10 ps;

    signal clock, reset : std_logic;

    signal sense_edge : std_logic;

    signal cnt : std_logic_vector( CNT_SIZE-1 downto 0 );
    signal newCntFlag : std_logic;

    signal time_max : unsigned( TIME_SIZE-1 downto 0 );

    -- A procedure to pulse the line and then wait for the desired time
    procedure pulse(        waitTime   : in integer := 0;
                     signal sense_edge : out std_logic ) is
    begin
        sense_edge <= '1';
        wait for T;
        sense_edge <= '0';
        wait for waitTime*T;
    end procedure pulse;

begin
    UUT : entity work.countEdges
      generic map (
        -- The bitwidth of the counter register
        CNT_SIZE     => CNT_SIZE
      )
      port map(
        -- Clock and reset lines
        CLK        => clock,
        RST        => reset,

        -- Single clock-cycle flag to signal the edge transition of the input signal
        SENSE_EDGE => sense_edge,

        -- The edge counter output and single clock-cycle flag saying the value has been updated
        COUNT      => cnt,
        NEW_CNT    => newCntFlag,

        -- The timer value to count up to
        TIME_END   => std_logic_vector(time_max)
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
        sense_edge <= '0';

        -- Configure the core
        time_max <= to_unsigned(50, TIME_SIZE);
        reset  <= '1';
        wait for T;

        -- Enable the core
        reset  <= '0';
        wait for 5*T;

        -- Give some edges
        pulse( 4, sense_edge );
        pulse( 9, sense_edge );
        pulse( 14, sense_edge );
        pulse( 4, sense_edge );
        pulse( 2, sense_edge );
        pulse( 4, sense_edge );
        pulse( 4, sense_edge );

        assert unsigned(cnt) = 7
            report "Counter incorrect"
            severity error;

        pulse( 9, sense_edge );
        pulse( 14, sense_edge );
        pulse( 4, sense_edge );
        pulse( 2, sense_edge );
        pulse( 4, sense_edge );

        wait for 20*T;

        assert unsigned(cnt) = 5
            report "Counter incorrect"
            severity error;

        pulse( 55, sense_edge );

        wait for 5*T;
        reset <= '1';
        wait;
    end process;


end tb ;
