def factors(o):
    factors=[]
    for i in range(o):
        if o%(i+1)==0:
            factors.append(i+1)
    return factors

   
def num():
    for i in range(100):
        
        a= i+1
        l.append((len(factors(a)),a))
    return l
l=[]
num()
l.sort(reverse=True)
res=[]
for length,a in l:
    res.append(a)
    
print(res)
    