--************************************************************************
--**    MODEL   :       async_1Mx16.vhd                                    **
--**    COMPANY :       Cypress Semiconductor                           **
--**    REVISION:       1.0 Created new base model                                  ** 
--************************************************************************

-------------------------------------------------------------------------------JC\/
--Library ieee,work;
LIBRARY ieee;
-------------------------------------------------------------------------------JC/\
USE IEEE.Std_Logic_1164.ALL;
USE IEEE.Std_Logic_unsigned.ALL;

-------------------------------------------------------------------------------JC\/
--use work.package_timing.all;
--use work.package_utility.all;
LIBRARY lpp;
USE lpp.package_timing.ALL;
USE lpp.package_utility.ALL;
-------------------------------------------------------------------------------JC/\

------------------------
-- Entity Description
------------------------

ENTITY CY7C1061DV33 IS
  GENERIC
    (ADDR_BITS : INTEGER := 20;
     DATA_BITS : INTEGER := 16;
     depth     : INTEGER := 1048576;

     TimingInfo   : BOOLEAN   := true;
     TimingChecks : STD_LOGIC := '1'
     );
  PORT (
    CE1_b : IN    STD_LOGIC;            -- Chip Enable CE1#
    CE2   : IN    STD_LOGIC;            -- Chip Enable CE2
    WE_b  : IN    STD_LOGIC;            -- Write Enable WE#
    OE_b  : IN    STD_LOGIC;            -- Output Enable OE#
    BHE_b : IN    STD_LOGIC;            -- Byte Enable High BHE#
    BLE_b : IN    STD_LOGIC;            -- Byte Enable Low BLE#
    A     : IN    STD_LOGIC_VECTOR(addr_bits-1 DOWNTO 0);  -- Address Inputs A
    DQ    : INOUT STD_LOGIC_VECTOR(DATA_BITS-1 DOWNTO 0) := (OTHERS => 'Z')-- Read/Write Data IO;
    ); 
END CY7C1061DV33;

-----------------------------
-- End Entity Description
-----------------------------
-----------------------------
-- Architecture Description
-----------------------------

ARCHITECTURE behave_arch OF CY7C1061DV33 IS

  TYPE mem_array_type IS ARRAY (depth-1 DOWNTO 0) OF STD_LOGIC_VECTOR(DATA_BITS-1 DOWNTO 0);

  SIGNAL write_enable : STD_LOGIC;
  SIGNAL read_enable  : STD_LOGIC;
  SIGNAL byte_enable  : STD_LOGIC;
  SIGNAL CE_b         : STD_LOGIC;

  SIGNAL data_skew : STD_LOGIC_VECTOR(DATA_BITS-1 DOWNTO 0);

  SIGNAL address_internal, address_skew : STD_LOGIC_VECTOR(addr_bits-1 DOWNTO 0);

  CONSTANT tSD_dataskew : TIME := tSD - 1 ns;
  CONSTANT tskew        : TIME := 1 ns;

  -------------------------------------------------------------------------------JC\/
  TYPE mem_array_type_t IS ARRAY (31 DOWNTO 0) OF STD_LOGIC_VECTOR(DATA_BITS-1 DOWNTO 0);
  SIGNAL mem_array_0 : mem_array_type_t;
  SIGNAL mem_array_1 : mem_array_type_t;
  SIGNAL mem_array_2 : mem_array_type_t;
  SIGNAL mem_array_3 : mem_array_type_t;
  -------------------------------------------------------------------------------JC/\

  

