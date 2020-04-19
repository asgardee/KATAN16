----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/13/2020 05:22:41 PM
-- Design Name: 
-- Module Name: RoundFunc - Behavioral
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

entity RoundFunc is
    port (
        keya    : in    STD_LOGIC; -- Key expansion terms       
        keyb    : in    STD_LOGIC; -- Key expansion terms   
        IR      : in    STD_LOGIC; -- Irregular update term      
        intext  : in    std_logic_vector(15 downto 0);  -- 16 bit input text
        outtext : out   std_logic_vector(15 downto 0)); -- 16 bit output text
end RoundFunc;

architecture Behavioral of RoundFunc is
    
    -- Intermediate terms for signal expansion
    signal L1, L1s : std_logic_vector(5 downto 0);
    signal L2, L2s : std_logic_vector(9 downto 0);
    signal fa, fb : std_logic;
    -- Selection of xi and yi bits
    constant x1 : natural := 2-1;
    constant x2 : natural := 3-1;
    constant x3 : natural := 4-1;
    constant x4 : natural := 1-1;
    constant x5 : natural := 6-1;
    constant y1 : natural := 10-1;
    constant y2 : natural := 1-1;
    constant y3 : natural := 3-1;
    constant y4 : natural := 7-1;
    constant y5 : natural := 5-1;
    constant y6 : natural := 8-1;

begin
    
    -- Seperating input text into vectors L1 and L2
    L1 <= intext(15 downto 10);
    L2 <= intext(9 downto 0);
    
    -- Calculating non-linear update terms from L1/L2, IR, and keya/keyb
    fa <= L1(x1) xor L1(x2) xor (L1(x3) and L1(x4)) xor (L1(x5) and IR) xor keya;
    fb <= L2(y1) xor L2(y2) xor (L2(y3) and L2(y4)) xor (L2(y5) and L2(y6)) xor keyb;
    
    -- Updating L1 and L2 vectors
    L1s <= L1(4 downto 0) & fb;
    L2s <= L2(8 downto 0) & fa;
    
    -- Concatenating L1 and L2 to create round encrypted text
    outtext <= L1s & L2s;

end Behavioral;
