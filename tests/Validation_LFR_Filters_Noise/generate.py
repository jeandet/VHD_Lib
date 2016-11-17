import numpy as np
import random

W,H=8,100000
low,high=-1000,1000
test = np.random.randint(low=low,high=high,size=(H,W))
np.savetxt("input.txt", test,fmt="%d", delimiter=" ")

