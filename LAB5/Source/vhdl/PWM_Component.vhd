----------------------------------------------------------------------------------
-- Company: VHDL_2023
-- Engineer: Linards Liepenieks
-- 
-- Create Date: 12/10/2023 02:34:43 PM
-- Design Name: 
-- Module Name: PWM_Component - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PWM_Component is
    generic (
        RESOLUTION : integer
    );
    Port (
        sysclk : in std_logic;
        n_reset : in std_logic;
        pwm_ctrl : in std_logic_vector(RESOLUTION - 1 downto 0);
        pwm_out : out std_logic
    );
end PWM_Component;

architecture Behavioral of PWM_Component is
    constant PWM_RATE : integer := 1;
    
    signal pwm_sysclk: std_logic := '0';
    signal pwm_counter : std_logic_vector(2**RESOLUTION - 1 downto 0) := (others => '0');
    signal pwm_clock_counter : std_logic_vector(RESOLUTION - 1 downto 0) := (others => '0');
begin
    
    process(sysclk, n_reset) --pwm clock divider
    begin
            
        if n_reset = '0' then -- resets conter and initally low pwm
            pwm_sysclk <= '0';
            pwm_clock_counter <= (others => '0');
        elsif sysclk'event and sysclk = '1' then
            if pwm_clock_counter = PWM_RATE - 1 then
                pwm_clock_counter <= (others => '0');
                pwm_sysclk <= NOT pwm_sysclk;
            else
                pwm_clock_counter <= pwm_clock_counter + 1;
            end if;
       
        end if;
    end process;
    
    process(pwm_sysclk, n_reset) --pwm resolution counter
    begin
        if n_reset = '0' then -- reset the counter
            pwm_counter <= (others => '0');
        elsif pwm_sysclk'event and pwm_sysclk = '1' then
            if pwm_counter = 2**RESOLUTION - 1 then -- pwm cycle has reached resolution from cycle
                pwm_counter <= (others => '0');
            else
                pwm_counter <= pwm_counter + 1;
            end if;
        end if;
    end process;
    
    --actual output
    process(pwm_counter, pwm_ctrl)
    begin
        if pwm_counter < pwm_ctrl then
            pwm_out <= '1';
        else
            pwm_out <= '0';
        end if;
    end process;
end Behavioral;
