from d_linked_list import *
import random

def test_sort_integer():
    integer_list = d_linked_list()
    
    for i in range(1000):
        data = random.randint(1, 1000)
        integer_list.append(data)
    print(integer_list)
    #print(integer_list)
      
    integer_list.sort()
    print('      ')
    print(integer_list)
    #print(integer_list)
    
    prev_data = integer_list.pop(0)
    cur_data = integer_list.pop(0)
    
    while integer_list.get_size() > 0:
        assert cur_data >= prev_data, 'error: linked list is not sorted'
        
        prev_data = cur_data
        cur_data = integer_list.pop(0)
        
    print('========== cong ==================')

if __name__ == '__main__':
    test_sort_integer()



