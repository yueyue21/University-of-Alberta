from binarytree import BinaryTree
r = BinaryTree('a')
print(r.getRootVal())
print(r.getLeftChild())
r.insertLeft('b')           #insert a node
print(r.getLeftChild())       #get that node
print(r.getLeftChild().getRootVal())    #get that node, get that key(name)
r.insertRight('c')
print(r.getRightChild().getRootVal())  #get the name of right child
r.getRightChild().setRootVal('hello')
print(r.getRightChild().getRootVal())  #get the changed name of right child
r.insertRight('o')
print('-----')
print(r.getRightChild().getRootVal())
print(r.getRightChild().getRightChild().getRootVal())
    