m = eval(input("No1:"))
n = eval(input("No2:"))
def gcd(a,b):
        while True:
                if a==b:
                        return a        
                elif a>b:
                        a=a-b
                elif a<b:
                        b=b-a
        
   
print(gcd(m,n))