(+ 1 1)

(doc tset)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fennel Tutorial
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(lambda print-x [x] 
  (print x))
(print-x 1) ; => 1
(print-x nil) ; => runtime error

(lambda print-calculation [x ?y z] ; arg y is allowed to be nil
  (print (- x (* (or ?y 1) z))))
(print-calculation 1 2 2)

(each [key value (pairs {"key1" 52 "key2" 99})]
  (print key value))

(each [index value (ipairs ["abc" "def" "xyz"])]
  (print index value))

; same-name table shorthand
(let [one 1 two 2
      tbl {: one : two}]
  tbl) ; -> {:one 1 :two 2}

; also works with destructuring
(let [pos {:x 23 :y 42}
      {: x : y} pos]
  (print x y)) ; -> 23      42

; protected calls for better composition in error handling
(let [(ok? val-or-msg) (pcall potentially-disastrous-call filename)]
  (if ok?
      (print "Got value" val-or-msg)
      (print "Could not get value:" val-or-msg)))

; variadic functions
(fn print-each [...]
 (each [i v (ipairs [...])] ; accessed via the vector seq-table notation.
  (print (.. "Argument " i " is " v))))
(print-each :a :b :c)


; Warning:
; Tables are compared for identity, not based on the value of their contents, as per Baker.

; No pretty printing, this may be hany
(local view (require :fennelview)) (global pp (fn [x] (print (view x))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fennel Reference
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; fn for unchecked args
(fn pxy [x y]
  (print x y))
(pxy 1) ; => 1 nil

; lambda for checked args
(λ pxy [x y]
  (print x y))
(pxy 1) ; => runtime error

; anonymous functions
(fn [a b] (+ a b))
(hashfn (+ $1 $2))
#(+ $1 $2)
#$3               ; same as (fn [x y z] z)
#[$1 $2 $3]       ; same as (fn [a b c] [a b c])
#$                ; same as (fn [x] x) (aka the identity function)
#val              ; same as (fn [] val)
#[:one :two $...] ; same as (fn [...] ["one" "two" ...])

; pick-values
(pick-values 2 (func)) ; => (let [(_0_ _1_) (func)] (values _0_ _1_))
[(pick-values 2 (unpack [:a :b :c]))] ; => ["a" "b"]

; pick-args
(pick-args 2 add) ; => (fn [_0_ _1_] (add _0_ _1_))

; with-open
(with-open [fin (assert (io.open :input.txt :r))]
  (fin:read))

(with-open [fout (assert (io.open :output.txt :w))] 
  (fout:write "Here is some text!\n"))

; Pattern matching
(match (io.open "/some/file")
  (nil msg) (report-error msg)
  f (read-file f))
(match [91 12 53]
  ([a b c] ? (= 5 a)) :will-not-match
  ([a b c] ? (= 0 (math.fmod (+ a b c) 2)) (= 91 a)) c) ; -> 53

; Destructuring in let
(let [{:msg message : val} {:msg "abc" :others "def" :another "ghi"}]
  (print message)  ; => "abc"
  val) ; => nil

(let [[x y z] [10 9 8]]
  (print x) ; => 10
  (print y) ; => 9
  (print z)) ; => 8

; Multiple-value binding - beware of partial matches
(let [(x y) (values 1 2 3)
      z     (values 1 2 3)]
  (print x) ; => 1
  (print y) ; => 2
  (print z)) ; => 1

(let [(x y z) (unpack [10 9 8])]
  (+ x y z)) ; => 27

(let [(x y z) [10 9 8]]
  (print x) ; => table
  (print y) ; => nil
  (print z)) ; => nil

; `if` acts like `cond`
(let [x (math.random 64)]
  (if (= 0 (% x 10))
      "multiple of ten"
      (= 0 (% x 2))
      "even"
      "I dunno, something else"))

; General iteration - ok for any iterators
(each [key value (pairs mytbl)]
  (print key (f value)))

; Numeric loop (i.e. range)
(for [i 1 10 2]
  (print i))
