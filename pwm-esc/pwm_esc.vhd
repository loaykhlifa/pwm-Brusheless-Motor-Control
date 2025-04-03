library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pwm_esc is
    Port (
        clk         : in STD_LOGIC;  -- Horloge FPGA (50 MHz sur Zybo)
        speed       : in INTEGER range 1000 to 2000;  -- Largeur d'impulsion en µs (1000 = arrêt, 2000 = max)
        pwm_out     : out STD_LOGIC  -- Signal PWM vers l'ESC
    );
end pwm_esc;

architecture Behavioral of pwm_esc is
    constant CLK_FREQ : INTEGER := 50000000;  -- 50 MHz
    constant PWM_FREQ : INTEGER := 50;        -- 50 Hz pour ESC
    constant PERIOD   : INTEGER := CLK_FREQ / PWM_FREQ;  -- 20 ms (1 cycle)
    
    signal counter : INTEGER := 0;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if counter >= PERIOD then
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
            
            -- Génération du PWM (1ms - 2ms dans une période de 20ms)
            if counter < (speed * (CLK_FREQ / 1000000)) then
                pwm_out <= '1';
            else
                pwm_out <= '0';
            end if;
        end if;
    end process;
end Behavioral;
