library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KATAN16_BareV2_tb is
--  Port ( );
end KATAN16_BareV2_tb;

architecture Behavioral of KATAN16_BareV2_tb is

    component KATAN16_BareV2 is
    port (
        clk        : in    STD_LOGIC := '0';           
        Start      : in    STD_LOGIC := '0';             -- Starts the counter
        plaintext  : in    std_logic_vector(15 downto 0) := (others => '0'); -- 16 bit input/ouput text
        key        : in    std_logic_vector(79 downto 0) := (others => '1'); -- 80 bit key
        ciphertext : out   std_logic_vector(15 downto 0));
    end component;

    -- Signals in KATAN16 system
    signal Start, clk: STD_LOGIC := '0';
    signal key        : std_logic_vector(79 downto 0) := (others => '1');
    signal plaintext  : std_logic_vector(15 downto 0) := (others => '0');
    signal ciphertext : std_logic_vector(15 downto 0);
    
    -- Signal for testbench clarity
    signal round_count : integer := -2;

begin

    -- Port mapping the KATAN16 system
    Encrypt : KATAN16_BareV2 port map (
        clk        => clk       ,
        Start      => Start     ,
        plaintext  => plaintext ,
        key        => key       ,
        ciphertext => ciphertext      
    );  

        -- Cycles through clock
    clock_prc : process
    begin
        wait for 2ns;
        clk <= not clk; 
    end process;
    
    -- Counts the rounds
    round_count_prc : process(clk)
    begin
        if rising_edge(clk) then
            round_count <= round_count + 1;
        end if;
    end process;
    
    -- Running test case
    test_cases_prc : process
    begin      
        -- Toggle start signal
        Start <= '1';
        wait until round_count = -1;
        wait for 500ps;
        Start <= '0';
        wait until round_count = 300;
        wait;
    end process;

end Behavioral;
