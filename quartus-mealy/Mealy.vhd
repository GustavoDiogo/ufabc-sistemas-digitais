library ieee;
use ieee.std_logic_1164.all;

entity Mealy is
    port (
        KEY  : in std_logic_vector(1 downto 0);  -- KEY(0): clock, KEY(1): reset
        SW   : in std_logic_vector(0 downto 0);  -- SW(0): entrada x
        LEDR : out std_logic_vector(0 downto 0); -- LEDR(0): saída z
        HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 : out std_logic_vector(0 to 6)
    );
end Mealy;

architecture behavior of Mealy is
    type state_type is (S0, S1, S2, S3);
    signal state, next_state : state_type;
    signal z_internal : std_logic;

    -- Mapeamento 7 segmentos (ativo baixo)
	function char_to_7seg(c: character) return std_logic_vector is
	begin
		 case c is
			  when 'F' => return "0111000"; -- segmentos 0,4,5,6
			  when 'O' => return "0000001"; -- segmentos 0,1,2,3,4,5
			  when 'I' => return "1111001"; -- segmentos 1,2
			  when ' ' => return "1111111"; -- apagado
			  when others => return "1111111";
		 end case;
	end;
begin
    -- Processamento do estado
    process (KEY)
    begin
        if (KEY(1) = '0') then
            state <= S0;
        elsif rising_edge(KEY(0)) then
            state <= next_state;
        end if;
    end process;

    -- Lógica de transição e detecção da sequência
    process (state, SW)
    begin
        z_internal <= '0';
        case state is
            when S0 =>
                if SW(0) = '1' then
                    next_state <= S1;
                else
                    next_state <= S0;
                end if;
            when S1 =>
                if SW(0) = '1' then
                    next_state <= S2;
                else
                    next_state <= S0;
                end if;
            when S2 =>
                if SW(0) = '0' then
                    next_state <= S3;
                else
                    next_state <= S2;
                end if;
            when S3 =>
                if SW(0) = '1' then
                    next_state <= S1;
                    z_internal <= '1';  -- Ativa por 1 ciclo
                else
                    next_state <= S0;
                end if;
        end case;
    end process;

    LEDR(0) <= z_internal;

    -- Displays com "  FOI "
    process(z_internal)
    begin
        if z_internal = '1' then
            HEX5 <= char_to_7seg(' ');
            HEX4 <= char_to_7seg(' ');
            HEX3 <= char_to_7seg('F');
            HEX2 <= char_to_7seg('O');
            HEX1 <= char_to_7seg('I');
            HEX0 <= char_to_7seg(' ');
        else
            HEX5 <= (others => '1');
            HEX4 <= (others => '1');
            HEX3 <= (others => '1');
            HEX2 <= (others => '1');
            HEX1 <= (others => '1');
            HEX0 <= (others => '1');
        end if;
    end process;
end behavior;
