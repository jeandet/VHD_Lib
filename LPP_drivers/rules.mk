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

CC  = sparc-elf-gcc
AR  = sparc-elf-ar
LIBDIR = ../../lib/
INCPATH = ../../includes
SCRIPTDIR=../../scripts/
OUTBINDIR=bin/
EXEC=exec.bin
INPUTFILE=main.c

$(FILE): $(FILE).a
	@echo "library ""lib"$(FILE)" created"


$(FILE).o: 
	mkdir -p tmp
	$(CC) -c $(FILE).c -I $(INCPATH) -o tmp/$(FILE).o

$(FILE).a: $(FILE).o
	$(AR) rs $(LIBDIR)"lib"$(FILE).a tmp/$(FILE).o
	cp *.h $(INCPATH)
	rm -R tmp

load: all
	@echo "load "$(OUTBINDIR)$(EXEC)>$(SCRIPTDIR)load.txt
	grmon-eval -uart $(PORT) -u -c $(SCRIPTDIR)load.txt

bin:
	mkdir -p $(OUTBINDIR)
	$(CC) $(INPUTFILE) -o $(OUTBINDIR)/$(EXEC) -I $(INCPATH) -L $(LIBDIR) -static $(LIBS)

clean:
	rm -f -R tmp
	rm -f *.{o,a}
	rm -f $(INCPATH)*.h
	rm -f $(LIBDIR)*.{o,a}

ruleshelp:
	@echo ""
	@echo ""
	@echo ""
	@echo "          load     : call grmon-eval and loads "$(EXEC)" in the leon"
	@echo "                     usage: make PORT=/dev/ttyUSBx load"


