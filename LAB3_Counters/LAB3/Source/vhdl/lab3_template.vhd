library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity integer_test is
    Port ( sysclk : in std_logic;
           btn : in std_logic_vector(0 downto 0); -- we don't have reset-button in zynq, using btn(0) instead
           ja : out STD_LOGIC_VECTOR (7 downto 0);
           jb : out STD_LOGIC_VECTOR (7 downto 0)
           );
end integer_test;

architecture rtl of integer_test is

    signal int_a: integer := 0;
    signal int_b: integer range 0 to 255 := 0;

    -- In Zynq we don't have a dedicated reset-button unless we assign some user button for that
    -- Now, just faking a reset which is always high = inactive
    -- This way our design is cleaner and we can take the reset in use later on
    
    signal n_Reset: std_logic := '1'; -- for simulation, initialize to high = inactive


begin
    
    --n_Reset <= not btn(0);
    --n_Reset <= '1'; --fake reset, always inactive
    
    counter1: process (sysclk, n_Reset) is
    begin
        if (n_Reset = '0') then
            int_a <= 0;
            int_b <= 0;
        elsif sysclk'event and sysclk='1' then
            int_a <= int_a +1;
            if int_b < 25 then -- condition to wrap int_b
                int_b <= int_b +1;
            else
                int_b <= 0;
            end if;
        end if; -- clk/rst
    end process counter1;

    -- grab n lowest bits of counter to I/O-pins
    ja <= std_logic_vector(to_unsigned(int_a, ja'length));
    jb <= std_logic_vector(to_unsigned(int_b, jb'length));

end rtl;
