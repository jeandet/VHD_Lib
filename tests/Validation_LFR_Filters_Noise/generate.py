import numpy as np
import random

W,H=8,6000000
low,high=-100,100
INPUT_F=98304
test = np.random.randint(low=low,high=high,size=(H,W))
test+=np.tile((3.*np.cos(np.arange(len(test)) *2.*np.pi * 3. /INPUT_F  )).astype(int),(8,1)).transpose()
test+=np.tile((3.*np.cos(np.arange(len(test)) *2.*np.pi * 16. /INPUT_F  )).astype(int),(8,1)).transpose()
test+=np.tile((3.*np.cos(np.arange(len(test)) *2.*np.pi * 256. /INPUT_F  )).astype(int),(8,1)).transpose()
test+=np.tile((3.*np.cos(np.arange(len(test)) *2.*np.pi * 2048. /INPUT_F  )).astype(int),(8,1)).transpose()
np.savetxt("input.txt", test,fmt="%d", delimiter=" ")

