from binary_search import binary_search
from sequential_search import sequential_search

import random

y = []
for i in range(1,1000):
    y.append(i)

times=0
    
import time
for i in range(10000):
    times=i
    x= random.randint(1,1000)
    a=0
    start = time.time()
    binary_search(y,x)
    end = time.time()
    time_interval = end - start
    a=time_interval+a

    b=0
    start = time.time()
    sequential_search(y,x)
    end = time.time()
    time_interval = end - start
    b=b+time_interval
    
print('bin',a)
print('seq',b)
