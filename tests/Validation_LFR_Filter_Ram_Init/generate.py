import numpy as np
import random
import time
import shutil
import os

DOFILE="run.do.in"
RAM1={
"instance":"/testbench/lpp_lfr_filter_1/IIR_CEL_f0_to_f1/IIR_CEL_CTRLR_v2_DATAFLOW_1/RAM_CTRLR_v2_1/memRAM/SRAM/axc/x0/a8to12/agen(0)/u0/u0/rp/rfd",
"abits":10,
"dbits":36,
"name":"RAM1.txt"
}
RAM2={
"instance":"/testbench/lpp_lfr_filter_1/YES_IIR_FILTER_f2_f3/IIR_CEL_CTRLR_v3_1/RAM_CTRLR_v2_2/memRAM/SRAM/axc/x0/a8to12/agen(0)/u0/u0/rp/rfd",
"abits":10,
"dbits":36,
"name":"RAM2.txt"
}
RAM3={
"instance":"/testbench/lpp_lfr_filter_1/YES_IIR_FILTER_f2_f3/IIR_CEL_CTRLR_v3_1/RAM_CTRLR_v2_1/memRAM/SRAM/axc/x0/a8to12/agen(0)/u0/u0/rp/rfd",
"abits":10,
"dbits":36,
"name":"RAM3.txt"
}
RAM4={
"instance":"/testbench/lpp_lfr_filter_1/cic_lfr_1/memRAM/SRAM/axc/x0/a8to12/agen(0)/u0/u0/rp/rfd",
"abits":10,
"dbits":36,
"name":"RAM4.txt"
}
RAM5={
"instance":"/testbench/lpp_lfr_filter_1/IIR_CEL_CTRLR_v2_1/IIR_CEL_CTRLR_v2_DATAFLOW_1/RAM_CTRLR_v2_1/memRAM/SRAM/axc/x0/a8to12/agen(0)/u0/u0/rp/rfd",
"abits":10,
"dbits":36,
"name":"RAM5.txt"
}
RAM6={
"instance":"/testbench/lpp_lfr_filter_1/cic_lfr_1/memRAM/SRAM/axc/x0/a8to12/agen(1)/u0/u0/rp/rfd",
"abits":10,
"dbits":36,
"name":"RAM6.txt"
}



RAMS=[RAM1,RAM2,RAM3,RAM4,RAM5,RAM6]







def mkram(length,width,gentype='rand',**kwargs):
    return toBinStr(gen(length,width,gentype,**kwargs),width)

def toBinStr(data,width):
    return [format(val, 'b').zfill(width) for val in data]

def gen(length,width,gentype='rand',**kwargs):
    LUT={
        "rand":gen_rand,
        "const":gen_const
    }
    return LUT[gentype](length,width,**kwargs)

def gen_rand(length,width,**kwargs):
    random.seed(time.time())
    mask=(2**width)-1
    data=[]
    for line in range(length):
        data.append(int(2**32*random.random())&mask)
    return data

def gen_const(length,width, value):
    mask=(2**width)-1
    return [value&mask for i in range(length)]

def save(data,file):
    f = open(file,"w")
    [f.write(line+'\n') for line in data]
    f.close()

if not os.path.exists("simulation"):
    os.mkdir('simulation')

args=""
for RAM in RAMS:
    save(mkram(2**RAM["abits"],RAM["dbits"],gentype='rand',value=0),""+RAM["name"])
    args = args +"mem load -i {RAMFILE} -format binary  {PATH}\n".format(RAMFILE=RAM["name"], PATH=RAM["instance"])
with open("run.do.in","r") as inFile, open("run.do","w") as outFile:
    input = inFile.read()
    outFile.write(input.replace("#RAM_INIT#",args))

W,H=8,400
test = np.ones((H,W))*[(random.random()*65535)-32768 for col in range(W)]
np.savetxt("input.txt", test,fmt="%d", delimiter=" ")
  
