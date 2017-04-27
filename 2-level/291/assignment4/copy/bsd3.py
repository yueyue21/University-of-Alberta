# Berkeley DB Example

__author__ = "Bing Xu"
__email__ = "bx3@ualberta.ca"

import bsddb3 as bsddb
from ctypes import cdll
import os
import time
import datetime
lib = cdll.LoadLibrary('./libfoo.so')
fin=open("answers","w")
fin1=open("runtime","w")
# Make sure you run "mkdir /tmp/my_db" first!
DA_FILE = "/tmp/my_db/sample_db"
INVERSE_DA_FILE = "/tmp/my_db/inverse_sample_db"
DB_SIZE = 100000
SEED = 10000000

# you cannot open  by btree method with there is an existing hash database. error occurred. also inversed.
# make the btree become in to the index, exchanged
def main():

    initial_choice=input("=====welcome========\n1.btree\n2.hash \n3.indexfile\n4.exit\n====================\nYour choice:")
    if initial_choice == '3':
        return btree_interface()
    elif initial_choice == '2':
        return hash_interface()
    elif initial_choice == '1':
        return index_interface()
    elif initial_choice == '4':
        fin.close()
        fin1.close()
        return 
    else:
        return main()
#-------------this is index an inversed----------------------------------------------------------------------------------------
def btree():
    global db
    global inverse_db    
    try:
        db = bsddb.btopen(DA_FILE, "w")
        inverse_db=bsddb.btopen(INVERSE_DA_FILE, "w")
    except:
        print("DB doesn't exist, creating a new one")
        inverse_db=bsddb.btopen(DA_FILE, "c")
        db = bsddb.btopen(INVERSE_DA_FILE, "c")
    counter =0
    lib.set_seed(SEED)
    for index in range(DB_SIZE):
        krng = 64 + lib.get_random() % 64
        key = ""
        for i in range(krng):
            key += str(chr(lib.get_random_char()))
        vrng = 64 + lib.get_random() % 64
        value = ""
        for i in range(vrng):
            value += str(chr(lib.get_random_char()))
        print(key)
        print(value)
        print("")
        key = key.encode(encoding='UTF-8')
        value = value.encode(encoding='UTF-8')
        if db.has_key(key):
            pass
        else:
            db[key] = value
            counter+=1
                
        if inverse_db.has_key(value):
            original_key=inverse_db[value].decode(encoding='UTF-8')
            key=key.decode(encoding='UTF-8')
            if key!=original_key:
                key=original_key+':'+key
                key=key.encode(encoding='UTF-8')
                inverse_db[value]=key
        else:
            inverse_db[value]=key
    print(counter,' records created------------------------')
    try:
        db.close()
        inverse_db.close()
    except Exception as e:
        print(e)    
        
def bt_key_search():
    temp_key=str(input("Please enter your key:"))
    temp_data=''
    try:
        db = bsddb.btopen(DA_FILE, "r")
    except:
        print("Open method and file type does not match,delete current and make a btre then come back!")
        return main()
    temp_key = temp_key.encode(encoding='UTF-8')
    try:
        start=time.time()
        temp_data=db[temp_key]
        end=time.time()
        temp_key = temp_key.decode(encoding='UTF-8')
        temp_data = temp_data.decode(encoding='UTF-8')
        time_used=end- start
        time_used*=1000000
        print('KEY:')
        fin.write(temp_key+'\n')
        print(temp_key)
        fin.write(temp_data+'\n\n')
        print('DATA:')
        print(temp_data)
        print('')        
        print(time_used,'micro seconds used')
        db.close()
    except:
        print('Key does not exist,go to main')
        db.close()
        return btree_interface()
    
def bt_data_search():
    temp_data=str(input("Please enter your data:"))
    temp_key=''
    try:
        inverse_db = bsddb.btopen(INVERSE_DA_FILE,"r")
    except:
        print("Open method and file type does not match,delete current and make a btre then come back!")
        return main()
    temp_data = temp_data.encode(encoding='UTF-8')
    if True:
        start=time.time()
        temp_key = inverse_db[temp_data]
        end=time.time()
        temp_key = temp_key.decode(encoding='UTF-8')
        temp_data = temp_data.decode(encoding='UTF-8')
        time_used=end- start
        time_used*=1000000
        print('KEY:')
        temp_key=temp_key.split(':')
        print(temp_key)
        for keys in temp_key:
            fin.write(keys+'\n')
            fin.write(temp_data+'\n\n')
        print('DATA:')
        print(temp_data)
        print('')
        print(time_used,'micro seconds used')
        inverse_db.close()
    else:
        print('Data does not exist, go to main')
        inverse_db.close()
        return btree_interface()
