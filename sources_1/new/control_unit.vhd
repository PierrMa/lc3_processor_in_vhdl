----------------------------------------------------------------------------------
-- Company: Pierrelec
-- Engineer: FREDERIC Pierre-Marie
-- 
-- Create Date: 14.11.2025 20:07:20
-- Design Name: LC3
-- Module Name: ALU - Behavioral
-- Project Name: LC3
-- Target Devices: Nexys4 Artix XC7A100T-CSG324
-- Tool Versions: Vivado 2024.2
-- Description: Implementation of LC-3 processor's FSM
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity control_unit is
Port ( 
    clk,rst : in std_logic;
    ir_data : in std_logic_vector(15 downto 0);
    nzp : in std_logic_vector(2 downto 0);
    gate_marmux : out std_logic;
    marmux_ctrl : out std_logic;
    gatePC : out std_logic;
    ld_pc : out std_logic;
    pcmux_ctrl : out std_logic_vector(1 downto 0);
    dr : out std_logic_vector(2 downto 0);
    ld_reg : out std_logic;
    sr1 : out std_logic_vector(2 downto 0);
    sr2 : out std_logic_vector(2 downto 0);
    addr1mux : out std_logic;
    addr2mux : out std_logic_vector(1 downto 0);
    ld_ir : out std_logic;
    aluk : out std_logic_vector(1 downto 0);
    gate_mdr : out std_logic;
    ld_mdr : out std_logic;
    ld_mar : out std_logic;
    mem_en : out std_logic;
    r_w : out std_logic;
    gate_alu : out std_logic;
    ld_cc : out std_logic
);
end control_unit;

architecture Behavioral of control_unit is

begin


end Behavioral;
