(doc 
  Sophia programming language

  lexcial rule:
    - single quote:         quote delimiter
    - double quote:         quote delimiter
    - back quote:           quote delimiter
    - left parenthesis      open delimiter
    - right parenthesis     close delimiter
    - left curly bracket    open delimiter
    - right curly bracket   close delimiter
    - left square bracket   open delimiter
    - right square bracket  close delimiter
    - identifier: non-spaces and non delimiter sequences 
    - spaces: one or more whitespace characters 

  lexcial property:
    for any text, lexer always recognize the token never fail, 
    lexcial rule is non ambiguous, lookahead(1) greedy DFA, 
    completely not need first match and longest match special rule for eliminating ambiguity, 
    and not need any heuristic method for error recovery. 
    
  structure rule:
    - if quote delimiter match     , then reduce.
    - if open/close delimiter match, then reduce.
    - if spaces                    , then shift.
    - if identifier                , then shift.
    - otherwise                    , error recovery.
      - lone delimiter
      - mismatch delimiter 

  structure property:
    for any text, structure parser always recognize as possible,
    report lone delimiter and mismatch delimiter two kinds errors.

    structure rule is non ambiguous, LALR(1) grammar.

  syntax rule:

    === CFG rule

    <program>    ::= <statement>*
    <statement>  ::= <expression>

    <expression> ::= <integer> | <variable> | <interpolation_string> | <binding> | <record> | <inductive> | <match> | <scope> | <lambda> | <apply> | <doc> | <hole>

    <label_body_pair> ::= '(' <identifier> <expression> ')'

    <doc>        ::= '(' 'doc' <bracket-blanced-sequence> ')'
    <binding>    ::= '(' 'let' <identifier> <expression> ')'
    <record>     ::= '(' 'record' <identifier> <label_body_pair>* ')'
    <inductive>  ::= '(' 'inductive' <identifier> <identifier>* ')'
    
    <match>      ::= '(' 'match' <expression> <clause>* ')'
    <clause>     ::= <identifier> <expression>
    
    <scope>      ::= '(' 'scope' <statement>* <expression> ')'
    <lambda>     ::= '(' 'lambda' <signature> <expression> ')'
    <signature>  ::= <label_body_pair>* <expression>

    <apply>      ::= '(' <expression> <expression>* ')'
    
    
    === heuristic rule

    <integer>    ::= [0-9]+
    <variable>   ::= [^0-9] <atom>+ 
    <atom>       ::= ? any token that is not a parenthesis or quote ?
    <identifier> ::= defined by lexcial rule.
    <double-quote> ::= ASCII 34
    <bracket-blanced-sequence> := flatten bracket blanced token tree.
    <hole>       ::= error recovery node

    === string interpolation rule
    
    <interpolation_string> ::= <double-quote> <string_segment>* <double-quote>
    <string_segment> ::= <raw_string> | <interpolation> 

    <interpolation> ::= '{' <expression> '}'
    <raw_string>  ::= 
      NOT include <left-curly-bracket> and <right-curly-bracket> sequences.


  language feature:
    - simple type system            ✅
    - toplevel mutual recursion     ✅
    - record type                   ✅
    - subtyping                     ✅   
    - pattern match (type dispatch) ✅
    - string interpolation          ✅
    - first order function          ✅
    - path resolution               ✅
      - toplevel module access      ✅
      - local field access          ✅
    - scope expression              ✅
    - main entry point              ✅

  not support yet:
    - higher order function     ❌
    - polymorphism             ❌
    - multi-stage programming  ❌
    - inheritance              ❌
    - toplevel value           ❌

  toolchain:
    - interpreter
        - diagnostic                   ✅
        - stack trace                  ✅
    - vscode extension
    - completion
      - module access                  ✅
      - field access                   ✅
      - type refine                    ✅
    - renaming                        
      - toplevel symbol in binder      ✅
      - toplevel symbol in variable    ❌
      - local variable                 ❌
      - record field                   ❌
      - toplevel type                  ❌
    - hover
      - local variable                 ✅
      - toplevel variable              ❌
    
    - accurate source location for diagnostic ✅
      - e.g. lone delimiter, mismatch delimiter, extra diagnostic family, missing diagnostic family
    - diagnostic
      - structure 
        - lone delimiter              ✅
        - mismatch delimiter          ✅
      - syntax
        - missing <child> in <parent> (family) ✅
        - extra <syntax> in <parent>  (family) ✅
        - invalid local binder                 ✅
        - expected <expr>                      ✅
        - unexpected <expr>                    ✅
        - expected <function> or <constructor> ✅
        - expected <lambda>                    ✅
        - expected <function> or <constructor> ✅
        - missing <argument> in <application>  ✅
        - extra <argument> in <application>    ✅

      - scope
        - unresolved toplevel symbol  ✅
        - unbound local variable      ✅
        - missing <name> in scope     ✅
        - name conflict               ✅
      - type
        - expected type                       ✅
        - expected record type                ✅
        - expected unit record type           ✅
        - expected record type in <variant>   ✅

      - pattern match 
        - non exhaustive <pattern> in <match>            ✅
        - expected <expr> has inductive type in <match>  ✅
        - expected type annotation for <match>           ✅
        - inaccessible record field                      ✅
      - ICE: 
        - ICE: not implemented intrinsic function      ✅

  WARNING: (doc ... ) is comment syntax, `;` not the comment syntax.

)



