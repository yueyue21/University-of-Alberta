#lang racket

(require "tree-edit.rkt")

;Debugging a functional program can be tricky, since the common 
;approach of adding debugging print or logging statements is not
;a functional modification of the source code.  For example, think
;of logging the value of x inside the condition of this if:
;    (if (odd x) (true-case x) (false-case x))
;Instead you need to wrap x in a function that behaves like the 
;identity function, but also logs a value as it passes through.
;This is what the wrap-in-print function does below.  You could use
;it like this:
;    (if (odd (wrap-in-print "x is " x)) (true-case x) (false-case x))
;or even like this
;    (if (odd (wrap-in-print "x is " x)) 
;        (true-case x) 
;        (wrap-in-print "false result is" (false-case x))
;        )

(define (wrap-in-print comment term)
    (display (format "~a: ~a\n" comment term))
    term
  )

(define (test-wrap x) 
  (define (odd x) (= 0 (remainder x 2)))
  (define (true-case a) (* a 2))
  (define (false-case a) (+ a 1))
  (if (odd (wrap-in-print "x is " x)) 
      (true-case x) 
      (wrap-in-print "false result is" (false-case x))
      )
  )

; PART 1 - write a function add-trace that takes an expression
; and a path into the expression, and wraps the end-point of the 
; path with wrap-in-print.  
;    (add-trace code comment path)
; If term is the subtree at the endpoint of path, then this will 
; wrap that end point in a (wrap-in-print comment term)
; If (eval code) would result in a proper racket expression
; then (eval (add-trace code comment path)) should also result
; in a proper racket expression
;
; Hint: if you use e-tree-edit this function is only 1 line long.

