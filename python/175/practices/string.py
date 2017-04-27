price = 24.54
item = 'banana'
print('1 The %s costs %.4f cents'%(item,price))
print('2 The %s costs %30.4f cents'%(item,price))
print('3 The %s costs %-30.4f cents'%(item,price))
print('4 The %s costs %030.4f cents'%(item,price))
print('5 The %s costs %-030.4f cents'%(item,price))
print('6 The %s costs %30e cents'%(item,price))
print('7 The %s costs %30d cents'%(item,price))
print('8 The %s costs %-30d cents'%(item,price))
itemdict = {'item':'banana','cost':24}
print('the %(item)s costs %(cost)9.2f cents'%itemdict)
itemdict = {'item':'banana','cost':24+99}
print('the %(item)s costs %(cost)9.2f cents'%itemdict)