(doc ============================================================ )

(doc intrinsic type )
(record int)
(record str )
(record unit)

(inductive ordering less equal greater)
(record less)
(record equal)
(record greater)


(doc intrinsic function, lambda body just placeholder )
(let int.add (lambda ((lft int) (rht int) int) 0))
(let int.sub (lambda ((lft int) (rht int) int) 0))
(let int.cmp (lambda ((lft int) (rht int) ordering) equal))
(let str.cmp (lambda ((lft str) (rht str) ordering) equal))

(doc 

Sophia programming language not support any type now, but println accept all types.

(let println
  (lambda ((self any) unit) unit))

)

(doc ============================================================ )

(doc 

  inductive type defines subtyping over record-typed variants, 
  with pattern matching refining types for local binder and 
  exhaustiveness statically checked against all clauses.

  record type has the same name as its constructor.

  types and modules support overloading.

  toplevel binder includes dots to denote namespaces. (e.g. `bool.and` is valid toplevel binder.)
  local binder must not contains dot.

  name resolution: 
    - toplevel symbols is unique identifier. (e.g. std.array.truncate )
    - local symbols using path resolution for record field access.
    - outer binder can be shadow by inner binder, but can not conflict with toplevel binder.

  )

(inductive bool true false)
(record true)
(record false)

(let bool.and
  (lambda ((lft bool) (rht bool) bool)
    (match lft
      (true (match rht
        (true true)
        (false false)))
      (false false))))

(let bool.or 
  (lambda ((lft bool) (rht bool) bool)
    (match lft
      (true true)
      (false (match rht
        (true true)
        (false false )
        )))))

(let bool.not 
  (lambda ((self bool) bool)
    (match self
      (true false)
      (false true))))

(let bool.test
  (lambda (unit) (scope
    (println "(bool.and true true):   {(bool.and true true)}")
    (println "(bool.and true false):  {(bool.and true false)}")
    (println "(bool.and false true):  {(bool.and false true)}")
    (println "(bool.and false false): {(bool.and false false)}")

    (println "(bool.or true true):   {(bool.or true true)}")
    (println "(bool.or true false):  {(bool.or true false)}")
    (println "(bool.or false true):  {(bool.or false true)}")
    (println "(bool.or false false): {(bool.or false false)}")

    (println "(bool.not true):  {(bool.not true)}")
    (println "(bool.not false): {(bool.not false)}")

    unit)))        
(doc ============================================================ )

(record nil)
(record cons (head int) (tail list))
(inductive list cons nil)

(doc list utility )

(let list.reverse 
  (lambda ((xs list) list)
    (list.reverse_append xs nil)))

(let list.reverse_append
  (lambda ((xs list) (ys list) list)
    (match xs
      (nil ys)
      (cons (list.reverse_append xs.tail (cons xs.head ys))))))

(let list.length
  (lambda ((xs list) int)
    (match xs 
      (nil 0)
      (cons (int.add 1 (list.length xs.tail))))))

(let list.to_string_aux
  (lambda ((xs list) str)
    (match xs
      (nil "")
      (cons " {xs.head}{(list.to_string_aux xs.tail)}"))))

(let list.to_string
  (lambda ((xs list) str)
    (match xs 
      (nil "nil")
      (cons "(list{(list.to_string_aux xs)})"))))


(doc recursion examples )

(let list.print
  (lambda ((xs list) unit)
    (match xs
      (nil unit)
      (cons (scope
        (println xs.head)
        (list.print xs.tail)
        unit)))))

(let list.add1
  (lambda ((xs list) list)
    (match xs
      (nil xs)
      (cons (cons (int.add 1 xs.head) (list.add1 xs.tail))))))


(let list.test
  (lambda (unit) (scope
    (let xs (cons 1 (cons 2 (cons 3 (cons 4 nil)))))
    (println xs)
    (println (list.length xs))

    (println (list.to_string xs))
    unit)))

(doc ============================================================ )

(record position (character int) (line int))
(record range (start position) (end position))

