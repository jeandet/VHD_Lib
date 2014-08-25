LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY lpp;
USE lpp.general_purpose.ALL;

ENTITY MS_calculation IS
  PORT (
    clk               : IN  STD_LOGIC;
    rstn              : IN  STD_LOGIC;
    -- IN
    fifo_in_data      : IN  STD_LOGIC_VECTOR(32*2-1 DOWNTO 0);
    fifo_in_ren       : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    fifo_in_empty     : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
    -- OUT
    fifo_out_data     : OUT STD_LOGIC_VECTOR(32-1 DOWNTO 0);
    fifo_out_wen      : OUT STD_LOGIC;
    fifo_out_full     : IN  STD_LOGIC;
    -- 
    correlation_start : IN  STD_LOGIC;
    correlation_auto  : IN  STD_LOGIC;  -- 1 => auto correlation / 0 => inter correlation

    correlation_begin : OUT STD_LOGIC;
    correlation_done  : OUT STD_LOGIC
    );
END MS_calculation;

ARCHITECTURE beh OF MS_calculation IS

  TYPE   fsm_calculation_MS IS (IDLE, WF, S1, S2, S3, S4, WFa, S1a, S2a);
  SIGNAL state : fsm_calculation_MS;

  SIGNAL OP1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL OP2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL RES : STD_LOGIC_VECTOR(31 DOWNTO 0);

  SIGNAL ALU_CTRL : STD_LOGIC_VECTOR(4 DOWNTO 0);


  CONSTANT ALU_CTRL_NOP  : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00000";
  CONSTANT ALU_CTRL_MULT : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00010";
  CONSTANT ALU_CTRL_MAC  : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00001";
  CONSTANT ALU_CTRL_MACn : STD_LOGIC_VECTOR(4 DOWNTO 0) := "10001";

  SIGNAL select_ctrl : STD_LOGIC_VECTOR(1 DOWNTO 0);
  CONSTANT select_ctrl_NOP  : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
  CONSTANT select_ctrl_MULT : STD_LOGIC_VECTOR(1 DOWNTO 0) := "01";
  CONSTANT select_ctrl_MAC  : STD_LOGIC_VECTOR(1 DOWNTO 0) := "10";
  CONSTANT select_ctrl_MACn : STD_LOGIC_VECTOR(1 DOWNTO 0) := "11";
  
  SIGNAL select_op1 : STD_LOGIC;
  SIGNAL select_op2 : STD_LOGIC_VECTOR(1 DOWNTO 0) ;
  
  CONSTANT select_R0 : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
  CONSTANT select_I0 : STD_LOGIC_VECTOR(1 DOWNTO 0) := "01";
  CONSTANT select_R1 : STD_LOGIC_VECTOR(1 DOWNTO 0) := "10";
  CONSTANT select_I1 : STD_LOGIC_VECTOR(1 DOWNTO 0) := "11";

  SIGNAL res_wen      : STD_LOGIC;
  SIGNAL res_wen_reg1 : STD_LOGIC;
  SIGNAL res_wen_reg2 : STD_LOGIC;
  --SIGNAL res_wen_reg3 : STD_LOGIC;

  SIGNAL fifo_in_ren_s : STD_LOGIC_VECTOR(1 DOWNTO 0);
  
