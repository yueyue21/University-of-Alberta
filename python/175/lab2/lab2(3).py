import random
num=random.randint(1,20)
print(num)
count = 0
while (count<6):
    a = int(input('Enter a guess (1-20):'))
    if a >20 or a<1:
        print ('That number is not between 1 and 20!')
        
    elif a == num:
        print('Correct! The number was',num)
        break 
    elif a > num:
        print('too high')
        count = count+1
        
    elif a < num:
        print('too low')
        count = count +1
    
print('You are out of guesses. The number was',num,'.')

