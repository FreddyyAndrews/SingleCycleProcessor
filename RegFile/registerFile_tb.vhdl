library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity registerFile_tb is
end registerFile_tb;

architecture behavior of registerFile_tb is

    -- Component under test signals
    signal read_reg1  : std_logic_vector(4 downto 0) := (others => '0');
    signal read_reg2  : std_logic_vector(4 downto 0) := (others => '0');
    signal write_reg  : std_logic_vector(4 downto 0) := (others => '0');
    signal write_data : std_logic_vector(7 downto 0) := (others => '0');
    signal read_data1 : std_logic_vector(7 downto 0);
    signal read_data2 : std_logic_vector(7 downto 0);

begin

    -- Instantiate the register file (Unit Under Test)
    UUT: entity work.registerFile
        port map (
            read_reg1  => read_reg1,
            read_reg2  => read_reg2,
            write_reg  => write_reg,
            write_data => write_data,
            read_data1 => read_data1,
            read_data2 => read_data2
        );

    stim_proc: process
    begin
        -- Write phase: write sequential values into registers 0 to 7.
        -- Register i receives value (i+1) in 8-bit binary.
        for i in 0 to 7 loop
            write_reg  <= std_logic_vector(to_unsigned(i, 5));
            wait for 1 ns;
            write_data <= std_logic_vector(to_unsigned(i + 1, 8));
            wait for 10 ns;
        end loop;
        
        wait for 10 ns;
        
        -- Read phase: verify the data using both read ports.
        -- read_reg1 selects register 'i' and read_reg2 selects register '7-i'.
        for i in 0 to 7 loop
            read_reg1 <= std_logic_vector(to_unsigned(i, 5));
            read_reg2 <= std_logic_vector(to_unsigned(7 - i, 5));
            wait for 10 ns;
            
            assert read_data1 = std_logic_vector(to_unsigned(i + 1, 8))
                report "Mismatch on read_data1 for register " & integer'image(i)
                severity error;
                
            assert read_data2 = std_logic_vector(to_unsigned((7 - i) + 1, 8))
                report "Mismatch on read_data2 for register " & integer'image(7 - i)
                severity error;
        end loop;
        
        wait; -- End simulation
    end process;

end behavior;
