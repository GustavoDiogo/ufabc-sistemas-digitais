library ieee;
use ieee.std_logic_1164.all;

-- Entidade do testbench (sem portas, pois é só para simulação)
entity tb_seq_rec_mealy is
end tb_seq_rec_mealy;

architecture test of tb_seq_rec_mealy is
    -- Declaramos o componente que vamos testar
    component seq_rec
        port (
            clk     : in  std_logic;
            reset   : in  std_logic;
            x       : in  std_logic;
            z       : out std_logic
        );
    end component;

    -- Sinais auxiliares para conectar ao componente
    signal clk     : std_logic := '0';
    signal reset   : std_logic := '1';
    signal x       : std_logic := '0';
    signal z       : std_logic;

    -- Período do clock (10 ns)
    constant clk_period : time := 10 ns;
begin
    -- Instanciação do componente a ser testado
    uut: seq_rec
        port map (
            clk   => clk,
            reset => reset,
            x     => x,
            z     => z
        );

    -- Processo que gera o clock (50% duty cycle)
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Processo que aplica os estímulos (sequência de bits)
    stim_proc: process
    begin
        -- Aplicamos o reset por 20 ns
        wait for 20 ns;
        reset <= '0';

        -- Enviamos a sequência 1, 1, 0, 1 — que deve ativar a saída 'z'
        x <= '1'; wait for clk_period;
        x <= '1'; wait for clk_period;
        x <= '0'; wait for clk_period;
        x <= '1'; wait for clk_period;

        -- Enviamos algumas sequências adicionais para verificar estabilidade
        x <= '0'; wait for clk_period;
        x <= '1'; wait for clk_period;
        x <= '0'; wait for clk_period;
        x <= '1'; wait for clk_period;

        -- Encerramos a simulação
        wait for 50 ns;
        assert false report "Fim da simulação." severity failure;
    end process;

end test;
