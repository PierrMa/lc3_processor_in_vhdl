----------------------------------------------------------------------------------
-- Company: Pierrelec
-- Engineer: FREDERIC Pierre-Marie
-- 
-- Create Date: 13.11.2025 13:40:44
-- Design Name: LC3
-- Module Name: compute_addr_logic - Behavioral
-- Project Name: LC3
-- Target Devices: Nexys4 Artix XC7A100T-CSG324
-- Tool Versions: Vivado 2024.2
-- Description: Implementation of the logic used to determine the rigth address based on IR value
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

entity compute_addr_logic is
Port ( 
    ir : in std_logic_vector(15 downto 0); --instruction value
    pc : in std_logic_vector(15 downto 0); --current instruction
    sr1_out : in std_logic_vector(15 downto 0);
    sr2_out : in std_logic_vector(15 downto 0);
    addr1mux_ctrl : in std_logic;
    addr2mux_ctrl : in std_logic_vector(1 downto 0);
    add_out : out std_logic_vector(15 downto 0);
    zext_out : out std_logic_vector(15 downto 0);
    sr2mux_out : out std_logic_vector(15 downto 0)
);
end compute_addr_logic;

architecture Behavioral of compute_addr_logic is
    signal sext1_in : std_logic_vector(5 downto 0);
    signal sext2_in : std_logic_vector(8 downto 0);
    signal sext3_in : std_logic_vector(10 downto 0);
    signal sext1_out,sext2_out,sext3_out : std_logic_vector(15 downto 0);
    signal zext_in : std_logic_vector(7 downto 0);
    signal sext_sr2_in : std_logic_vector(4 downto 0);
    signal sext_sr2_out : std_logic_vector(15 downto 0);
    signal sr2mux_ctrl : std_logic;
    signal addr1mux_out : std_logic_vector(15 downto 0);
    signal addr2mux_out : std_logic_vector(15 downto 0);
begin

    zext_in <= ir(7 downto 0);
    zext_out <= x"00"&zext_in;
    
    sext1_in <= ir(5 downto 0);
    sext2_in <= ir(8 downto 0);
    sext3_in <= ir(10 downto 0);
    sext1_out <= x"00"&"00"&sext1_in when sext1_in(5) = '0'
                 else x"FF"&"11"&sext1_in when sext1_in(5) = '1';
    sext2_out <= "0000000"&sext2_in when sext2_in(8) = '0'
                 else "1111111"&sext2_in when sext2_in(8) = '1';
    sext3_out <= "00000"&sext3_in when sext3_in(10) = '0'
                 else "11111"&sext3_in when sext3_in(10) = '1';
                 
    sext_sr2_in <= ir(4 downto 0);
    sext_sr2_out <= x"00"&"000"&sext_sr2_in when sext_sr2_in(4) = '0'
                 else x"FF"&"111"&sext_sr2_in when sext_sr2_in(4) = '1';
    
    sr2mux_ctrl <= ir(5);
    
    addr1mux_out <= pc when addr1mux_ctrl ='0' else sr1_out;
    addr2mux_out <= x"0000" when addr2mux_ctrl = "00"
                    else sext1_out when addr2mux_ctrl = "01"
                    else sext2_out when addr2mux_ctrl = "10"
                    else sext3_out when addr2mux_ctrl = "11";
    
    add_out <= std_logic_vector(unsigned(addr1mux_out) + unsigned(addr2mux_out));
    
    sr2mux_out <= sr2_out when sr2mux_ctrl = '0' else sext_sr2_out;
                    
end Behavioral;
