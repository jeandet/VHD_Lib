echo  "======================================================================================="
echo  "---------------------------------------------------------------------------------------"
echo  "                                LPP's GRLIB GLOBAL PATCHER				"
echo  "                    Copyright (C) 2010 Laboratory of Plasmas Physic.			" 
echo  "======================================================================================="
echo '------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2010, Laboratory of Plasmas Physic - CNRS
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 3 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
-------------------------------------------------------------------------------'
echo 
echo
echo 

# Absolute path to this script. /home/user/bin/foo.sh
#SCRIPT=$(readlink -f $0)
# Absolute path this script is in. /home/user/bin

#LPP_PATCHPATH=`dirname $SCRIPT`
LPP_PATCHPATH=`pwd -L`

GRLIBPATH=$1


if [ -d "$GRLIBPATH" ]; then
	if [ -d "$GRLIBPATH/lib" ]; then
		if [ -d "$GRLIBPATH/designs" ]; then
			if [ -d "$GRLIBPATH/boards" ]; then
				#PATCH /lib
				echo "patch /lib"
				echo

				sh  scripts/patchlibs.sh $GRLIBPATH

				#PATCH /boards
				echo "patch /boards"
				echo
				sh scripts/patchboards.sh $GRLIBPATH

				#PATCH /designs
				echo "patch /designs"
				echo
				sh scripts/patchdesigns.sh $GRLIBPATH

				echo
				echo

				#CLEAN
				echo "CLEANING .."
				rm -f -v $1/lib/*.sh
				rm -f -v $1/lib/TODO
				rm -f -v $1/lib/Makefile
				rm -f -v $1/lib/log.txt
				echo
				echo
				echo
			else
				echo "I can't find GRLIB in             $1"
			fi

		else
			echo "I can't find GRLIB in             $1"
		fi
	else
		echo "I can't find GRLIB in             $1"
	fi

else
	echo "I can't find GRLIB in             $1"
fi






