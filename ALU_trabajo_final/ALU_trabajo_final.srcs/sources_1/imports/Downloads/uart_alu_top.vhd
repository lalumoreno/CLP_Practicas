library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_alu_top is
    Port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        rxd      : in  std_logic;
        leds     : out std_logic_vector(3 downto 0)
    );
end;

architecture Behavioral of uart_alu_top is

    -- UART signals
    signal rx_data  : std_logic_vector(7 downto 0);
    signal rx_ready : std_logic;
    signal frm_err  : std_logic;

    -- ALU signals
    signal A, B, Result : std_logic_vector(3 downto 0);
    signal Op           : std_logic_vector(2 downto 0);
    signal Zero          : std_logic;

    signal byte_count : integer range 0 to 2 := 0;

begin

    ------------------------------------------------------------------
    -- Instancia UART RX
    ------------------------------------------------------------------
    UartRX : entity work.uart_rx
        port map (
            clk_rx      => clk,
            rst_clk_rx  => reset,
            rxd_i       => rxd, -- confirmar si se esta conectando el correcto
            rx_data     => rx_data,
            rx_data_rdy => rx_ready,
            frm_err     => frm_err
        );

    ------------------------------------------------------------------
    -- Captura de bytes recibidos (A, B y Op)
    ------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                byte_count <= 0;
                A <= (others => '0');
                B <= (others => '0');
                Op <= (others => '0');
            elsif rx_ready = '1' then
                case byte_count is
                    when 0 =>
                        A <= rx_data(3 downto 0);  -- 4 bits menos significativos
                        byte_count <= 1;
                    when 1 =>
                        B <= rx_data(3 downto 0);
                        byte_count <= 2;
                    when 2 =>
                        Op <= rx_data(2 downto 0);
                        byte_count <= 0; -- listo para procesar la siguiente operación
                    when others =>
                        byte_count <= 0;
                end case;
            end if;
        end if;
    end process;

    ------------------------------------------------------------------
    -- Instancia ALU
    ------------------------------------------------------------------
    ALU_inst : entity work.ALU
        port map (
            A      => A,
            B      => B,
            Op     => Op,
            Result => Result,
            Zero   => Zero
        );

    ------------------------------------------------------------------
    -- Mostrar resultado en los LEDs
    ------------------------------------------------------------------
    leds <= Result;

end Behavioral;
