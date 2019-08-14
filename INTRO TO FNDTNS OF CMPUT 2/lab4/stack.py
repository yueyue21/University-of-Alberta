# CMPUT 175 Winter 2013 Lab 4 Exercise 3
# A Stack implementation

class Stack:
    
    def __init__(self):
        self.__items = []
        
    def push(self, item):
        self.__items.append(item)
        
    def pop(self):
        return self.__items.pop()
    
    def peek(self):
        return self.__items[len(self.__items)-1]
    
    def is_empty(self):
        return len(self.__items) == 0
    
    def size(self):
        return len(self.__items)
s = Stack()

a = input('enter a string:')

i = 0
while i < len(a):
    s.push(a[i])
    i = i +1
k = 0
m = []
while k < len(a):
    m.append(s.peek())
    s.pop()
    k = k+1
for r in m:
    print(r,end = '')




