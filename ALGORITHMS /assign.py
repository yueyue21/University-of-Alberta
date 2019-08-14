import random
a = []
small = []
big = []
index = 0
n = random.randint(0,1000)
# make a shuffled list,which contain n items
for i in range(n):
    a.append(i)
random.shuffle(a)
#n is even
if n % 2 == 0:
    for i in range(int(len(a)/2)):
        if a[i]<a[int(i+len(a)/2)]:
            big.append(a[int(i+len(a)/2)])
            small.append(a[i])
        elif a[i]>a[int(i+len(a)/2)]:
            big.append(a[i])
            small.append(a[int(i+len(a)/2)])
            # up here # of comparision  = n/2
    # this step contain n/2 - 1 comparisions
    maxNumber = max(big)
    # this step contain n/2 - 1 comparisions
    minNumber = min(small)
    # DONE: that is 3n/2 - 2 steps in total

#n is odd, take n-1.
else:
    for i in range(int((len(a)-1)/2)):
        if a[i]<a[int(i+(len(a)-1)/2)]:
            big.append(a[int(i+(len(a)-1)/2)])
            small.append(a[i])
        elif a[i]>a[int(i+(len(a)-1)/2)]:
            big.append(a[i])
            small.append(a[int(i+(len(a)-1)/2)])  
            # up here # of comparision = (n-1)/2
            # this step contain (n-1)/2 - 1 comparisions
            maxNumber = max(big)
            # this step contain (n-1)/2 - 1 comparisions
            minNumber = min(small) 
    # we need at more 2 steps to compare the last element
    #with minNumber and maxNumber
    # DONE: that is 3(n-1)/2 - 2 + 2 == 3(n-1)/2 steps in total at most
    
# OVER ALL total steps is less than 3n/2

