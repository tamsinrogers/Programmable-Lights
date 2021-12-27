-- Tamsin Rogers
-- 10/5/20
-- CS232 Project4
-- reaction.vhd

-- Quartus II VHDL Template
-- Four-State Moore State Machine

-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lights is

	-- control circuit port statement (3B)
	port
	(
		clk		 : in	std_logic;
		reset	 	 : in	std_logic;								-- key0
		fastButton	 	 : in	std_logic;						-- key1
		pause	 	 : in	std_logic;								-- key2
		invert	 	 : in	std_logic;							-- key3
		lightsig	 : out	std_logic_vector(7 downto 0);
		IRView	 : out	std_logic_vector(2 downto 0)
	);

end entity;

architecture rtl of lights is

	component lightrom

	port 
	(
		addr	:  in std_logic_vector(3 downto 0);
		data  : out std_logic_vector(2 downto 0)
	);
	
	end component;

	type state_type is (sFetch, sExecute);	-- state machine
	
	-- internal signals (3C)
	signal IR			:	std_logic_vector(2 downto 0);	-- register
	signal PC			:	unsigned(3 downto 0);			-- register
	signal LR			:	unsigned(7 downto 0);			-- drives board LED dislplay
	signal ROMvalue	:	std_logic_vector(2 downto 0);

	-- Register to hold the current state
	signal state   : state_type;
	signal slowclock : std_logic;								-- the slowclock signal
  	signal counter: unsigned (24 downto 0);				-- the counter to be used in the slowclock

begin

	lightrom1: lightrom											-- change lightrom to lightrom2 or lightrom3 to run the other programs
		port map(addr => std_logic_vector(PC), data => ROMvalue);

	-- slow down the clock
  process(clk, reset) 
    begin
      if reset = '0' then
        counter <= "0000000000000000000000000";
		  
      elsif (rising_edge(clk)) then
			if fastButton = '0' then							-- if fastButton (key1) pressed
				counter <= counter + 12;							-- run faster
			else
				counter <= counter + 1;							-- slowclock case
			end if;
      end if;
  end process;
	
  slowclock <= counter(24);
  
	-- Logic to advance to the next state
	process (slowclock, reset)
	begin
	
		if reset = '0' then
			state <= sFetch;
			PC <= "0000";
			IR <= "000";
			LR <= "00000000";
			
		elsif (rising_edge(slowclock) and pause = '1') then
			case state is
			
				when sFetch =>
					IR <= ROMvalue;
					PC <= PC+1;
					state <= sExecute;
					
				when sExecute =>
					case IR is
					
						when "000" =>								-- load "00000000" into the LR
							if invert = '0' then	
								LR <= "11111111";
							else
								LR <= "00000000";
							end if;
						
						when "001" =>								-- shift the LR right by one position, fill from the left with a '0'
							if invert = '0' then	
								LR <= LR(1) & LR(2) & LR(3) & LR(4) & LR(5) & LR(6) & LR(7) & '1';
							else
								LR <= '0' & LR(7 downto 1);
							end if;
						
						when "010" =>								-- shift the LR left by one position, fill from the right with a '0'
							if invert = '0' then	
								LR <= '1' & LR(0) & LR(1) & LR(2) & LR(3) & LR(4) & LR(5) & LR(6);
							else
								LR <= LR(6 downto 0) & '0';
							end if;
						
						when "011" =>								-- add 1 to the LR
							if invert = '0' then	
								LR <= LR -1;
							else
								LR <= LR + 1;
							end if;
						
						when "100" =>								-- subtract 1 from the LR
							if invert = '0' then	
								LR <= LR + 1;
							else
								LR <= LR - 1;
							end if;
						
						when "101" =>								-- invert all of the bits of the LR
							if invert = '0' then	
								LR <= LR;
							else
								LR <= NOT LR;
							end if;
						
						when "110" =>								-- rotate the LR right by one position (rightmost bit becomes leftmost bit)
							if invert = '0' then	
								LR <= LR(1) & LR(2) & LR(3) & LR(4) & LR(5) & LR(6) & LR(7) & LR(0);
							else
								LR <= LR(0) & LR(7 downto 1);
							end if;
						
						when "111" =>								-- rotate the LR left by one position (leftmost bit becomes rightmost bit)
							if invert = '0' then	
								LR <= LR(7) & LR(0) & LR(1) & LR(2) & LR(3) & LR(4) & LR(5) & LR(6);
							else
								LR <= LR(6 downto 0) & LR(7);
							end if;
					
						when others =>
							LR <= LR;
						
					end case;
					
					state <= sFetch;								-- set the case back to sFetch
					
			end case;
		end if;
	end process;

	IRview <= IR;
	lightsig <= std_logic_vector(LR);	-- connect internal signals to output signals
  	
end rtl;