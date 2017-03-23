import wordplay
import random
try:
    fin=open('pride1.txt','r')

except:
    print('file does not exist')
    exit()

m=wordplay.all_anagrams()
n=wordplay.all_homophones()
p=wordplay.invert_dict(n)
for i in range(20):
    line=fin.readline()
    line=line.strip()
    word=line.split(' ')
    for i in word:
        sign=wordplay.signature(i)
        pron=wordplay.pronunciation(i,n)
        if pron in p and len(p[pron])>1:
            u = random.choice(p[pron])
        elif sign in m and len(m[sign])>1:
            u = random.choice(m[sign])
        else:
            u=wordplay.random_swap(i)
        print(u,end=' ')
    print()                 
                
            
        
fin.close