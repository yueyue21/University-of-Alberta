#lang racket

; generate all 2^n possible truth assignments of n boolean variables.
(define (gen-assign n)
   (define (gen-assign-r m assigns)
        (if (<= m 1) 
            assigns
            (append
              (map (lambda (a) (cons #f a) ) (gen-assign-r (- m 1) assigns))
              (map (lambda (a) (cons #t a) ) (gen-assign-r (- m 1) assigns))
              )
        )
    )
   (gen-assign-r n '( (#f) (#t) ))
)



; find first satisfying assignment for a function of 2 variables
; result is 
; '(#t "solved" assignment)
; '(#f "no solution")

(define (satisfy fn)
    ; RESUME                 
    (call/cc
     ; when everything is finished we invoke RESUME to give the call/cc a value
     (lambda (RESUME)  
       
       (let ( 
             [exception 
              
              ; the context around this is the catch, it expects an exception result
              (call/cc 
               (lambda (THROW)  
                 ; TRY
                 ; here is the body of the try, which computes result
                 (map (lambda (assig) 
                        (if (apply fn assig)
                            (RESUME (list #t "solved" assig))
                            '()
                        )) 
                      (gen-assign 2))
                 
                 (THROW '(#f "no solution"))
                 )
               )  ; THROW gives this a value, assigned to exception
               ] )
         
         ; CATCH - if we get here, it is because of THROW
        
         exception
         
         ))
       ) ; RESUME gives this a value, which is returned as the result of satisfy
     
     )
;f t -> t
(define (f1 v0 v1) (and (not v0) v1))
(satisfy f1)

(define (f2 v0 v1) (eq? v0 v1))
(satisfy f2)

(define (f3 v0 v1) #f)
(satisfy f3)

