#lang racket

; an operation can appear as quoted or as a procedure, depending on how the 
; expression was constructed, so detect both forms.

(define (is-plus? op) (or (equal? op +) (equal? op '+))) 
(define (is-times? op) (or (equal? op *) (equal? op '*))) 
(define (is-substraction? op) (or (equal? op -) (equal? op '-)))
(define (is-division? op) (or (equal? op /) (equal? op '/)))
; apply op to left and right arguments, assume they are numbers
; this can be tested with the number? predicate
(define (op-eval op larg rarg)
  (cond 
    [ (is-plus? op) (+ larg rarg) ]
    [ (is-times? op) (* larg rarg) ]
    [ (is-substraction? op) (- larg rarg)]
    [ (is-division? op) (/ larg rarg)]
    ))

; evaluate an infix expression tree, assuming that all the leaves 
; are numbers.
(define (exp-eval ex)
  (cond
    ; atoms are themselves
    [ (not (list? ex)) ex ]  

    ; single element lists are the value of their first element
    [ (null? (rest ex)) (exp-eval (first ex)) ] 

    ; triples require evaluation of left and right, followed by operation
    [ else (op-eval (second ex) (exp-eval (first ex)) (exp-eval (third ex))) ]
    ;(exp-eval '((x + 1) + (x * y)) '( (x 2) (y 3) )) is 9
   ; [ ]
    ))

(exp-eval 1)
(exp-eval '1)
(exp-eval '(1))
(exp-eval '(1 + 2))
(exp-eval '(3 * 4))
;(exp-eval '( (1 + 2) * (3 + 4) ))
;will not work: (exp-eval '(1 + x))
