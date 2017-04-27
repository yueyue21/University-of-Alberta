p = int(input())
score=dict()
for i in range(p):
    a= str(input())
    t=a.split()
    name = t[0]
    mark = t[1]
    if mark in score:
        score[mark].append(name)
    else:
        score[mark]=[name]
        
            
    
        
   
u=list(score.keys())

u.sort(reverse= True)

for i in u:
    print(i,score[i])
    
    
    

    
    