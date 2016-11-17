#!/usr/bin/xonsh

import datetime as dt

folder=dt.datetime.today().strftime("%Y-%m-%d_%H-%M-%S")
mkdir @(folder)
cp input.txt output_f*.txt @(folder) 
