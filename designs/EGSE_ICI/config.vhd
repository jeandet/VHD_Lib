-----------------------------------------------------------------------------
-- LEON3 Demonstration design test bench configuration
-- Copyright (C) 2004 Jiri Gaisler, Gaisler Research
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
-- GNU General Public License for more details.
------------------------------------------------------------------------------


library techmap;
use techmap.gencomp.all;

package config is


-- Technology and synthesis options
  constant CFG_FABTECH : integer := apa3;
  constant CFG_MEMTECH : integer := apa3;
  constant CFG_PADTECH : integer := inferred;
  constant CFG_NOASYNC : integer := 0;
  constant CFG_SCAN : integer := 0;

-- Clock generator
  constant CFG_CLKTECH : integer := apa3;
  constant CFG_CLKMUL : integer := (25);
  constant CFG_CLKDIV : integer := (9);
  constant CFG_OCLKDIV : integer := (4);
  constant CFG_PCIDLL : integer := 0;
  constant CFG_PCISYSCLK: integer := 0;
  constant CFG_CLK_NOFB : integer := 0;
  constant BOARDFREQ : integer := 48000;


end;
