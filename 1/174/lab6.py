x= str(input("enter the pattern"))

fin = open('words.txt')
def match_pattern(word,a):
    
    if len(word)==len(a):
        index = 0
        while index<len(a):
            if a[index]!='_' and a[index]!=word[index]:
                return False
            index = index +1
        return True  
for line in fin:
    word = line.strip()
    if match_pattern(word,x) == True:
        print(word)

                
                
            

    
    
    
    
    






  
