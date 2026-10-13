library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_calculator is
    Port (
        clk  : in  STD_LOGIC;
        btnR : in  STD_LOGIC;
        btnU : in  STD_LOGIC;
        btnD : in  STD_LOGIC;
        btnC : in  STD_LOGIC;
        sw   : in  STD_LOGIC_VECTOR(15 downto 0);
        led  : out STD_LOGIC_VECTOR(3 downto 0); -- Tambahan LED
        seg  : out STD_LOGIC_VECTOR(6 downto 0);
        an   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end top_calculator;

architecture Behavioral of top_calculator is

    signal btnU_db, btnD_db, btnC_db : STD_LOGIC;
    signal display_val_sig           : STD_LOGIC_VECTOR(15 downto 0);

begin

    u_db_U: entity work.debounce_edge
        port map (clk => clk, btn_in => btnU, pulse_out => btnU_db);

    u_db_D: entity work.debounce_edge
        port map (clk => clk, btn_in => btnD, pulse_out => btnD_db);

    u_db_C: entity work.debounce_edge
        port map (clk => clk, btn_in => btnC, pulse_out => btnC_db);

    u_fsm: entity work.calculator_fsm
        port map (
            clk         => clk,
            btnR        => btnR,
            btnU        => btnU_db,
            btnD        => btnD_db,
            btnC        => btnC_db,
            sw          => sw,
            display_val => display_val_sig,
            state_led   => led
        );

    u_display: entity work.seven_seg_driver
        port map (
            clk    => clk,
            val_in => display_val_sig,
            seg    => seg,
            an     => an
        );

end Behavioral;