; trace the value of the expression at the endpoint of path
(define (add-trace code comment path)
    ; your code goes here 
  (e-tree-edit (lambda (x)(list 'wrap-in-print comment x)) code path)
    )
    

; example uses 

(define prog-g 
  '(define (g x) (if (< x 0) x (+ 1 (g (- x 1)))))
  )

; trace the result of every call to g.
; should transform prog-g into
;   '(define (g x) (wrap-in-print "g-1" (if (< x 0) x (+ 1 (g (- x 1))))))

(define (test-g-1)
  (define p (add-trace prog-g "g-1" '(2)))
  (print p)(newline)
  (eval p) ; test if syntactically correct
  )

; trace the inner call
; should transform prog-g into
;   '(define (g x) (if (< x 0) x (+ 1 (wrap-in-print "g-2" (g (- x 1))))))

(define (test-g-2)
  (define p (add-trace prog-g "g-2" '(2 3 2)))
  (print p)(newline)
  (eval p) ; test if syntactically correct
  )

; trace the value of x coming in
; should transform prog-g into
;   '(define (g x) (if (< (wrap-in-print "g-3" x) 0) x (+ 1 (g (- x 1)))))

(define (test-g-3)
  (define p (add-trace prog-g "g-3" '(2 1 1)))
  (print p)(newline)
  (eval p) ; test if syntactically correct
)
  
(define (test-add-trace) 
  (test-g-1)
  (test-g-2)
  (test-g-3)
  )

(define (trace-a-call param)
    ; instrument the function g and then use eval to introduce g into
    ; the current environment
    (eval (add-trace prog-g "g-3" '(2 1 1)))
  
    ; now actually run g.  Note we have to put it into an eval becuase
    ; g does not exist yet when checking if trace-a-call is properly
    ; defined. So we build up an expression to then be evaluated.
    (eval (list 'g param))
  )

; PART 2 begins here
; Consider our friend factorial, defined with an accumulator
; fact-def needs to be eval's in order to actuall define fact

(define fact-def 
    '(define (fact n (a 1)) (if (<= n 0) a (fact (- n 1) (* n a)))))

; and then instrumented on every call

(define i-fact-def (add-trace fact-def "fact" '(2)))

; which creates this:
; '(define (fact n (a 1)) 
;   (wrap-in-print "fact" (if (<= n 0) a (fact (- n 1) (* n a)))))

; now when you do this sequence of commands to define fact (in instrumented
; form) and run it you get a weird trace.  

; > (eval i-fact-def)
; > (fact 3)
; fact: 6
; fact: 6
; fact: 6
; fact: 6
; 6
; PART 2 - explain what is happening here with the repeated "fact: 6"
(display"Part 2:
After calling eval i-fact-def, we have alread modified the fact function
there's an accumlator in fact function which enable us to return the whole
result at last. The true value of a is '(1,3,6,6) mapping to n is'(3,2,1,0)
since the function would return the last value in the accumlator (a),it would
always be 6 after 'fact'.\n\n")
                

; PART 3 Background
; You may want to add tracing to multiple points in the function.
; this can be done by composing add-trace with new paths, provided the paths
; do not interfere with each other in the sequence of compositions.
; for example in test-g-4 below, the result of the add trace is
;
; '(define (g x) (wrap-in-print "3rd" 
;     (if (< (wrap-in-print "1st" x) 0) 
;       x (+ 1 (wrap-in-print "2nd" (g (- x 1)))))))
;
; and you get this trace on (g 4)
; > (g 4)
; 1st: 4
; 1st: 3
; 1st: 2
; 1st: 1
; 1st: 0
; 1st: -1
; 3rd: -1
; 2nd: -1
; 3rd: 0
; 2nd: 0
; 3rd: 1
; 2nd: 1
; 3rd: 2
; 2nd: 2
; 3rd: 3
; 2nd: 3
; 3rd: 4
; 4

(define (test-g-4)
  (define p (add-trace (add-trace (add-trace prog-g "1st" '(2 1 1)) 
                        "2nd"'(2 3 2)) 
             "3rd" '(2)))
  (print p)(newline)
  (eval p)
  )

; The function add-trace-many takes a list of (comment path) pairs and adds a
; trace at those points.

(define (add-trace-many prog trace-points)
  (foldl 
   ; point is the trace-point to add
   ; acc is the accumulated transforms so far
   (lambda (point acc) 
     (add-trace acc (first point) (second point))
     )
   prog trace-points))

(define (test-g-5)
  (define p (add-trace-many prog-g 
                 '(("1st" (2 1 1)) ("2nd" (2 3 2)) ("3rd" (2))) ) )
  (print p)(newline)
  (eval p)
  )


; PART 3 Continued - consider the standard recursive version of Fibonacci 
; where we want to trace every invocation of fib.

(define fib-def 
  '(define (fib n) 
     (cond 
       ( (= 0 n) 1 )
       ( (= 1 n) 1 )
       (else (+ (fib (- n 1)) (fib (- n 2))) )  ) ) )

; we can use e-tree-find-paths-match to identify paths to all the
; recursive calls to fib, then we can pair each path with a generated
; trace symbol to create a list of trace points, and then add-trace-many
; to get an instrumented fib.

; trace-rec below generalizes this to any recursive fuction.

; trace symbol generator
(define trace-sym 0)
(define (reset-trace-sym [x 0]) (set! trace-sym x))
(define (gen-trace-sym)
  (let ( (s (format "tr~a" trace-sym)) )
    (set! trace-sym (add1 trace-sym))
    s
    ))

; turn a list of tree paths into a list of trace points by
; pairing each path with a generated trace symbol

(define (make-trace-points paths) 
  (map (lambda (p) (list (gen-trace-sym) p)) paths) )
; trace all the recursive calls to name in function-def, including the 
; final result being returned.
(define (trace-rec name function-def)
  (reset-trace-sym)
  
  ; is-rec-call? looks for subtrees that look like (name ...) indicating
  ; a recursive call.
  (define (is-rec-call? tree) (and (list? tree) (eq? name (first tree))) )
  
  ; search for all these matches in the function definition, these are 
  ; points to be instrumented.
  (define paths (e-tree-find-paths-match is-rec-call? function-def))
  ;(cons '(2)  (rest paths)) 
  ; insert the traces
  (add-trace-many fib-def (make-trace-points paths))
  )


; Usage example:
; If we apply trace-rec as follows
;   (trace-rec 'fib fib-def)
; we get this result
; '(define (wrap-in-print "tr0" (fib n))
;  (cond 
;    ((= 0 n) 1) 
;    ((= 1 n) 1) 
;    (else (+ (wrap-in-print "tr1" (fib (- n 1))) 
;             (wrap-in-print "tr2" (fib (- n 2)))))
;  ))
;
; when we really wanted something like this:
; '(define (fib n) (wrap-in-print "tr0" 
;  (cond 
;    ((= 0 n) 1) 
;    ((= 1 n) 1) 
;    (else (+ (wrap-in-print "tr1" (fib (- n 1))) 
;             (wrap-in-print "tr2" (fib (- n 2)))))
;  )))

; Finally we get to the question ...
(display "Part 3(1):
the trace-rec function would treat its second arguement as a list it would
turn everything like (fib..) into (wrap-in-print tr~x (fib ...)) based on the
function of e-tree-find-paths-match(path finding of an identity), but in 
our case THE first (fib ..)is a declaration(define) we can not replace it as 
usuall,since it would recursively call this (fib ..) function as 'fib rather than 
(wrap-in-print tr~x (fib ..)).
Part 3(2):
(cons '(2)  (rest paths)) in fuction of trace-rec
Part 3(3):
we need to implement a new condition in function of e-tree-find-paths-match 
to let this function would give a path of (2) rather than (1) when it 
encounting the searching identity the first time. after modified the first time
we will
")
; PART 3 TASK - What is wrong with the behaviour of trace-rec?  Fix it
; to the extent possible without changing tree-edit.rkt.  What new functionality
; would you need to add to tree-edit.rkt to handle all recursive calls?
