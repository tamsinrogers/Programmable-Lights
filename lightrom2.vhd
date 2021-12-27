-- Tamsin Rogers
-- 10/3/20
-- CS232 Project4
-- lightrom2.vhd
-- ROM to hold program 2

-- Quartus II VHDL Template
-- Unsigned Adder

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lightrom2 is
	port 
	(
		addr :  in std_logic_vector (3 downto 0);		-- address of the instruction to return
		data : out std_logic_vector (2 downto 0)		-- the instruction to be executed
	);

end entity;

architecture rtl of lightrom2 is
begin

	-- program = the 3 bit values stored at each address

	data <= 
      "000" when addr = "0000" else -- move 0s to LR  00000000
      
      "101" when addr = "0001" else -- bit invert LR  11111111
      "101" when addr = "0010" else -- bit invert LR  00000000
      "101" when addr = "0011" else -- bit invert LR  11111111
      "101" when addr = "0001" else -- bit invert LR  11111111
      "101" when addr = "0010" else -- bit invert LR  00000000
      "101" when addr = "0011" else -- bit invert LR  11111111
      "101" when addr = "0011" else -- bit invert LR  11111111
      
      "100" when addr = "1101" else -- sub 1 from LR  11001100
      "100" when addr = "1101" else -- sub 1 from LR  11001100
      "100" when addr = "1110" else -- bit invert LR  00110011
      "100" when addr = "1101" else -- sub 1 from LR  11001100
      "100" when addr = "1110" else -- bit invert LR  00110011
      "100" when addr = "1101" else -- sub 1 from LR  11001100
      "100" when addr = "1110" else -- bit invert LR  00110011
      
      "011";         

end rtl;
