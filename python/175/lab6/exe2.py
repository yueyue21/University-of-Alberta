class BoundedQueue:
    
    def __init__(self, capacity):
        if type(capacity) != int or capacity < 0:
            raise Expection("capacity")
        self.queue = []
        self.count = 0
        self.max = capacity

    def enqueue(self, item):
        if self.count == self.max:
            raise Expection("queue is full")
        self.queue.append(item)
        self.count += 1

    def dequeue(self):       
        if self.count == 0:
            raise("empty!")      
        self.count -= 1
        return self.queue.pop(0)
        
    def peek(self):
        if self.count == 0:
            raise("empty!")
        return self.queue[0]

    def is_empty(self):
        return 0 == self.count 

    def is_full(self):
        return self.max == self.count

    def size(self):
        return self.count

    def capacity(self):
        return self.max

    def clear(self):
        self.queue = []
        self.count = 0
        
    def __str__(self):
        return " ".join(self.queue)
    


m=BoundedQueue(10)
#n=CircularQueue(10)
for i in range(5):
    m.enqueue(i)
    #n.enqueue(i)
    
import time
start = time.time()
# The program you want to test
m.dequeue()
end = time.time()
time_interval = end - start
print('BoundedQueue',time_interval)


start = time.time()
# The program you want to test
#n.dequeue
end = time.time()
time_interval = end - start

#print('CircularQueue',time_interval)
