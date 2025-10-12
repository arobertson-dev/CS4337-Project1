#!/usr/bin/env racket
#lang racket

#|
This Program is a prefix-notation expression calculator, the calculator will be able to run in two modes, interactive or bash
In batch mode the only outputs are the results of the calculated expressions, and error outputs.
In interactive mode the program will prompt the user for an expression to calculate.
If the input is "quit" then the program will ecxit, otherwise it will evaluate the expression thats inputted
The program will also keep a history log of the last evaluted expressions result which can be used in the users next input
expression to be calculated.

the following binary operations are allowed for this calculator " + ", " - ", " * ", " / "
$n will correspond to the history value
any real number can be used in this calculator
Expressions are in prefix notation, being read (left to right ) 
|#




;;Convert command-line arguments (vector)--> list, or return empty list if none are provided
(define args-list 
  (or (and (not (equal? (current-command-line-arguments) '())) ;;check if the program has started with arguments
           (vector->list (current-command-line-arguments))) ;; if yes, convert them from vector to list
      '()))                                                  ;; otherwise, default to empty list

;; Deternube wgetger the calculator should run in interactive or batch mode
(define (interactive?)
  ;; helper function to check each argument in the list
  (define (check lst)
    (cond
      [(null? lst) #t] ;;if no arguments left --> default to interactive mode (#t)
      [(or (string=? (car lst) "-b")
           (string=? (car lst) "--batch")) #f] ;;if "-b" or "--batch" found --> batch mode (#f)
      [else (check (cdr lst))])) ;; otherwise keep checking the rest of the list
  (check args-list)) ;; start checking from the global args-list




;;Break an input string into a list of valid tokens (numbers, operators, and history references)
(define (tokenize input)
  ;;Convert the input string into a list of individual characters
  (define chars (string->list input)) 
  ;;helper function to skip over any whitespace characters
  (define (skip cs)
    (cond [(and (pair? cs) (char-whitespace? (car cs))) (skip (cdr cs))] ;;if whitespace, keep skipping
          [else cs]))                                                    ;;stop one a non-whitespace character is found
  ;;helper function to collect conseutive digits into one numeric string
  (define (take-digits cs)
    ;; returns a two-element list: (digit-string remaining-characters)
    (let loop ((r cs) (acc '())) ;;acc accumulates digits in reverse order
      (cond
        [(and (pair? r) (char-numeric? (car r))) ;;keep taking while current char is numeric
         (loop (cdr r) (cons (car r) acc))]
        [else (list (list->string (reverse acc)) r)]))) ;;convert collected digits to string and return
  ;;helper function to identify and return the next token from the char list
  (define (next-token cs)
    (let ((cs (skip cs))) ;;skip any leading whitespace first
      (cond
        [(null? cs) (list #f '())] ;;if nothing left, indicate end of tokens
        [else
         (let ((c (car cs))) ;; look at the first character
           (cond
             ;; single-char operators +. *, /
             [(or (char=? c #\+) (char=? c #\*) (char=? c #\/))
              (list (string c) (cdr cs))] ;;return token and remaining chars

             ;;handle history reference (ex. $1, $2)
             [(char=? c #\$)
              (let ((r (cdr cs)))
                (if (and (pair? r) (char-numeric? (car r))) ;;ensure digits follow the $
                    (let ((res (take-digits r))) ;;extract digits after $
                      (list (string-append "$" (car res)) (cadr res))) ;;token = "$n"
                    ;;invalid if no digits after $
                    (list 'ERROR '())) )]

             ;;handle '-' --> can be an operator or start of negative number
             [(char=? c #\-)
              (let ((nextc (and (pair? (cdr cs)) (car (cdr cs))))) ;;peek next character
                (if (and nextc (char-numeric? nextc)) ;;if followed by digit --> negative number
                    (let ((res (take-digits (cdr cs)))) ;; collect digits after '-'
                      (list (string-append "-" (car res)) (cadr res))) ;;return negative number token
                    (list "-" (cdr cs))))] ;;otherwise just return "-" as operator

             ;; handle numeric literal (not negative)
             [(char-numeric? c)
              (let ((res (take-digits cs)))
                (list (car res) (cadr res)))]

             ;; anything else --> invalid character
             [else (list 'ERROR '())]))])))

  ;;collect all tokens from the input by repetedly calling next-token
  ;; builds up a list of tokens or returns error string if invalid character found
  ;;Ex. "+ 5 -2" --> ("+", "5", "-2")
  (let collect ((cs chars) (acc '()))
    (let ((p (next-token cs)))
      (let ((tok (car p)) (rest (cadr p)))
        (cond
          [(eq? tok #f) (reverse acc)] ;;if no more tokens, return list in correct order
          [(eq? tok 'ERROR) "Error: Invalid Expression"] ;;invalid char encountered
          [else (collect rest (cons tok acc))])))))


;;evaluate a single token and return its numeric value
;; supports real numbers and history references($n)

(define (eval-token tok history)
  (let ((num (string->number tok))) ;;try converting token directly to a number
    (if num
        num ;;if conversion succeeds, return numeric value
        (if (and (> (string-length tok) 1)
                 (char=? (string-ref tok 0) #\$)) ;;check if token begins with '$'
            (let* ((id-str (substring tok 1)) ;;get substring after '$'
                   (id (string->number id-str))) ;;convert index to number
              (if (and id (integer? id) (>= id 1) (<= id (length history))) ;;ensure valid integer in range
                  (list-ref history (sub1 id)) ;;retreive corresponding previous result (1-based index)
                  "Error: Invalid Expression")) ;;invalid $ reference
            "Error: Invalid Expression")))) ;;invalid token (not number or $n)


;;recursively evalute a list of tokens (in prefix order) using stored history
;;Returns a two element list: (result, reamining-tokens)
;;Example: tokens ("+", "5", "2") --> (7 '())

(define (eval-expr tokens history)
  (cond
    ;;if there are no tokens left--> invalid because operator/operand mismatch
    [(null? tokens) (list "Error: Invalid number of operands" '())]

    [else
     ;;separate the first token (operator or operand) from the rest
     (let ((tok (car tokens))
           (rest (cdr tokens)))
       (cond
         ;;case 1: binary operators +, *, /
         [(or (string=? tok "+") (string=? tok "*") (string=? tok "/"))
          ;;recursively evaluate the first operand (r1 = [value1, remaining-tokens])
          (let ((r1 (eval-expr rest history)))
            (if (string? (car r1)) ;;if result is error message, just propagate it
                r1
                (let ((v1 (car r1)) (rest1 (cadr r1))) ;;first value, remaining tokens after first operand
                  ;;recursively evaluate second operand
                  (let ((r2 (eval-expr rest1 history)))
                    (if (string? (car r2)) ;;if error in second operand
                        r2
                        (let ((v2 (car r2)) (rest2 (cadr r2))) ;;second value, remaining tokens after second operand
                          ;;perform arithmetic operation
                          (cond
                            [(and (string=? tok "/") (= v2 0))
                             (list "Error: Division by zero" '())] ;;handle divison by zero
                            [(string=? tok "+") (list (+ v1 v2) rest2)]
                            [(string=? tok "*") (list (* v1 v2) rest2)]
                            [(string=? tok "/") (list (/ v1 v2) rest2)]
                            [else (list "Error: Invalid Expression" '())])))))))]

         ;;case 2: unary operator (-)
         [(string=? tok "-")
          ;;evaluate the next expression to apply unary negation
          (let ((r (eval-expr rest history)))
            (if (string? (car r))
                r
                (let ((v (car r)) (rest1 (cadr r)))
                  (list (- v) rest1))))]

         ;;case 3: Operand(number or $n)
         [else
          (let ((val (eval-token tok history))) ;;evaluate single token
            (if (string? val)
                (list val '()) ;;if invalid token, return error
                (list val rest)))]))])) ;;otherwise return numeric value with remaining tokens 



;;safely evaluate a full input line while handling errors and maintaining history
(define (safe-eval line history)
  ;; catch any runtime exceptions (ex. invalid syntax or type errors)
  (with-handlers ([exn:fail? (lambda (e)
                               (list "Error: Invalid Expression" history))]) ;;on failure, return error with unchanged history
    (let* ((tokens (tokenize line)) ;;convert user input string to list of tokens
           (res (eval-expr tokens history))) ;;recusrively evaluate the expression
      (cond
        ;;case1: expression produced an error message
        [(string? (car res))
         (list (car res) history)] ;;return same history (no new result stored)

        ;;case2: extra tokens left --> too many operands
        [(not (null? (cadr res)))
         (list "Error: Invalid number of operands" history)]

        ;;case3: valid result
        ;;append the computed value to the history list
        [else
         (let ((val (car res)))
           (list val (append history (list val))))]))))



;;takes a result (from evaluating a user expression)
;;and the updated command history list, then prints the output
;;in a formatted way depending on the result type

(define (print-result result new-history)
  (if (string? result) ;;check if the result is a string
      ;;if its a string, print it directly followed by a newline
      (begin
        (displayln result))
      ;;otherwise, assume its a numeric result
      (begin
        (display (number->string (length new-history))) ;;print the ID of the result, based on how mant results are in the updated history list(1-based)
        (display ": ")
        (display (real->double-flonum result)) ;;convert the numeric result to a double-precision float before displaying, ensuring consistent numeric formatting
        (newline)))) ;;finally, print a newline to end the output cleanly

 
   
;;implement an interactive Read-Eval-Print loop (REPL)
;; Continuously prompts the user for input, evaluates it safely
;; prints the result, and updates the command history
;; terminates when user enteres quit or end-of-file (Ctrl+d/EOF)

(define (interactive-loop)
  ;;define a named let for recursion - "loop" acts like a while loop
  ;; 'history' stores all previous results; starts as an empty list
  (let loop ((history '()))
    (display "Enter Expression to be evaluated: ") ;;display the user prompt
    (flush-output) ;;force prompt text to appear immediately (no buffering delay)
    (let ((line (read-line))) ;;read a line of input from the user
      (cond
        [(eof-object? line) (void)] ;;case1: end of input, or end of file, end loop with void
        [(string=? line "quit") (void)] ;;case2: user typed "quit", end loop with void
        [else
         (let ((res (safe-eval line history))) ;;case3: normal input -- process it,
           (let ((result (car res)) ;;extract the result (first element of the pair
                 (new-h (cadr res))) ;; and updated history (second element)
             (print-result result new-h) ;;print the result neatly
             (loop new-h)))])))) ;;recurse with updated history, continuing the REPL


;;continously read lines from input, evaluate each line safely, print the result, and update history.
;;stops when "quit" is read or EOF is reached
;;Unlike interactive-loop, there is no user prompt.

(define (batch-loop)
  (let loop ((history '())) ;;named let recursion "history" starts empty
    (let ((line (read-line))) ;;read a line from input (could be from a file, pipe, or terminal)
      (cond
        [(eof-object? line) (void)] ;;case1: End of file --> stop
        [(string=? line "quit") (void)] ;;User explicity typed "quit" --> stop
        [else
         (let ((res (safe-eval line history))) ;;case3: valid input line --> evaluate
           (let ((result (car res))
                 (new-h (cadr res)))
             (print-result result new-h) ;;print the computed result
             (loop new-h)))])))) ;;recurse with updated history

;;program entry point, determines whether to run in interactive or batch mode
;;based on command-line arguments, then starts the appropriate loop


(define (main)
  ;;check if program should run interactively
  (if (interactive?) ;;interactive? returns #t or #f
      (interactive-loop) ;;start interactive REPL if true
      (batch-loop))) ;;otherwise start batch processing

(main)

                               
                             






























































                 
            