def bt_range_search():
    try:
        db = bsddb.btopen(DA_FILE, "r")
    except:
        print("Open method and file type does not match,delete current and make a btre then come back!")
        return main()
    upper=str(input("Enter your upper key:"))
    lower=str(input("Enter your lower key:"))
    if upper < lower:
        print("Upper lessthan lower, go to main")
        return main()
    elif upper == lower:
        temp_key = lower
        temp_data = ''
        temp_key = temp_key.encode(encoding='UTF-8')
        try:
            start=time.time()
            temp_data=db[temp_key]
            end=time.time()
            temp_key = temp_key.decode(encoding='UTF-8')
            temp_data = temp_data.decode(encoding='UTF-8')
            time_used=end- start
            time_used*=1000000
            print('Equal bounds\nKEY:')
            fin.write(temp_key+'\n')
            print(temp_key)
            print('DATA:')
            fin.write(temp_data+'\n\n')
            print(temp_data)
            print('')
            print(time_used,'micro seconds used')
            db.close()
        except:
            print('Key does not exist,go to main')
            db.close()
            return btree_interface() 
    else:
        lower=lower.encode(encoding='UTF-8')
        upper=upper.encode(encoding='UTF-8')
        counter = 0
        try:
            start=time.time()
            for key,data in db.items():
                if key<=upper and key >= lower:
                    counter+=1
                    print("KEY:\n"+key.decode(encoding='UTF-8')+"\nDATA:\n"+data.decode(encoding='UTF-8')+"\n")
                    fin.write(key.decode(encoding='UTF-8')+'\n')
                    fin.write(data.decode(encoding='UTF-8')+"\n\n")
            end=time.time()
            time_used=end- start
            time_used*=1000000
            print(counter," records displayed")
            print(time_used,"micro seconds used")
        except:
            print('Key does not exist,go to main')
            db.close()
            return btree_interface()

        
def btree_interface():
    m='-'
    for i in range(50):
        m=m+'-'
    print(m) 
    choice=str(input("ADVANVED INDEX MAIN MENU:\n1. Create and populate the database\n2. Retrieve records with a given key\n3. Retrieve records with a given data\n4. Retrieve records with a given range of key values\n5. Destroy the database\n6. Go back\nEnter your choice:"))
    print(m)
    if choice == '1':
        btree()
        return btree_interface()
    elif choice =='2':
        bt_key_search()
        return btree_interface()
    elif choice == '3':
        bt_data_search()
        return btree_interface()
    elif choice == '4':
        bt_range_search()
        return btree_interface()    
    elif choice == '5':
        os.system("rm /tmp/my_db/sample_db")
        os.system("rm /tmp/my_db/inverse_sample_db")
        print("Database(btree) removed")
        return btree_interface()
    elif choice == '6':
        return main()
    else:
        print("Wrong input, try again!")
        return btree_interface()
#--------------------------------------------------------------------------------------
def hash1():
    global db    
    try:
        db = bsddb.hashopen(DA_FILE, "w")
    except:
        print("DB doesn't exist, creating a new one")
        inverse_db=bsddb.hashopen(DA_FILE, "c")
    lib.set_seed(SEED)
    counter = 0
    for index in range(DB_SIZE):
        krng = 64 + lib.get_random() % 64
        key = ""
        for i in range(krng):
            key += str(chr(lib.get_random_char()))
        vrng = 64 + lib.get_random() % 64
        value = ""
        for i in range(vrng):
            value += str(chr(lib.get_random_char()))
        print(key)
        print(value)
        print("")
        key = key.encode(encoding='UTF-8')
        value = value.encode(encoding='UTF-8')
        if db.has_key(key):
            pass
        else:
            db[key] = value
            counter+=1
    print(counter,' records created------------------------')
    try:
        db.close()
    except Exception as e:
        print(e)    

def hash_key_search():
    temp_key=str(input("Please enter your key:"))
    temp_data=''
    try:
        db = bsddb.hashopen(DA_FILE, "r")
    except:
        print("Open method and file type does not match,delete current make a hash one then come back!")
        return main()
    temp_key = temp_key.encode(encoding='UTF-8')
    try:
        start=time.time()
        temp_data=db[temp_key]
        end=time.time()
        temp_key = temp_key.decode(encoding='UTF-8')
        temp_data = temp_data.decode(encoding='UTF-8')
        time_used=end- start
        time_used*=1000000
        print('KEY:')
        fin.write(temp_key+'\n')
        print(temp_key)
        print('DATA:')
        fin.write(temp_data+'\n\n')
        print(temp_data)
        print('')
        print(time_used,'micro seconds used')
        db.close()
    except:
        print('Key does not exist,go to main')
        db.close()
        return hash_interface()
    
