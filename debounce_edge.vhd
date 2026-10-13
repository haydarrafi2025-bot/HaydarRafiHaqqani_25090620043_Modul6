library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debounce_edge is
    Port (
        clk       : in  STD_LOGIC;
        btn_in    : in  STD_LOGIC;
        pulse_out : out STD_LOGIC
    );
end debounce_edge;

architecture Behavioral of debounce_edge is
    signal btn_sync  : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal count     : integer range 0 to 1000000 := 0; -- Filter 10ms (clock 100MHz)
    signal btn_deb   : STD_LOGIC := '0';
    signal btn_deb_d : STD_LOGIC := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- Synchronizer 2-ff
            btn_sync <= btn_sync(0) & btn_in;

            -- Debounce Filter
            if btn_sync(1) /= btn_deb then
                count <= count + 1;
                if count = 1000000 then
                    btn_deb <= btn_sync(1);
                    count   <= 0;
                end if;
            else
                count <= 0;
            end if;

            -- Deteksi Tepi Naik (Rising Edge)
            btn_deb_d <= btn_deb;
        end if;
    end process;

    pulse_out <= btn_deb and (not btn_deb_d);
end Behavioral;