----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/13/2020 05:38:38 PM
-- Design Name: 
-- Module Name: KATAN16 - Behavioral
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

entity KATAN16 is
    port (
        clk        : in    STD_LOGIC := '0';           
        Start      : in    STD_LOGIC := '0';             -- Starts the counter
        plaintext  : in    std_logic_vector(15 downto 0) := (others => '0'); -- 16 bit input/ouput text
        key        : in    std_logic_vector(79 downto 0) := (others => '1'); -- 80 bit key
        ciphertext : out   std_logic_vector(15 downto 0));
end KATAN16;

architecture Behavioral of KATAN16 is

    -- Used to run through all 254 rounds and update the IR term
    component RoundCount_Bare is
        Port ( clk     : in    STD_LOGIC := '0';   
               Start   : in    STD_LOGIC := '0';  -- Starts the counter
               Looping : inout STD_LOGIC := '0';  -- Flagged high system is looping
               Finish  : out   STD_LOGIC := '0';  -- Flagged high when LFSR loops back
               IR      : out   STD_LOGIC := '1'); -- Irregular update term (MSB of LFSR)
    end component;  
    
    -- Used to generate the key expansion
    component KeyExpansion_Bare is
    Port ( keyi : in  STD_LOGIC_VECTOR (79 downto 0);  -- Input key 
           keyo : out STD_LOGIC_VECTOR (79 downto 0)); -- Expanded output key 
    end component;  
    
    -- Used to update the encrypted text
    component RoundFunc_Bare is
    port (
        keya    : in    STD_LOGIC; -- Key expansion terms       
        keyb    : in    STD_LOGIC; -- Key expansion terms   
        IR      : in    STD_LOGIC; -- Irregular update term      
        intext  : in    std_logic_vector(15 downto 0);  -- 16 bit input text
        outtext : out   std_logic_vector(15 downto 0)); -- 16 bit output text
    end component;  
    
    -- Signals for round counter
    signal Looping, IR : std_logic;
    signal Finish : std_logic;
    -- Signals for key expansion 
    signal keyi, keyo : STD_LOGIC_VECTOR (79 downto 0);
    -- Signals for round function
    signal keya, keyb: std_logic;
    signal intext, outtext : std_logic_vector(15 downto 0) := plaintext;
    
begin
    
    keya <= keyo(1);
    keyb <= keyo(0);
    
    -- Port mapping for the round counter
    RoundCounter : RoundCount_Bare port map (
        clk     => clk    ,
        Start   => Start  ,
        Looping => Looping,
        Finish  => Finish ,
        IR      => IR         
    );  
    
    -- Port mapping for the round counter
    KeyExpans : KeyExpansion_Bare port map (
        keyi => keyi,
        keyo => keyo      
    );  
    
    -- Port mapping for the round counter
    RoundFunc : RoundFunc_Bare port map (
        keya    => keya   ,
        keyb    => keyb   ,
        IR      => IR     ,
        intext  => intext ,
        outtext => outtext
    );
        
    -- Next state logic
    NextRound : process(clk) is
    begin
        if rising_edge(clk)  then      
            if Start = '1' then
                -- Load in initial data
                intext <= plaintext;
                keyi <= key;
            elsif Looping = '1' then
                -- Update next state logic
                keyi <= keyo;
                intext <= outtext;
            elsif Finish = '1' then
                ciphertext <= outtext;
            end if;
           
            if Finish = '1' then
                ciphertext <= outtext;
            end if;
           
        end if;
    end process;

end Behavioral;