def hash_data_search():
    temp_data=str(input("Please enter your data:"))
    temp_key=''
    try:
        db = bsddb.hashopen(DA_FILE ,"r")
    except:
        print("Open method and file type does not match,delete current make a hash one then come back!")
        return main()
    temp_data = temp_data.encode(encoding='UTF-8')
    try:
        start=time.time()
        for temp_key in db.keys():
            if db[temp_key] ==temp_data:
                print('KEY:\n'+temp_key.decode(encoding='UTF-8'))
                fin.write(temp_key.decode(encoding='UTF-8')+'\n')
                fin.write(temp_data.decode(encoding='UTF-8')+'\n\n')
                print('DATA:\n'+temp_data.decode(encoding='UTF-8')+'\n')
        end=time.time()
        time_used=(end-start)
        time_used*=1000000
        print(time_used,'micro seconds used')
        db.close()
    except:
        print('Data does not exist, go to main')
        db.close()
        return hash_interface()
def hash_range_search():
    try:
        db = bsddb.hashopen(DA_FILE, "r")
    except:
        print("Open method and file type does not match,delete current and make a btre then come back!")
        return main()
    upper=str(input("Enter your upper key:"))
    lower=str(input("Enter your lower key:"))
    if upper < lower:
        print("Upper lessthan lower, go to main")
        return main()
    elif upper == lower:
        temp_key = lower
        temp_data = ''
        temp_key = temp_key.encode(encoding='UTF-8')
        try:
            start=time.time()
            temp_data=db[temp_key]
            end=time.time()
            temp_key = temp_key.decode(encoding='UTF-8')
            temp_data = temp_data.decode(encoding='UTF-8')
            time_used=end- start
            time_used*=1000000
            print('Equal bounds\nKEY:')
            fin.write(temp_key+'\n')
            print(temp_key)
            print('DATA:')
            fin.write(temp_data+'\n\n')
            print(temp_data)
            print('')
            print(time_used,'micro seconds used')
            db.close()
        except:
            print('Key does not exist,go to main')
            db.close()
            return hash_interface() 
    else:
        lower=lower.encode(encoding='UTF-8')
        upper=upper.encode(encoding='UTF-8')
        counter=0
        try:
            encoded_key_list=list(db)
            start=time.time()
            encoded_key_list.sort()
            for key in encoded_key_list:
                if key<=upper and key >= lower:
                    counter+=1
                    print("KEY:\n"+key.decode(encoding='UTF-8')+"\nDATA:\n"+db[key].decode(encoding='UTF-8')+"\n")
                    fin.write(key.decode(encoding='UTF-8')+'\n')
                    fin.write(db[key].decode(encoding='UTF-8')+'\n\n')
            end=time.time()
            time_used=end- start
            time_used*=1000000
            print(counter," records displayed")
            print(time_used, "micro seconds used")
        except:
            print('Key does not exist,go to main')
            db.close()
            return hash_interface()
    
def hash_interface():
    m='-'
    for i in range(50):
        m=m+'-'
    print(m)    
    choice=str(input("HASH MAIN MENU:\n1. Create and populate the database\n2. Retrieve records with a given key\n3. Retrieve records with a given data\n4. Retrieve records with a given range of key values\n5. Destroy the database\n6. Go back\nEnter your choice:"))
    print(m)
    if choice == '1':
        hash1()
        return hash_interface()
    elif choice == '2':
        hash_key_search()
        return hash_interface()
    elif choice == '3':
        hash_data_search()
        return hash_interface()
    elif choice == '4':
        hash_range_search()
        return hash_interface()    
    elif choice == '5':
        os.system("rm /tmp/my_db/sample_db")
        print('Database(hash) destoryed')
        return hash_interface()
    elif choice == '6':
        return main()
    else:
        print("Wrong input, try again!")
        return hash_interface()
#-----------this is btree under--------------------------------------------------

def index():
    global db    
    try:
        db = bsddb.btopen(DA_FILE, "w")
    except:
        print("DB doesn't exist, creating a new one")
        db=bsddb.btopen(DA_FILE, "c")
    
    lib.set_seed(SEED)
    counter =0
    for index in range(DB_SIZE):
        krng = 64 + lib.get_random() % 64
        key = ""
        for i in range(krng):
            key += str(chr(lib.get_random_char()))
        vrng = 64 + lib.get_random() % 64
        value = ""
        for i in range(vrng):
            value += str(chr(lib.get_random_char()))
        print(key)
        print(value)
        print("")
        key = key.encode(encoding='UTF-8')
        value = value.encode(encoding='UTF-8')
        if db.has_key(key):
            pass
        else:
            db[key] = value
            counter+=1
    print(counter,' records created------------------------')            
    try:
        db.close()
    except Exception as e:
        print(e)    
        
