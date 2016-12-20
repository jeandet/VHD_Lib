import os
import shutil
import datetime as dt
import glob

folder=dt.datetime.today().strftime("%Y-%m-%d_%H-%M-%S")
os.mkdir(folder)
shutil.copy("input.txt",folder+"/input.txt")
for file in glob.glob("output_f*.txt"):
    shutil.copy(file, folder)
    
for file in glob.glob("RAM*.txt"):
    shutil.copy(file, folder)
    
