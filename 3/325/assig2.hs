data BinTree = L | N BinTree BinTree | N1 BinTree BinTree | NULL deriving (Eq, Show)
        
-- this function creates the full binary tree of size 2^(n+1) -1
makeBinTree 0 = L
makeBinTree n = N (makeBinTree (n-1)) (makeBinTree (n-1)) 

-- this function computes the size of a binary tree
size NULL  = 0
size L = 1
size (N1 t1 t2) = 1 + size t1 + size t2
size (N t3 t4) = 1 + size t3 + size t4


depth L = 1
depth NULL = 0
depth (N t3 t4) = 1 + max (depth t3) (depth t4)
depth (N1 t5 t6) = 1 + max (depth t5) (depth t6)

makeABinTree 0 = NULL
makeABinTree 1 = L
makeABinTree s = if even s
			then N (makeABinTree ((s `div` 2)-1)) (makeABinTree (s `div` 2))
			else N (makeABinTree ((s-1) `div` 2)) (makeABinTree ((s-1) `div` 2))
