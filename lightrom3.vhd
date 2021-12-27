-- Tamsin Rogers
-- 10/3/20
-- CS232 Project4
-- lightrom3.vhd
-- ROM to hold program 3

-- Quartus II VHDL Template
-- Unsigned Adder

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lightrom3 is
	port 
	(
		addr :  in std_logic_vector (3 downto 0);		-- address of the instruction to return
		data : out std_logic_vector (2 downto 0)		-- the instruction to be executed
	);

end entity;

architecture rtl of lightrom3 is
begin
	
	-- program = the 3 bit values stored at each address

	data <= 
      "000" when addr = "0000" else -- move 0s to LR  00000000
      
      "001" when addr = "0100" else -- shift LR right 01111111
      "111" when addr = "0110" else -- rotate LR left 01111110
      "001" when addr = "0100" else -- shift LR right 01111111
      "111" when addr = "0110" else -- rotate LR left 01111110
      "001" when addr = "0100" else -- shift LR right 01111111
      "111" when addr = "0110" else -- rotate LR left 01111110
      "001" when addr = "0100" else -- shift LR right 01111111
      "111" when addr = "0110" else -- rotate LR left 01111110
      "001" when addr = "0100" else -- shift LR right 01111111
      "111" when addr = "0110" else -- rotate LR left 01111110
      "001" when addr = "0100" else -- shift LR right 01111111
      "111" when addr = "0110" else -- rotate LR left 01111110
      "001" when addr = "0100" else -- shift LR right 01111111
      "111" when addr = "0110" else -- rotate LR left 01111110
      
      "011";     

end rtl;
