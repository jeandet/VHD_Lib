import math              as m
import numpy             as np

def int2hex(n,nbits):
    if (nbits % 4) != 0 :
        return 'ERROR 1!'
    spec='0'+str(nbits/4)+'x'
    if n >= (-2**(nbits-1)) and n <= (2**(nbits-1)-1) :
        return format(n, spec) if n>=0 else format(2**nbits+n, spec)
    else :
        return 'ERROR 2!'



nb_point  = 256
t         = np.arange(nb_point)

## f0 
ampl_f0_0 = pow(2,16)-1
freq_f0_0 = float(16)/256
phi_f0_0  = 0

ampl_f0_1 = pow(2,15)-1
freq_f0_1 = float(16)/256
phi_f0_1  = 0

ampl_f0_2 = pow(2,14)-1
freq_f0_2 = float(16)/256
phi_f0_2  = 0

ampl_f0_3 = pow(2,13)-1
freq_f0_3 = float(16)/256
phi_f0_3  = 0

ampl_f0_4 = pow(2,10)-1
freq_f0_4 = float(16)/256
phi_f0_4  = 0

x_f0   	     = [ampl_f0_0 * np.cos(2 * m.pi * freq_f0_0 * t + phi_f0_0 * m.pi / 180 ) , 
				ampl_f0_1 * np.cos(2 * m.pi * freq_f0_1 * t + phi_f0_1 * m.pi / 180 ) ,
				ampl_f0_2 * np.cos(2 * m.pi * freq_f0_2 * t + phi_f0_2 * m.pi / 180 ) ,
				ampl_f0_3 * np.cos(2 * m.pi * freq_f0_3 * t + phi_f0_3 * m.pi / 180 ) ,
				ampl_f0_4 * np.cos(2 * m.pi * freq_f0_4 * t + phi_f0_4 * m.pi / 180 ) ]

# x_f0   	     = [ampl_f0_0 * np.cos(2 * m.pi * freq_f0_0 * t + phi_f0_0 * m.pi / 180 ) , 
# 				np.zeros(nb_point,dtype=np.int16) + 10 ,
# 				np.zeros(nb_point,dtype=np.int16) - 10 ,
# 				ampl_f0_3 * np.cos(2 * m.pi * freq_f0_3 * t + phi_f0_3 * m.pi / 180 ) ,
# 				ampl_f0_4 * np.cos(2 * m.pi * freq_f0_4 * t + phi_f0_4 * m.pi / 180 ) ]


x_f0_int16 = [np.zeros(nb_point,dtype=np.int16),
			  np.zeros(nb_point,dtype=np.int16),
			  np.zeros(nb_point,dtype=np.int16),
			  np.zeros(nb_point,dtype=np.int16),
			  np.zeros(nb_point,dtype=np.int16)]

for  j in xrange(5) :
	for  i in xrange(nb_point) :
		x_f0_int16[j][i] = int(round(x_f0[j][i]))

f = open("data_f0.txt", 'w')
for i in xrange(nb_point) :
	for  j in xrange(5) :
		f.write(int2hex(x_f0_int16[j][i],16))
	f.write('\n')
f.close

f = open("data_f1.txt", 'w')
for i in xrange(1) :
	for  j in xrange(5) :
		f.write(int2hex(0,16))
f.close

f = open("data_f2.txt", 'w')
for i in xrange(1) :
	for  j in xrange(5) :
		f.write(int2hex(0,16))
f.close
