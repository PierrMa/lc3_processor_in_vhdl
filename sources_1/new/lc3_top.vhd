----------------------------------------------------------------------------------
-- Company: Pierrelec
-- Engineer: FREDERIC Pierre-Marie
-- 
-- Create Date: 13.11.2025 13:50:01
-- Design Name: LC3
-- Module Name: lc3_top - Behavioral
-- Project Name: LC3
-- Target Devices: Nexys4 Artix XC7A100T-CSG324
-- Tool Versions: Vivado 2024.2
-- Description: Top module
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

entity lc3_top is
Port ( 
    clk,rst : in std_logic
);
end lc3_top;

architecture Behavioral of lc3_top is
    -- compute_addr_logic
    signal ir : std_logic_vector(15 downto 0); --instruction value
    signal pc : std_logic_vector(15 downto 0); --current instruction
    signal sr1_out : std_logic_vector(15 downto 0);
    signal sr2_out : std_logic_vector(15 downto 0);
    signal addr1mux_ctrl : std_logic;
    signal addr2mux_ctrl : std_logic_vector(1 downto 0);
    -- alu
    signal sr2mux_data : std_logic_vector(15 downto 0);
    signal aluk : std_logic_vector(1 downto 0);
    signal gateALU : std_logic;
    -- pc_logic
    signal add_data : std_logic_vector(15 downto 0);
    signal pcmux_control : std_logic_vector(1 downto 0);
    signal ld_pc : std_logic;
    signal gatePC : std_logic;
    -- reg_file
    signal dr : std_logic_vector(2 downto 0); --destination register address
    signal ld_reg : std_logic;
    signal sr1,sr2 : std_logic_vector(2 downto 0); --source registers addresses
    -- nzp_logic
    signal ld_cc : std_logic;
    signal nzp : std_logic_vector(2 downto 0);
    -- memory_logic
    signal ld_mar : std_logic;
    signal ld_mdr : std_logic;
    signal mem_en : std_logic;
    signal r_w : std_logic; --read if r_w = '1', write if r_w = '0'
    signal zext_data : std_logic_vector(15 downto 0);
    signal gate_mdr : std_logic;
    signal gate_marmux : std_logic;
    signal marmux_ctrl : std_logic;
    -- ir
    signal ld_ir : std_logic;
    signal ir_data : std_logic_vector(15 downto 0);
    -- bus
    signal bus_data : std_logic_vector(15 downto 0);
    --control unit
     
begin

    compute_addr_logic_inst : entity work.compute_addr_logic
    port map(
        ir => ir,
        pc => pc,
        sr1_out => sr1_out,
        sr2_out => sr2_out,
        addr1mux_ctrl => addr1mux_ctrl,
        addr2mux_ctrl => addr2mux_ctrl,
        add_out => add_data,
        zext_out => zext_data,
        sr2mux_out => sr2mux_data
    );
    
    alu_inst : entity work.alu
    port map(
        register_data => sr1_out,
        sr2mux_data => sr2mux_data,
        control => aluk,
        gateALU => gateALU,
        alu_output => bus_data
    );
    
    pc_logic_inst : entity work.pc_logic
    port map(
        clk => clk,
        rst => rst,
        add_data => add_data,
        bus_data => bus_data,
        pcmux_control => pcmux_control,
        ld_pc => ld_pc,
        gatePC => gatePC,
        pc_data => pc,
        gate_out => bus_data
    );
    
    reg_file_inst : entity work.reg_file
    port map(
        clk => clk,
        rst => rst,
        data_in => bus_data,
        dr => dr,
        ld_reg => ld_reg,
        sr1 => sr1,
        sr2 => sr2,
        sr1_out => sr1_out,
        sr2_out => sr2_out
    );
    
    nzp_logic_inst : entity work.nzp_logic
    port map(
        clk => clk,
        rst => rst,
        bus_data => bus_data,
        ld_cc => ld_cc,
        nzp_out => nzp
    );
    
    memory_logic_inst : entity work.memory_logic
    port map(
        clk => clk,
        rst => rst,
        bus_data => bus_data,
        ld_mar => ld_mar,
        ld_mdr => ld_mdr,
        mem_en => mem_en,
        r_w => r_w,
        zext_data => zext_data,
        add_data => add_data,
        gate_mdr => gate_mdr,
        gate_marmux => gate_marmux,
        marmux_ctrl => marmux_ctrl,
        mdr_out => bus_data,
        marmux_out => bus_data
    );
    
    ir_inst : entity work.ir
    port map(
        clk => clk,
        rst => rst,
        bus_data => bus_data,
        ld_ir => ld_ir,
        ir_out => ir_data
    );
    
    control_unit_inst : entity work.control_unit
    port map(
        clk => clk,
        rst => rst,
        ir_data => ir_data,
        nzp => nzp,
        gate_marmux => gate_marmux,
        marmux_ctrl => marmux_ctrl,
        gatePC => gatePC,
        ld_pc => ld_pc,
        pcmux_ctrl => pcmux_control,
        dr => dr,
        ld_reg => ld_reg,
        sr1 => sr1,
        sr2 => sr2,
        addr1mux => addr1mux_ctrl,
        addr2mux => addr2mux_ctrl,
        ld_ir => ld_ir,
        aluk => aluk,
        gate_mdr => gate_mdr,
        ld_mdr => ld_mdr,
        ld_mar => ld_mar,
        mem_en => mem_en,
        r_w => r_w,
        gate_alu => gateALU,
        ld_cc => ld_cc
    );
    
end Behavioral;
