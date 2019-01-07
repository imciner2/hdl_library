library ieee;
use ieee.std_logic_1164.all;


entity pwm_tb is
    generic (
        PWM_CNT_BIT_WIDTH : integer := 32
    );
end pwm_tb;

architecture tb of pwm_tb is
    constant T : integer := 10;

    signal clock, reset, enable, pwm : std_logic;
    signal period, duty   : unsigned( PWM_CNT_BIT_WIDTH-1 downto 0); 
begin
    UUT : entity pwm 
    generic map (
        PWM_CNT_BIT_WIDTH <= 32
    )
    port map(
        -- Clock signal
        clk        => clock,

        -- Enable signal for the PWM (active high)
        en         => enable,

        -- Asynchronous reset signal (active high)
        rst        => reset,

        -- Duty cycle (counter point to transition from high to low)
        pwm_duty   => duty,

        -- Period (counter point at which to transition from low to high)
        pwm_period => period,

        -- PWM signal output
        pwm_o      => pwm
      );

    -- Create the clock
    clk : process
    begin
        clock <= '1';
        wait for T/2;
        clock <= '0';
        wait for T/2;
    end process

    -- Create the main test process
    test : process
    begin
        duty   <= to_unsigned(10, PWM_CNT_BIT_WIDTH);
        period <= to_unsigned(20, PWM_CNT_BIT_WIDTH);
        reset  <= '1';
        enable <= '0';

        wait for T;
        
        reset  <= '0';
        enable <= '1';

        wait for 40*T

    end process;


end tb ;
