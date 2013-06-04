(load "error.scm")

(define (terminal char)
  (case char
    [#\λ 'lam]
    [#\. 'dot]
    [#\( 'oparen]
    [#\) 'cparen]
    [#\[ 'osquare]
    [#\] 'csquare]
    [else #f]))

(define (legal? char)
  (or
    (char-alphabetic? char)
    (char-numeric? char)))

(define (tokenize clst)
  (define (name-helper acc clst)
    (if (or
          (null? clst)
          (char-whitespace? (car clst))
          (terminal (car clst)))
      (cons
        acc
        (tokenize clst))
      (if (legal? (car clst))
        (name-helper (string-append acc (string (car clst))) (cdr clst))
        (error "Invalid character in variable name."))))
  (cond
    [(null? clst) '()]
    [(char-whitespace? (car clst)) (tokenize (cdr clst))]
    [(terminal (car clst)) (cons
                              (terminal (car clst))
                              (tokenize (cdr clst)))]
    [else (name-helper "" clst)]))