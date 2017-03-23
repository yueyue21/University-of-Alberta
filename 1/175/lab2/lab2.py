fin = open ( 'accounts.txt','r')
account=dict()
for i in fin:
    line = i.split(':')
    
    account[line[0]]=line[1]
    
for i in account:
    try :
        words=float(account[i])
    except ValueError:
        print('Account for',i,'not added: illegal value for balance')
        
    del account[i]
def input1():
    name = str(input("Enter account name, or 'Stop' to exit:") )
    if name in ['Stop']:
            print('done')    
    else:
        if name not in account:
            print('Account does not exist, transaction canceled')
            input1()
        try:
            transaction = float(input("Enter transaction amount: "))
        except ValueError:
            print('Illegal value for transaction, transaction canceled')
            print (transaction)
        num= float(account[name])+transaction
        print('New balance for account',name,':',num)
        account[name]=num
        input1()
    
input1()

