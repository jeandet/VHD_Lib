echo  "======================================================================================="
echo  "---------------------------------------------------------------------------------------"
echo  "                                 LPP VHDL lib makeDirs					"
echo  "                    Copyright (C) 2010 Laboratory of Plasmas Physic.			" 
echo  "======================================================================================="
echo '----------------------------------------------------------------------------------------
            This file is a part of the LPP VHDL IP LIBRARY
            Copyright (C) 2010, Laboratory of Plasmas Physic - CNRS

            This program is free software; you can redistribute it and/or modify
            it under the terms of the GNU General Public License as published by
            the Free Software Foundation; either version 2 of the License, or
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



LPP_PATCHPATH=`pwd -L`

cd $LPP_PATCHPATH/lib/lpp


#find . -type d|grep ./>$LPP_PATCHPATH/lib/lpp/dirs.txt

rm $LPP_PATCHPATH/lib/lpp/dirs.txt

for folders in $(find . -type d|grep ./)
		do
			echo "enter folder : $folders"
			files=$(ls $folders|grep .vhd)
			if(ls $folders|grep .vhd|grep -i -v .html|grep -i -v .tex); then
				echo "found $files"
				echo $folders>>$LPP_PATCHPATH/lib/lpp/dirs.txt
			fi
		done


cd $LPP_PATCHPATH
