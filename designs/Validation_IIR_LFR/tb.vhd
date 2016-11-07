
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
USE IEEE.std_logic_signed.ALL;
USE IEEE.MATH_real.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

library std;
use std.textio.all;

LIBRARY lpp;
USE lpp.iir_filter.ALL;
USE lpp.lpp_ad_conv.ALL;
USE lpp.FILTERcfg.ALL;
USE lpp.lpp_lfr_filter_coeff.ALL;
USE lpp.general_purpose.ALL;
USE lpp.data_type_pkg.ALL;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.general_purpose.ALL;

ENTITY testbench IS
END;

ARCHITECTURE behav OF testbench IS

  SIGNAL TSTAMP         : INTEGER:=0;
  SIGNAL clk            : STD_LOGIC := '0';
  SIGNAL clk_24k        : STD_LOGIC := '0';
  SIGNAL clk_24k_r      : STD_LOGIC := '0';
  SIGNAL rstn           : STD_LOGIC;

  SIGNAL signal_gen     :  Samples(7 DOWNTO 0);
  SIGNAL offset_gen     :  Samples(7 DOWNTO 0);

  SIGNAL sample       : Samples(7 DOWNTO 0);

  SIGNAL sample_val   : STD_LOGIC;

  SIGNAL sample_f0_val   : STD_LOGIC;
  SIGNAL sample_f1_val   : STD_LOGIC;
  SIGNAL sample_f2_val   : STD_LOGIC;
  SIGNAL sample_f3_val   : STD_LOGIC;

  SIGNAL sample_f0_wdata : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f1_wdata : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f2_wdata : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f3_wdata : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);

  SIGNAL sample_f0  : Samples(5 DOWNTO 0);
  SIGNAL sample_f1  : Samples(5 DOWNTO 0);
  SIGNAL sample_f2  : Samples(5 DOWNTO 0);
  SIGNAL sample_f3  : Samples(5 DOWNTO 0);



  SIGNAL temp : STD_LOGIC;


  COMPONENT generator IS
  GENERIC (
    AMPLITUDE            : INTEGER := 100;
    NB_BITS              : INTEGER := 16);

  PORT (
    clk      : IN  STD_LOGIC;
    rstn     : IN  STD_LOGIC;
    run      : IN  STD_LOGIC;

    data_ack : IN  STD_LOGIC;
    offset   : IN  STD_LOGIC_VECTOR(NB_BITS-1 DOWNTO 0);
    data     : OUT STD_LOGIC_VECTOR(NB_BITS-1 DOWNTO 0)
    );
  END COMPONENT;


  file log_input       : TEXT open write_mode is "log_input.txt";
  file log_output_f0   : TEXT open write_mode is "log_output_f0.txt";
  file log_output_f1   : TEXT open write_mode is "log_output_f1.txt";
  file log_output_f2   : TEXT open write_mode is "log_output_f2.txt";
  file log_output_f3   : TEXT open write_mode is "log_output_f3.txt";


BEGIN

  -----------------------------------------------------------------------------
  -- CLOCK and RESET
  -----------------------------------------------------------------------------
  clk <= NOT clk AFTER 5 ns;
  PROCESS
  BEGIN  -- PROCESS
    WAIT UNTIL clk = '1';
    rstn <= '0';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    WAIT UNTIL clk = '1';
    rstn <= '1';
    WAIT FOR 2000 ms;
    REPORT "*** END simulation ***" SEVERITY failure;
    WAIT;
  END PROCESS;
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- COMMON TIMESTAMPS
  -----------------------------------------------------------------------------

    PROCESS(clk)
    BEGIN
      IF clk'event and clk ='1' THEN
        TSTAMP <= TSTAMP+1;
      END IF;
    END PROCESS;
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- LPP_LFR_FILTER
  -----------------------------------------------------------------------------
  lpp_lfr_filter_1: lpp_lfr_filter
    GENERIC MAP (
      --tech    => 0,
      --Mem_use => use_CEL,
      tech    => axcel,
      Mem_use => use_RAM,
      RTL_DESIGN_LIGHT =>0
      )
    PORT MAP (
      sample           => sample,
      sample_val       => sample_val,
      sample_time      => (others=>'0'),
      clk              => clk,
      rstn             => rstn,

      data_shaping_SP0 => '0',
      data_shaping_SP1 => '0',
      data_shaping_R0  => '0',
      data_shaping_R1  => '0',
      data_shaping_R2  => '0',

      sample_f0_val    => sample_f0_val,
      sample_f1_val    => sample_f1_val,
      sample_f2_val    => sample_f2_val,
      sample_f3_val    => sample_f3_val,

      sample_f0_wdata  => sample_f0_wdata,
      sample_f1_wdata  => sample_f1_wdata,
      sample_f2_wdata  => sample_f2_wdata,
      sample_f3_wdata  => sample_f3_wdata
      );
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- SAMPLE GENERATION
  -----------------------------------------------------------------------------
  clk_24k <= NOT clk_24k AFTER 20345 ns;

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                    -- asynchronous reset (active low)
      sample_val <= '0';
      clk_24k_r  <= '0';
      temp <= '0';
    ELSIF clk'event AND clk = '1' THEN    -- rising clock edge
      clk_24k_r <= clk_24k;
      IF clk_24k = '1' AND clk_24k_r = '0' THEN
        sample_val   <= '1';
        temp         <= NOT temp;
      ELSE
        sample_val   <= '0';
      END IF;
    END IF;
  END PROCESS;
  -----------------------------------------------------------------------------
