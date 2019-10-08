/*
** Another example of using backward chaining with a template.
**
** Notice that only half of the backward chaining takes place if you just use a ? in the (need-) construct.
** Once a slot has been resolved with this syntax, all slots for that template instance are considered resolved
** (in this case, all patterns with (modern no) with that template.
**
** There is a work around however, if you use a variable in the (need-) construct rather than just
** a question mark then both backward chained rules fire. Checking for nil prevents the same (need-) rule
** from multiple firings. Play with the code and see what it does.
*/

(clear)
(reset)

(deftemplate music (slot classical) (slot modern))

(do-backward-chaining music)

(defrule classicalBackward "Rule to Backward-Chain the characteristic Classical"
    (need-music (classical ?x &~nil))
    =>
    (printout t "asserting classical to no" crlf)
    (assert (music (classical yes)))
)

(defrule modernBackward "Rule to Backward-Chain the characteristic Modern"
    (need-music (modern ?x  &~nil))
    =>
    (printout t "asserting modern to no" crlf)
    (assert (music (modern no)))
)


(defrule rule4 "match on classical yes"
    (music (classical yes))
    =>
    (printout t "classical yes" crlf)
)


(defrule rule3 "match on modern no"
    (music (modern no))
    =>
    (printout t "modern no" crlf)
)

(reset)
(run)
