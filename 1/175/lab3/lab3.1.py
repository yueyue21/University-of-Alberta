file = input('Please enter file name:')
fin = open(file,'r')
line1=fin.readline()
m=line1.split()
m[0]=m[0][1:]
opp=[]
print('The attributes of the data are:',line1)
def input1():
    attr = str(input('Enter requested attributes:'))
    n=attr.split()
    for i in n:
        if i not in m:
            print('There is no attribute called Gender, please enter again')
            return input1()
    for k in fin:                     
        eachline=k.split()
        for i in n:
                position = m.index(i)
                context = eachline[position]
                sublist = []
                sublist.append(context)
                opp.append(sublist)
input1()

outputfile = input('Please enter a file name to store the new data:')

output = open(outputfile,'w')
for i in opp:
    for k in i:
        output.write(k)
    output.write('\n')

output.close()
    
print('The data has been saved, please check',outputfile)
        