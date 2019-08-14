# CMPUT 175 Winter 2013 Assignment 3 Solution
# Implementation of the abstract data type Table, which stores an arbitrary 
# number of rows, each of which is defined by a set number of columns.  One
# column is the key column, and each row must have a unique key in the Table.
class Table:
    
    # Static variables for table types:
    CONFIGURATION_TYPE = "configuration"
    DATA_TYPE = "data"
    INVERTED_INDEX_TYPE = "inverted_index"
    
    # Static variables for table attributes and keys:
    CONFIGURATION_ATTRIBUTES = ["table_name", "degree", "list_of_attributes"]
    CONFIGURATION_KEY = CONFIGURATION_ATTRIBUTES[0]
    INVERTED_INDEX_ATTRIBUTES = ["word", "list_of_document_ids"]
    INVERTED_INDEX_KEY = INVERTED_INDEX_ATTRIBUTES[0]
    
    # Static variables for sequential search flags:
    FLAG_NEXT = "next"
    FLAG_PREV = "prev"
    FLAG_FIRST = "first"
    FLAG_LAST = "last"
    
    # Static variables for reading and writing files:
    FILE_HEADER = "zjullion_table_file_header\n"
    FIELD_SEPARATOR = ":::::"
    RECORD_SEPARATOR = "_:|:_\n"
    
    # Static varible for parsing words from documents:
    WORD_CHARACTERS = "abcdefghijklmnopqrstuvwxyz0123456789"
     
    # Constructor.  Initializes the Table type to 'data' by default, the file 
    # name to table_name, and does not set any attributes.  
    def __init__(self, table_name):
        self.__type = Table.DATA_TYPE
        self.__file_name = table_name
        self.__attributes = []
        self.__rows = []
        self.__key = None
        self.__current_pointer = None
        
    # Private method that raises an exception if the Table is not empty.  Used
    # by all set_something methods.
    def __check_if_not_empty(self):
        if len(self.__rows) != 0:
            raise Exception("Table is not empty.")
        
    # Private method that returns the index of the key column in the list of
    # attributes.  Raises an exception if no attributes have been set.
    def __get_key_index(self):
        if len(self.__attributes) == 0:
            raise Exception("No attributes set for this table.")
        return self.__attributes.index(self.__key)
       
    # Sets the Table to be 'data', 'configuration', or 'inverted_index' type,
    # and also sets the list of attributes and key accordingly.  Raises an
    # exception if the Table is not empty.
    def set_type(self, type):
        self.__check_if_not_empty()
        self.__type = type
        
        if self.__type == Table.CONFIGURATION_TYPE:
            self.__attributes = Table.CONFIGURATION_ATTRIBUTES
            self.__key = Table.CONFIGURATION_KEY
            
        elif self.__type == Table.INVERTED_INDEX_TYPE:
            self.__attributes = Table.INVERTED_INDEX_ATTRIBUTES
            self.__key = Table.INVERTED_INDEX_KEY
        
    # Sets the file name.  Raises an exception if the Table is not empty.
    def set_file_name(self, file_name):
        self.__check_if_not_empty()
        self.__file_name = file_name
        
    # Sets the attributes list.  Raises an exception if the attribute list
    # conflicts with the Table type, or if the Table is not empty.
    def set_attributes(self, list_of_attributes):
        self.__check_if_not_empty()
        
        if self.__type == Table.DATA_TYPE:
            self.__attributes = list_of_attributes
            self.__key = self.__attributes[0]
            
        elif self.__type == Table.CONFIGURATION_TYPE:
            if list_of_attributes != Table.CONFIGURATION_ATTRIBUTES:
                raise Exception("Attributes do not match table type.")
            
        elif self.__type == Table.INVERTED_INDEX_TYPE:
            if list_of_attributes != Table.INVERTED_INDEX_ATTRIBUTES:
                raise Exception("Attributes do not match table type.")
            
    # Sets the key, which must be one of the attributes.  Raises an exception if
    # the key conflicts with the Table type, or if the key is not an attribute,
    # of if the Table is not empty.
    def set_key(self, key):
        self.__check_if_not_empty()        
        
        if self.__type == Table.DATA_TYPE:
            if key not in self.__attributes:
                raise Exception("Key is not an attribute.")
            self.__key = key
            
        elif self.__type == Table.CONFIGURATION_TYPE:
            if key != Table.CONFIGURATION_KEY:
                raise Exception("Key does not match table type.")
            
        elif self.__type == Table.INVERTED_INDEX_TYPE:
            if key != Table.INVERTED_INDEX_KEY:
                raise Exception("Key does not match table type.")
            
    # Returns the Table type.
    def get_type(self):
        return self.__type
    
    # Returns the number of degrees (attributes).  Raises an exception if no 
    # attributes have been set.
    def get_degree(self):
        self.__get_key_index()
        return len(self.__attributes)
    
    # Returns the file name.
    def get_file_name(self):
        return self.__file_name
    
    # Returns the list of attributes.  Raises an exception if no attributes have
    # been set.
    def get_attributes(self):
        self.__get_key_index()
        return self.__attributes
    
    # Returns the key.    Raises an exception if no attributes have been set.
    def get_key(self):
        self.__get_key_index()
        return self.__key
    
    # Returns the Table size.
    def get_size(self):
        return len(self.__rows)
    
    # Loads Table data from file, overwriting any data currently in the Table.
    # Raises an exception if the file was not saved by this Table implementation,
    # or if the data is in an incorrect format.
    def load(self):
        if self.__type == Table.DATA_TYPE:
            file = open("data/" + self.__file_name, "r")
        elif self.__type == Table.CONFIGURATION_TYPE:
            file = open("config/" + self.__file_name, "r")
        elif self.__type == Table.INVERTED_INDEX_TYPE:
            file = open("inverted/" + self.__file_name, "r")
            
        file_contents = file.read()
        temp_rows = []
        
        if file_contents[0 : len(Table.FILE_HEADER)] != Table.FILE_HEADER:
            raise Exception("File was not saved by Table implementation.")    
        file_contents = file_contents[len(Table.FILE_HEADER) : ]
        
        rows = file_contents.split(Table.RECORD_SEPARATOR)
        rows.pop(-1)
        for row in rows:
            columns = row.split(Table.FIELD_SEPARATOR)
            columns.pop(-1)
            if len(columns) != len(self.__attributes):
                raise Exception("File data is not in the correct format.")
            temp_rows.append(columns)
                
        file.close()
        self.__rows = temp_rows
        if len(self.__rows) != 0:
            self.__current_pointer = 0
        else:
            self.__current_pointer = None        
        
    # Writes the current Table data to file.
    def save(self):
        if self.__type == Table.DATA_TYPE:
            file = open("data/" + self.__file_name, "w")
        elif self.__type == Table.CONFIGURATION_TYPE:
            file = open("config/" + self.__file_name, "w")
        elif self.__type == Table.INVERTED_INDEX_TYPE:
            file = open("inverted/" + self.__file_name, "w")            
            
        file.write(Table.FILE_HEADER)
        for row in self.__rows:
            for column in row:
                file.write(str(column) + Table.FIELD_SEPARATOR)
            file.write(Table.RECORD_SEPARATOR)
        
        file.close()
        
    # Adds the row given to the list of rows in the Table.  Raises an exception
    # if the row is in an incorrect format, or if another row already exists in
    # the Table with the same key.
    def append(self, row):
        if len(row) != len(self.__attributes):
            raise Exception("Row has incorrect number of attributes.")
        key_index = self.__get_key_index()
        
        #use binary search to check if the row already exists in the table
        insert_position = self.binary_search(row[key_index]) 
        if insert_position >=0 and insert_position < len(self.__rows):
            if self.compare(self.__rows[insert_position][key_index], row[key_index]) == 0:
                raise Exception("A row with that key already exists.")
        
        self.__rows.insert(insert_position, row)
        
        if self.__current_pointer == None:
            self.__current_pointer = 0
        
    # Updates the current pointer of the Table, and returns the row at the
    # current pointer.  Returns None if the Table is empty, if the "prev" flag
    # is given when current pointer is at the first row, or if the "next" flag
    # is given when current pointer is at the last row.
    def sequential_search(self, flags):
        if self.__current_pointer == None:
            return None
        
        if flags == Table.FLAG_FIRST:
            self.__current_pointer = 0
        elif flags == Table.FLAG_LAST:
            self.__current_pointer = len(self.__rows)-1
        elif flags == Table.FLAG_PREV:
            if self.__current_pointer == 0:
                return None
            else:
                self.__current_pointer-=1
        elif flags == Table.FLAG_NEXT:
            if self.__current_pointer == len(self.__rows)-1:
                return None
            else:
                self.__current_pointer+=1
            
        return self.__rows[self.__current_pointer]
        
    # Returns the row with the given key in the Table, or None if no such row
    # exists.  If the row does exists, the current pointer is moved to it.
    def key_search(self, key):
        key_index = self.__get_key_index()
        
        #use binary search to find corresponding row
        match_position = self.binary_search(key)
        if match_position >= 0 and match_position < len(self.__rows):
            if self.compare(self.__rows[match_position][key_index], key) == 0:
                self.__current_pointer = match_position
                return self.__rows[match_position]
            
        return None
    
    #compare left_opr with right_opr 
    #return 1 if left_str > right_str, -1 if left_str < right_str, 
    #0 if left_str = right_str.
    #recognize that if both strings are integer strings, say s1, and s2, 
    #then it returns int(s1) < int(s2) otherwise returns s1 < s2.
    #parameter 'left_str': left string
    #parameter 'right_str': right string
    def compare(self, left_str, right_str):
        if left_str.isdigit() and right_str.isdigit():
            left_num = int(left_str)
            right_num = int(right_str)
            
            if left_num > right_num:
                return 1
            elif left_num < right_num:
                return -1
            else:
                return 0    
        else:
            if left_str > right_str:
                return 1
            elif left_str < right_str:
                return -1
            else:
                return 0
    
    #Binary search in sorted rows, use key to find matched row
    #if found, return the index of the matched row
    #if not found, return the index of the first row that is bigger than key 
    def binary_search(self, key):
        #empty rows, return 0
        if len(self.__rows) == 0:
            return 0
        
        #cannot find match, and the key is bigger than any of these rows
        #return n
        key_index = self.__get_key_index()
        if self.compare(self.__rows[len(self.__rows)-1][key_index], key) < 0:
            return len(self.__rows)
        
        #divide and conquer 
        beg_index = 0
        end_index = len(self.__rows) - 1
        
        mid_index = (beg_index + end_index) // 2
        while beg_index < end_index:
            #stop the loop there are only two rows
            if beg_index == end_index - 1:
                if self.compare(self.__rows[beg_index][key_index], key) >= 0:
                    mid_index = beg_index
                else:
                    mid_index = end_index
                break
        
            mid_index = (beg_index + end_index) // 2
        
            #stop the loop when find matched row
            if self.compare(self.__rows[mid_index][key_index], key) == 0:
                break
            elif self.compare(self.__rows[mid_index][key_index], key) < 0:
                beg_index = mid_index
            else:
                end_index = mid_index     
        
        return mid_index
    
    # Removes the row pointed to by the current pointer, and moves the current
    # pointer to the next row.  If the current pointer was pointing to the last
    # row, it will now point to the first row.  Raises an exception if the Table
    # is empty (current pointer is None).
    def remove_current_row(self):
        if self.__current_pointer == None:
            raise Exception("Table is empty.")
        
        self.__rows.pop(self.__current_pointer)
        if len(self.__rows) == 0:
            self.__current_pointer = None
        elif self.__current_pointer >= len(self.__rows):
            self.__current_pointer = 0
            
    # Overrites all data currently in the Table with the data in the given raw
    # data file.  Raises an exception if the raw data file is not in the correct
    # format.
    def populate_initial_data(self, raw_data_file_name, field_delimiter, 
                              record_delimiter):
        file = open("raw_data/" + raw_data_file_name, "r")
        file_contents = file.read()
        
        self.__rows = []
        
        rows = file_contents.split(record_delimiter)
        for row in rows:
            columns = row.split(field_delimiter)    
            if len(row) > 0:
                if len(columns) != len(self.__attributes):
                    raise Exception("File data is not in the correct format.")
                else:
                    self.append(columns)

        file.close()
        if len(self.__rows) != 0:
            self.__current_pointer = 0
        else:
            self.__current_pointer = None


    # Updates the inverted index of this Table with the document given.  Raises
    # an exception if this Table is not "inverted_index" type.
    def load_one_document(self, document_location, document_id):
        if self.__type != Table.INVERTED_INDEX_TYPE:
            raise Exception("Table is not an inverted index.")
        
        file = open(document_location, "r")
        file_contents = file.read().lower()
        document_id = str(document_id)
        
        output_file = open("docs/" + document_id, "w")
        output_file.write(file_contents)
        output_file.close()
        
        building_word = False
        word_start_index = 0
        for i in range(0, len(file_contents)):
            
            if building_word and file_contents[i] not in Table.WORD_CHARACTERS:
                building_word = False
                word = file_contents[word_start_index:i]
                for i in range(0, len(self.__rows)):
                    if self.__rows[i][0] == word:
                        if document_id not in self.__rows[i][1]:
                            self.__rows[i][1]+= "," + document_id
                        break
                else:
                    row = [word, document_id]
                    self.append(row)
                    
            elif not building_word and file_contents[i] in Table.WORD_CHARACTERS:
                building_word = True
                word_start_index = i
                
        file.close()
        if self.__current_pointer == None and len(self.__rows) != 0:
            self.__current_pointer = 0
    
     