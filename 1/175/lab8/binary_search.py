def binary_search( data, key ):
    #TODO
    found = False
    low = 0
    high = len(data)-1
    
    while (not found and low<=high):
        guess = (high+low)//2
        if (key == data[guess]):
            found = True
        else:
            if (key < data[guess]):
                high = guess - 1
            else:
                low = guess + 1
    
    if (not found):
        for i in range(len(data)-1):
            if abs(data[i] - key) < abs(key - data[(high+low)//2]):
                guess = i
    return guess

def test():
    seq = []
    for i in range(1,1001):
        seq.append(i)
    for j in range(1,100):
        is_pass = (binary_search(seq,j)==j-1)
        assert is_pass == True, "fail the test when key is %d"%j
    try:
        is_pass = (binary_search(seq,-2)==0)
        assert is_pass == True, "fail the test when key is -2"
    except:
        print('Exception when key is -2')
    try:
        is_pass = (binary_search(seq,1002)==999)
        assert is_pass == True, "fail the test when key is 1002"
    except:
        print('fail the test when key is 1002')
    try:
        is_pass = (binary_search(seq,55.4)==54)
        assert is_pass == True, "fail the test when key is 55.4"
    except:
        assert False, 'fail the test when key is 55.4'
    try:
        is_pass = (binary_search(seq,55.5)==54 or binary_search(seq,55.5)==55)
        assert is_pass == True, "fail the test when key is 55.5"
    except:
        assert False, 'fail the test when key is 55.5'    
    if is_pass == True:
        print("=========== Congratulations! Your have finished exercise 1! ============")

if __name__ == '__main__':
    test()         
