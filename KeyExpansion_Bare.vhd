----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/13/2020 05:00:05 PM
-- Design Name: 
-- Module Name: KeyExpansion_Bare - Behavioral
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


entity KeyExpansion_Bare is
    Port ( keyi : in  STD_LOGIC_VECTOR (79 downto 0);  -- Input key 
           keyo : out STD_LOGIC_VECTOR (79 downto 0)); -- Expanded output key 
end KeyExpansion_Bare;

architecture Behavioral of KeyExpansion_Bare is

-- Hold outputs of non-linear key expansion terms
signal keya, keyb : std_logic;

begin
    
    -- Calculting outputs of non-linear key expansion terms
    keya <= (keyi(79) xor keyi(60) xor keyi(49) xor keyi(12));
    keyb <= (keyi(78) xor keyi(59) xor keyi(48) xor keyi(11));
    
    -- Shifting key expansion terms into output key
    keyo <= keyi(77 downto 0) & keya & keyb;
    
end Behavioral;
