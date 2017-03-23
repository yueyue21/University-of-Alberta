class item:
    def __init__(self, name, price, quantity):
        self.__name = name
        self.__price = price
        self.__quantity = quantity
        
    def set_name(self, name):
        self.__name = name

    def set_price(self, price):
        self.__price = price
        
    def set_quantity(self, quantity):
        self.__quantity = quantity
        
    def get_name(self):
        return self.__name

    def get_price(self):
        return self.__price
        
    def get_quantity(self):
        return self.__quantity
    
    def __str__(self):
        return '[' + self.__name + ', ' + str(self.__price) \
            + ', ' + str(self.__quantity) + ']'
        
