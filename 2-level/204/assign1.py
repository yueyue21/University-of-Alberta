import random
a = []
index = 0
n = random.randint(0,1000)
x = random.randint(0,n-1)       #x would be max number when it is terminated
y = random.randint(0,n-1)       #y would be min number when it is terminated
#initialize two prameters(x >= y)
if x < y:
    x = y   
# make a shuffled list,which contain n items
for i in range(n):
    a.append(i)
random.shuffle(a)
#here is the algorithm. 
counter = 0
#the counter is supposed to be less than 3n/2
def find():
    global counter
    global index
    global x
    global y
    if counter >= 1.5*n:
        print("the number of comparison is more than 1.5n.")
        print("total number of comparision:",counter)
        return counter
    elif index == n:
        print("the finding algorithm is over.")
        print("the largest number is:",x)
        print("the smallest number is:",y)
        print("total number of comparision:",counter)
        return
#comparision part
    else:
        if y >= a[index]:               #number<= y <= x
            y = a[index]
            counter = counter + 1
            index = index + 1
            find()
        elif y < a[index]:              #y < number
            counter =counter + 1            
            if x < a[index]:            #y <= x < number
                x = a[index]
                counter = counter +  1
                index = index + 1
                find()
            elif x >= a[index]:         #y < number <= x
                x = x
                counter = counter + 1
                index = index + 1
                find()
find()



        