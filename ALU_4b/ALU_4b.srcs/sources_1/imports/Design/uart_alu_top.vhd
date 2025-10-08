library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_alu_top is
    Port (
        clk   : in  std_logic;
        reset : in  std_logic;
        rxd   : in  std_logic;
        leds  : out std_logic_vector(3 downto 0)
    );
end;

architecture Behavioral of uart_alu_top is

    -- UART signals
    signal rx_data      : std_logic_vector(7 downto 0);
    signal rx_ready     : std_logic;
    signal rx_ready_prev: std_logic := '0';
    signal frm_err      : std_logic;

    -- Buffers temporales
    signal A_buf, B_buf : std_logic_vector(3 downto 0);

    -- ALU signals
    signal A_uart, B_uart, Result_uart : std_logic_vector(3 downto 0);
    signal Op_uart      : std_logic_vector(2 downto 0);
    signal Zero         : std_logic;

    -- Control
    signal byte_count : integer range 0 to 2 := 0;
    signal alu_ready  : std_logic := '0';

    -- Registers for outputs
    signal leds_reg : std_logic_vector(3 downto 0) := (others => '0');

begin

    ------------------------------------------------------------------
    -- Instancia UART RX (usa nombres de puerto exactos del módulo)
    ------------------------------------------------------------------
    UartRX : entity work.uart_rx
        port map (
            clk_rx      => clk,
            rst_clk_rx  => reset,
            rxd_i     => rxd,
            rx_data     => rx_data,
            rx_data_rdy => rx_ready,
            frm_err     => frm_err
        );

    ------------------------------------------------------------------
    -- Captura de bytes recibidos (edge-detect en rx_ready)
    -- rx_ready_prev guarda el estado previo; solo procesamos en 0->1
    ------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                byte_count <= 0;
                A_uart <= (others => '0');
                B_uart <= (others => '0');
                Op_uart <= (others => '0');
                rx_ready_prev <= '0';
                alu_ready <= '0';
            else
                -- guardar el valor anterior para detectar flanco
                rx_ready_prev <= rx_ready;

                -- detectar flanco de subida de rx_ready
                if (rx_ready = '1' and rx_ready_prev = '0') then
                    case byte_count is
                        when 0 =>
                            A_buf <= rx_data(3 downto 0);
                            byte_count <= 1;
                            alu_ready <= '0';
                        when 1 =>
                            B_buf <= rx_data(3 downto 0);
                            byte_count <= 2;
                            alu_ready <= '0';
                        when 2 =>
                            Op_uart <= rx_data(2 downto 0);
                            -- Actualizar valores de la ALU
                             A_uart <= A_buf;
                             B_uart <= B_buf;
                            byte_count <= 0;
                            alu_ready <= '1'; -- los 3 bytes ya están listos
                        when others =>
                            byte_count <= 0;
                            alu_ready <= '0';
                    end case;
                end if;
            end if;
        end if;
    end process;

    ------------------------------------------------------------------
    -- Instancia ALU (combinacional)
    ------------------------------------------------------------------
    ALU_inst : entity work.ALU
        port map (
            A      => A_uart,
            B      => B_uart,
            Op     => Op_uart,
            Result => Result_uart,
            Zero   => Zero
        );

    ------------------------------------------------------------------
    -- Latch del resultado a los LEDs cuando alu_ready = '1'
    -- Se limpia alu_ready aquí para que sea un pulso (se usa una vez)
    ------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                leds_reg <= (others => '0');
            else
                leds_reg <= Result_uart;  -- capturamos el resultado actual
            end if;
        end if;
    end process;

    ------------------------------------------------------------------
    -- Salida física
    ------------------------------------------------------------------
    leds <= leds_reg;

end Behavioral;