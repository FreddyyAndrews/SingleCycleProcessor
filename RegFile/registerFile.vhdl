library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity registerFile is
    Port (
        read_reg1  : in  std_logic_vector(4 downto 0);
        read_reg2  : in  std_logic_vector(4 downto 0);
        write_reg  : in  std_logic_vector(4 downto 0);
        write_data : in  std_logic_vector(7 downto 0);
        read_data1 : out std_logic_vector(7 downto 0);
        read_data2 : out std_logic_vector(7 downto 0)
    );
end registerFile;

architecture Structural of registerFile is

    -- Subcomponent declarations
    component enabler is
        Port (
            address    : in  std_logic_vector(4 downto 0);
            my_address : in  std_logic_vector(4 downto 0);
            enable     : out std_logic
        );
    end component;

    component asyncEightBitRegister is
        Port (
            D  : in  std_logic_vector(7 downto 0);
            EN : in  std_logic;
            Q  : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Signal declarations for register outputs and enable signals
    type reg_array is array (0 to 7) of std_logic_vector(7 downto 0);
    signal reg_outputs : reg_array;

    type enable_array is array (0 to 7) of std_logic;
    signal enable_signals : enable_array;

begin

    -- Generate loop to create 8 registers and associated enablers
    gen_registers: for i in 0 to 7 generate
        -- Hard-code the my_address constant for each instance (00000, 00001, ... 00111)
        constant my_addr : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(i, 5));
    begin
        enabler_inst: enabler
            port map (
                address    => write_reg,
                my_address => my_addr,
                enable     => enable_signals(i)
            );
            
        register_inst: asyncEightBitRegister
            port map (
                D  => write_data,
                EN => enable_signals(i),
                Q  => reg_outputs(i)
            );
    end generate;

end Structural;
