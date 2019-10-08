/*
*
*/
(clear)
(reset)
; (deftemplate val (slot n) (slot k))

(defrule threeUnknown
   (declare (salience 1))
   (val ?v1 FALSE)
   (val ?v2&~?v1 FALSE)
   (val ?v3&~?v2&~?v1 FALSE)
   =>
   (printout t "Three or more values unknown" crlf)
   (halt)
)

(defrule know3
   (declare (salience 1))
   (val ?v1 TRUE)
   (val ?v2&~?v1 TRUE)
   (val ?v3&~?v2&~?v1 TRUE)
   =>
   (assert (threeKnown))
)

(defrule dontCareT
   (val t FALSE)
   (val ?v1 TRUE)
   (val ?v2&~?v1 TRUE)
   (val ?v3&~?v2&~?v1 TRUE)
   (val ?v4~?v3&~?v2&~?v1 TRUE)
   =>
   (printout t "You want to use the equation 2aΔs = v²-v₀²")
)

(defrule dontCareV
   (val v FALSE)
   (val ?v1 TRUE)
   (val ?v2&~?v1 TRUE)
   (val ?v3&~?v2&~?v1 TRUE)
   (val ?v4~?v3&~?v2&~?v1 TRUE)
   =>
   (printout t "You want to use the equation Δs = v₀t + ½at²")
)

(defrule dontCareVZero
   (val vZero FALSE)
   (val ?v1 TRUE)
   (val ?v2&~?v1 TRUE)
   (val ?v3&~?v2&~?v1 TRUE)
   (val ?v4~?v3&~?v2&~?v1 TRUE)
   =>
   (printout t "You want to use the equation Δs = vt - ½at²")
)

(defrule dontCareA
   (val a FALSE)
   (val ?v1 TRUE)
   (val ?v2&~?v1 TRUE)
   (val ?v3&~?v2&~?v1 TRUE)
   (val ?v4~?v3&~?v2&~?v1 TRUE)
   =>
   (printout t "You want to use the equation Δs = ½(v + v₀t)")
)

(defrule dontCareDeltaS
   (val deltaS FALSE)
   (val ?v1 TRUE)
   (val ?v2&~?v1 TRUE)
   (val ?v3&~?v2&~?v1 TRUE)
   (val ?v4~?v3&~?v2&~?v1 TRUE)
   =>
   (printout t "You want to use the equation v = v₀ + at")
)



(defrule askVelocity
   (not (val v TRUE))
   (not (threeKnown))
   =>
   (assert (val v (askKnown "velocity")))
)

(defrule askVZero
   (not (val vZero TRUE))
   (not (threeKnown))
   =>
   (assert (val vZero (askKnown "initial velocity")))
)

(defrule askAcceleration
   (not (val a TRUE))
   (not (threeKnown))
   =>
   (assert (val a (askKnown "acceleration")))
)

(defrule askDeltaS
   (not (val deltaS TRUE))
   (not (threeKnown))
   =>
   (assert (val deltaS (askKnown "displacement")))
)

(defrule askTime
   (not (val t TRUE))
   (not (threeKnown))
   =>
   (assert (val t (askKnown "time")))
)

(defrule wantVelocity
   (not (val v TRUE))
   (threeKnown)
   =>
   (assert (val v (askWant "velocity")))
)

(defrule wantVZero
   (not (val vZero TRUE))
   (threeKnown)
   =>
   (assert (val vZERO (askWant "initial velocity")))
)

(defrule wantAcceleration
   (not (val a TRUE))
   (threeKnown)
   =>
   (assert (val a (askWant "acceleration")))
)

(defrule wantDeltaS
   (not (val deltaS TRUE))
   (threeKnown)
   =>
   (assert (val deltaS (askWant "displacement")))
)

(defrule wantTime
   (not (val t TRUE))
   (threeKnown)
   =>
   (assert (val t (askWant "time")))
)

/*
* Prompts the user for input and returns the first token entered.
*/
(deffunction ask (?prompt)
   (printout t ?prompt "? ")
   (bind ?response (read))
   (return ?response)
)

(deffunction askYesNo (?prompt)
   (bind ?answer "")
   (while (and (<> (str-compare ?answer "y") 0) (<> (str-compare ?answer "n") 0))
      (printout t ?prompt " (y/n)? ")
      (bind ?answer (lowcase (sub-string 1 1 (read))))
   )
   (return (= (str-compare ?answer "y") 0))
)

/*
*
*/
(deffunction askKnown (?var)
   (return (askYesNo (str-cat "Do you know the " ?var)))
)

/*
*
*/
(deffunction askWant (?var)
   (return (askYesNo (str-cat "Do you want to know the " ?var)))
)

(run)
