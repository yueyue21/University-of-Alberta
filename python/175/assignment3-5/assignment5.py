from assignment4 import Table
a='----------------------------  Welcome to MyDB 175 -------------------------------'
b='(1)  Create an initial database'
c='(2)  Create a list of tables for your application'
d='(3)  Access a table in the database'
e='(4)  Load documents into the search engine'
f='(5)  Search documents from the search engine'
g='(6)  Quit'
h='---------------------------------------------------------------------------------'
k = '----------------------------  Please try again -------------------------------'

def create_initial_database():
   table = Table('con.dat')
   table.set_type('configuration')
   table.save()
   
    
def create_a_list_of_tables():
   return

def access_table():
   table_name = input('Enter a table name:')
   table= Table(table_name+'.dat')
   table.load()
   print("---------------------------  to access the table table_name   ------------------------------------")
   print('(1)  Retrieve one row by the given key value')
   print('(2)  Retrieve all the rows by  the given value of an attribute')
   print('(3)  Retrieve all the rows')
   print('(4)  Retrieve the top n rows')
   print('(5)  Retrieve the bottom n rows')
   print('(6)  Insert one row')
   print('(7)  Delete one row by its key value')
   print('(8)  Populate initial data for the table')
   print('(9)  Return to the main menu')
   print(h)
   enter2 = input('Enter your choice:')
   if enter2 not in ['1','2','3','4','5','6']:
      input2()
   elif enter2 == '1':
      give_key=input('Enter the key you want to search:')
      print(table.key_search(give_key))
   elif enter2 == '2':
      give_attr=input('Enter an attribute:')
      give_value= input('Enter a value:')
      #table.
      
   

def load_docs():
   doc_location=input('Enter document location:')
   title= input('Enter the title of the document:')
   table.load_one_document(doc_location, title)
   choice=input(' Do you want to enter another document (y/n):')
   if choice == 'y':
      load_docs()
   else:
      input2()
   #update the invert index

def search_docs():
   give_key_word=input('enter a key word:')

def input2():
   print(a)
   print(b)
   print(c)
   print(d)
   print(e)
   print(f)
   print(g)
   print(h)
   enter1 = input('enter your choice:')
   if enter1 not in ['1','2','3','4','5','6']:
      input2()
   elif enter1 == '1':
      create_initial_database()
   elif enter1 == '2':
      create_a_list_of_tables()
   elif enter1=='3':
      access_table()
   elif enter1 == '4':
      load_docs()
   elif enter1 == '5':
      search_docs()
   elif enter1 == '6':
      return

def input1():
   j = 0
   while True:
      if j == 0:
         print(a)
         name = input('Enter user name:')
         password = input('Enter password:')
         table = Table(name+'.dat')
         table.set_type("configuration")         
         try:
            table.load()
         except:
            print('This is a new account')
            input2()         
      elif 0<j<3:  
         print(k)
         j = j+1
         name = input('Enter user name:')
         password = input('Enter password:')
         table = Table(name+'.dat')
         table.set_type("configuration")
         try:
            table.load()
            table.get_key()
         except:
            ok=1 # does not mean any thing
         
      if j == 3:
         return


input1()


