library ieee;
use ieee.std_logic_1164.all;

entity Mealy is
    port (
        KEY  : in std_logic_vector(1 downto 0);  -- KEY(0): clock, KEY(1): reset
        SW   : in std_logic_vector(0 downto 0);  -- SW(0): entrada x
        LEDR : out std_logic_vector(0 downto 0)  -- LEDR(0): saída z
    );
end Mealy;

architecture behavior of Mealy is
    type state_type is (S0, S1, S2, S3);
    signal state, next_state : state_type;
    signal z_internal : std_logic;
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

    -- Lógica de transição de estados e cálculo da saída
    process (state, SW)
    begin
        z_internal <= '0';  -- valor padrão
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
                    z_internal <= '1';  -- Reconhecimento imediato!
                else
                    next_state <= S0;
                end if;
        end case;
    end process;

    -- Conecta a saída à LEDR(0)
    LEDR(0) <= z_internal;

end behavior;
