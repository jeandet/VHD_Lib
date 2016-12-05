import numpy as np
import random

W,H=8,10000
low,high=-100,100
INPUT_F=98304
test = np.random.randint(low=low,high=high,size=(H,W))
test *= 0

test=np.stack(( +1.*(20000.*np.sin(np.arange(len(test)) *2.*np.pi * 3. /INPUT_F  )).astype(int) ,
                 -1.*(20000.*np.sin(np.arange(len(test)) *2.*np.pi * 3. /INPUT_F  )).astype(int) ,
                 +1.*(20000.*np.sin(np.arange(len(test)) *2.*np.pi * 3. /INPUT_F  )).astype(int) ,
                 -1.*(20000.*np.sin(np.arange(len(test)) *2.*np.pi * 3. /INPUT_F  )).astype(int) ,
                 +1.*(20000.*np.sin(np.arange(len(test)) *2.*np.pi * 3. /INPUT_F  )).astype(int) ,
                 -1.*(20000.*np.sin(np.arange(len(test)) *2.*np.pi * 3. /INPUT_F  )).astype(int) ,
                 +1.*(20000.*np.sin(np.arange(len(test)) *2.*np.pi * 3. /INPUT_F  )).astype(int) ,
                 -1.*(20000.*np.sin(np.arange(len(test)) *2.*np.pi * 3. /INPUT_F  )).astype(int))).transpose()

np.savetxt("input.txt", test,fmt="%d", delimiter=" ")



  