generators: FOR I IN 0 TO 7 GENERATE
  gen1: generator
    GENERIC MAP (
      AMPLITUDE            => 100,
      NB_BITS              => 16)
    PORT MAP (
      clk      => clk,
      rstn     => rstn,
      run      => '1',
      data_ack => sample_val,
      offset   => offset_gen(I),
      data     => signal_gen(I)
      );
offset_gen(I)  <=  std_logic_vector( to_signed((I*200),16) );
END GENERATE generators;

output_splitter: FOR CHAN IN 0 TO 5 GENERATE
    bits_splitter: FOR BIT IN 0 TO 15 GENERATE
        sample_f0(CHAN)(BIT)  <= sample_f0_wdata((CHAN*16) + BIT);
        sample_f1(CHAN)(BIT)  <= sample_f1_wdata((CHAN*16) + BIT);
        sample_f2(CHAN)(BIT)  <= sample_f2_wdata((CHAN*16) + BIT);
        sample_f3(CHAN)(BIT)  <= sample_f3_wdata((CHAN*16) + BIT);
    END GENERATE bits_splitter;
END GENERATE output_splitter;


sample  <= signal_gen;

  -----------------------------------------------------------------------------
  --  RECORD SIGNALS
  -----------------------------------------------------------------------------

process(sample_val)
variable line_var : line;
begin
if sample_val'event and sample_val='1' then
    write(line_var,integer'image(TSTAMP) );
    for I IN 0 TO 7 loop
      write(line_var, "  " & integer'image(to_integer(signed(signal_gen(I)))));
    end loop;
    writeline(log_input,line_var);
end if;
end process;

process(sample_f0_val)
variable line_var : line;
begin
if sample_f0_val'event and sample_f0_val='1' then
    write(line_var,integer'image(TSTAMP) );
    for I IN 0 TO 5 loop
      write(line_var, "  " & integer'image(to_integer(signed(sample_f0(I)))));
    end loop;
    writeline(log_output_f0,line_var);
end if;
end process;


process(sample_f1_val)
variable line_var : line;
begin
if sample_f1_val'event and sample_f1_val='1' then
    write(line_var,integer'image(TSTAMP) );
    for I IN 0 TO 5 loop
      write(line_var, "  " & integer'image(to_integer(signed(sample_f1(I)))));
    end loop;
    writeline(log_output_f1,line_var);
end if;
end process;


process(sample_f2_val)
variable line_var : line;
begin
if sample_f2_val'event and sample_f2_val='1' then
    write(line_var,integer'image(TSTAMP) );
    for I IN 0 TO 5 loop
      write(line_var, "  " & integer'image(to_integer(signed(sample_f2(I)))));
    end loop;
    writeline(log_output_f2,line_var);
end if;
end process;

process(sample_f3_val)
variable line_var : line;
begin
if sample_f3_val'event and sample_f3_val='1' then
    write(line_var,integer'image(TSTAMP) );
    for I IN 0 TO 5 loop
      write(line_var, "  " & integer'image(to_integer(signed(sample_f3(I)))));
    end loop;
    writeline(log_output_f3,line_var);
end if;
end process;


END;
