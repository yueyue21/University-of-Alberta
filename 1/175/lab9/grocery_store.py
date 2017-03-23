from item import item
import random

def compare(item1, item2, attribute):
    if attribute == "price":
        a=int(item.get_price(item1))
        b=int(item.get_price(item2))
        if a>b:
            return 1
        elif a==b:
            return 0 
        else:
            return -1
    elif attribute == "quantity":
        a = int(item.get_quantity(item1))
        b = int(item.get_quantity(item2))
        if a>b:
            return 1
        elif a==b:
            return 0 
        else:
            return -1        
            
    
# complete this function

def quick_sort_goods(goods_list, attribute):
    quick_sort_helper(goods_list, 0, len(goods_list)-1, attribute)

# a recursive quick sort method
def quick_sort_helper(goods_list, first, last, attribute):
    if first < last:
        splitpoint = partition(goods_list, first, last, attribute)
        quick_sort_helper(goods_list, first,splitpoint-1, attribute)
        quick_sort_helper(goods_list, splitpoint+1, last, attribute)

# to partition the given list by 
# (1) picking the first int as the pivot value
# (2) re-arrange all integers accoding to the pivot value
def partition(goods_list, first, last, attribute):
    
    pivotvalue = goods_list[first].get_price()
    leftmark = first+1
    rightmark = last
    done = False
    while not done:
        while leftmark <= rightmark and \
              compare(goods_list[leftmark], goods_list[first], attribute) <= 0:
            leftmark = leftmark + 1
        while compare(goods_list[rightmark], goods_list[first], attribute) >= 0 and \
              rightmark >= leftmark:
                rightmark = rightmark -1
        if rightmark < leftmark:
            done = True
        else:
            # exchange items pointed by the 
            # leftmark and rightmarks
            temp = goods_list[leftmark]
            goods_list[leftmark] = goods_list[rightmark]
            goods_list[rightmark] = temp
    temp = goods_list[first]
    goods_list[first] = goods_list[rightmark]
    goods_list[rightmark] = temp
        
    return rightmark
        
        
#####################################################################




goods_list = []
for i in range(0, 10):
    goods_list.append(item("goods"+str(i), random.randint(1,100), random.randint(1,100)))
        
while True:
    
    print("1: Add a new item")
    print("2: Delete an existing item")
    print("3: Display goods information")
    print("4: Quit")

        
        
