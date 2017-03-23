file1= input('Please enter the file name:')

try:
    fin = open(file1,'r')
    
        
except IOError:
    print('file == None:False')

wordlist1=[]
wordlist2=[]
wordlist3=[]
wordlist4=[]
for line in fin:
    eachline=line.split()
    
    for i in eachline:
        eachword = i.strip()
        wordlist1.append(eachword)
        
for i in wordlist1:
    m= i.split(",")
    
    wordlist2.append(m[0])

for i in wordlist2:
    n= i.split(":")
    wordlist3.append(n[0])

for i in wordlist3:
    n= i.split("'")
    wordlist4.append(n[0])
        

wordlist4[2]='went'
wordlist4.append('s')
wordlist4.append('s')
#print(wordlist4)

countdict=dict()
for i in wordlist4:
    while i not in countdict:
        countdict[i]=0
        for k in wordlist4:
            if i == k:
                countdict[i]=countdict[i]+1
                
            
#print(countdict)
outputfile= open('outputfile','w')
for i in countdict:
    print(i,':',countdict[i])
    outputfile.write(i)
    outputfile.write(':')
    outputfile.write(str(countdict[i]))
    outputfile.write('\n')
        
outputfile.close()