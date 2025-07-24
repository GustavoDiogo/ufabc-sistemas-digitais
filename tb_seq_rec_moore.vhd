library ieee;
use ieee.std_logic_1164.all;

-- Entidade do testbench (não tem portas pois só serve para testar)
entity tb_seq_rec_moore is
end tb_seq_rec_moore;

architecture test of tb_seq_rec_moore is
    -- Declaramos o componente que vamos testar
    component seq_rec_moore
        port (
            clk     : in  std_logic;
            reset   : in  std_logic;
            x       : in  std_logic;
            z       : out std_logic
        );
    end component;

    -- Sinais internos que ligam ao DUT (Device Under Test)
    signal clk     : std_logic := '0';
    signal reset   : std_logic := '1';  -- Começamos com reset ativado
    signal x       : std_logic := '0';  -- Entrada do sistema
    signal z       : std_logic;        -- Saída do sistema

    constant clk_period : time := 10 ns;  -- Período do clock (10 ns)
begin
    -- Instanciamos o componente a ser testado
    uut: seq_rec_moore
        port map (
            clk   => clk,
            reset => reset,
            x     => x,
            z     => z
        );

    -- Processo que gera o clock (sobe e desce a cada 5 ns)
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Processo de estímulo: aqui definimos os testes que serão aplicados
    stim_proc: process
    begin
        -- Mantemos o reset ativo por 20 ns e depois desativamos
        wait for 20 ns;
        reset <= '0';

        -- A partir daqui aplicamos a sequência de entrada bit a bit

        -- Enviando a sequência: 1, 1, 0, 1 → Deve ativar a saída 'z'
        x <= '1'; wait for clk_period;
        x <= '1'; wait for clk_period;
        x <= '0'; wait for clk_period;
        x <= '1'; wait for clk_period;

        -- Adicionamos algumas sequências extras para validar outras transições
        x <= '0'; wait for clk_period;
        x <= '1'; wait for clk_period;
        x <= '0'; wait for clk_period;
        x <= '1'; wait for clk_period;

        -- Encerramos a simulação com uma pausa
        wait for 50 ns;

        -- Comando que para a simulação com uma mensagem
        assert false report "Fim da simulação." severity failure;
    end process;

end test;
