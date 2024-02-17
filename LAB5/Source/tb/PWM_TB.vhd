----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/10/2023 04:19:59 PM
-- Design Name: 
-- Module Name: PWM_TB - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.std_logic_signed.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PWM_TB is
--  Port ( );
end PWM_TB;

architecture Behavioral of PWM_TB is

    signal sysclk : std_logic := '0';
    signal n_reset : std_logic :='1';
    signal pwm_ctrl_tb : std_logic_vector(1 downto 0) := (others => '0');
    signal result : std_logic;
    
    component PWM_Component
        generic (
            RESOLUTION : integer
            );
        Port(
            sysclk : in std_logic;
            n_reset : in std_logic;
            pwm_ctrl : in std_logic_vector(RESOLUTION - 1 downto 0);
            pwm_out : out std_logic
            );
    end component;
begin

    clock_force: process
            begin
                sysclk <= '0';
                wait for 4 ns;
                sysclk <= '1';
                wait for 4 ns;
            end process;
    
    DUT: PWM_Component
        generic map (
            RESOLUTION => 2
        )
        port map (
            sysclk => sysclk,
            n_reset => n_reset,
            pwm_ctrl => pwm_ctrl_tb,
            pwm_out => result
        );
    process begin
        pwm_ctrl_tb <= "00";
        wait for 400ns;
        pwm_ctrl_tb <= "01";
        wait for 400ns;
        pwm_ctrl_tb <= "10";
        wait for 400ns;
        pwm_ctrl_tb <= "11";
        wait for 400ns;
    end process;
    

end Behavioral;
