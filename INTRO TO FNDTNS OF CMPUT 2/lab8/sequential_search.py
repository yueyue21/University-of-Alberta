def sequential_search(data, key) :
    found = False
    index = 0
    while ( not found and index < len(data) ):
        if ( key == data[index] ):
            found = True
        else:
            index = index + 1
    if ( not found):
        index = -1
    return index
