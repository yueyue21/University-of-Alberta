import random
import time
from quick_sort import quick_sort
from bubble_sort import bubble_sort
list1 = []
input1=int(input('enter n:'))
for i in range(input1):
    list1.append(random.randint(1,100000000))
list2= list(list1)    
print(list2)
start= time.time()
quick_sort(list1)
end = time.time()
print('###quick_sort',end-start)

start = time.time()
bubble_sort(list2)
end = time.time()
print('###bubble_sort',end-start)
print(list2)