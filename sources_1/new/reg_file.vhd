----------------------------------------------------------------------------------
-- Company: Pierrelec
-- Engineer: FREDERIC Pierre-Marie
-- 
-- Create Date: 13.11.2025 12:05:29
-- Design Name: LC3
-- Module Name: reg_file - Behavioral
-- Project Name: LC3
-- Target Devices: Nexys4 Artix XC7A100T-CSG324
-- Tool Versions: Vivado 2024.2
-- Description: Implementation of registers of LC-3 processor
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

entity reg_file is
Port ( 
    clk,rst : in std_logic;
    data_in : in std_logic_vector(15 downto 0);
    dr : in std_logic_vector(2 downto 0); --destination register address
    ld_reg : in std_logic;
    sr1,sr2 : in std_logic_vector(2 downto 0); --source registers addresses
    sr1_out,sr2_out : out std_logic_vector(15 downto 0)
);
end reg_file;

architecture Behavioral of reg_file is
signal r0,r1,r2,r3,r4,r5,r6,r7 : std_logic_vector(15 downto 0);

begin

process (clk,rst)
begin
    if rst='1' then 
        r0 <= (others =>'0');
        r1 <= (others =>'0');
        r2 <= (others =>'0');
        r3 <= (others =>'0');
        r4 <= (others =>'0');
        r5 <= (others =>'0');
        r6 <= (others =>'0');
        r7 <= (others =>'0');
    elsif rising_edge(clk) then
        if ld_reg = '1' then
            case dr is
            when "000" => r0 <= data_in;
            when "001" => r1 <= data_in;
            when "010" => r2 <= data_in;
            when "011" => r3 <= data_in;
            when "100" => r4 <= data_in;
            when "101" => r5 <= data_in;
            when "110" => r6 <= data_in;
            when "111" => r7 <= data_in;
            end case;
        end if;
    end if;
end process;

sr1_out <= r0 when sr1 = "000"
           else r1 when sr1 = "001"
           else r2 when sr1 = "010"
           else r3 when sr1 = "011"
           else r4 when sr1 = "100"
           else r5 when sr1 = "101"
           else r6 when sr1 = "110"
           else r7 when sr1 = "111";
sr2_out <= r0 when sr2 = "000"
           else r1 when sr2 = "001"
           else r2 when sr2 = "010"
           else r3 when sr2 = "011"
           else r4 when sr2 = "100"
           else r5 when sr2 = "101"
           else r6 when sr2 = "110"
           else r7 when sr2 = "111";

end Behavioral;
