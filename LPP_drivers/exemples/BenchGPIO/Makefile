#------------------------------------------------------------------------------
#--  This file is a part of the LPP VHDL IP LIBRARY
#--  Copyright (C) 2010, Laboratory of Plasmas Physic - CNRS
#--
#--  This program is free software; you can redistribute it and/or modify
#--  it under the terms of the GNU General Public License as published by
#--  the Free Software Foundation; either version 3 of the License, or
#--  (at your option) any later version.
#--
#--  This program is distributed in the hope that it will be useful,
#--  but WITHOUT ANY WARRANTY; without even the implied warranty of
#--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#--  GNU General Public License for more details.
#--
#--  You should have received a copy of the GNU General Public License
#--  along with this program; if not, write to the Free Software
#--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#------------------------------------------------------------------------------

include ../../rules.mk
LIBDIR = ../../lib
INCPATH = ../../includes
SCRIPTDIR=../../scripts/
LIBS=-lapb_gpio_Driver -llpp_apb_functions -lapb_delay_Driver
INPUTFILE=main.c
EXEC=BenchGPIO.bin
OUTBINDIR=bin/


.PHONY:bin

all:bin
	@echo $(EXEC)" file created"

clean:
	rm -f *.{o,a}



help:ruleshelp
	@echo "          all      : makes an executable file called "$(EXEC)
	@echo "                     in "$(OUTBINDIR)
	@echo "          clean    : removes temporary files"

