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
    type fsm_t is (INIT,FETCH1,FETCH2,FETCH3,DECODE,EXECUTE,MEMORY_ACCESS,WRITE_BACK);
    signal actual_st, next_st: fsm_t;
    signal round2 : std_logic := '0';
    
begin

    process(clk,rst)
    begin
        if rst = '1' then actual_st <= INIT;
        elsif rising_edge(clk) then
            actual_st <= next_st;
        end if;
    end process;
    
    process(actual_st)
    begin
        case actual_st is
        when INIT => 
            gate_marmux <= '0';
            marmux_ctrl <= '0';
            gatePC <= '0';
            ld_pc <= '0';
            pcmux_ctrl <= (others => '0');
            dr <= (others => '0');
            ld_reg <= '0';
            sr1 <= (others => '0');
            sr2 <= (others => '0');
            addr1mux <= '0';
            addr2mux <= (others => '0');
            ld_ir <= '1';
            aluk <= (others => '0');
            gate_mdr <= '0';
            ld_mdr <= '0';
            ld_mar <= '0';
            mem_en <= '0';
            r_w <= '1';
            gate_alu <= '0';
            ld_cc <= '0';
            
            next_st <= FETCH1;
            
        when FETCH1 => -- get address from pc and put it into MAR
            gatePC <= '1';
            ld_mar <= '1';
            ld_pc <= '0';
            
            next_st <= FETCH2;
        
        when FETCH2 => -- get instruction from memory[addr] and put it into MDR
            ld_mar <= '0';
            ld_mdr <= '1';
            gate_mdr <= '1';
            mem_en <= '1';
            r_w <= '1';
            
            next_st <= FETCH3;
        
        when FETCH3 => -- get instruction from the bus into IR
            ld_mdr <= '0';
            gate_mdr <= '0';
            mem_en <= '0';
            r_w <= '0';
            ld_ir <= '1';
            
            next_st <= DECODE;
            
        when DECODE =>
            gatePC <= '0';
            ld_ir <= '0';
            case ir_data(15 downto 12) is
            when "0001" => -- ADD 
                dr <= ir_data(11 downto 9);
                sr1 <= ir_data(8 downto 6);
                sr2 <= ir_data(2 downto 0);
                
                pcmux_ctrl <= "00";
                addr1mux <= '0';
                addr2mux <= "00";
                marmux_ctrl <= '0';
                gate_marmux <= '0';
                
                next_st <= EXECUTE;
               
            when "0101" => -- AND
                dr <= ir_data(11 downto 9);
                sr1 <= ir_data(8 downto 6);
                sr2 <= ir_data(2 downto 0);
                
                pcmux_ctrl <= "00";
                addr1mux <= '0';
                addr2mux <= "00";
                marmux_ctrl <= '0';
                gate_marmux <= '0';
                
                next_st <= EXECUTE;
                
            when "0000" => -- BR 
                addr1mux <= '0';
                marmux_ctrl <= '0';
                gate_marmux <= '0';
                if (nzp(2) = '1' and ir_data(11)= '1') or (nzp(1)= '1' and ir_data(10)= '1') or (nzp(0)= '1' and ir_data(9)= '1') then 
                    pcmux_ctrl <= "01";
                    addr2mux <= "10";
                else 
                    pcmux_ctrl <= "00";
                    addr2mux <= "00";
                end if;
                ld_pc <= '1';
                
                next_st <= FETCH1;
                
            when "1100" => -- JMP & RET
                sr1 <= ir_data(8 downto 6);
                next_st <= EXECUTE;
                
            when "0100" => -- JSR & JSRR
                --save pc
                gatePC <= '1';
                ld_reg <= '1';
                dr <= "111";
                next_st <= EXECUTE;
            
            when "0010" => -- LD
                addr2mux <= "10";
                addr1mux <= '0';
                marmux_ctrl <= '0';
                gate_marmux <= '1';
                ld_mar <= '1';
                next_st <= EXECUTE;
                
            when "1010" => -- LDI
                addr2mux <= "10";
                addr1mux <= '0';
                marmux_ctrl <= '0';
                gate_marmux <= '1';
                ld_mar <= '1';
                round2 <= '0';
                next_st <= EXECUTE;
                
            when "0110" => -- LDR
                sr1 <= ir_data(8 downto 6);
                addr2mux <= "01";
                addr1mux <= '1';
                marmux_ctrl <= '0';
                gate_marmux <= '1';
                ld_mar <= '1';
                next_st <= EXECUTE;
                
            when "1110" => -- LEA
                addr2mux <= "10";
                addr1mux <= '0';
                marmux_ctrl <= '0';
                gate_marmux <= '1';
                dr <= ir_data(11 downto 9);
                ld_reg <= '1';
                pcmux_ctrl <= "00";
                ld_pc <= '1';
                next_st <= FETCH1;
                
            when "1001" => -- NOT
                sr1 <= ir_data(8 downto 6);
                aluk <= "10";
                gate_alu <= '1';
                next_st <= EXECUTE;
                
            when "0011" => -- ST
            when "1011" => -- STI
            when "0111" => -- STR
            when "1111" => -- TRAP
            when "1101" => -- reserved
            end case;
        
        when EXECUTE =>
            case ir_data(15 downto 12) is
            when "0001" => -- ADD
                aluk <= "00";
                gate_alu <= '1';
                ld_cc <= '1';
                ld_reg <= '1';
                ld_pc <= '1';
                next_st <= FETCH1;
                
            when "0101" => -- AND
                aluk <= "01";
                gate_alu <= '1';
                ld_cc <= '1';
                ld_reg <= '1';
                ld_pc <= '1';
                next_st <= FETCH1;
            
            when "1100" => -- JMP & RET
                addr1mux <= '1';
                addr2mux <= "00";
                pcmux_ctrl <= "01";
                ld_pc <= '1';
                next_st <= FETCH1;
                
            when "0100" => -- JSR & JSRR--go to subroutine
                if ir_data(11) = '0' then --use BaseR
                    sr1 <= ir_data(8 downto 6);
                    addr1mux <= '1';
                    addr2mux <= "00";
                    pcmux_ctrl <= "01";
                elsif ir_data(11) = '1' then -- use PCoffset11
                    addr1mux <= '0';
                    addr2mux <= "11";
                    pcmux_ctrl <= "01";
                end if;
                ld_pc <= '1';
                next_st <= FETCH1;
                
            when "0010" => -- LD
                gate_marmux <= '0';
                ld_mar <= '0';
                mem_en <= '1';
                r_w <= '1';
                ld_mdr <= '1';
                gate_mdr <= '1';
                next_st <= WRITE_BACK;
                
            when "1010" => -- LDI
                mem_en <= '1';
                r_w <= '1';
                ld_mdr <= '1';
                gate_mdr <= '1';
                ld_ir <= '1';
                if round2 = '0' then 
                    round2 <= '1';
                    next_st <= DECODE;
                else
                    round2 <= '0';
                    next_st <= WRITE_BACK;
                end if;
                
            when "0110" => -- LDR
                mem_en <= '1';
                r_w <= '1';
                ld_mdr <= '1';
                gate_mdr <= '1';
                next_st <= WRITE_BACK;
                
            when "1001" => -- NOT
                dr <= ir_data(11 downto 9);
                ld_reg <= '1';
                ld_cc <= '1';
                next_st <= FETCH1;
            
            when "0011" => -- ST
            when "1011" => -- STI
            when "0111" => -- STR
            when "1111" => -- TRAP
            when "1101" => -- reserved
            end case; 
            
        when WRITE_BACK =>
            mem_en <= '0';
            ld_mdr <= '0';
            gate_mdr <= '0';
            --write result in DR
            ld_reg <= '1';
            dr <= ir_data(11 downto 9);
            --prepare next cycle
            ld_cc <= '1';
            pcmux_ctrl <= "00";
            ld_pc <= '1';
            next_st <= FETCH1;
            
        end case;
    end process;
        
end Behavioral;
