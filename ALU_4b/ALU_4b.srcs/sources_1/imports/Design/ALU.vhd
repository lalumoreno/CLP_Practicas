library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (
        A      : in  STD_LOGIC_VECTOR(3 downto 0);
        B      : in  STD_LOGIC_VECTOR(3 downto 0);
        Op     : in  STD_LOGIC_VECTOR(2 downto 0);
        Result : out STD_LOGIC_VECTOR(3 downto 0);
        Zero   : out STD_LOGIC
    );
end entity;

architecture Behavioral of ALU is
    signal A_int, B_int, R_int : signed(3 downto 0);
begin
    A_int <= signed(A);
    B_int <= signed(B);

    process(A_int, B_int, Op)
    begin
        case Op is
            when "000" =>  -- Suma
                R_int <= A_int + B_int;
            when "001" =>  -- Resta
                R_int <= A_int - B_int;
            when "010" =>  -- AND
                R_int <= signed(A and B);
            when "011" =>  -- OR
                R_int <= signed(A or B);
            when "100" =>  -- XOR
                R_int <= signed(A xor B);
            when "101" =>  -- NOT
                R_int <= signed(not A);
            when "110" =>  -- Shift Left
                R_int <= shift_left(A_int, 1);
            when "111" =>  -- Shift Right
                R_int <= signed(shift_right(unsigned(A), 1));
            when others =>
                R_int <= (others => '0');
        end case;
    end process;

    Result <= std_logic_vector(R_int);
    Zero   <= '1' when R_int = 0 else '0';
end Behavioral;