echo  "======================================================================================="
echo  "---------------------------------------------------------------------------------------"
echo  "                                LPP's GRLIB IPs PATCHER					"
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


LPP_LIBPATH=`pwd -L`

echo "Patching Grlib..."
echo
echo

#COPY
echo "Remove old lib Files..."
rm -R -v $1/lib/lpp
echo "Copy lib Files..."
cp -R -v $LPP_LIBPATH/lib $1
echo
echo
echo


#PATCH libs.txt
echo "Patch $1/lib/libs.txt..."
if(grep -q lpp $1/lib/libs.txt); then
	echo "No need to Patch $1/lib/libs.txt..."
else
	echo lpp>>$1/lib/libs.txt
fi

echo
echo
echo

#CLEAN
echo "CLEANING .."
rm -v $1/lib/*.sh
rm -v $1/lib/GPL_HEADER
echo
echo
echo