BEGIN
  CE_b         <= CE1_b OR NOT(CE2);
  byte_enable  <= NOT(BHE_b AND BLE_b);
  write_enable <= NOT(CE1_b) AND CE2 AND NOT(WE_b) AND NOT(BHE_b AND BLE_b);
  read_enable  <= NOT(CE1_b) AND CE2 AND (WE_b) AND NOT(OE_b) AND NOT(BHE_b AND BLE_b);

  data_skew    <= DQ AFTER 1 ns;        -- changed on feb 15
  address_skew <= A  AFTER 1 ns;

  PROCESS (OE_b)
  BEGIN
    IF (OE_b'EVENT AND OE_b = '1' AND write_enable /= '1') THEN
      DQ <= (OTHERS => 'Z') after tHZOE;
    END IF;
  END PROCESS;

  PROCESS (CE_b)
  BEGIN
    IF (CE_b'EVENT AND CE_b = '1') THEN
      DQ <= (OTHERS => 'Z') after tHZCE;
    END IF;
  END PROCESS;

  PROCESS (write_enable'DELAYED(tHA))
  BEGIN
    IF (write_enable'DELAYED(tHA) = '0' AND TimingInfo) THEN
      ASSERT (A'LAST_EVENT = 0 ns) OR (A'LAST_EVENT > tHA)
        REPORT "Address hold time tHA violated";
    END IF;
  END PROCESS;

  PROCESS (write_enable'DELAYED(tHD))
  BEGIN
    IF (write_enable'DELAYED(tHD) = '0' AND TimingInfo) THEN
      ASSERT (DQ'LAST_EVENT > tHD) OR (DQ'LAST_EVENT = 0 ns)
        REPORT "Data hold time tHD violated";
    END IF;
  END PROCESS;

-- main process
  PROCESS
    
    VARIABLE mem_array : mem_array_type;

--- Variables for timing checks
    VARIABLE tPWE_chk  : TIME := -10 ns;
    VARIABLE tAW_chk   : TIME := -10 ns;
    VARIABLE tSD_chk   : TIME := -10 ns;
    VARIABLE tRC_chk   : TIME := 0 ns;
    VARIABLE tBAW_chk  : TIME := 0 ns;
    VARIABLE tBBW_chk  : TIME := 0 ns;
    VARIABLE tBCW_chk  : TIME := 0 ns;
    VARIABLE tBDW_chk  : TIME := 0 ns;
    VARIABLE tSA_chk   : TIME := 0 ns;
    VARIABLE tSA_skew  : TIME := 0 ns;
    VARIABLE tAint_chk : TIME := -10 ns;

    VARIABLE write_flag : BOOLEAN := true;

    VARIABLE accesstime : TIME := 0 ns;
    
  BEGIN
    IF (address_skew'EVENT) THEN
      tSA_skew := NOW;
    END IF;

    -- start of write
    IF (write_enable = '1' AND write_enable'EVENT) THEN
      
      DQ(DATA_BITS-1 DOWNTO 0) <= (OTHERS => 'Z') after tHZWE;

      IF (A'LAST_EVENT >= tSA) THEN
        address_internal <= A;
        tPWE_chk         := NOW;
        tAW_chk          := A'LAST_EVENT;
        tAint_chk        := NOW;
        write_flag       := true;

      ELSE
        IF (TimingInfo) THEN
          ASSERT false
            REPORT "Address setup violated";
        END IF;
        write_flag := false;

      END IF;

      -- end of write (with CE high or WE high)
    ELSIF (write_enable = '0' AND write_enable'EVENT) THEN

      --- check for pulse width
      IF (NOW - tPWE_chk >= tPWE OR NOW - tPWE_chk <= 0.1 ns OR NOW = 0 ns) THEN
        --- pulse width OK, do nothing
      ELSE
        IF (TimingInfo) THEN
          ASSERT false
            REPORT "Pulse Width violation";
        END IF;

        write_flag := false;
      END IF;


      IF (NOW > 0 ns) THEN
        IF (tSA_skew - tAint_chk > tskew) THEN
          ASSERT false
            REPORT "Negative address setup";
          write_flag := false;
        END IF;
      END IF;

      --- check for address setup with write end, i.e., tAW
      IF (NOW - tAW_chk >= tAW OR NOW = 0 ns) THEN
        --- tAW OK, do nothing
      ELSE
        IF (TimingInfo) THEN
          ASSERT false
            REPORT "Address setup tAW violation";
        END IF;

        write_flag := false;
      END IF;

      --- check for data setup with write end, i.e., tSD
      IF (NOW - tSD_chk >= tSD_dataskew OR NOW - tSD_chk <= 0.1 ns OR NOW = 0 ns) THEN
        --- tSD OK, do nothing
      ELSE
        IF (TimingInfo) THEN
          ASSERT false
            REPORT "Data setup tSD violation";
        END IF;
        write_flag := false;
      END IF;

      -- perform write operation if no violations
      IF (write_flag = true) THEN

        IF (BLE_b = '1' AND BLE_b'LAST_EVENT = write_enable'LAST_EVENT AND NOW /= 0 ns) THEN
          mem_array(conv_integer1(address_internal))(7 DOWNTO 0) := data_skew(7 DOWNTO 0);
        END IF;

        IF (BHE_b = '1' AND BHE_b'LAST_EVENT = write_enable'LAST_EVENT AND NOW /= 0 ns) THEN
          mem_array(conv_integer1(address_internal))(15 DOWNTO 8) := data_skew(15 DOWNTO 8);
        END IF;

        IF (BLE_b = '0' AND NOW - tBAW_chk >= tBW) THEN
          mem_array(conv_integer1(address_internal))(7 DOWNTO 0) := data_skew(7 DOWNTO 0);
        ELSIF (NOW - tBAW_chk < tBW AND NOW - tBAW_chk > 0.1 ns AND NOW > 0 ns) THEN
          ASSERT false REPORT "Insufficient pulse width for lower byte to be written";
        END IF;

        IF (BHE_b = '0' AND NOW - tBBW_chk >= tBW) THEN
          mem_array(conv_integer1(address_internal))(15 DOWNTO 8) := data_skew(15 DOWNTO 8);
        ELSIF (NOW - tBBW_chk < tBW AND NOW - tBBW_chk > 0.1 ns AND NOW > 0 ns) THEN
          ASSERT false REPORT "Insufficient pulse width for higher byte to be written";
        END IF;

        
        -------------------------------------------------------------------------------JC\/
        all_mem_array_obs: FOR I IN 0 TO 31 LOOP
          IF I + ((2**15) *0) < depth THEN  mem_array_0(I) <= mem_array(I+((2**15) *0)); END IF;
          IF I + ((2**15) *1) < depth THEN  mem_array_1(I) <= mem_array(I+((2**15) *1)); END IF;
          IF I + ((2**15) *2) < depth THEN  mem_array_2(I) <= mem_array(I+((2**15) *2)); END IF;
          IF I + ((2**15) *3) < depth THEN  mem_array_3(I) <= mem_array(I+((2**15) *3)); END IF;
        END LOOP all_mem_array_obs;
        -------------------------------------------------------------------------------JC/\

      END IF;

      -- end of write (with BLE high)
    ELSIF (BLE_b'EVENT AND NOT(BHE_b'EVENT) AND write_enable = '1') THEN
      
      IF (BLE_b = '0') THEN

        --- Reset timing variables
        tAW_chk    := A'LAST_EVENT;
        tBAW_chk   := NOW;
        write_flag := true;
        
      ELSIF (BLE_b = '1') THEN

        --- check for pulse width
        IF (NOW - tPWE_chk >= tPWE) THEN
          --- tPWE OK, do nothing
        ELSE
          IF (TimingInfo) THEN
            ASSERT false
              REPORT "Pulse Width violation";
          END IF;

          write_flag := false;
        END IF;

        --- check for address setup with write end, i.e., tAW
        IF (NOW - tAW_chk >= tAW) THEN
          --- tAW OK, do nothing
        ELSE
          IF (TimingInfo) THEN
            ASSERT false
              REPORT "Address setup tAW violation for Lower Byte Write";
          END IF;

          write_flag := false;
        END IF;

        --- check for byte write setup with write end, i.e., tBW
        IF (NOW - tBAW_chk >= tBW) THEN
          --- tBW OK, do nothing
        ELSE
          IF (TimingInfo) THEN
            ASSERT false
              REPORT "Lower Byte setup tBW violation";
          END IF;

          write_flag := false;
        END IF;

        --- check for data setup with write end, i.e., tSD
        IF (NOW - tSD_chk >= tSD_dataskew OR NOW - tSD_chk <= 0.1 ns OR NOW = 0 ns) THEN
          --- tSD OK, do nothing
        ELSE
          IF (TimingInfo) THEN
            ASSERT false
              REPORT "Data setup tSD violation for Lower Byte Write";
          END IF;

          write_flag := false;
        END IF;

        --- perform WRITE operation if no violations
        IF (write_flag = true) THEN
          mem_array(conv_integer1(address_internal))(7 DOWNTO 0) := data_skew(7 DOWNTO 0);
          IF (BHE_b = '0') THEN
            mem_array(conv_integer1(address_internal))(15 DOWNTO 8) := data_skew(15 DOWNTO 8);
          END IF;
        END IF;

        --- Reset timing variables
        tAW_chk    := A'LAST_EVENT;
        tBAW_chk   := NOW;
        write_flag := true;
        
      END IF;

      -- end of write (with BHE high)
    ELSIF (BHE_b'EVENT AND NOT(BLE_b'EVENT) AND write_enable = '1') THEN

      IF (BHE_b = '0') THEN

        --- Reset timing variables
        tAW_chk    := A'LAST_EVENT;
        tBBW_chk   := NOW;
        write_flag := true;
        
      ELSIF (BHE_b = '1') THEN

        --- check for pulse width
        IF (NOW - tPWE_chk >= tPWE) THEN
          --- tPWE OK, do nothing
        ELSE
          IF (TimingInfo) THEN
            ASSERT false
              REPORT "Pulse Width violation";
          END IF;

          write_flag := false;
        END IF;

        --- check for address setup with write end, i.e., tAW
        IF (NOW - tAW_chk >= tAW) THEN
          --- tAW OK, do nothing
        ELSE
          IF (TimingInfo) THEN
            ASSERT false
              REPORT "Address setup tAW violation for Upper Byte Write";
          END IF;
          write_flag := false;
        END IF;

        --- check for byte setup with write end, i.e., tBW
        IF (NOW - tBBW_chk >= tBW) THEN
          --- tBW OK, do nothing
        ELSE
          IF (TimingInfo) THEN
            ASSERT false
              REPORT "Upper Byte setup tBW violation";
          END IF;

          write_flag := false;
        END IF;

        --- check for data setup with write end, i.e., tSD
        IF (NOW - tSD_chk >= tSD_dataskew OR NOW - tSD_chk <= 0.1 ns OR NOW = 0 ns) THEN
          --- tSD OK, do nothing
        ELSE
          IF (TimingInfo) THEN
            ASSERT false
              REPORT "Data setup tSD violation for Upper Byte Write";
          END IF;

          write_flag := false;
        END IF;

        --- perform WRITE operation if no violations

        IF (write_flag = true) THEN
          mem_array(conv_integer1(address_internal))(15 DOWNTO 8) := data_skew(15 DOWNTO 8);
          IF (BLE_b = '0') THEN
            mem_array(conv_integer1(address_internal))(7 DOWNTO 0) := data_skew(7 DOWNTO 0);
          END IF;
          
        END IF;

        --- Reset timing variables
        tAW_chk    := A'LAST_EVENT;
        tBBW_chk   := NOW;
        write_flag := true;
        
      END IF;

    END IF;
    --- END OF WRITE

    IF (data_skew'EVENT AND read_enable /= '1') THEN
      tSD_chk := NOW;
    END IF;

    --- START of READ

    --- Tri-state the data bus if CE or OE disabled
    IF (read_enable = '0' AND read_enable'EVENT) THEN
      IF (OE_b'LAST_EVENT >= CE_b'LAST_EVENT) THEN
        DQ <= (OTHERS => 'Z') after tHZCE;
      ELSIF (CE_b'LAST_EVENT > OE_b'LAST_EVENT) THEN
        DQ <= (OTHERS => 'Z') after tHZOE;
      END IF;
    END IF;

    --- Address-controlled READ operation
    IF (A'EVENT) THEN
      IF (A'LAST_EVENT = CE_b'LAST_EVENT AND CE_b = '1') THEN
        DQ <= (OTHERS => 'Z') after tHZCE;
      END IF;

      IF (NOW - tRC_chk >= tRC OR NOW - tRC_chk <= 0.1 ns OR tRC_chk = 0 ns) THEN
        --- tRC OK, do nothing
      ELSE
        
        IF (TimingInfo) THEN
          ASSERT false
            REPORT "Read Cycle time tRC violation";
        END IF;

      END IF;

      IF (read_enable = '1') THEN
        
        IF (BLE_b = '0') THEN
          DQ (7 DOWNTO 0) <= mem_array (conv_integer1(A))(7 DOWNTO 0) AFTER tAA;
        END IF;

        IF (BHE_b = '0') THEN
          DQ (15 DOWNTO 8) <= mem_array (conv_integer1(A))(15 DOWNTO 8) AFTER tAA;
        END IF;

        tRC_chk := NOW;

      END IF;

      IF (write_enable = '1') THEN
        --- do nothing
      END IF;
      
    END IF;

    IF (read_enable = '0' AND read_enable'EVENT) THEN
      DQ <= (OTHERS => 'Z') after tHZCE;
      IF (NOW - tRC_chk >= tRC OR tRC_chk = 0 ns OR A'LAST_EVENT = read_enable'LAST_EVENT) THEN
        --- tRC_chk needs to be reset when read ends
        tRC_CHK := 0 ns;
      ELSE
        IF (TimingInfo) THEN
          ASSERT false
            REPORT "Read Cycle time tRC violation";
        END IF;
        tRC_CHK := 0 ns;
      END IF;

    END IF;

    --- READ operation triggered by CE/OE/BHE/BLE
    IF (read_enable = '1' AND read_enable'EVENT) THEN

      tRC_chk := NOW;

      --- CE triggered READ
      IF (CE_b'LAST_EVENT = read_enable'LAST_EVENT) THEN  --  changed rev2

        IF (BLE_b = '0') THEN
          DQ (7 DOWNTO 0) <= mem_array (conv_integer1(A)) (7 DOWNTO 0) AFTER tACE;
        END IF;

        IF (BHE_b = '0') THEN
          DQ (15 DOWNTO 8) <= mem_array (conv_integer1(A)) (15 DOWNTO 8) AFTER tACE;
        END IF;
        
      END IF;


      --- OE triggered READ  
      IF (OE_b'LAST_EVENT = read_enable'LAST_EVENT) THEN

        -- if address or CE changes before OE such that tAA/tACE > tDOE
        IF (CE_b'LAST_EVENT < tACE - tDOE AND A'LAST_EVENT < tAA - tDOE) THEN
          
          IF (A'LAST_EVENT < CE_b'LAST_EVENT) THEN

            accesstime := tAA-A'LAST_EVENT;
            IF (BLE_b = '0') THEN
              DQ (7 DOWNTO 0) <= mem_array (conv_integer1(A)) (7 DOWNTO 0) AFTER accesstime;
            END IF;

            IF (BHE_b = '0') THEN
              DQ (15 DOWNTO 8) <= mem_array (conv_integer1(A)) (15 DOWNTO 8) AFTER accesstime;
            END IF;

          ELSE
            accesstime := tACE-CE_b'LAST_EVENT;
            IF (BLE_b = '0') THEN
              DQ (7 DOWNTO 0) <= mem_array (conv_integer1(A)) (7 DOWNTO 0) AFTER accesstime;
            END IF;

            IF (BHE_b = '0') THEN
              DQ (15 DOWNTO 8) <= mem_array (conv_integer1(A)) (15 DOWNTO 8) AFTER accesstime;
            END IF;
          END IF;

          -- if address changes before OE such that tAA > tDOE
        ELSIF (A'LAST_EVENT < tAA - tDOE) THEN
          
          accesstime := tAA-A'LAST_EVENT;
          IF (BLE_b = '0') THEN
            DQ (7 DOWNTO 0) <= mem_array (conv_integer1(A)) (7 DOWNTO 0) AFTER accesstime;
          END IF;

          IF (BHE_b = '0') THEN
            DQ (15 DOWNTO 8) <= mem_array (conv_integer1(A)) (15 DOWNTO 8) AFTER accesstime;
          END IF;

          -- if CE changes before OE such that tACE > tDOE
        ELSIF (CE_b'LAST_EVENT < tACE - tDOE) THEN
          
          accesstime := tACE-CE_b'LAST_EVENT;
          IF (BLE_b = '0') THEN
            DQ (7 DOWNTO 0) <= mem_array (conv_integer1(A)) (7 DOWNTO 0) AFTER accesstime;
          END IF;

          IF (BHE_b = '0') THEN
            DQ (15 DOWNTO 8) <= mem_array (conv_integer1(A)) (15 DOWNTO 8) AFTER accesstime;
          END IF;

          -- if OE changes such that tDOE > tAA/tACE           
        ELSE
          IF (BLE_b = '0') THEN
            DQ (7 DOWNTO 0) <= mem_array (conv_integer1(A)) (7 DOWNTO 0) AFTER tDOE;
          END IF;

          IF (BHE_b = '0') THEN
            DQ (15 DOWNTO 8) <= mem_array (conv_integer1(A)) (15 DOWNTO 8) AFTER tDOE;
          END IF;
          
        END IF;
        
      END IF;
      --- END of OE triggered READ

      --- BLE/BHE triggered READ  
      IF (BLE_b'LAST_EVENT = read_enable'LAST_EVENT OR BHE_b'LAST_EVENT = read_enable'LAST_EVENT) THEN

        -- if address or CE changes before BHE/BLE such that tAA/tACE > tDBE
        IF (CE_b'LAST_EVENT < tACE - tDBE AND A'LAST_EVENT < tAA - tDBE) THEN
          
          IF (A'LAST_EVENT < BLE_b'LAST_EVENT) THEN
            accesstime := tAA-A'LAST_EVENT;

            IF (BLE_b = '0') THEN
              DQ (7 DOWNTO 0) <= mem_array (conv_integer1(A)) (7 DOWNTO 0) AFTER accesstime;
            END IF;

            IF (BHE_b = '0') THEN
              DQ (15 DOWNTO 8) <= mem_array (conv_integer1(A)) (15 DOWNTO 8) AFTER accesstime;
            END IF;

          ELSE
            accesstime := tACE-CE_b'LAST_EVENT;

            IF (BLE_b = '0') THEN
              DQ (7 DOWNTO 0) <= mem_array (conv_integer1(A)) (7 DOWNTO 0) AFTER accesstime;
            END IF;

            IF (BHE_b = '0') THEN
              DQ (15 DOWNTO 8) <= mem_array (conv_integer1(A)) (15 DOWNTO 8) AFTER accesstime;
            END IF;
          END IF;

          -- if address changes before BHE/BLE such that tAA > tDBE
        ELSIF (A'LAST_EVENT < tAA - tDBE) THEN
          accesstime := tAA-A'LAST_EVENT;

          IF (BLE_b = '0') THEN
            DQ (7 DOWNTO 0) <= mem_array (conv_integer1(A)) (7 DOWNTO 0) AFTER accesstime;
          END IF;

          IF (BHE_b = '0') THEN
            DQ (15 DOWNTO 8) <= mem_array (conv_integer1(A)) (15 DOWNTO 8) AFTER accesstime;
          END IF;

          -- if CE changes before BHE/BLE such that tACE > tDBE
        ELSIF (CE_b'LAST_EVENT < tACE - tDBE) THEN
          accesstime := tACE-CE_b'LAST_EVENT;

          IF (BLE_b = '0') THEN
            DQ (7 DOWNTO 0) <= mem_array (conv_integer1(A)) (7 DOWNTO 0) AFTER accesstime;
          END IF;

          IF (BHE_b = '0') THEN
            DQ (15 DOWNTO 8) <= mem_array (conv_integer1(A)) (15 DOWNTO 8) AFTER accesstime;
          END IF;

          -- if BHE/BLE changes such that tDBE > tAA/tACE   
        ELSE
          IF (BLE_b = '0') THEN
            DQ (7 DOWNTO 0) <= mem_array (conv_integer1(A)) (7 DOWNTO 0) AFTER tDBE;
          END IF;

          IF (BHE_b = '0') THEN
            DQ (15 DOWNTO 8) <= mem_array (conv_integer1(A)) (15 DOWNTO 8) AFTER tDBE;
          END IF;
          
        END IF;
        
      END IF;
      -- END of BHE/BLE controlled READ

      IF (WE_b'LAST_EVENT = read_enable'LAST_EVENT) THEN

        IF (BLE_b = '0') THEN
          DQ (7 DOWNTO 0) <= mem_array (conv_integer1(A)) (7 DOWNTO 0) AFTER tACE;
        END IF;

        IF (BHE_b = '0') THEN
          DQ (15 DOWNTO 8) <= mem_array (conv_integer1(A)) (15 DOWNTO 8) AFTER tACE;
        END IF;

      END IF;

    END IF;
    --- END OF CE/OE/BHE/BLE controlled READ

    --- If either BHE or BLE toggle during read mode
    IF (BLE_b'EVENT AND BLE_b = '0' AND read_enable = '1' AND NOT(read_enable'EVENT)) THEN
      DQ (7 DOWNTO 0) <= mem_array (conv_integer1(A)) (7 DOWNTO 0) AFTER tDBE;
    END IF;

    IF (BHE_b'EVENT AND BHE_b = '0' AND read_enable = '1' AND NOT(read_enable'EVENT)) THEN
      DQ (15 DOWNTO 8) <= mem_array (conv_integer1(A)) (15 DOWNTO 8) AFTER tDBE;
    END IF;

    --- tri-state bus depending on BHE/BLE 
    IF (BLE_b'EVENT AND BLE_b = '1') THEN
      DQ (7 DOWNTO 0) <= (OTHERS => 'Z') after tHZBE;
    END IF;

    IF (BHE_b'EVENT AND BHE_b = '1') THEN
      DQ (15 DOWNTO 8) <= (OTHERS => 'Z') after tHZBE;
    END IF;

    WAIT ON write_enable, A, read_enable, DQ, BLE_b, BHE_b, data_skew, address_skew;
    
  END PROCESS;

  
END behave_arch;
