# CMPUT 175 Winter 2013 Lab 2 Exercise 2
# This program is used to calculate the worth of an automobile.

class Automobile:
    
    # Constructor:
    def __init__(self, length, horsepower, color):
        
        self.__length = length
        self.__horsepower = horsepower
        self.__color = color
        
    # Returns the length:
    def get_length(self):
        return self.__length
    
    # Returns the horsepower:
    def get_horsepower(self):
        return self.__horsepower
        # TODO: You must implement this method!
    
    # Returns the color:
    def get_color(self):
        return self.__color
        # TODO: You must implement this method!
    
    
    def get_worth(self):
        worth = horsepower*length*color_factor*10
        return worth
        
def main():
    length = int(input('Enter automobile's length in meters:'))
    horsepower=int(input('Enter automobile's horsepower:'))
    color = str(int('Enter automobile's color: '))
    
    if color in ['red']:
        color_factor = 3
    elif color in ['yellow','blue']:
        color_factor = 2
    else:
        color_factor = 1
    print ('This automobile is worth',get_worth(self))
    
    

main()