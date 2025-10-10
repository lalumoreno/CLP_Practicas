library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_alu_top_tb is
end;

architecture sim of uart_alu_top_tb is

    -- SeÃ±ales del DUT (Device Under Test)
    signal clk      : std_logic := '0';
    signal reset    : std_logic := '0';
    signal rxd      : std_logic := '1';  -- UART IDLE = '1'
    signal leds     : std_logic_vector(3 downto 0);

    -- Constantes UART
    constant CLK_PERIOD : time := 8 ns;  -- 125 MHz clock
    constant BAUD_RATE  : integer := 115200;
    constant BIT_PERIOD : time := 1 sec / BAUD_RATE;

    -- Procedimiento para enviar un byte por UART
    procedure uart_send_byte(signal rxd : out std_logic; data : std_logic_vector(7 downto 0)) is
    begin
        -- Start bit
        rxd <= '0';
        wait for BIT_PERIOD;

        -- 8 bits de datos (LSB primero)
        for i in 0 to 7 loop
            rxd <= data(i);
            wait for BIT_PERIOD;
        end loop;

        -- Stop bit
        rxd <= '1';
        wait for BIT_PERIOD;
    end procedure;

begin

    --------------------------------------------------------------------
    -- Instancia del mÃ³dulo a probar (DUT)
    --------------------------------------------------------------------
    DUT : entity work.uart_alu_top
        port map (
            clk   => clk,
            reset => reset,
            rxd   => rxd,
            leds  => leds
        );

    --------------------------------------------------------------------
    -- GeneraciÃ³n de reloj
    --------------------------------------------------------------------
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    --------------------------------------------------------------------
    -- Secuencia de prueba
    --------------------------------------------------------------------
    stim_proc : process
    begin
        -- Reset inicial
        reset <= '1';
        wait for 10 us;
        reset <= '0';
        wait for 10 us;

        -- Enviando datos por UART: A = 0011 (3), B = 0101 (5), Op = 000 (suma)
        report "Enviando A = 3, B = 5, Op = 000 (Suma)";
        uart_send_byte(rxd, x"03");  -- A = 3
        uart_send_byte(rxd, x"05");  -- B = 5
        uart_send_byte(rxd, x"00");  -- Op = 0
        wait for 100 us;

        -- Enviando datos: A = 7, B = 2, Op = 001 (resta)
        report "Enviando A = 7, B = 2, Op = 001 (Resta)";
        uart_send_byte(rxd, x"07");
        uart_send_byte(rxd, x"02");
        uart_send_byte(rxd, x"01");
        wait for 100 us;

        -- Enviando de datos: A = 9, B = 3, Op = 010 (AND)
        report "Enviando A = 9, B = 3, Op = 010 (AND)";
        uart_send_byte(rxd, x"09");
        uart_send_byte(rxd, x"03");
        uart_send_byte(rxd, x"02");
        wait for 100 us;

        report "Fin de la simulacion";
        wait;
    end process;

end sim;
