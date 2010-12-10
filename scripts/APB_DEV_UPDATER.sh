echo  "======================================================================================="
echo  "---------------------------------------------------------------------------------------"
echo  "                            LPP VHDL APB Devices List Updater		        	"
echo  "                    Copyright (C) 2010 Laboratory of Plasmas Physic.			" 
echo  "======================================================================================="
echo  '----------------------------------------------------------------------------------------
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

LPP_PATCHPATH=`pwd -L`

cd $LPP_PATCHPATH/lib/lpp


VHDFileStart=$LPP_PATCHPATH/APB_DEVICES/VHDListSTART
VHDFileEnd=$LPP_PATCHPATH/APB_DEVICES/VHDListEND

CFileStart=$LPP_PATCHPATH/APB_DEVICES/CListSTART
CFileEnd=$LPP_PATCHPATH/APB_DEVICES/CListEND

ListFILE=$LPP_PATCHPATH/APB_DEVICES/apb_devices_list.txt

VHDListFILE=$LPP_PATCHPATH/lib/lpp/lpp_amba/apb_devices_list.vhd
CListFILE=$LPP_PATCHPATH/LPP_drivers/libsrc/AMBA/apb_devices_list.h


cat $VHDFileStart>$VHDListFILE
cat $CFileStart>$CListFILE

grep vendor $ListFILE | sed "s/vendor /constant /" | sed "s/.* /&  : amba_vendor_type := 16#/" | sed "s/.*#*/&;/" >> $VHDListFILE
grep vendor $ListFILE | sed "s/vendor /#define /" | sed "s/.* /& 0x/" >> $CListFILE

echo " ">>$VHDListFILE
echo " ">>$CListFILE

grep device $ListFILE | sed "s/device /constant /" |  sed "s/.* /&  : amba_device_type := 16#/" | sed "s/.*#*/&;/"   >> $VHDListFILE
grep device $ListFILE | sed "s/device /#define /" | sed "s/.* /& 0x/" >> $CListFILE

cat $VHDFileEnd>>$VHDListFILE
cat $CFileEnd>>$CListFILE

sh $(SCRIPTSDIR)/GPL_Patcher.sh vhd lib/lpp/lpp_amba/
sh $(SCRIPTSDIR)/GPL_Patcher.sh h LPP_drivers/libsrc/AMBA/

cd $LPP_PATCHPATH














