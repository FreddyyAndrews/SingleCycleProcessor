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

    component eightX8To8Mux is
        Port (
            I0 : in  std_logic_vector(7 downto 0);
            I1 : in  std_logic_vector(7 downto 0);
            I2 : in  std_logic_vector(7 downto 0);
            I3 : in  std_logic_vector(7 downto 0);
            I4 : in  std_logic_vector(7 downto 0);
            I5 : in  std_logic_vector(7 downto 0);
            I6 : in  std_logic_vector(7 downto 0);
            I7 : in  std_logic_vector(7 downto 0);
            S  : in  std_logic_vector(2 downto 0);
            O  : out std_logic_vector(7 downto 0)
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

    -- Multiplexer for read_data1 using lower 3 bits of read_reg1 as selector
    mux_read1: eightX8To8Mux port map (
        I0 => reg_outputs(0),
        I1 => reg_outputs(1),
        I2 => reg_outputs(2),
        I3 => reg_outputs(3),
        I4 => reg_outputs(4),
        I5 => reg_outputs(5),
        I6 => reg_outputs(6),
        I7 => reg_outputs(7),
        S  => read_reg1(2 downto 0),
        O  => read_data1
    );

    -- Multiplexer for read_data2 using lower 3 bits of read_reg2 as selector
    mux_read2: eightX8To8Mux port map (
        I0 => reg_outputs(0),
        I1 => reg_outputs(1),
        I2 => reg_outputs(2),
        I3 => reg_outputs(3),
        I4 => reg_outputs(4),
        I5 => reg_outputs(5),
        I6 => reg_outputs(6),
        I7 => reg_outputs(7),
        S  => read_reg2(2 downto 0),
        O  => read_data2
    );

end Structural;
