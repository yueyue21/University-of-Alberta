fin = open('story.txt','r')
file_content= fin.read()
row = file_content.split('.')
print(row)
for i in fin:
    a = i.split('.')
    #print(a)
    