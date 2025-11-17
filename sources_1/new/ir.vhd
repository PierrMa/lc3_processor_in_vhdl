----------------------------------------------------------------------------------
-- Company: Pierrelec
-- Engineer: FREDERIC Pierre-Marie
-- 
-- Create Date: 14.11.2025 10:43:02
-- Design Name: LC3
-- Module Name: memory_logic - Behavioral
-- Project Name: LC3
-- Target Devices: Nexys4 Artix XC7A100T-CSG324
-- Tool Versions: Vivado 2024.2
-- Description: Implementation of IR register of LC-3 processor
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

entity ir is
Port ( 
    clk,rst : in std_logic;
    bus_data : in std_logic_vector(15 downto 0);
    ld_ir : in std_logic;
    ir_out : out std_logic_vector(15 downto 0)
);
end ir;

architecture Behavioral of ir is
    signal ir_data: std_logic_vector(15 downto 0);
begin

    process(clk,rst)
    begin
        if rst = '1' then ir_data <= (others => '0');
        elsif rising_edge(clk) then
            if ld_ir = '1' then ir_data <= bus_data; end if;
        end if;
    end process;
    
    ir_out <= ir_data;
end Behavioral;
