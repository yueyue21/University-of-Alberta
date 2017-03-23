sqlist= [x*x for x in range(1,11)]
print(sqlist)
sqlist= [x*x for x in range(1,11) if x%2 !=0]
print(sqlist)
sqlist= [x*x for x in range(1,11) if x%2 !=0 and x>5]
print(sqlist)
ch_list = [ch.upper() for ch in "what's up" if ch not in 'aeiou']
print(ch_list)