BEGIN


  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      fifo_in_ren <= "11";
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      fifo_in_ren <= fifo_in_ren_s;
    END IF;
  END PROCESS;
  
  
  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      
      correlation_begin <= '0';
      correlation_done <= '0';
      state       <= IDLE;
      fifo_in_ren_s <= "11";
      select_ctrl <= select_ctrl_NOP;
      --ALU_CTRL    <= ALU_CTRL_NOP;
      select_op1  <= select_R0(0);
      select_op2  <= select_R0;
      res_wen <= '1';
      
    ELSIF clk'EVENT AND clk = '1' THEN
      select_ctrl <= select_ctrl_NOP;
      --ALU_CTRL    <= ALU_CTRL_NOP;
      correlation_begin <= '0';
      fifo_in_ren_s <= "11";
      res_wen <= '1';
      correlation_done <= '0';
      CASE state IS
        WHEN IDLE =>
          IF correlation_start = '1' THEN
            IF correlation_auto = '1' THEN
              IF fifo_out_full = '1' THEN
                state <= WFa;
              ELSE
                correlation_begin <= '1';
                state       <= S1a;
                fifo_in_ren_s <= "10";
              END IF;
            ELSE
              IF fifo_out_full = '1' THEN
                state <= WF;
              ELSE
                correlation_begin <= '1';
                state       <= S1;
                fifo_in_ren_s <= "00";
              END IF;
            END IF;
          END IF;

          ---------------------------------------------------------------------
          -- INTER CORRELATION
          ---------------------------------------------------------------------
        WHEN WF =>
          IF fifo_out_full = '0' THEN
            correlation_begin <= '1';
            state       <= S1;
            fifo_in_ren_s <= "00";
          END IF;
        WHEN S1 =>
          select_ctrl <= select_ctrl_MULT;
          --ALU_CTRL    <= ALU_CTRL_MULT;
          select_op1  <= select_R0(0);
          select_op2  <= select_R1;
          state <= S2;
        WHEN S2 =>
          select_ctrl <= select_ctrl_MAC;
          --ALU_CTRL    <= ALU_CTRL_MAC;
          select_op1  <= select_I0(0);
          select_op2  <= select_I1;
          res_wen     <= '0';
          state <= S3;
        WHEN S3 =>
          select_ctrl <= select_ctrl_MULT;
          --ALU_CTRL    <= ALU_CTRL_MULT;
          select_op1  <= select_I0(0);
          select_op2  <= select_R1;
          state <= S4;
        WHEN S4 =>
          select_ctrl <= select_ctrl_MACn;
          --ALU_CTRL    <= ALU_CTRL_MACn;
          select_op1  <= select_R0(0);
          select_op2  <= select_I1;
          res_wen     <= '0';
          IF fifo_in_empty = "00" THEN
            state       <= S1;
            fifo_in_ren_s <= "00";
          ELSE
            correlation_done <= '1';
            state <= IDLE;
          END IF;



          ---------------------------------------------------------------------
          -- AUTO CORRELATION
          ---------------------------------------------------------------------
        WHEN WFa =>
          IF fifo_out_full = '0' THEN
            correlation_begin <= '1';
            state               <= S1a;
            fifo_in_ren_s         <= "10";
          END IF;
        WHEN S1a =>
          select_ctrl <= select_ctrl_MULT;
          --ALU_CTRL    <= ALU_CTRL_MULT;
          select_op1  <= select_R0(0);
          select_op2  <= select_R0;
          state <= S2a;
        WHEN S2a =>
          select_ctrl <= select_ctrl_MAC;
          --ALU_CTRL    <= ALU_CTRL_MAC;
          select_op1  <= select_I0(0);
          select_op2  <= select_I0;
          res_wen     <= '0';
          IF fifo_in_empty(0) = '0' THEN
            state       <= S1a;
            fifo_in_ren_s <= "10";
          ELSE
            correlation_done <= '1';
            state <= IDLE;
          END IF;
          
          
        WHEN OTHERS => NULL;
      END CASE;
      
    END IF;
  END PROCESS;

  ALU_CTRL <= ALU_CTRL_NOP  WHEN select_ctrl = select_ctrl_NOP  ELSE
              ALU_CTRL_MULT WHEN select_ctrl = select_ctrl_MULT ELSE
              ALU_CTRL_MAC  WHEN select_ctrl = select_ctrl_MAC  ELSE
              ALU_CTRL_MACn;
  
  OP1 <= fifo_in_data(15 DOWNTO  0) WHEN select_op1 = select_R0(0) ELSE           
         fifo_in_data(31 DOWNTO 16);  -- WHEN select_op1 = select_I0(0) ELSE      
  
  OP2 <= fifo_in_data(15 DOWNTO  0) WHEN select_op2 = select_R0 ELSE
         fifo_in_data(31 DOWNTO 16) WHEN select_op2 = select_I0 ELSE
         fifo_in_data(47 DOWNTO 32) WHEN select_op2 = select_R1 ELSE
         fifo_in_data(63 DOWNTO 48);  -- WHEN select_op2 = select_I1 ELSE
  
  ALU_MS : ALU
    GENERIC MAP (
      Arith_en   => 1,
      Logic_en   => 0,
      Input_SZ_1 => 16,
      Input_SZ_2 => 16,
      COMP_EN    => 0)                  -- 0> Enable  and 1> Disable
    PORT MAP (
      clk   => clk,
      reset => rstn,

      ctrl => ALU_CTRL(2 DOWNTO 0),
      comp => ALU_CTRL(4 DOWNTO 3),

      OP1 => OP1,
      OP2 => OP2,

      RES => RES);

  fifo_out_data <= RES;

  
  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      res_wen_reg1 <= '1';
      res_wen_reg2 <= '1';
      --res_wen_reg3 <= '1';
      fifo_out_wen <= '1';
    ELSIF clk'event AND clk = '1' THEN
      res_wen_reg1 <= res_wen;
      res_wen_reg2 <= res_wen_reg1;
      --res_wen_reg3 <= res_wen_reg2;
      fifo_out_wen <= res_wen_reg2;
    END IF;
  END PROCESS;


END beh;
