----------------------------------------------------------------------------------
-- Engineer: David Asgar-Deen
-- 
-- Create Date: 04/13/2020 05:17:12 PM
-- Design Name: KATAN16
-- Module Name: RoundCount - Behavioral
-- Project Name: KATAN16+
-- Target Devices: xc7z010clg400-1 
-- Description: Round counter used for KATAN16 cipher. This module also provides
-- the irregular update term used by the round function.
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

entity RoundCount is
    Port ( clk     : in    STD_LOGIC := '0';   
           Start   : in    STD_LOGIC := '0';  -- Starts the counter
           Looping : inout STD_LOGIC := '0';  -- Flagged high system is looping
           Finish  : out   STD_LOGIC := '0';  -- Flagged high when LFSR loops back
           IR      : out   STD_LOGIC := '1'); -- Irregular update term (MSB of LFSR)
end RoundCount;

architecture Behavioral of RoundCount is

constant LFSR_ini : std_logic_vector(7 downto 0) := (others => '1'); -- Initial state for round count LFSR
constant LFSR_ini_next : std_logic_vector(7 downto 0) := (0 => '0', others => '1'); -- Initial state for round count LFSR
signal LFSR8 : std_logic_vector(7 downto 0) := LFSR_ini;

begin

    RoundCount_LSFR : process(clk,Start) is
    begin
        if rising_edge(clk) then
            if Start = '1' then
                LFSR8 <= LFSR_ini_next;
                Looping <= '1'; -- Indicates loop is starting 
                Finish <= '0';
                
            -- Start the LFSR when 'Looping' signal is asserted
            elsif Looping = '1' then
                IR <= LFSR8(7); -- MSB of LFSR goes to the IR term
                -- Shifting LFSR with feedback polynomial x8+x7+x5+x3+1
                LFSR8 <= LFSR8(6 downto 0) & (LFSR8(7) xor LFSR8(6) xor LFSR8(4) xor LFSR8(2));
                -- Stops looping and updates the finish signal after 254 itterations
                if (LFSR8 = LFSR_ini) then 
                    Looping <= '0';
                    Finish <= '1';
                end if;
            end if;
        end if;
    end process;
    
end Behavioral;
