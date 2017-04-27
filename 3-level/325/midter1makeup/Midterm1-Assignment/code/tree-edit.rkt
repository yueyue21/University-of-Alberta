#lang racket

(provide list-edit)
(provide e-tree-ref)
(provide e-tree-find-paths-match)
(provide e-tree-find-paths)
(provide e-tree-edit)
(provide e-tree-edit-many)

; this module provides tools for manipulating trees.  You can navigate
; to specific points a tree, search for subtrees, and edit subtrees in
; a tree.

; an e-tree represents the kinds of tree structures that we want to
; manipulate.  Defined recursively:

; atom := a single primative unstructured element, like a number 42 
;         or symbol 'x

; e-tree := atom | ( e-tree * )
; that is, an e-tree is an atom, or a list of 0 or more e-trees

; the following operations are implemented below:

; list-edit - is a simple function for modifying a specific entry in a list
; and returning the resulting list

; e-tree-ref - is used to follow a path into an e-tree and return the
; subtree rooted at the end of the path.

; e-tree-find-paths does a search and returns paths to subtrees in the 
; tree that match the target tree. 

; e-tree-find-paths-match does a search and returns paths to subtrees
; in the tree that satisfy a match predicate

; e-tree-edit - is a function that follows a path into a tree and then 
; edits the subtree rooted at the end of the path.

; e-tree-edit-many - takes a list of paths and edits the endpoints of each 
; of each path.


; editing lists:
; we need a primative for editing a specific element of a list

; given editing function edit-fn, list lst, and 0-origin position n 
; inside lst, return a list which is lst with the element at 
; (list-ref lst n) replaced by (edit-fn (list-ref lst n))
; 
; for example
; > (list-edit (lambda (x) (* 10 x)) '(0 1 2 3 4) 2)
; '(0 1 20 3 4)


(define (list-edit edit-fn lst n) 
   (let-values 
      ( [ (a b) (split-at lst n) ] )  ; note how to capture a 2 value result
               
      (if (null? b)
          (error (format "edit-list n of ~a >= length l of ~a" n lst))
          (append a (list (edit-fn (first b))) (rest b))
          )
      )
  )

; paths in e-trees:
; a path in an e-tree is a list of 0-origin indexes that navigate to a 
; sub-component of the e-tree.  Navigation via a path is defined
; by the e-tree-ref function, modelled after list-ref:

(define (e-tree-ref e-tree path)
  (if (null? path) e-tree
      (e-tree-ref (list-ref e-tree (first path)) (rest path)))
  )



; find paths to all instances of target-e-tree in expression expr
; A path is a list of 0-origin indexes into the expression tree
; indicating how to navigate down from the root to locate the target
(define (e-tree-find-paths target-e-tree e-tree [paths '()] [rootpath '()])
    (e-tree-find-paths-match 
       (lambda (t) (equal? target-e-tree t))
       e-tree paths rootpath)
    )


; find paths to all instances of target-e-tree in that satisfy match-pred?
; A path is a list of 0-origin indexes into the expression tree
; indicating how to navigate down to the root to locate the target

(define (e-tree-find-paths-match match-pred? e-tree [paths '()] [rootpath '()] )
   (cond
        ; are we at a matching term?  Note we do not descend further to see if there
        ; are more matches on this branch.
        [ (match-pred? e-tree) (append paths (list rootpath) ) ]
        
        ; ok, no match, no recursion when e-tree empty
        [ (null? e-tree) paths ]
        
        ; do a depth-first recurse into sub e-trees accumulating paths to matches
        [ (list? e-tree) 
            (second 
               (foldl 
                ; (e s) is current sub e-tree e, and prior state s
                ; where prior state s is (n p) where 
                ;    n is 0-origin position of e in containing e-tree, 
                ;    p collection of paths found so far
                (lambda (e s)
                    (let ( 
                          ; pull apart state
                          (n (first s)) 
                          (p (second s)) 
                          )
                        ; new state - next position, add newly found paths
                        (list
                           (add1 n) 
                           (e-tree-find-paths-match match-pred? e p (append rootpath (list n)))
                           )
                    ) 
                )
                (list 0 paths)
                e-tree  ; fold over the subtrees left to right
                )
            ) ]
        
        [ else paths ]
    )
) 


; editing e-trees:
; given an e-tree and a target-path to a subtree of e-tree, we would like to 
; edit the subtree at the endpoint of the path.

; e-tree-edit returns an e-tree which is the original tree but with the 
; subtree t reached by edit-path repaced by (edit-fn t)

(define (e-tree-edit edit-fn e-tree target-path)
  (cond 
    ; empty path edits entire e-tree
    [ (null? target-path) (edit-fn e-tree) ]
          
    ; for longer path, replace the (first target-path) position in e-tree with the
    ; result of recursing down the sub e-tree at that position using the rest
    ; of the target path
    
    [ else (list-edit 
              (lambda (sub-e-tree) (e-tree-edit edit-fn sub-e-tree (rest target-path)))
              e-tree 
              (first target-path))
             ]
  ))
  

; perform the same edit at multiple points in the tree.  You need
; to be careful if the paths intersect in the sense that the endpoint
; of one path is in a sub e-tree below the endpoint of another path.

(define (e-tree-edit-many edit-fn e-tree edit-paths)
  (foldl (lambda (path cur-e-tree) (e-tree-edit edit-fn cur-e-tree path))
         e-tree edit-paths)
  )

