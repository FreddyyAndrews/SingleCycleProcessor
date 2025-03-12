library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity thirtyTwoBitComparator is
    port (
        A      : in  std_logic_vector(31 downto 0);
        B      : in  std_logic_vector(31 downto 0);
        A_gt_B : out std_logic;
        A_eq_B : out std_logic
    );
end thirtyTwoBitComparator;

architecture behavioral of thirtyTwoBitComparator is
begin
    process(A, B)
        variable A_u, B_u : unsigned(31 downto 0);
    begin
        A_u := unsigned(A);
        B_u := unsigned(B);
        
        if A_u > B_u then
            A_gt_B <= '1';
        else
            A_gt_B <= '0';
        end if;
        
        if A_u = B_u then
            A_eq_B <= '1';
        else
            A_eq_B <= '0';
        end if;
    end process;
end behavioral;
