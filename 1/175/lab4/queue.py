# CMPUT 175 Winter 2013 Lab 4 Exercise 1
# This file implements the Queue class and can be used to test the Queue.

class Queue:
    
    # Constructor, which creates a new empty queue:
    def __init__(self):
        self.__items = []
        # TODO: You must implement this constructor!
        
    # Adds a new item to the back of the queue, and returns nothing:
    def queue(self, item):
        self.__items.append(item)
        # TODO: You must implement this method!
        
    # Removes and returns the front-most item in the queue.  
    # Returns nothing if the queue is empty.
    def dequeue(self):
        if len(self.__items)!=0:
            return self.__items.pop(0)
        # TODO: You must implement this method!
        
    # Returns the front-most item in the queue, and DOES NOT change the queue.  
    def peek(self):
        if len(self.__items)!=0:
            return self.__items[0]
        
        # TODO: You must implement this method!
        
    # Returns True if the queue is empty, and False otherwise:
    def is_empty(self):
        if len(self.__items) == 0:
            return True
        else:
            return False
        # TODO: You must implement this method!
    
    # Returns the number of items in the queue:
    def size(self):
        return len(self.__items)
        # TODO: You must implement this method!
    
    # Removes all items from thq queue, and sets the size to 0:
    def clear(self):
        self.__items=[]
        # TODO: You must implement this method!
        
    # Returns a string representation of the queue:
    def __str__(self):
        new = repr(''.join(self.__items))
        return new
            
            
        # TODO: You must implement this method!
    
    
    
# Main function, which can be used to test your queue implementation:
def main():
    string_queue = Queue()
    int_queue = Queue()
    print("Initial size of empty Queue is zero:", int_queue.size() == 0)
    print("is_empty() works correctly:", int_queue.is_empty())
    
    string_queue.queue("Hello")
    string_queue.queue("World")
    print("Queue size updates after adding items:", string_queue.size() == 2)
    print("Queue keeps correct ordering:", string_queue.peek() == "Hello")
    print("peek() does not change Queue:", string_queue.peek() == "Hello" 
          and string_queue.size() == 2)
    print("String representation of queue:", string_queue)
    
    string_queue.clear()
    print("peek() returns nothing when Queue is empty:", 
          string_queue.peek() == None)
    print("clear() sets size to 0:", string_queue.size() == 0)
    print("dequeue() returns nothing when Queue is empty:", 
          string_queue.dequeue() == None)
    
    for i in range(0, 1000):
        int_queue.queue(i)      
    correctOrder = True
    for i in range(0, 200):
        if int_queue.dequeue() != i:
            correctOrder = False
    print("Queue keeps correct ordering using dequeue():", correctOrder)
    print("Queue size updates after removing items:", int_queue.size() == 800)
    print("peek() works correctly after dequeue():", int_queue.peek() == 200)    

main()
