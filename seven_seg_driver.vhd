library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_seg_driver is
    Port (
        clk    : in  STD_LOGIC;
        val_in : in  STD_LOGIC_VECTOR(15 downto 0);
        seg    : out STD_LOGIC_VECTOR(6 downto 0); -- Segment A-G (Active Low)
        an     : out STD_LOGIC_VECTOR(3 downto 0)  -- Anode Digit Select (Active Low)
    );
end seven_seg_driver;

architecture Behavioral of seven_seg_driver is
    signal refresh_counter : unsigned(19 downto 0) := (others => '0');
    signal active_digit    : STD_LOGIC_VECTOR(1 downto 0);
    signal hex_nibble      : STD_LOGIC_VECTOR(3 downto 0);
begin
    -- Counter pemutar scanner display (~1 kHz)
    process(clk)
    begin
        if rising_edge(clk) then
            refresh_counter <= refresh_counter + 1;
        end if;
    end process;

    active_digit <= std_logic_vector(refresh_counter(19 downto 18));

    -- Seleksi Anoda
    process(active_digit, val_in)
    begin
        case active_digit is
            when "00" =>
                an         <= "1110"; -- Digit 0 (Paling Kanan)
                hex_nibble <= val_in(3 downto 0);
            when "01" =>
                an         <= "1101"; -- Digit 1
                hex_nibble <= val_in(7 downto 4);
            when "10" =>
                an         <= "1011"; -- Digit 2
                hex_nibble <= val_in(11 downto 8);
            when "11" =>
                an         <= "0111"; -- Digit 3 (Paling Kiri)
                hex_nibble <= val_in(15 downto 12);
            when others =>
                an         <= "1111";
                hex_nibble <= "0000";
        end case;
    end process;

    -- Decoder Hexadecimal ke 7-Segment
    process(hex_nibble)
    begin
        case hex_nibble is
            when "0000" => seg <= "1000000"; -- 0
            when "0001" => seg <= "1111001"; -- 1
            when "0010" => seg <= "0100100"; -- 2
            when "0011" => seg <= "0110000"; -- 3
            when "0100" => seg <= "0100101"; -- 4
            when "0101" => seg <= "0010010"; -- 5
            when "0110" => seg <= "0000010"; -- 6
            when "0111" => seg <= "1111000"; -- 7
            when "1000" => seg <= "0000000"; -- 8
            when "1001" => seg <= "0010000"; -- 9
            when "1010" => seg <= "0001000"; -- A
            when "1011" => seg <= "0000011"; -- b
            when "1100" => seg <= "1000111"; -- C
            when "1101" => seg <= "0100001"; -- d
            when "1110" => seg <= "0000110"; -- E
            when "1111" => seg <= "0001110"; -- F
            when others => seg <= "1111111";
        end case;
    end process;
end Behavioral;