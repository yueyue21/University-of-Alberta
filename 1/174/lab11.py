import os
fout = open('output.txt','w')
cmd=''
while cmd!="exit":
    cmd=str(input())
    
    fp=os.popen(cmd)
    lin=fp.read()
    print(lin)
    fout.write(lin)
    fp.close()
    

fout.close() 