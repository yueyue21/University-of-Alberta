from d_linked_node import d_linked_node
from item import item

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
        temp = d_linked_node(item,None,None)
        if (self.__tail == None):
            self.__head = temp
            self.__size += 1            
            self.__tail = temp
        else:
            temp.setNext(self.__head)            
            self.__head.setPrevious(temp)
            self.__head = temp
            self.__size += 1
        
    def remove(self, item):
        if (self.search(item)):
            inde = self.index(item)
            self.__size -= 1
            temp = self.__head
            if (inde == 0):
                self.__head = temp.getNext()
                if(self.__head == None):
                    self.__tail = None
                else:
                    self.__head.setPrevious(None)
            else:
                for i in range(inde):
                    temp = temp.getNext()
                a = temp.getPrevious()
                a.setNext(temp.getNext())
                if (a.getNext() == None):
                    self.__tail = a
                else:
                    a.getNext().setPrevious(a)
        
    def append(self, item):
        if self.__size == 0:
            self.add(item)
        else:
            self.__size +=1
            temp = d_linked_node(item,None,self.__tail)
            self.__tail.setNext(temp)
            self.__tail = temp
        
    def insert(self, pos, item):
        temp = self.__head
        temp_in = d_linked_node(item,None,None)
        for i in range(pos):
            temp = temp.getNext()        
        if (pos == 0):
            temp_in.setNext(self.__head)
            self.__head = temp_in
            if (self.__size == 0):
                self.__tail = temp_in
            else:
                temp_in.getNext().setPrevious(temp_in)
            self.__size +=1
        else:
            if (temp == None):
                temp_in.setPrevious(self.__tail)
                self.__tail.setNext(temp_in)
                self.__tail=temp_in
            else:
                temp_in.setNext(temp)
                temp.getPrevious().setNext(temp_in)
                temp_in.setPrevious(temp.getPrevious())
                temp.setPrevious(temp_in)
            self.__size +=1
      
        
    def pop1(self):
        temp = self.__tail
        if (self.__size < 2):
            self.__head = None
            self.__tail = None
            self.__size = 0
        else:            
            temp.getPrevious().setNext(None)
            self.__tail = temp.getPrevious()
            self.__size -= 1          
        return temp.getData()
        
    def pop(self, pos):
        self.__size -= 1
        temp = self.__head
        if (pos == 0):
            self.__head = temp.getNext()
            if(self.__head == None):
                self.__tail = None
            else:
                self.__head.setPrevious(None)
            return temp.getData()
        else:
            for i in range(pos):
                temp = temp.getNext()
            a = temp.getPrevious()
            a.setNext(temp.getNext())
            if (a.getNext() == None):
                self.__tail = a
            else:
                a.getNext().setPrevious(a)
            return temp.getData()
        
    def search_larger(self, item):
        temp = self.__head
        a = 0
        while temp != None:
            if (temp.getData() > item):
                break
            temp = temp.getNext()
            a +=1
        if(temp == None):
            return -1
        return a
        
    def get_size(self):
        return self.__size    
    
    def get_item(self, pos):
        if (pos < 0):
            if (pos < -self.__size):
                raise Exception("pos doesn't exist")
            temp = self.__tail
            for i in range(pos,-1):
                temp = temp.getPrevious()
            return temp.getData()
        else:
            if (pos >= self.__size):
                raise Exception("pos doesn't exist")
            temp = self.__head
            for i in range(0,pos):
                temp = temp.getNext()     
            return temp.getData()
 
    #you need to implement the sort by using selection sort to sort a list of integers
    def sort(self):
        
        for i in range(self.__size-1,0,-1):
            #print(i)
            posimax=0
            maxitem = self.__head.getData()
            temp = self.__head
            temp = temp.getNext()
            for m in range(i,0,-1):
                #print(temp.getData())
                if (temp.getData() > maxitem):
                    maxitem = temp.getData()
                temp = temp.getNext()
            
            
            templast=self.get_item(i)
            
            #print(i,'   ',self.__str__())
            posimax = self.index(maxitem)
            self.pop(i)
            
            self.insert(i,maxitem)
            self.pop(posimax)
            self.insert(posimax,templast)
            
    #you need to implement the sort by using selection sort to sort a list of items
    #sort by the specified attribute, either "price" or "quantity"
    def sort_by_attr(self, attr):
        if attr == 'price':
            for i in range(self.__size-1,0,-1):
            #print(i)
                posimax=0
                maxitem = self.__head.getData().get_price()
                maxitemnode = self.__head.getData()
                #print(maxitem)
                
                temp = self.__head
                temp = temp.getNext()
                for m in range(i,0,-1):
                #print(temp.getData())
                    if (temp.getData().get_price() > maxitem):
                        maxitem = temp.getData().get_price()
                        maxitemnode = temp.getData()
                    temp = temp.getNext()
            
            
                templast=self.get_item(i)
            
            #print(i,'   ',self.__str__())
                posimax = self.index(maxitemnode)
                self.pop(i)
            
                self.insert(i,maxitemnode)
                self.pop(posimax)
                self.insert(posimax,templast)
        else:
            for i in range(self.__size-1,0,-1):
            #print(i)
                posimax=0
                maxitem = self.__head.getData().get_quantity()
                maxitemnode = self.__head.getData()
                #print(maxitem)
                
                temp = self.__head
                temp = temp.getNext()
                for m in range(i,0,-1):
                #print(temp.getData())
                    if (temp.getData().get_quantity() > maxitem):
                        maxitem = temp.getData().get_quantity()
                        maxitemnode = temp.getData()
                    temp = temp.getNext()
            
            
                templast=self.get_item(i)
            
            #print(i,'   ',self.__str__())
                posimax = self.index(maxitemnode)
                self.pop(i)
            
                self.insert(i,maxitemnode)
                self.pop(posimax)
                self.insert(posimax,templast)            
        
    def __str__(self):
        temp = self.__head
        pr = ""
        while (temp != None):
            pr = pr + str(temp.getData()) + " "
            temp = temp.getNext()
        pr = pr[:-1]
        return pr

def test():
          
    linked_list = d_linked_list()
            
    is_pass = (linked_list.get_size() == 0)
    assert is_pass == True, "fail the test"
    
    linked_list.add("World")
    linked_list.add("Hello")    
    
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
