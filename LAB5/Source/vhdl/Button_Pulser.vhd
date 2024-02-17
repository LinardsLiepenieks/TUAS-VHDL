----------------------------------------------------------------------------------
-- Company: VHDL_2023
-- Engineer: Linards Liepenieks
-- 
-- Create Date: 11/14/2023 01:52:52 PM
-- Design Name: 
-- Module Name: Button_Pulser - Behavioral
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

entity Button_Pulser is
  generic(
    DELAY: integer := 0; -- on default button will instantly create pulse train
    INTERVAL: integer := 1
  );
  Port ( 
    clk_in: in std_logic;
    n_reset: in std_logic;
    btn: in std_logic;
    output: out std_logic
  );
end Button_Pulser;

architecture Behavioral of Button_Pulser is

    signal delay_c: integer := 0;
    signal interval_c: integer := INTERVAL;
    -- signal output_internal: std_logic := '0'; -- was trying to add another variable to create output but that created 1 cycle delay
    type state is (Idle, Armed, Repeat);
    signal pulser_state : state := Idle;

begin

    process(clk_in, n_reset)
    begin
        
        if n_reset = '0' then -- reset function
            pulser_state <= Idle;
            delay_c <= 0;
            interval_c <= 0;
            output <= '0';
            
            
            
        elsif clk_in'event and clk_in = '1' then --check if clock is on a rising edge
        
            case pulser_state is
                when Idle =>
                    if btn = '1' then
                        output <= '1';
                        delay_c <= 0;
                        pulser_state <= Armed;
                        

                    end if;
                when Armed =>
                    if btn = '1' then
                        output <='0';
                        if delay_c<DELAY then
                            delay_c <= delay_c+1;
                        else
                            interval_c <= 0;
                            pulser_state <= Repeat;
                        end if;
                    else
                        pulser_state <= Idle;
                    end if;
                when Repeat =>
                     if btn = '1' then
                        if interval_c < INTERVAL then
                            output <= '0';
                            interval_c <= interval_c + 1;
                        else
                            output <= '1';
                            interval_c <= 0;
                        end if;
                     else
                        pulser_state <= Idle;
                     end if;
                end case;                        
        end if;   
    end process;
end Behavioral;
