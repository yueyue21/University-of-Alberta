from d_linked_node import d_linked_node

class d_linked_list:
    
    def __init__(self):
        self.__head=None
        self.__tail=None
        self.__size=0        

            
    def search(self, item):
        current = self.__head
        found = False
        while current != None and not found:
            if current.getData() == item:
                found= True
            else:
                current = current.getNext()
        return found
        
    def index(self, item):
        current = self.__head
        found = False
        index = 0
        while current != None and not found:
            if current.getData() == item:
                found= True
            else:
                current = current.getNext()
                index = index + 1
        if not found:
                index = -1
        return index        
         
    def add(self, item):
        temp= d_linked_node(item,None,None)   
        temp.setNext(self.__head)
        self.__head = temp
        
        self.__size=self.__size+1
        
    def remove(self, item):
        current = self.__head
        previous= None
        found = False
        while not found:
            if current.getData()==item:
                found = Ture
            else:
                previous = current
                current = current.getNext()
        
        if previous == None:
            self.head = current.getNext()
        else:
            previous.setNext(current.getNext())
        self.__size=self.__size-1
            
        
    def append(self, item):
        temp = d_linked_node(item, None,None)
        if self.__head== None:
            self.__head==temp
        else:
            current = self.__head
            while(current.getNext()!=None):
                currten=current.getNext()
            current.setNext(temp)
        self.__size+=1
        
    def insert(self, pos, item):
        current = self.__head
        found = False
        index = 0 
        while current!= None and not found:
            if current.getData() == item:
                found = True
            else:
                current = current.getNext()
                index = index + 1
        if not found:
            index = index - 1
        return index
        
    def pop1(self):
        current = self.__head
        previous = None
        while (current.getNext!=None):
            previous = current.getData()
            current = current.getNext()
        if (previous == None):          #for only 1 item in the list
            self.__head == None
        else:
            previous.setNext(None)
        return current.getNext()   
         
    def pop(self, pos):
        current = self.__head
        previous = None
        index = 0 
        while index != pos:
            previous = current.getData()
            current = current.getNext()
        previous.setNext(current.getNext())
        self.__size -=1
        
        
    def search_larger(self, item):
        current = self.__head
        index = 0
        while current !=None:
            if item >= current:
                current = current.getNext()
                if index < self.__size-1:
                    index +=1
                else:
                    index = -1
            elif item < current:
                return index +1
        return index      
        
        
    def get_size(self):
        return self.__size  
    
    def get_item(self, pos):
        if pos <0:
            if abs(pos)>self.__size:
                raise Exception
            else:
                current = self.__tail
                index1= -1
                while index1 >= pos:
                    index1 -=1
                    current = current.getPrevious()
                return current
        else:
            if pos>self.__size-1:
                raise Exception
            else:
                current = self.__head
                index2 = 0
                while index2 <=pos:
                    current = current.getNext()
                    index2 +=1
                return current
                
        
        
    def __str__(self):
        current= self.__head
        s=''
        index = 0
        while current!=None:
            if index == 0:
                s = s+str(current.getData())
            else:
                s = s + ' '+str(current.getData())
            current=current.getNext()
            
        
        return s

def test():
                  
    linked_list = d_linked_list()
                    
    is_pass = (linked_list.get_size() == 0)
    assert is_pass == True, "fail the test"
            
    linked_list.add("World")
    linked_list.add("Hello")    
    
    print(linked_list)
    is_pass = (str(linked_list) == "Hello World")
    assert is_pass == True, "fail the test"
              
    is_pass = (linked_list.get_size() == 2)
    assert is_pass == True, "fail the test"
            
    is_pass = (linked_list.get_item(0) == "Hello")
    assert is_pass == True, "fail the test"
        
        
    is_pass = (linked_list.get_item(1) == "World")
    assert is_pass == True, "fail the test"    
            
    is_pass = (linked_list.get_item(0) == "Hello" and linked_list.get_size() == 2)
    assert is_pass == True, "fail the test"
            
    is_pass = (linked_list.pop(1) == "World")
    assert is_pass == True, "fail the test"     
            
    is_pass = (linked_list.pop1() == "Hello")
    assert is_pass == True, "fail the test"     
            
    is_pass = (linked_list.get_size() == 0)
    assert is_pass == True, "fail the test" 
                    
    int_list2 = d_linked_list()
                    
    for i in range(0, 10):
        int_list2.add(i)      
    int_list2.remove(1)
    int_list2.remove(3)
    int_list2.remove(2)
    int_list2.remove(0)
    is_pass = (str(int_list2) == "9 8 7 6 5 4")
    assert is_pass == True, "fail the test"
                
    for i in range(11, 13):
        int_list2.append(i)
    is_pass = (str(int_list2) == "9 8 7 6 5 4 11 12")
    assert is_pass == True, "fail the test"
                
    for i in range(21, 23):
        int_list2.insert(0,i)
    is_pass = (str(int_list2) == "22 21 9 8 7 6 5 4 11 12")
    assert is_pass == True, "fail the test"
                
    is_pass = (int_list2.get_size() == 10)
    assert is_pass == True, "fail the test"    
                    
    int_list = d_linked_list()
                    
    is_pass = (int_list.get_size() == 0)
    assert is_pass == True, "fail the test"
                    
        
                    
    for i in range(0, 1000):
        int_list.append(i)      
    correctOrder = True
            
    is_pass = (int_list.get_size() == 1000)
    assert is_pass == True, "fail the test"            
            
        
    for i in range(0, 200):
        if int_list.pop1() != 999 - i:
            correctOrder = False
                            
    is_pass = correctOrder
    assert is_pass == True, "fail the test" 
            
    is_pass = (int_list.search_larger(200) == 201)
    assert is_pass == True, "fail the test" 
            
    int_list.insert(7,801)   
        
    is_pass = (int_list.search_larger(800) == 7)
    assert is_pass == True, "fail the test"
            
            
    is_pass = (int_list.get_item(-1) == 799)
    assert is_pass == True, "fail the test"
            
    is_pass = (int_list.get_item(-4) == 796)
    assert is_pass == True, "fail the test"
                    
    if is_pass == True:
        print ("=========== Congratulations! Your have finished exercise 1! ============")
                
if __name__ == '__main__':
    test()