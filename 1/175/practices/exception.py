import math
anumber = 23
if anumber <0:
    raise RuntimeError("you can't use a negative number")
else:
    print(math.sqrt(anumber))
    
def squareroot(n):
    root = n/2  #initial guess will be half of n
    for k in range(20):
        root = (1/2)*(root + (n/root))
        
    return root
print(squareroot(9))
print(squareroot(23))