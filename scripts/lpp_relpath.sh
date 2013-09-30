#!/bin/bash
#"======================================================================================="
#"---------------------------------------------------------------------------------------"
#"                                 LPP VHDL lib makeDirs                                   "
#"                    Copyright (C) 2010 Laboratory of Plasmas Physic.                     "
#"======================================================================================="
#----------------------------------------------------------------------------------------
#            This file is a part of the LPP VHDL IP LIBRARY
#            Copyright (C) 2010, Laboratory of Plasmas Physic - CNRS
#
#            This program is free software; you can redistribute it and/or modify
#            it under the terms of the GNU General Public License as published by
#            the Free Software Foundation; either version 3 of the License, or
#            (at your option) any later version.
#
#            This program is distributed in the hope that it will be useful,
#            but WITHOUT ANY WARRANTY; without even the implied warranty of
#            MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#            GNU General Public License for more details.
#
#            You should have received a copy of the GNU General Public License
#            along with this program; if not, write to the Free Software
#            Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#----------------------------------------------------------------------------------------

function fullpath() {
    if test $# -gt 0
    then
        cd $1
        echo `pwd`
    fi
}

function relpath() {
    if test $# -gt 1
    then
        source=`fullpath $1`
        target=`fullpath $2`

        common_part=$source # for now
        result="" # for now

        while [[ "${target#$common_part}" == "${target}" ]]; do
            # no match, means that candidate common part is not correct
            # go up one level (reduce common part)
            common_part="$(dirname $common_part)"
            # and record that we went back, with correct / handling
            if [[ -z $result ]]; then
                result=".."
            else
                result="../$result"
            fi
        done

        if [[ $common_part == "/" ]]; then
            # special case for root (no common path)
            result="$result/"
        fi

        # since we now have identified the common part,
        # compute the non-common part
        forward_part="${target#$common_part}"

        # and now stick all parts together
        if [[ -n $result ]] && [[ -n $forward_part ]]; then
            result="$result$forward_part"
        elif [[ -n $forward_part ]]; then
            # extra slash removal
            result="${forward_part:1}"
        fi

        echo $result
    fi
}

PATH1=`pwd`
echo `relpath $PATH1 $GRLIB`