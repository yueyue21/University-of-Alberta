# CMPUT 175 Winter 2013 Lab 5 Exercise 3
# This file implements the Bounded Queue class and can be used to test the Queue.

class BoundedQueue:
    
    
    # Constructor, which creates a new empty queue, with user-specified capacity:
    def __init__(self, capacity):
        
        if capacity != int(capacity):
            raise Exception('')
            
        
        elif capacity < 0:
            raise Exception('')
        else:
            self.__items = []
            ma = capacity
            
        
        
        
        # TODO: You must implement this constructor!
        
        
    # Adds a new item to the back of the queue, and returns nothing:
    def enqueue(self, item):
        if self.is_full() is True:
            raise Exception(' ')
        else:
            self.__items.append(item)
        
            
        # TODO: You must implement this method!

        
    # Removes and returns the front-most item in the queue.  
    # Returns nothing if the queue is empty.
    def dequeue(self):
        if self.is_empty() is True:
            raise Exception('')
        else:
            self.__items.pop(0)
            
            
        # TODO: You must implement this method!
        
    # Returns the front-most item in the queue, and DOES NOT change the queue.  
    def peek(self):
        if self.is_empty():
            raise Exception
        else:
            return self.__items[0]
        # TODO: You must implement this method!

        
    # Returns True if the queue is empty, and False otherwise:
    def is_empty(self):
        if len(self.__items)==0:
            return True
        else:
            return False
        # TODO: You must implement this method!
    
    # Returns True if the queue is full, and False otherwise:
    def is_full(self):
        if len(self.__items)==3:
            return True
        else:
            return False
        # TODO: You must implement this method!
    
    # Returns the number of items in the queue:
    def size(self):
        return len(self.__items)
        # TODO: You must implement this method!
        
    # Returns the capacity of the queue:
    def capacity(self):
        return self.__init__()
        # TODO: You must implement this method!
    
    # Removes all items from the queue, and sets the size to 0.
    # clear() should not change the capacity
    def clear(self):
        self.__items=[]
        # TODO: You must implement this method!
        
    # Returns a string representation of the queue:
    def __str__(self):
        new = repr(''.join(self.__items))
        return new
        # TODO: You must implement this method!
        
        
panda=BoundedQueue(3)


# use this function to test your Bounded Queue implementation    
def test():
    is_pass = True

    try:
        string_queue = BoundedQueue('wrong type')
    except Exception as e:
        is_pass = True
    else:
        is_pass = False
    assert is_pass == True, "fail the test"
    
    try:
        string_queue = BoundedQueue(-1)
    except Exception as e:
        is_pass = True
    else:
        is_pass = False  
    assert is_pass == True, "fail the test" 
        
    string_queue = BoundedQueue(3)
    
    is_pass = (string_queue.size() == 0)
    assert is_pass == True, "fail the test"
    
    is_pass = (string_queue.capacity() == 3)
    assert is_pass == True, "fail the test" 
    
    is_pass = (string_queue.is_empty())
    assert is_pass == True, "fail the test"
    
    string_queue.enqueue("Hello")
    string_queue.enqueue("World")
    
    is_pass = (string_queue.size() == 2)
    assert is_pass == True, "fail the test"
    print(string_queue)
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
    
    string_queue.clear()
    
    is_pass = (string_queue.capacity() == 3)
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
    
    int_queue = BoundedQueue(2000)
    for i in range(0, 1000):
        int_queue.enqueue(i)      
    correctOrder = True
    for i in range(0, 200):
        if int_queue.dequeue() != i:
            correctOrder = False
            
    is_pass = correctOrder
    assert is_pass == True, "fail the test" 
    
    is_pass = (int_queue.size() == 800)
    assert is_pass == True, "fail the test" 
 
    is_pass = (int_queue.capacity() == 2000)
    assert is_pass == True, "fail the test"    

    is_pass = (int_queue.peek() == 200)
    assert is_pass == True, "fail the test"
    
    if is_pass == True:
        print ("=========== cong, your implementation passes the test ============")


#let's test it

test()
