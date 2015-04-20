
--=================================================================================
--THIS FILE IS GENERATED BY A SCRIPT, DON'T TRY TO EDIT
--
--TAKE A LOOK AT VHD_LIB/APB_DEVICES FOLDER TO ADD A DEVICE ID OR VENDOR ID
--=================================================================================


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY grlib;
USE grlib.amba.ALL;
USE std.textio.ALL;


PACKAGE apb_devices_list IS


  CONSTANT VENDOR_LPP : amba_vendor_type := 16#19#;

  CONSTANT ROCKET_TM           : amba_device_type := 16#1#;
  CONSTANT otherCore           : amba_device_type := 16#2#;
  CONSTANT LPP_SIMPLE_DIODE    : amba_device_type := 16#3#;
  CONSTANT LPP_MULTI_DIODE     : amba_device_type := 16#4#;
  CONSTANT LPP_LCD_CTRLR       : amba_device_type := 16#5#;
  CONSTANT LPP_UART            : amba_device_type := 16#6#;
  CONSTANT LPP_CNA             : amba_device_type := 16#7#;
  CONSTANT LPP_APB_ADC         : amba_device_type := 16#8#;
  CONSTANT LPP_CHENILLARD      : amba_device_type := 16#9#;
  CONSTANT LPP_IIR_CEL_FILTER  : amba_device_type := 16#10#;
  CONSTANT LPP_FIFO_PID        : amba_device_type := 16#11#;
  CONSTANT LPP_FFT             : amba_device_type := 16#12#;
  CONSTANT LPP_MATRIX          : amba_device_type := 16#13#;
  CONSTANT LPP_DELAY           : amba_device_type := 16#14#;
  CONSTANT LPP_USB             : amba_device_type := 16#15#;
  CONSTANT LPP_BALISE          : amba_device_type := 16#16#;
  CONSTANT LPP_DMA_TYPE        : amba_device_type := 16#17#;
  CONSTANT LPP_BOOTLOADER_TYPE : amba_device_type := 16#18#;
  CONSTANT LPP_LFR             : amba_device_type := 16#19#;
  CONSTANT LPP_CLKSETTING      : amba_device_type := 16#20#;
  CONSTANT LPP_LFR_HK_DEVICE   : amba_device_type := 16#21#;
  CONSTANT LPP_LFR_MANAGEMENT  : amba_device_type := 16#22#;
  CONSTANT LPP_DEBUG_DMA       : amba_device_type := 16#A0#;
  CONSTANT LPP_DEBUG_LFR       : amba_device_type := 16#A1#;
  constant APB_ADC_READER   : amba_device_type := 16#F1#;
  CONSTANT LPP_DEBUG_LFR_ID    : amba_device_type := 16#A2#;
  
END;
