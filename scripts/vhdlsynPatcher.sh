echo  "======================================================================================="
echo  "---------------------------------------------------------------------------------------"
echo  "                        	     LPP vhdlsyn PATCHER					"
echo  "                     Copyright (C) 2010 Laboratory of Plasmas Physic.			" 
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

cd $LPP_PATCHPATH/lib/lpp

echo `pwd -L`

case $1 in
	-h | --help | --h | -help) 
		echo 'Help:
			This script add all non testbensh VHDL files in vhdlsyn.txt file of each folder.'
	;;
	* )
	for folders in $(find . -type d|grep ./)
		do
			echo "enter folder : $folders"
			files=$(ls $folders | grep .vhd | grep -i -v "test")
				echo "found $files"
				rm -f $folders/vhdlsyn.txt
				for file in $files
					do
						echo "$file">>$folders/vhdlsyn.txt
					done
		done
	;;
	
esac

cd $LPP_PATCHPATH

