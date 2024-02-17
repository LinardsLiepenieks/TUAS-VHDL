library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;


entity lab_4 is
    Port ( 
           --clock divider variables
           sysclk : in std_logic;
           --RGB controller variables
           btn : in std_logic_vector(3 downto 0);
           led4_r : out std_logic;
           led4_g : out std_logic;
           led4_b : out std_logic;
           led : out std_logic_vector(3 downto 0);
           led5_r : out std_logic;
           led5_g : out std_logic;
           led5_b : out std_logic
           );
end lab_4;

architecture rtl of lab_4 is
    
    --RGB controller states
    type state is (R, G, B);
    signal cur_state : state := R;
    signal divider_out : std_logic;

    --clock divider declaration
    component Clock_Divider is
    generic ( 
        OUTPUT_CLOCK_F : integer :=  1000 -- 1Khz for implementation
        --OUTPUT_CLOCK_F : integer := 125000000 --for testing
    );
    port(
        clk_in: in std_logic;
        n_reset: in std_logic;
        clk_out: out std_logic
    );
    end component;
    
    -- Button pulser declaration
    component Button_Pulser is
        generic(
            -- REMINDER: this is counted in cycles NOT in time units
            DELAY: integer := 2000; --time * f 
            --DELAY: integer := 15; --for testing
            INTERVAL: integer := 500 --time * f
            --INTERVAL: integer := 1 --for testing

        );
        Port (
            clk_in: in std_logic;
            n_reset: in std_logic;
            btn: in std_logic;
            output: out std_logic
        );
    end component;
    
    component PWM_Component is
        generic (
            RESOLUTION : integer
        );
        Port (
            sysclk : in std_logic;
            n_reset : in std_logic;
            pwm_ctrl : in std_logic_vector(RESOLUTION - 1 downto 0);
            pwm_out : out std_logic
        );
    end component;
        
    --Global reset
    signal n_reset : std_logic := '1';
    -- long press detection
    signal press_output : std_logic := '0';
    signal btn2_pulser_output, btn3_pulser_output : std_logic := '0';

    -- PWM control signals
    signal pwm_r, pwm_g, pwm_b : std_logic;
    
    -- PWM control values
    constant PWM_RESOLUTION : integer := 4;
    signal pwm_ctrl_r, pwm_ctrl_g, pwm_ctrl_b : std_logic_vector(PWM_RESOLUTION - 1 downto 0) := (others => '0');
    



begin
    
    n_reset <= not btn(0);
    
    -- Clock divider instantiation
    divider_inst: Clock_Divider
    port map(
        clk_in => sysclk,
        n_reset => n_reset,
        clk_out => divider_out
    );
    
    -- Button pulser instantiation for btn-1
    pulser_inst: Button_pulser
    port map(
        clk_in => divider_out,
        n_reset => n_reset,
        btn => btn(1),
        output => press_output
    );
    
    -- Buttons 3 and 2. Button Pulser.
    btn2_pulser_inst: Button_Pulser
    port map(
        clk_in => divider_out,
        n_reset => n_reset,
        btn => btn(2),
        output => btn2_pulser_output
    );


    btn3_pulser_inst: Button_Pulser
    port map(
        clk_in => divider_out,
        n_reset => n_reset,
        btn => btn(3),
        output => btn3_pulser_output
    );


    
    pwm_r_inst: PWM_Component
    generic map(
        RESOLUTION => PWM_RESOLUTION
    )
    port map(
        sysclk => sysclk,
        n_reset => n_reset,
        pwm_ctrl => pwm_ctrl_r,
        pwm_out => pwm_r
    );
    
    
    pwm_g_inst: PWM_Component
    generic map(
           RESOLUTION => PWM_RESOLUTION
    )
    port map(
        sysclk => sysclk,
        n_reset => n_reset,
        pwm_ctrl => pwm_ctrl_g,
        pwm_out => pwm_g
    );
    
    pwm_b_inst: PWM_Component
    generic map(
          RESOLUTION => PWM_RESOLUTION
    )
    port map(
        sysclk => sysclk,
        n_reset => n_reset,
        pwm_ctrl => pwm_ctrl_b,
        pwm_out => pwm_b
    );
    
    
    process(divider_out, n_reset)
    begin
        if n_reset = '0' then
            cur_state <= R;
            pwm_ctrl_r <= (others => '0');
            pwm_ctrl_b <= (others => '0');
            pwm_ctrl_g <= (others => '0');
        elsif divider_out'event and divider_out = '1' then
            if press_output = '1' then
                case cur_state is
                    when R => cur_state <= G;
                    when G => cur_state <= B;
                    when B => cur_state <= R;
                end case;
             elsif btn3_pulser_output = '1' then
                case cur_state is
                    when R => pwm_ctrl_r <= pwm_ctrl_r + 1;
                    when G => pwm_ctrl_g <= pwm_ctrl_g + 1;
                    when B => pwm_ctrl_b <= pwm_ctrl_b + 1;
                end case;
             elsif btn2_pulser_output = '1' then
                case cur_state is
                    when R => pwm_ctrl_r <= pwm_ctrl_r - 1;
                    when G => pwm_ctrl_g <= pwm_ctrl_g - 1;
                    when B => pwm_ctrl_b <= pwm_ctrl_b - 1;
                end case;
             
             end if;  
        end if;
    end process;
    
    led(0) <= pwm_r;
    led5_r <= pwm_r;
    led5_g <= pwm_g;
    led5_b <= pwm_b;

    
    
    
    
    process(cur_state)
    begin
        case cur_state is
            when R =>
                led4_r <= '1';
                led4_g <= '0';
                led4_b <= '0';
            when G =>
                led4_r <= '0';
                led4_g <= '1';
                led4_b <= '0';
            when B =>
                led4_r <= '0';
                led4_g <= '0';
                led4_b <= '1';
            when others =>
                led4_r <= '0';
                led4_g <= '0';
                led4_b <= '0';
        end case;
    end process;
    
     
    

end rtl;
