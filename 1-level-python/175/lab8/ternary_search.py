def ternary_search(seq,key):
    left = 0 
    right = len(seq)-1
    found = False
    index1 = 0
    index2 = 0
    
    while (not found and left <= right):
        if left == right:
            found = True
            return left
        elif right - left > 0:
            index1 = (right + 2*left)//3
            index2 = (2*right + left)//3
            
            if key == seq[index1]:
                
                return index1
            elif key == seq[index2]:
                
                return index2
            else:
                if key < seq[index1]:
                    right = index1 - 1
                elif key > seq[index1] and key < seq[index2]:
                    right = index2 -1
                    left = index1 + 1
                elif key> seq[index2]:
                    left = index2 + 1
    if (not found):
        for i in range (len(seq)-1):
            if abs(data[i] - key) < abs(key - data[(right+left)//2]):
                finalindex = i
                
    return finalindex
            

    
def test():
    seq = []
    for i in range(1,1001):
        seq.append(i)
        
    for j in range(1,1001):
        is_pass = (ternary_search(seq,j)==j-1)
        print(ternary_search(seq,j))
        assert is_pass == True, "fail the test when key is %d"%j
    if is_pass == True:
        print("=========== Congratulations! Your have finished exercise 2! ============")
if __name__ == '__main__':
    test()
