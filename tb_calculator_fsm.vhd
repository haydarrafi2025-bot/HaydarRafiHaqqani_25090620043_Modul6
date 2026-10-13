library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_calculator_fsm is
end tb_calculator_fsm;

architecture Behavioral of tb_calculator_fsm is

    component top_calculator is
        Port (
            clk  : in  STD_LOGIC;
            btnR : in  STD_LOGIC;
            btnU : in  STD_LOGIC;
            btnD : in  STD_LOGIC;
            btnC : in  STD_LOGIC;
            sw   : in  STD_LOGIC_VECTOR(15 downto 0);
            seg  : out STD_LOGIC_VECTOR(6 downto 0);
            an   : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    signal clk  : STD_LOGIC := '0';
    signal btnR : STD_LOGIC := '0';
    signal btnU : STD_LOGIC := '0';
    signal btnD : STD_LOGIC := '0';
    signal btnC : STD_LOGIC := '0';
    signal sw   : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal seg  : STD_LOGIC_VECTOR(6 downto 0);
    signal an   : STD_LOGIC_VECTOR(3 downto 0);

    constant clk_period : time := 10 ns;

begin

    uut: top_calculator
        port map (
            clk  => clk,
            btnR => btnR,
            btnU => btnU,
            btnD => btnD,
            btnC => btnC,
            sw   => sw,
            seg  => seg,
            an   => an
        );

    -- Clock generator 100 MHz
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus Skenario Pembagian 20 / 4 = 5
    stim_proc: process
    begin
        -- Reset Sistem
        btnR <= '1';
        wait for 50 ns;
        btnR <= '0';
        wait for 50 ns;

        -- 1. Input Operand A = 20 (0x14)
        sw(7 downto 0) <= x"14";
        wait for 100 ns;
        btnU <= '1';
        wait for 20 ms; -- Durasi tombol melewati debouncer
        btnU <= '0';
        wait for 100 ns;

        -- 2. Input Operand B = 4 (0x04)
        sw(7 downto 0) <= x"04";
        wait for 100 ns;
        btnD <= '1';
        wait for 20 ms; -- Durasi tombol melewati debouncer
        btnD <= '0';
        wait for 100 ns;

        -- 3. Set Opcode Pembagian ("11") dan Hitung
        sw(15 downto 14) <= "11";
        wait for 100 ns;
        btnC <= '1';
        wait for 20 ms; -- Durasi tombol melewati debouncer
        btnC <= '0';

        wait for 1 ms;
        wait;
    end process;

end Behavioral;