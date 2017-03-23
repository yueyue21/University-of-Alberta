#lang racket
;  
; tests and examples for the tree editing module
;
(require "tree-edit.rkt")

; examples:
(define (test-e-tree-ref)
  (define t1 '(a (b c) (d (e f) (g h (i j)))))
  
  (map displayln (list
    t1
    " "
    (e-tree-ref t1 '())
    (e-tree-ref t1 '(0))
    (e-tree-ref t1 '(2))
    (e-tree-ref t1 '(2 1 1))
    (e-tree-ref t1 '(2 2 2 1))
                  
    )) 
  (void)            
  )


(define (test-e-tree-edit)
  (define t1 '(a (b c) (d (e f) (g h (i j)))))
  
  (map displayln (list
    t1
    " "
    (e-tree-edit (lambda (s) (rest s)) t1 '())
    (e-tree-edit (lambda (s) 'f1) t1 '(0))
    (e-tree-edit (lambda (s) (list (second s) (first s))) t1 '(1))
    (e-tree-edit (lambda (s) (list 'f2 s) ) t1 '(2 1 1))
    (e-tree-edit (lambda (s) (list 'lambda (list (e-tree-ref s '(1))) s) ) t1 '(2 2 2))
                  
    )) 
  (void)            
  )

(define (test-e-tree-edit-many)
  (define t1 '(a (b c) (d (e f) (g h (i j)))))
  
  (map displayln (list
    t1
    " "
    (e-tree-edit-many (lambda (s) 'f1) t1 '( (0) (1 1)))
    (e-tree-edit-many (lambda (s) (list 'f2 s) ) t1 '( (2 1 1) (2 2 2)) )
                  
    )) 
  (void)            
  )


(define (test-e-tree-find-paths)
  (define t2 '(a (b a) (b (a f) (f h (b a)))))
  
  (map displayln (list
    t2
    " "
    (e-tree-find-paths 'a t2)
    (e-tree-find-paths 'b t2)
    (e-tree-find-paths '(b a) t2)
    
    
    (e-tree-edit-many (lambda (s) 'delta) t2 (e-tree-find-paths 'a t2))
    (e-tree-edit-many (lambda (s) 'delta) t2 (e-tree-find-paths '(b a) t2) )
    )) 
  (void)            
  )

