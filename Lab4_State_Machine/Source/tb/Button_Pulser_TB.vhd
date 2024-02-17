----------------------------------------------------------------------------------
-- Company: VHDL_2023
-- Engineer: Linards Liepenieks
-- 
-- Create Date: 11/14/2023 02:09:34 PM
-- Design Name: 
-- Module Name: Button_Pulser_TB - Behavioral
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

entity Button_Pulser_TB is
--  Port ( );
end Button_Pulser_TB;

architecture Behavioral of Button_Pulser_TB is

    signal sysclk: std_logic;
    signal n_reset: std_logic := '0';
    signal output_TB: std_logic;
    signal btn_sim: std_logic := '0';
    
    component Button_Pulser
    generic(
        DELAY: integer := 0;
        INTERVAL: integer := 1
    );
    port(
        clk_in: in std_logic;
        n_reset: in std_logic;
        btn: in std_logic;
        output: out std_logic
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

    DUT: Button_Pulser
        generic map(
            DELAY  => 10,
            INTERVAL => 3
        )
        port map(
            clk_in => sysclk,
            n_reset => n_reset,
            btn => btn_sim,
            output => output_TB
        );
     
    process begin
        n_reset <= '1';
        btn_sim<='0';
        wait for 10ns;
        
        btn_sim <= '1';
        wait for 90ns;
        btn_sim <= '0';
        wait for 20ns;
        btn_sim <='1';
        wait for 200ns;
        btn_sim <= '0';
        wait for 20ns;
        btn_sim <='1';
        wait for 200ns;
        assert false report "Testing done" severity failure;
        
      
        
    end process;


end Behavioral;
