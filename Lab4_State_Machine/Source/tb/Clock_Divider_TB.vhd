----------------------------------------------------------------------------------
-- Company: VHDL_2023
-- Engineer: Linards Liepenieks
-- 
-- Create Date: 11/13/2023 06:51:18 PM
-- Design Name: 
-- Module Name: Clock_Divider_TB - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Clock_Divider_TB is
--  Port ( );
end Clock_Divider_TB;
    

architecture Behavioral of Clock_Divider_TB is
    --testbench signals
    signal sysclk: std_logic;
    signal n_reset: std_logic := '1';
    signal clk_out_TB: std_logic;
    
    component Clock_Divider
    generic(
        OUTPUT_CLOCK_F: integer := 125000000
    );
    port(
        clk_in: in std_logic;
        n_reset: in std_logic;
        clk_out: out std_logic
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

    DUT: Clock_Divider
        generic map(
            OUTPUT_CLOCK_F => 31250000 --testing with 31.25MHz should be 4 sysclock cycles for each cycle - correct
        )
        port map(
            clk_in => sysclk,
            n_reset => n_reset,
            clk_out => clk_out_TB
        );
        
     process begin
         n_reset <= '0';
         wait for 10ns;
         n_reset <= '1';
         
         
         
         wait for 1 ms;
         
         assert false report "Testing done" severity failure;
         
     end process;


end Behavioral;
