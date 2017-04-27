wordlist=['The','quick','brown','fox','jumps','over','a','lazy','dog']
a= str(input('Enter a letter:',))
m=[]
n=[]
for i in range(len(wordlist)):
                                                
                                                if a in wordlist[i]:
                                                                                                m.append(wordlist[i])
                                                else:
                                                                                                n.append(wordlist[i])
                                                                                               
                                                
      
print (m)
print(n)





