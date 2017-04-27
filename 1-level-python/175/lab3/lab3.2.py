n = int(input('prime'))

def check1():
         i = 3
         while i < n:
                  m= n%i
                  i = i+2
                  if m ==0:
                           return False
                  
         return True
def check2():
         k = 2
         while k < n:
                  m = n%k
                  k = k+2
                  if m==0:
                           return False 
         return True
if n == 1:
         print('false')
elif n ==2:
         print ('true')
elif n == 3:
         print ('true')
        


        

elif check1()==True and check2() == True:
         print('true')
    
else:
         print('false')


