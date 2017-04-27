fin = open('rainfall.txt','r')
output = dict()
output['60-70 ']=list()
output['70-80 ']=list()
output['80-90 ']=list()
output['90-100 ']=list()
for i in fin:
    word = i.split()
    
    if float(word[1])>60 and float(word[1])<=70:
        output['60-70 '].append(word)
    elif float(word[1])>70 and float(word[1])<=80:
        output['70-80 '].append(word)
    elif float(word[1])>80 and float(word[1])<=90:
        output['80-90 '].append(word)    
    elif float(word[1])>90:
        output['90-100 '].append(word)       
            
out=open('rainfallfmt.txt','w')
ppp=['60-70 ','70-80 ','80-90 ','90-100 ']


for i in ppp:
    out.write(i)
    out.write('\n')
    
    for m in output[i]:
        m.sort()
        
        out.write('                    ')
        out.write(m[0])
        out.write(' ')
        
        out.write('%.1f'%(float(m[1])))
        out.write('\n')
        
out.close()






#222222222222222222222222222222222222222222
fin2 = open('earthquake.txt','r')
iii = dict()
for i in  fin2:
    con = i.split()
    if con[1] in iii:
        iii[con[1]].append(i[0])
    else:
        iii[con[1]]=[con[0]]
    
final=list()
for i in iii:
    final.append(i)
    for m in iii[i]:
        final.append(m)
        
print(final)
    
    