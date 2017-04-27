class CircularQueue:
    
    def __init__(self, capacity):
        self._item = []
        
        for i in range(capacity):
            self._item.append(i)
        self.counter = 0
        self.head=0
        self.tail=0
        self.maxnum = capacity
            
    def enqueue(self, item):
        if self.is_full():
            raise Exception()
        else:
            if self.tail ==self.maxnum-1:
                self.tail = 0
                self._item[self.tail]=item
                self.counter +=1
            else:
                self._item[self.tail]=item
                self.tail+=1
                self.counter +=1
           
        
        
    def dequeue(self):
        if self.is_empty():
            raise Exception()
        else:
            if self.head == self.maxnum-1:
                self.head = 0
                self.counter = self.counter -1
            else:
                self.head += 1
                self.counter = self.counter -1
           
         
    def peek(self):
        if self.is_empty():
            raise Exception()
        else:
            print('peek',self._item)
            return self._item[self.head]
        
    def is_empty(self):
        if self.counter== 0:
            return True
        
    def is_full(self):
        if self.counter==self.maxnum:
            return True
        
    def size(self):
        return self.counter 
       
        
    def capacity(self):
        return self.maxnum
        
        
    def clear(self):
        self.head=0
        self.tail=0
        self.counter = 0 
        
    def __str__(self):
        if self.head <self.tail:
            ppp=''
            for i in range(len(self._item[self.head:self.tail])):
                if i == len(self._item[self.head:self.tail])-1:
                    ppp += str(self._item[self.head:self.tail][i])
                else:
                    ppp += (str(self._item[self.head:self.tail][i])+' ')
        elif self.head ==self.tail:
            ppp=''
        else:
            pp1=''
            for i in self._item[self.head:self.maxnum]:
                pp1+=(str(i)+' ')
            pp2=''
            for i in range(len(self._item[0:self.tail])):
                if i==len(self._item[0:self.tail])-1:
                    pp2+=str(self._item[0:self.tail][i])
                else:
                    pp2 +=(self._item[0:self.tail][i]+' ')
            ppp = pp1+pp2
            
        return ppp


# use this function to test your Circular Queue implementation    
def test():
  
    string_queue = CircularQueue(3)
    
    is_pass = (string_queue.size() == 0)
    assert is_pass == True, "fail the test"
    
    is_pass = (string_queue.capacity() == 3)
    assert is_pass == True, "fail the test" 
    
    is_pass = (string_queue.is_empty())
    assert is_pass == True, "fail the test"
    
    string_queue.enqueue("Hello")
    string_queue.enqueue("World")
    
    is_pass = (str(string_queue) == "Hello World")
    print(string_queue)
    assert is_pass == True, "fail the test"
    
    is_pass = (string_queue.size() == 2)
    assert is_pass == True, "fail the test"
    
    is_pass = (string_queue.peek() == "Hello")
    assert is_pass == True, "fail the test"

    is_pass = (string_queue.capacity() == 3)
    assert is_pass == True, "fail the test"
    
    is_pass = (string_queue.peek() == "Hello" and string_queue.size() == 2)
    assert is_pass == True, "fail the test"
 
    string_queue.enqueue("python")
    
    is_pass = (string_queue.is_full())
    assert is_pass == True, "fail the test"
        
    
    try:
        string_queue.enqueue("rules")
    except Exception as e:
        is_pass = True
    else:
        is_pass = False
    assert is_pass == True, "fail the test"
        
    string_queue.dequeue()
    is_pass = (string_queue.peek() == "World")
        
    assert is_pass == True, "fail the test" 
        
        
    string_queue.dequeue()
    is_pass = (string_queue.peek() == "python")
    
    assert is_pass == True, "fail the test"  

    string_queue.enqueue("apple")
    string_queue.enqueue("google") 
    string_queue.dequeue()
    is_pass = (string_queue.peek() == "apple")
    assert is_pass == True, "fail the test"
    
    string_queue.clear()
    
    is_pass = (string_queue.capacity() == 3)
    assert is_pass == True, "fail the test" 
    
    is_pass = (string_queue.size() == 0)
    assert is_pass == True, "fail the test"
    
    try:
        string_queue.dequeue()
    except Exception as e:
        is_pass = True
    else:
        is_pass = False
    assert is_pass == True, "fail the test" 
        
    try:
        string_queue.peek()
    except Exception as e:
        is_pass = True
    else:
        is_pass = False
    assert is_pass == True, "fail the test"
    
    int_queue2 = CircularQueue(10)
    
    for i in range(0, 10):
        int_queue2.enqueue(i)      
    int_queue2.dequeue()
    int_queue2.dequeue()
    int_queue2.dequeue()
    int_queue2.dequeue()
    is_pass = (str(int_queue2) == "4 5 6 7 8 9")
    assert is_pass == True, "fail the test"

    for i in range(11, 13):
        int_queue2.enqueue(i)
    is_pass = (str(int_queue2) == "4 5 6 7 8 9 11 12")
    assert is_pass == True, "fail the test"

    for i in range(21, 23):
        int_queue2.enqueue(i)
    is_pass = (str(int_queue2) == "4 5 6 7 8 9 11 12 21 22")
    assert is_pass == True, "fail the test"

    
    int_queue = CircularQueue(1000)
    
    is_pass = (int_queue.is_empty())
    assert is_pass == True, "fail the test"
    
    is_pass = (int_queue.is_full())
    assert is_pass == False, "fail the test"
    
    for i in range(0, 1000):
        int_queue.enqueue(i)      
    correctOrder = True
    
    is_pass = (int_queue.is_empty())
    assert is_pass == False, "fail the test"
    
    is_pass = (int_queue.is_full())
    assert is_pass == True, "fail the test"
    
    for i in range(0, 200):
        if int_queue.dequeue() != i:
            correctOrder = False
            
    is_pass = correctOrder
    assert is_pass == True, "fail the test" 
    
    is_pass = (int_queue.size() == 800)
    assert is_pass == True, "fail the test" 
 
    is_pass = (int_queue.capacity() == 1000)
    assert is_pass == True, "fail the test"    

    is_pass = (int_queue.peek() == 200)
    assert is_pass == True, "fail the test"
    
    for i in range(0, 200):
        int_queue.enqueue(i)      
    
    is_pass = (int_queue.is_empty())
    assert is_pass == False, "fail the test"
    
    is_pass = (int_queue.is_full())
    assert is_pass == True, "fail the test"
    
    is_pass = (int_queue.peek() == 200)
    assert is_pass == True, "fail the test"
    
    if is_pass == True:
        print ("=========== Congratulations! Your have finished exercise 1! ============")

if __name__ == '__main__':
    test()
