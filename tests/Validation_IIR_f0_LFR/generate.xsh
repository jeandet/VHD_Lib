#!/usr/bin/xonsh

import numpy as np
import random

W,H=8,1000
test = np.ones((H,W))*[(random.random()*65535)-32768 for col in range(W)]
np.savetxt("input.txt", test,fmt="%d", delimiter=" ")
  