(doc record as constructor examples )
(let position.test 
  (lambda (unit) (scope
    (let start (position 10 20))
    (let end start)

    (println (range start end))

    (println "line: {start.line}")
    (println "character: {start.character}")
    unit)))


(doc ============================================================ )
(doc NEB example )
(doc normalization by evaluation (untyped version ) )
(doc norm function fuze eval/quote into norm )
(record var (name str))
(record abs (param str) (body exp))
(record app (func exp) (args exp))
(inductive exp  var abs app)

(record env.nil)
(record env.cons (name str) (val exp) (tail env))
(inductive env env.nil env.cons)

(let env.lookup
  (lambda ((self env) (name str) exp)
    (match self
      (env.nil abort)
      (env.cons (match (str.cmp self.name name)
        (equal self.val)
        (less (env.lookup self.tail name))
        (greater (env.lookup self.tail name)))))))

(let env.contains
  (lambda ((self env) (name str) bool)
    (match self
      (env.nil false)
      (env.cons (match (str.cmp self.name name)
        (equal true)
        (less (env.contains self.tail name))
        (greater (env.contains self.tail name)))))))

(let fresh 
  (lambda ((self env) (name str) (n int) str)
    (match (env.contains self name)
      (true (scope
        (fresh self "{name}{n}" (int.add n 1))) )
      (false name))))

(let norm 
  (lambda ((e env) (self exp) exp)
    (match self
      (var (env.lookup e self.name))
      (doc eta-expansion )
      (abs (scope
        (let binder (fresh e self.param 1))
        (let x (var binder))
        (let new_e (env.cons self.param x e))
        (let body (norm new_e self.body))
        (abs binder body)))
      (app (scope
        (let funs (norm e self.func))
        (let args (norm e self.args))
        (doc beta reduction )
        (match funs
          (abs (scope
            (let new_e (env.cons funs.param args e))
            (norm new_e funs.body)))
          (var (app funs args))
          (app (app funs args)))
          )))))

(let exp.debug
  (lambda ((self exp) str)
    (match self
      (var self.name)
      (app (scope 
        (let func (exp.debug self.func))
        (let args (exp.debug self.args))
        "({func} {args})"
        ))
      (abs (scope
        (let param self.param)
        (let body (exp.debug self.body))
        "(lambda {param} {body})")))))

(let norm_examples 
  (lambda (unit)
    (scope 
    (let add 
      (abs "m"
        (abs "n"
          (abs "f"
            (abs "x"
              (app
                (app (var "m") (var "f"))
                (app
                  (app (var "n") (var "f"))
                  (var "x"))))))))

    (let mul
      (abs "m"
        (abs "n"
          (abs "f"
            (app
              (var "m")
              (app (var "n") (var "f")))))))

    (let zero
      (abs "f"
        (abs "x"
          (var "x"))))

    (let one
      (abs "f"
        (abs "x"
          (app (var "f") (var "x")))))

    (let cas
      (abs "x"
        (app
          (abs "y" (abs "x" (var "y")))
          (var "x"))))
    (let add1 (app add one))
    (let two (app add1 one))
    (let three (app add1 two))
    (let four (app add1 three))
    (let five (app add1 four))
    (let nf_five (norm env.nil five))
    (let num_25 (app (app mul five) five))
    (let nf_num_25 (norm env.nil num_25))
    (let nf_cas (norm env.nil cas))

    (println (exp.debug nf_cas))
    (println (exp.debug nf_five))
    (println (exp.debug nf_num_25))

    )))

(doc ============================================= )

(let playground.foo
  (lambda (unit) (scope
    (playground.bar)
    unit)))

(let playground.bar
  (lambda (unit) (scope
    (playground.qux)
    unit)))

(let playground.qux
  (lambda (unit) (scope
    abort
    unit)))

(let playground.stack_trace
  (lambda (unit) (playground.foo)))
(doc ============================================= )

(doc user defined int function )
(let int.eq 
  (lambda ((lft int) (rht int) bool)
    (match (int.cmp lft rht)
      (equal true)
      (less true)
      (greater false))))

(let int.mul.step 
  (lambda ((lft int) (rht int) int)
    (scope
        (let next_lft (int.sub lft 1))
        (let rslt (int.mul next_lft rht))
        (int.add rht rslt))))

(let int.mul 
  (lambda ((lft int) (rht int) int)
    (match (int.eq lft 0)
      (true 0)
      (false (int.mul.step lft rht)))))

(doc ============================================= )

(let foo
  (lambda (unit) (scope
    unit)))


(let main
  (lambda (unit) (scope 
    (doc (bool.test) )
    
    (doc (list.test) )
    
    (playground.stack_trace)

    unit)))