def index_key_search():
    temp_key=str(input("Please enter your key:"))
    temp_data=''
    try:
        db = bsddb.btopen(DA_FILE, "r")
    except:
        print("Open method and file type does not match,delete current and make a btre then come back!")
        return main()
    temp_key = temp_key.encode(encoding='UTF-8')
    try:
        start=time.time()
        temp_data=db[temp_key]
        end=time.time()
        temp_key = temp_key.decode(encoding='UTF-8')
        temp_data = temp_data.decode(encoding='UTF-8')
        time_used=end- start
        time_used*=1000000
        print('KEY:')
        fin.write(temp_key+'\n')
        print(temp_key)
        print('DATA:')
        fin.write(temp_data+'\n\n')
        print(temp_data)
        print('')
        print(time_used,'micro seconds used')
        db.close()
    except:
        print('Key does not exist,go to main')
        db.close()
        return index_interface()
    
def index_data_search():
    temp_data=str(input("Please enter your data:"))
    temp_key=''
    try:
        db = bsddb.btopen(DA_FILE,"r")
    except:
        print("Open method and file type does not match,delete current and make a btre then come back!")
        return main()
    temp_data = temp_data.encode(encoding='UTF-8')
    try:
        start=time.time()
        for temp_key in db.keys():
            if db[temp_key]==temp_data:
                print('KEY:\n'+temp_key.decode(encoding='UTF-8'))
                fin.write(temp_key.decode(encoding='UTF-8')+'\n')
                print('DATA:\n'+temp_data.decode(encoding='UTF-8')+'\n')
                fin.write(temp_data.decode(encoding='UTF-8')+'\n\n')
        end=time.time()
        time_used=end- start
        time_used*=1000000
        print(time_used,'micro seconds used')
        db.close()
    except:
        print('Data does not exist, go to main')
        db.close()
        return index_interface()
def index_range_search():
    try:
        db = bsddb.btopen(DA_FILE, "r")
    except:
        print("Open method and file type does not match,delete current and make a btre then come back!")
        return main()
    upper=str(input("Enter your upper key:"))
    lower=str(input("Enter your lower key:"))
    if upper < lower:
        print("Upper lessthan lower, go to main")
        return main()
    elif upper == lower:
        temp_key = lower
        temp_data = ''
        temp_key = temp_key.encode(encoding='UTF-8')
        try:
            start=time.time()
            temp_data=db[temp_key]
            end=time.time()
            temp_key = temp_key.decode(encoding='UTF-8')
            temp_data = temp_data.decode(encoding='UTF-8')
            time_used=end- start
            time_used*=1000000
            print('Equal bounds\nKEY:')
            fin.write(temp_key+'\n')
            print(temp_key+'\n')
            print('DATA:')
            fin.write(temp_data+'\n\n')
            print(temp_data)
            print('')
            print(time_used,'micro seconds used')
            db.close()
        except:
            print('Key does not exist,go to main')
            db.close()
            return index_interface() 
    else:
        lower=lower.encode(encoding='UTF-8')
        upper=upper.encode(encoding='UTF-8')
        counter = 0
        try:
            start=time.time()
            for key,data in db.items():
                if key<=upper and key >= lower:
                    counter+=1
                    print("KEY:\n"+key.decode(encoding='UTF-8')+"\nDATA:\n"+data.decode(encoding='UTF-8')+"\n")
                    fin.write(key.decode(encoding='UTF-8')+'\n')
                    fin.write(data.decode(encoding='UTF-8')+"\n\n")
            end=time.time()
            time_used=end- start
            print(counter," records displayed")
            time_used*=1000000
            print(time_used,"micro seconds used")
        except:
            print('Key does not exist,go to main')
            db.close()
            return index_interface()

        
def index_interface():
    m='-'
    for i in range(50):
        m=m+'-'
    print(m) 
    choice=str(input("BTREE MAIN MENU:\n1. Create and populate the database\n2. Retrieve records with a given key\n3. Retrieve records with a given data\n4. Retrieve records with a given range of key values\n5. Destroy the database\n6. Go back\nEnter your choice:"))
    print(m)
    if choice == '1':
        index()
        return index_interface()
    elif choice =='2':
        index_key_search()
        return index_interface()
    elif choice == '3':
        index_data_search()
        return index_interface()
    elif choice == '4':
        index_range_search()
        return index_interface()    
    elif choice == '5':
        os.system("rm /tmp/my_db/sample_db")
        print("Database(btree) removed")
        return index_interface()
    elif choice == '6':
        return main()
    else:
        print("Wrong input, try again!")
        return index_interface()
    

if __name__ == "__main__":
    main()
    