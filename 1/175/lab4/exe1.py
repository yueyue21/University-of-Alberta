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

q= Queue()

def main():
    input1= input('Add, Serve, or Exit:')
    if input1 == 'Serve' :
        if q.is_empty() == True:
            print('The lineup is already empty.')
            main()
        else:
            print(q.peek(),'has been served.')
            q.dequeue()
            main()
    elif input1 =='Add':
        if q.size()==3:
            print('You cannot add more people, the lineup is full!')
            main()
        else:
            input2=input('Enter the name of the person to add:')
            q.queue(input2)
            main()
    elif input1 == 'Exit':
        return
    

main()    
        
        
