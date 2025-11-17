----------------------------------------------------------------------------------
-- Company: Pierrelec
-- Engineer: FREDERIC Pierre-Marie
-- 
-- Create Date: 12.11.2025 10:23:29
-- Design Name: LC3
-- Module Name: ALU - Behavioral
-- Project Name: LC3
-- Target Devices: Nexys4 Artix XC7A100T-CSG324
-- Tool Versions: Vivado 2024.2
-- Description: Implementation of ALU module of LC-3 processor 
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
use IEEE.NUMERIC_STD.ALL;

entity ALU is
Port ( 
    register_data : in std_logic_vector(15 downto 0);
    sr2mux_data : in std_logic_vector(15 downto 0);
    control : in std_logic_vector(1 downto 0);
    gateALU : in std_logic;
    alu_output : out std_logic_vector(15 downto 0)
);
end ALU;

architecture Behavioral of ALU is

begin

    alu_output <= std_logic_vector(unsigned(register_data) + unsigned(sr2mux_data)) when control = "00" and gateALU = '1'
                else register_data AND sr2mux_data when control = "01" and gateALU = '1'
                else not(register_data) when control = "10" and gateALU = '1'
                else register_data when control = "11" and gateALU = '1'
                else (others=>'Z') when gateALU = '0';
    
end Behavioral;
