def quick_sort(alist):
    quick_sort_helper(alist,0,len(alist)-1)

# a recursive quick sort method
def quick_sort_helper(alist,first,last):
    if first<last:
        splitpoint = partition(alist,first,last)
        quick_sort_helper(alist,first,splitpoint-1)
        quick_sort_helper(alist,splitpoint+1,last)

# to partition the given list by 
# (1) picking the first int as the pivot value
# (2) re-arrange all integers accoding to the pivot value
def partition(alist,first,last):
    pivotvalue = alist[first]

    leftmark = first+1
    rightmark = last

    done = False
    while not done:

        while leftmark <= rightmark and \
              alist[leftmark] <= pivotvalue:
            leftmark = leftmark + 1

        while alist[rightmark] >= pivotvalue and \
              rightmark >= leftmark:
            rightmark = rightmark -1

        if rightmark < leftmark:
            done = True
        else:
            # exchange integers pointed by the 
            # leftmark and rightmarks
            temp = alist[leftmark]
            alist[leftmark] = alist[rightmark]
            alist[rightmark] = temp

    temp = alist[first]
    alist[first] = alist[rightmark]
    alist[rightmark] = temp


    return rightmark

