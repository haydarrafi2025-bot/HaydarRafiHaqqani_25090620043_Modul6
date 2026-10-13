library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu8 is
    Port (
        A      : in  STD_LOGIC_VECTOR(7 downto 0);
        B      : in  STD_LOGIC_VECTOR(7 downto 0);
        Op     : in  STD_LOGIC_VECTOR(1 downto 0); -- 00: +, 01: -, 10: x, 11: /
        Result : out STD_LOGIC_VECTOR(15 downto 0)
    );
end alu8;

architecture Behavioral of alu8 is
begin
    process(A, B, Op)
        variable a_unsigned : unsigned(7 downto 0);
        variable b_unsigned : unsigned(7 downto 0);
    begin
        a_unsigned := unsigned(A);
        b_unsigned := unsigned(B);

        case Op is
            when "00" => -- Penjumlahan (+)
                Result <= std_logic_vector(resize(a_unsigned + b_unsigned, 16));
                
            when "01" => -- Pengurangan (-)
                Result <= std_logic_vector(resize(a_unsigned - b_unsigned, 16));
                
            when "10" => -- Perkalian (x)
                Result <= std_logic_vector(a_unsigned * b_unsigned);
                
            when "11" => -- Pembagian (/)
                if b_unsigned /= 0 then
                    Result <= std_logic_vector(resize(a_unsigned / b_unsigned, 16));
                else
                    Result <= (others => '1'); -- Indikator error pembagian nol (0xFFFF)
                end if;
                
            when others =>
                Result <= (others => '0');
        end case;
    end process;
end Behavioral;