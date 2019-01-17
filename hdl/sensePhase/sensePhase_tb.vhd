library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;


entity sensePhase_tb is
    
end sensePhase_tb;

architecture tb of sensePhase_tb is
    constant T : time := 10 ps;

    signal clock, reset : std_logic;
    
    signal sense_A_rising  : std_logic;
    signal sense_A_falling : std_logic;
    signal sense_B_rising  : std_logic;
    signal sense_B_falling : std_logic;


    signal relPhase : std_logic;
    signal newPhase : std_logic;

    procedure rising (
        signal sense : out std_logic
    ) is
    begin
        sense <= '1';
        wait for T;
        sense <= '0';
        wait for 4*T;
    end rising;

    procedure falling (
        signal sense : out std_logic
    ) is
    begin
        sense <= '1';
        wait for T;
        sense <= '0';
        wait for 4*T;
    end falling;

begin
    UUT : entity work.sensePhase
      port map(
        -- Clock and reset lines
        CLK    => clock,
        RST    => reset,

        -- Single clock-cycle flags to signal the edge transition of the input signals
        SENSE_A_RISING_EDGE  => sense_A_rising,
        SENSE_A_FALLING_EDGE => sense_A_falling,
        SENSE_B_RISING_EDGE  => sense_B_rising,
        SENSE_B_FALLING_EDGE => sense_B_falling,

        -- Relative phase of the input signals 
        -- 0 = A leads B
        -- 1 = B leads A
        REL_PHASE => relPhase,

        -- Phase updated
        NEW_PHASE => newPhase
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
        sense_A_rising  <= '0';
        sense_A_falling <= '0';
        sense_B_rising  <= '0';
        sense_B_falling <= '0';


        -- Reset the core
        reset  <= '1';
        wait for T;
        reset  <= '0';
        wait for 5*T;


        -- Give an A then B twice
        rising(sense_A_rising);
        rising(sense_B_rising);
        falling(sense_A_falling);
        falling(sense_B_falling);
        
        rising(sense_A_rising);
        rising(sense_B_rising);
        falling(sense_A_falling);
        falling(sense_B_falling);

        wait for 10*T;


        -- Give a B then A twice
        rising(sense_B_rising);
        rising(sense_A_rising);
        falling(sense_B_falling);
        falling(sense_A_falling);

        rising(sense_B_rising);
        rising(sense_A_rising);
        falling(sense_B_falling);
        falling(sense_A_falling);

        wait for 10*T;


        -- Give an A then B followed by a B then A
        rising(sense_A_rising);
        rising(sense_B_rising);
        falling(sense_A_falling);
        falling(sense_B_falling);

        rising(sense_B_rising);
        rising(sense_A_rising);
        falling(sense_B_falling);
        falling(sense_A_falling);

        wait for 10*T;


        -- Give a B then A followed by a A then B
        rising(sense_B_rising);
        rising(sense_A_rising);
        falling(sense_B_falling);
        falling(sense_A_falling);

        rising(sense_A_rising);
        rising(sense_B_rising);
        falling(sense_A_falling);
        falling(sense_B_falling);
        
        wait for 10*T;


        -- Give A rising followed immediately by B falling followed by a BA phase
        rising(sense_A_rising);
        falling(sense_B_falling);

        rising(sense_B_rising);
        rising(sense_A_rising);
        falling(sense_A_falling);
        falling(sense_B_falling);

        -- End
        wait for 5*T;
        reset <= '1';
        wait;
    end process;


end tb ;
