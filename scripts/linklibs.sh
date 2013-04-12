echo  "======================================================================================="
echo  "---------------------------------------------------------------------------------------"
echo  "                                LPP's GRLIB GLOBAL PATCHER				"
echo  "                    Copyright (C) 2013 Laboratory of Plasmas Physic.			" 
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


VHDLIB_LIB_PATH=`pwd -L`
source $VHDLIB_LIB_PATH/scripts/lpp_bash_functions.sh
GRLIBPATH=$1

if [ -d "$GRLIBPATH" ]; then
        LPP_PATCHPATH=`relpath $GRLIBPATH $VHDLIB_LIB_PATH`
        echo $LPP_PATCHPATH
	if [ -d "$GRLIBPATH/lib" ]; then
		if [ -d "$GRLIBPATH/designs" ]; then
			if [ -d "$GRLIBPATH/boards" ]; then

				echo "Patch $1/lib/libs.txt..."
				if(grep -q $LPP_PATCHPATH/lib/lpp $1/lib/libs.txt); then
					echo "No need to Patch $1/lib/libs.txt..."
				else
					echo $LPP_PATCHPATH/lib/lpp >>$1/lib/libs.txt
				fi
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






