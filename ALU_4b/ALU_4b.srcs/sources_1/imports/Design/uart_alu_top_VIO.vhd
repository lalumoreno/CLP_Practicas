library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_alu_top_VIO is
    port (
        clk_i   : in  std_logic;
        rtx_i	: in  std_logic
    );
end entity;

architecture uart_alu_top_arq of uart_alu_top_VIO is

	signal probe_reset  : std_logic;
    signal probe_leds   : std_logic_vector(3 downto 0);

    COMPONENT vio_0
      PORT (
          clk : IN STD_LOGIC;
          probe_in0 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
          probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
        );
    END COMPONENT;

begin

	------------------------------------------------------------------
    -- Instancia ALU (combinacional)
    ------------------------------------------------------------------
    ALU_TOP_inst : entity work.uart_alu_top 
        port map (
            clk   => clk_i,
            reset => probe_reset,
            rxd   => rtx_i,
            leds  => probe_leds
        );

    vio_inst : vio_0
      PORT MAP (
          clk => clk_i,
          probe_in0 => probe_leds,
          probe_out0(0) => probe_reset
        );

end architecture;