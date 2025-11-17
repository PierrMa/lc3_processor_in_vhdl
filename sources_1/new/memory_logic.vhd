----------------------------------------------------------------------------------
-- Company: Pierrelec
-- Engineer: FREDERIC Pierre-Marie
-- 
-- Create Date: 13.11.2025 19:09:02
-- Design Name: LC3
-- Module Name: memory_logic - Behavioral
-- Project Name: LC3
-- Target Devices: Nexys4 Artix XC7A100T-CSG324
-- Tool Versions: Vivado 2024.2
-- Description: Implementation of MAR and MDR registers, memory and MARMUX of lc-3 processor
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

entity memory_logic is
Port ( 
    clk,rst : std_logic;
    bus_data : in std_logic_vector(15 downto 0);
    ld_mar : in std_logic;
    ld_mdr : in std_logic;
    mem_en : in std_logic;
    r_w : in std_logic; --read if r_w = '1', write if r_w = '0'
    zext_data : in std_logic_vector(15 downto 0);
    add_data : in std_logic_vector(15 downto 0);
    gate_mdr : in std_logic;
    gate_marmux : in std_logic;
    marmux_ctrl : in std_logic;
    mdr_out : out std_logic_vector(15 downto 0);
    marmux_out : out std_logic_vector(15 downto 0)
);
end memory_logic;

architecture Behavioral of memory_logic is
    type mem_type is array (0 to 65535) of std_logic_vector(15 downto 0);
    signal mar_reg : std_logic_vector(15 downto 0);
    signal mdr_reg : std_logic_vector(15 downto 0);
    signal mem : mem_type := (others => (others => '0'));
begin

    process(clk,rst)
    begin
        if rst = '1' then
            mar_reg <= (others=>'0');
            mdr_reg <= (others=>'0');
            mem <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if ld_mar = '1' then mar_reg <= bus_data; end if;
            if mem_en = '1' and r_w = '1' then --read
                if ld_mdr = '1' then 
                    mdr_reg <= mem(to_integer(unsigned(mar_reg)));
                    if gate_mdr = '1' then 
                        mdr_out <= mdr_reg; 
                    else 
                        mdr_out <= (others => 'Z');
                    end if;
                end if;
            end if;
            if mem_en = '1' and r_w = '0' then --write
                if ld_mdr = '1' then 
                    mdr_reg <= bus_data;
                    mem(to_integer(unsigned(mar_reg))) <= mdr_reg;
                end if;
            end if; 
        end if;
    end process;

    marmux_out <= add_data when marmux_ctrl = '0' and gate_marmux = '1'
                  else zext_data when marmux_ctrl = '1' and gate_marmux = '1'
                  else (others => 'Z') when gate_marmux = '0';
                  
    
end Behavioral;
