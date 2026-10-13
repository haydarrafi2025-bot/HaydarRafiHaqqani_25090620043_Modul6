library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity calculator_fsm is
    Port (
        clk         : in  STD_LOGIC;
        btnR        : in  STD_LOGIC;
        btnU        : in  STD_LOGIC;
        btnD        : in  STD_LOGIC;
        btnC        : in  STD_LOGIC;
        sw          : in  STD_LOGIC_VECTOR(15 downto 0);
        display_val : out STD_LOGIC_VECTOR(15 downto 0);
        state_led   : out STD_LOGIC_VECTOR(3 downto 0) -- Indikator State di LED
    );
end calculator_fsm;

architecture Behavioral of calculator_fsm is

    type state_type is (S_RESET, S_WAIT_A, S_WAIT_B, S_CALC, S_DISPLAY);
    signal current_state, next_state : state_type := S_RESET;

    signal reg_A, reg_B : STD_LOGIC_VECTOR(7 downto 0)  := (others => '0');
    signal reg_out      : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal alu_out      : STD_LOGIC_VECTOR(15 downto 0);

    signal load_A, load_B, disp_en : STD_LOGIC := '0';

    component alu8 is
        Port (
            A      : in  STD_LOGIC_VECTOR(7 downto 0);
            B      : in  STD_LOGIC_VECTOR(7 downto 0);
            Op     : in  STD_LOGIC_VECTOR(1 downto 0);
            Result : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

begin

    u_alu: alu8
        port map (
            A      => reg_A,
            B      => reg_B,
            Op     => sw(15 downto 14),
            Result => alu_out
        );

    -- Process 1: Logika Sekuensial
    process(clk, btnR)
    begin
        if btnR = '1' then
            current_state <= S_RESET;
            reg_A         <= (others => '0');
            reg_B         <= (others => '0');
            reg_out       <= (others => '0');
        elsif rising_edge(clk) then
            current_state <= next_state;

            if load_A = '1' then
                reg_A <= sw(7 downto 0);
            end if;

            if load_B = '1' then
                reg_B <= sw(7 downto 0);
            end if;

            if disp_en = '1' then
                reg_out <= alu_out;
            end if;
        end if;
    end process;

    -- Process 2: Logika Kombinasional & Sinyal LED
    process(current_state, btnU, btnD, btnC)
    begin
        next_state <= current_state;
        load_A     <= '0';
        load_B     <= '0';
        disp_en    <= '0';
        state_led  <= "0000";

        case current_state is
            when S_RESET =>
                next_state <= S_WAIT_A;

            when S_WAIT_A =>
                state_led <= "0001"; -- LED 0 Menyala
                if btnU = '1' then
                    load_A     <= '1';
                    next_state <= S_WAIT_B;
                end if;

            when S_WAIT_B =>
                state_led <= "0010"; -- LED 1 Menyala
                if btnD = '1' then
                    load_B     <= '1';
                    next_state <= S_CALC;
                end if;

            when S_CALC =>
                state_led <= "0100"; -- LED 2 Menyala
                if btnC = '1' then
                    next_state <= S_DISPLAY;
                end if;

            when S_DISPLAY =>
                state_led <= "1000"; -- LED 3 Menyala
                disp_en   <= '1';
                -- Izinkan kembali ke S_WAIT_A jika btnU ditekan lagi
                if btnU = '1' then
                    load_A     <= '1';
                    next_state <= S_WAIT_B;
                end if;

            when others =>
                next_state <= S_RESET;
        end case;
    end process;

    display_val <= reg_out;

end Behavioral;