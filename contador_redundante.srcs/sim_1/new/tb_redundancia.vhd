library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_redundancia is
end tb_redundancia;

architecture Behavioral of tb_redundancia is
    signal CLK100MHZ : STD_LOGIC := '0';
    signal RESET : STD_LOGIC := '0';
    signal SW : STD_LOGIC_VECTOR(0 downto 0) := "0";
    signal LED : STD_LOGIC_VECTOR(7 downto 0);
    signal LED_CONTADOR_1 : STD_LOGIC;
    signal LED_CONTADOR_2 : STD_LOGIC;
    signal AN : STD_LOGIC_VECTOR(7 downto 0);
    signal SEG : STD_LOGIC_VECTOR(6 downto 0);

    -- Período del reloj: 100 MHz = 10 ns
    constant CLK_PERIOD : time := 10 ns;

    component redundancia
        Generic ( SIMULATION_MODE : boolean := false );
        Port ( CLK100MHZ : in STD_LOGIC;
               RESET : in STD_LOGIC;
               SW : in STD_LOGIC_VECTOR (0 downto 0);
               LED : out STD_LOGIC_VECTOR (7 downto 0);
               LED_CONTADOR_1 : out STD_LOGIC;
               LED_CONTADOR_2 : out STD_LOGIC;
               AN : out STD_LOGIC_VECTOR (7 downto 0);
               SEG : out STD_LOGIC_VECTOR (6 downto 0));
    end component;

begin
    uut: redundancia
        generic map (SIMULATION_MODE => true)
        port map (
            CLK100MHZ => CLK100MHZ,
            RESET => RESET,
            SW => SW,
            LED => LED,
            LED_CONTADOR_1 => LED_CONTADOR_1,
            LED_CONTADOR_2 => LED_CONTADOR_2,
            AN => AN,
            SEG => SEG
        );

    -- Generarador de señales de reloj
    clk_process: process
    begin
        while true loop
            CLK100MHZ <= '0';
            wait for CLK_PERIOD / 2;
            CLK100MHZ <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    stim_proc: process
    begin
    --poner el reset a 0 donde veremos que la cuenta se queda en 0
        RESET <= '0';
        SW <= "1";
        wait for 100 ns;

        -- Deberemos ver la cuenta de ambos contadores
        RESET <= '1';
        SW <= "0";
        wait for 500 ns; 
        
        --reseteamos la cuenta
        RESET <= '0';
        wait for 100 ns; 
        --reanudamos la cuenta
        RESET <= '1';
        wait for 100 ns;

        --reseteamos cuenta
        RESET <= '0';
        wait for 100 ns;
        
        --reanudamos la cuenta
        RESET <= '1';
        wait for 100 ns;

        -- Probar la cuenta del otro contador
        SW <= "1";
        wait for 5000 ns; 

        -- Finalizar
        report "Simulación terminada" severity note;
        wait;
    end process;

end Behavioral;