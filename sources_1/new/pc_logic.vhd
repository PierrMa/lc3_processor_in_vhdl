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
-- Description: Implementation of PC module of LC-3 processor and all connected logic (PCMUX,GatePC)
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

entity pc_logic is
Port ( 
    add_data : in std_logic_vector(15 downto 0);
    bus_data : in std_logic_vector(15 downto 0);
    pcmux_control : in std_logic_vector(1 downto 0);
    pc_control : in std_logic;
    gatePC : in std_logic;
    pc_data : out std_logic_vector(15 downto 0); -- pc register output before tristate buffer
    gate_out : out std_logic_vector(15 downto 0) -- pc register output after tristate buffer
);
end pc_logic;

architecture Behavioral of pc_logic is
    signal pc_data_s : std_logic_vector(15 downto 0) := x"3000";
    signal pcmux_data : std_logic_vector(15 downto 0);
begin

    pcmux_data <= std_logic_vector(unsigned(pc_data_s) + 1) when pcmux_control = "00"
                  else add_data when pcmux_control = "01"
                  else bus_data when pcmux_control = "10";
                  
    pc_data_s <= pcmux_data when pc_control = '1';
    
    pc_data <= pc_data_s;
    gate_out <= pc_data_s when gatePC = '1' else (others => 'Z');
end Behavioral;
