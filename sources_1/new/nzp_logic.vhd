----------------------------------------------------------------------------------
-- Company: Pierrelec
-- Engineer: FREDERIC Pierre-Marie
-- 
-- Create Date: 13.11.2025 18:19:22
-- Design Name: LC3
-- Module Name: nzp_logic - Behavioral
-- Project Name: LC3
-- Target Devices: Nexys4 Artix XC7A100T-CSG324
-- Tool Versions: Vivado 2024.2
-- Description: Implementation of Logic and NZP modules of LC3 processor.
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

entity nzp_logic is
Port ( 
    clk,rst : in std_logic;
    bus_data : in std_logic_vector(15 downto 0);
    ld_cc : in std_logic;
    nzp_out : out std_logic_vector(2 downto 0)
);
end nzp_logic;

architecture Behavioral of nzp_logic is
    signal nzp_s : std_logic_vector(2 downto 0);
    signal n,z,p : std_logic;
begin
    
    n <= bus_data(15);
    z <= '1' when bus_data = x"0000" else '0';
    p <= '1' when bus_data(15) = '0' and bus_data /= x"0000" else '0';
    nzp_s <= n&z&p;
    
    process(clk,rst)
    begin
        if rst = '1' then nzp_out <= "000";
        elsif rising_edge(clk) and ld_cc = '1' then
            nzp_out <= nzp_s;
        end if;
    end process;
end Behavioral;
