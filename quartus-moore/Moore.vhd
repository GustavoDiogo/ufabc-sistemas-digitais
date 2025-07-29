library ieee;
use ieee.std_logic_1164.all;

entity Moore is
    port (
        KEY  : in std_logic_vector(1 downto 0);  -- KEY(0) = clk, KEY(1) = reset
        SW   : in std_logic_vector(0 downto 0);  -- SW(0) = entrada x
        LEDR : out std_logic_vector(0 downto 0)  -- LEDR(0) = saída z
        -- Opcional: saída HEX para mostrar estado
    );
end Moore;

architecture behavior of Moore is
    type state_type is (S0, S1, S2, S3, S4);
    signal state, next_state : state_type;
begin
    -- Processamento do estado
    process (KEY)
    begin
        if (KEY(1) = '0') then
            state <= S0;  -- Reset ativo em nível baixo
        elsif rising_edge(KEY(0)) then
            state <= next_state;
        end if;
    end process;

    -- Transições de estado baseadas na entrada x
    process (state, SW)
    begin
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
                    next_state <= S4;
                else
                    next_state <= S0;
                end if;
            when S4 =>
                if SW(0) = '1' then
                    next_state <= S2;
                else
                    next_state <= S0;
                end if;
        end case;
    end process;

    -- Saída Moore: depende apenas do estado
    LEDR(0) <= '1' when state = S4 else '0';
end behavior;
