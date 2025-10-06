library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_tb is
end entity;

architecture sim of ALU_tb is
    -- Señales de prueba
    signal A, B     : STD_LOGIC_VECTOR(3 downto 0);
    signal Op       : STD_LOGIC_VECTOR(2 downto 0);
    signal Result   : STD_LOGIC_VECTOR(3 downto 0);
    signal Zero     : STD_LOGIC;
begin

    -- Instancia de la ALU
    uut: entity work.ALU
        port map (
            A      => A,
            B      => B,
            Op     => Op,
            Result => Result,
            Zero   => Zero
        );

    -- Proceso de estimulación
    stim_proc: process
    begin
        -- Caso 1: Suma
        A <= "0011";  -- 3
        B <= "0101";  -- 5
        Op <= "000";  -- Suma
        wait for 10 ns;

        -- Caso 2: Resta
        A <= "1001";  -- 9
        B <= "0011";  -- 3
        Op <= "001";  -- Resta
        wait for 10 ns;

        -- Caso 3: AND
        A <= "1100";  -- 12
        B <= "1010";  -- 10
        Op <= "010";  -- AND
        wait for 10 ns;

        -- Caso 4: OR
        A <= "1100";
        B <= "1010";
        Op <= "011";  -- OR
        wait for 10 ns;

        -- Caso 5: XOR
        A <= "1100";
        B <= "1010";
        Op <= "100";  -- XOR
        wait for 10 ns;

        -- Caso 6: NOT A
        A <= "1100";  
        Op <= "101";  -- NOT
        wait for 10 ns;

        -- Caso 7: Shift Left
        A <= "0011";  -- 3
        Op <= "110";  -- <<1
        wait for 10 ns;

        -- Caso 8: Shift Right
        A <= "1000";  -- 8
        Op <= "111";  -- >>1
        wait for 10 ns;

        -- Fin de simulación
        wait;
    end process;
end architecture;
