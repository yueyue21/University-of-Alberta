file1 = input('enter the file name:')
fin = open(file1,'r')
count1=0
count2=0
count3=0
count4=0
count5=0
count6=0
for line in fin:
        a= list(line)
        for i in a:
                if i =='[':
                        count1=count1+1
                elif i==']':
                        count2=count2+1
                elif i=='{':
                        count3=count3+1
                elif i== '}':
                        count4= count4+1
                elif i== '(':
                        count5= count5+1
                elif i == ')':
                        count6= count6+1
            
if count1==count2:
        print('[] pairs:',count2)
        print('All [] matched.')
elif count1<count2:
        print('[] pairs:',count1)
        print('Not all [] matched.')
else:
        print('[] pairs:',count2)
        print('Not all [] matched.')
        
if count3==count4:
        print('{} pairs:',count2)
        print('All {} matched.')
elif count3<count4:
        print('{} pairs:',count3)
        print('Not all {} matched.')
else:
        print('{} pairs:',count4)
        print('Not all {} matched.')
        
        
if count5==count6:
        print('() pairs:',count5)
        print('All () matched.')
elif count5<count6:
        print('() pairs:',count5)
        print('Not all () matched.')
else:
        print('() pairs:',count6)
        print('Not all () matched.')
            
    
    
