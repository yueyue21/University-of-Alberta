# CMPUT 175 Winter 2013 Assignment 3 Table Tester
# This file has several functions for testing a Table implementation.  Any 
# problems that are found will be printed to the screen.  Note that passing all 
# the tests does not guarantee the Table implementation is correct: additional 
# testing should still be done.  This program DOES NOT test all Table methods, 
# and you should write additional code to do so.  As well, the import statement 
# immediately after this comment should be changed to point to the file with the 
# Table implementation.
from solution import Table
    
# Tests some of the Table's set_something() and get_something methods.  This 
# function works with empty tables.
def test_table_getters_and_setters():
    
    table = Table("example_name.dat")
    if table.get_type() != "data":
        print("Default Table type must be data.")

    try:
        table.get_attributes()
    except:
        a = 0 # This code does nothing, but is necessary for the except block
    else:
        print("get_attributes() must raise an exception when no attributes are set.")
    
    table.set_attributes(["col1", "col2", "col3"])
    if table.get_attributes() != ["col1", "col2", "col3"]:
        print("Attributes not set correctly.")
    
    table.set_key("col1")
    if table.get_key() != "col1":
        print("Key not set correctly.") 
    
    try:
        table.set_key("non_existant_attribute")
    except:
        a = 0 # This code does nothing, but is necessary for the except block
    else:
        print("set_key() must raise an exception when key is not an attribute.")
    
    table.set_type("configuration")
    if table.get_attributes() != ["table_name", "degree", "list_of_attributes"]:
        print("Attributes not set correctly for 'configuration' type.")
    
    try:
        table.set_attributes(["incorrect_col1", "incorrect_col2", "incorrect_col3"])
    except:
        a = 0 # This code does nothing, but is necessary for the except block
    else:
        print("set_attributes() must raise an exception when wrong attributes are set for 'configuration' type.") 

# Tests some functionality of the Table's append(), sequential_search(), and 
# key_search() methods.  Data will be added to a table, and then searched.  This 
# function assumes that your Table implementation fully passes 
# test_table_getters_and_setters().  If it does not, there may be errors running 
# this method.
def test_table_data_and_search():
    table = Table("data_table.dat")
    table.set_attributes(["name", "age", "weight"])
    table.set_key("name")
    
    table.append(["Abe Simons", "48", "176"])
    table.append(["Billy Kidd", "17", "145"])
    table.append(["Emily Smith", "22", "138"])
    table.append(["Carla Cree", "34", "215"])
    table.append(["David Johnson", "71", "165"])
    table.append(["Katherine Diaz", "32", "144"])
    table.append(["Frank Small", "29", "129"])
    table.append(["George Sorenson", "16", "188"])
    table.append(["Lenny Peterson", "19", "201"])
    table.append(["Heidi Thomson", "55", "133"])
    table.append(["Iggy Bat", "61", "153"])
    table.append(["Jules Rory", "25", "167"])
    
    sequential_search_correct = True   
    if table.sequential_search("first") != ["Abe Simons", "48", "176"]:
        sequential_search_correct = False
    if table.sequential_search("last") != ["Jules Rory", "25", "167"]:
        sequential_search_correct = False
    if table.sequential_search("prev") != ["Iggy Bat", "61", "153"]:
        sequential_search_correct = False
    if table.sequential_search("next") != ["Jules Rory", "25", "167"]:
        sequential_search_correct = False
    if not sequential_search_correct:
        print("Sequential search does not work correctly.")
        
    if table.key_search("Nobody") != None:
        print("Key search must return None when key does not exist in Table.")
    if table.key_search("George Sorenson") != ["George Sorenson", "16", "188"]:
        print("Key search must return row when key does exist in Table.")
    if table.sequential_search("prev") != ["Frank Small", "29", "129"]:
        print("Current pointer not set correctly after key search.")
    
# Tests some functionality of the Table's populate_initial_data() and 
# load_one_document() methods.  Various files will be read in.  This function 
# assumes that your Table implementation fully passes 
# test_table_getters_and_setters() and test_table_data_and_search().  If it does 
# not, there may be errors running this method.
def test_table_file_operations():
    table = Table("person_data.dat")
    table.set_attributes(["name", "age", "weight"])
    table.set_key("name")
    
    try:
        table.populate_initial_data("person_data_four_col.txt", "++++", "\n")
    except:
        a = 0 # This code does nothing, but is necessary for the except block
    else:
        print("populate_initial_data() must raise an exception when input file has incorrect format.")
    
    table.populate_initial_data("person_data_three_col.txt", "++++", "\n")
    if table.get_size() != 12:
        print("Table size not correct after populating initial data.")
    if table.sequential_search("first") != ["Abe Simons", "48", "176"]:
        print("First row of Table after populating initial data is incorrect.")
    if table.sequential_search("last") != ["Jules Rory", "25", "167"]:
        print("Last row of Table after populating initial data is incorrect.")
        
    table = Table("inverted_index_table.dat")
    table.set_type("inverted_index")
    table.load_one_document("story.txt", "101")
    if table.get_size() != 347:
        print("Table size incorrect after loading one document.")
    if table.sequential_search("first") != ["the", "101"]:
        print("First row of Table is incorrect after loading one document.")
    if table.key_search("darigan") != ["darigan", "101"]:
        print("Table is missing key(s) after loading one document.")

# Runs all three tests on the Table implementation, and then prints
def complete_table_test():
    test_table_getters_and_setters()
    test_table_data_and_search()
    test_table_file_operations()
    print("    ----------    ALL TESTS COMPLETE    ----------    ")
    
complete_table_test()