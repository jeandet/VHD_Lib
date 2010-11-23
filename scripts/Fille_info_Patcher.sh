echo  "======================================================================================="
echo  "---------------------------------------------------------------------------------------"
echo  "                                	LPP GPL PATCHER					"
echo  "                    Copyright (C) 2010 Laboratory of Plasmas Physic.			" 
echo  "======================================================================================="
echo '----------------------------------------------------------------------------------------
            This file is a part of the LPP VHDL IP LIBRARY
            Copyright (C) 2010, Laboratory of Plasmas Physic - CNRS

            This program is free software; you can redistribute it and/or modify
            it under the terms of the GNU General Public License as published by
            the Free Software Foundation; either version 3 of the License, or
            (at your option) any later version.

            This program is distributed in the hope that it will be useful,
            but WITHOUT ANY WARRANTY; without even the implied warranty of
            MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
            GNU General Public License for more details.

            You should have received a copy of the GNU General Public License
            along with this program; if not, write to the Free Software
            Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
----------------------------------------------------------------------------------------'
echo 
echo
echo 

# Absolute path to this script. /home/user/bin/foo.sh
#SCRIPT=$(readlink -f $0)
# Absolute path this script is in. /home/user/bin

#LPP_PATCHPATH=`dirname $SCRIPT`
LPP_PATCHPATH=`pwd -L`


case $1 in
	-R | --recursive ) 
	for file in $(find . -name '*.vhd')
		do
		if(grep -q "This program is free software" $file); then
			echo "$file already contains GPL HEADER"
		else
			echo "Modifying file : $file"
			more $LPP_PATCHPATH/lib/GPL_HEADER >> $file.tmp
			cat $file >> $file.tmp
			mv $file.tmp $file
		fi
	done
	;;
	-h | --help | --h | -help) 
		echo 'Help:
			This script add a GPL HEADER in all vhdl files.

			-R or --recurcive:
				Analyse recurcively folders starting from $LPP_PATCHPATH'
	;;
	* )
	for file in $(ls *.vhd)
		do
		if(grep -q "This program is free software" $file); then
			echo "$file already contains GPL HEADER"
		else
			echo "Modifying file : $file"
			more $LPP_PATCHPATH/lib/GPL_HEADER >> $file.tmp
			cat $file >> $file.tmp
			mv $file.tmp $file
		fi
	done
	;;
	
esac

