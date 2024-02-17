----------------------------------------------------------------------------------
-- Company: VHDL_2023
-- Engineer: Linards Liepenieks
-- 
-- Create Date: 11/13/2023 05:31:23 PM
-- Design Name: 
-- Module Name: Clock_Divider - Behavioral
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

entity Clock_Divider is
    generic (
        OUTPUT_CLOCK_F: integer := 125000000 --Default as 125Mhz
    );
    Port ( 
        clk_in: in std_logic; --Input clock rate = 125Mhz
        n_reset: in std_logic;
        clk_out: out std_logic
    );
end Clock_Divider;

architecture Behavioral of Clock_Divider is
    
    constant clk_in_f: integer := 125000000; --fixed input clock f
    constant divider: integer := clk_in_f / OUTPUT_CLOCK_F;
    
    signal c : integer range 0 to divider := divider-1; -- counter signal
    signal clk_out_internal: std_logic := '0'; --output signal during process
    

begin

    process(clk_in, n_reset)
    begin
    
    if n_reset = '0' then
        c <= 0;
        clk_out_internal <= '0';
    elsif clk_in'event and clk_in = '1' then
        if c > (divider/2) then
            c <= 0;
            clk_out_internal <= not clk_out_internal;
        else
            c <= c + 1;
        end if;
    end if;
    
    end process;
    
    clk_out <= clk_out_internal;


end Behavioral;
