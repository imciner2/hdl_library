library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm is
  generic (
    PWM_CNT_BIT_WIDTH : integer := 32
  );
  port (
    -- Clock signal
    clk        : in  std_logic;

    -- Enable signal for the PWM (active high)
    en         : in  std_logic;

    -- Asynchronous reset signal (active high)
    rst        : in  std_logic;

    -- Duty cycle (counter point to transition from high to low)
    pwm_duty   : in  unsigned( PWM_CNT_BIT_WIDTH-1 downto 0);

    -- Period (counter point at which to transition from low to high)
    pwm_period : in  unsigned( PWM_CNT_BIT_WIDTH-1 downto 0);

    -- PWM signal output
    pwm_o      : out std_logic
  );
end pwm;

architecture behavioral of pwm is

  type gen_states is (UPDATE, HIGH, LOW);

  signal gen_state_ps : gen_states;
  signal gen_state_ns : gen_states;
  signal cnt          : unsigned(PWM_CNT_BIT_WIDTH-1 downto 0);
  signal period       : unsigned(PWM_CNT_BIT_WIDTH-1 downto 0);
  signal duty         : unsigned(PWM_CNT_BIT_WIDTH-1 downto 0);

  signal runCnt    : std_logic;
  signal latchVal  : std_logic;
  signal reach_dty : std_logic;
  signal reach_per : std_logic;

begin
  pwm_combo : process (en, gen_state_ns, gen_state_ps, reach_dty, reach_per, cnt, period, duty) is
  begin
    case gen_state_ps is
    when UPDATE =>
      -- Latch in new values of the PWM parameters
      pwm_o        <= '0';
      latchVal     <= '1';
      runCnt       <= '0';

      -- Only transition if the PWM is enabled
      gen_state_ns <= UPDATE;
      if (en = '1') then
        gen_state_ns <= HIGH;
      end if;


    when HIGH =>
      -- Generate the high portion of the PWM pulse
      pwm_o    <= '1';
      latchVal <= '0';
      runCnt   <= '1';

      -- Only transition when the duty cycle has been reached
      gen_state_ns <= HIGH;
      if (reach_dty = '1') then
        gen_state_ns <= LOW;
      end if;

    when LOW =>
      -- Generate the low portion of the PWM pulse
      pwm_o        <= '0';
      latchVal     <= '0';
      runCnt       <= '1';

      -- Only transition when the period has be reached
      gen_state_ns <= LOW;
      if (reach_per = '1') then
        gen_state_ns <= UPDATE;
      end if;
    end case;

    -- Test to see if the duty cycle has been reached
    if ( cnt >= duty ) then
      reach_dty <= '1';
    else
      reach_dty <= '0';
    end if;

    -- Test to see if the period has been reached
    if ( cnt >= period ) then
      reach_per <= '1';
    else
      reach_per <= '0';
    end if;
  end process;

  pwm_reg : process ( clk, rst, pwm_period, pwm_duty, latchVal, runCnt, gen_state_ns ) is
  begin
    if ( rst = '1' ) then
      gen_state_ps <= UPDATE;

      -- Initialize values to known values
      duty   <= to_unsigned(0, PWM_CNT_BIT_WIDTH);
      cnt    <= to_unsigned(1, PWM_CNT_BIT_WIDTH);
      period <= to_unsigned(0, PWM_CNT_BIT_WIDTH);

    elsif(rising_edge(clk)) then

      if (latchVal = '1') then
        -- Latch the duty cycle for the next period
        duty   <= pwm_duty;

        -- Latch the period
        -- Subtract 1 to allow for the 1 cycle delay of the next update stage without adding an additional low period
        period <= pwm_period - 1;
        
        -- Reset the PWM counter to 1 to ensure proper counting
        cnt    <= to_unsigned(1, PWM_CNT_BIT_WIDTH);
      elsif (runCnt = '1') then
        -- Increment the pwm counter when running
        cnt <= cnt + 1;
      end if;

      -- Update the state machine
      gen_state_ps <= gen_state_ns;

    end if;
  end process;

end behavioral;
