from d_linked_list import *
import random

def test_sort_by_attr(attr):
    item_list = d_linked_list()
    
    for i in range(10):
        name = 'goods' + str(i)
        price = random.randint(0, 1000)
        quantity = random.randint(1, 100)
        
        good = item(name, price, quantity)
        
        item_list.append(good)
    
    print(item_list)
    
    item_list.sort_by_attr(attr)
    
    print(item_list)
    
    prev_data = item_list.pop(0)
    cur_data = item_list.pop(0)
    
    while item_list.get_size() > 0:
        if attr == 'price':
            assert cur_data.get_price() >= prev_data.get_price(), \
            'error: linked list is not sorted by price'
        elif attr == 'quantity':
            assert cur_data.get_quantity() >= prev_data.get_quantity(), \
            'error: linked list is not sorted by quantity' 
        else:
            raise Exception('illegal attribute')           
        
        prev_data = cur_data
        cur_data = item_list.pop(0)
        
    print('========== cong on ' + attr + ' ==================')

def test_sort():
    test_sort_by_attr('price')
    test_sort_by_attr('quantity')

if __name__ == '__main__':
    test_sort()



