;;;======================================================
;;;   Who Drinks Water? And Who owns the Zebra?
;;;
;;;     Another puzzle problem in which there are five
;;;     houses, each of a different color, inhabited by
;;;     men of different nationalities, with different
;;;     pets, drinks, and cigarettes. Given the initial
;;;     set of conditions, it must be determined which
;;;     attributes are assigned to each man.
;;;
;;;     Jess version 4.1 example
;;;
;;;     To execute, merely load, reset and run.
;;;======================================================

;(set-node-index-hash 13)

/* Template for one attribute of a house.
*  Has a slot a for the name of the attribute, a slot v for the value of the attribute,
*/ and a slot h for the integer index of the house it applies to.
(deftemplate avh  (slot a)  (slot v)  (slot h (type INTEGER)))

(defrule find-solution
  ; The Englishman lives in the red house.

  (avh (a nationality) (v englishman) (h ?n1))                   ; the Englishman lives in the house n1.
  (avh (a color) (v red) (h ?c1 & ?n1))                          ; the house n1=c1 is red.

  ; The Spaniard owns the dog.

  (avh (a nationality) (v spaniard) (h ?n2 & ~?n1))              ; the Spaniard lives in the house p1=n2, which is a different house than n1.
  (avh (a pet) (v dog) (h ?p1 & ?n2))                            ; the house p1=n2 has a pet dog.

  ; The ivory house is immediately to the left of the green house,
  ; where the coffee drinker lives.

  (avh (a color) (v ivory) (h ?c2&~?c1))                         ; the house c2 is ivory, which is a different house from c1 (the red house).
  (avh (a color) (v green) (h ?c3&~?c2&~?c1&:(= (+ ?c2 1) ?c3))) ; the house c3 is green, which is a different house from c2 and c1 (the ivory and red houses).
                                                                 ; c3 is also to the right of c2.
  (avh (a drink) (v coffee) (h ?d1&?c3))                         ; the house d1=c3 drinks coffee.

  ; The milk drinker lives in the middle house.

  (avh (a drink) (v milk) (h ?d2&~?d1&3))                        ; the house d2 drinks milk, which is a different house than d1 (who drinks coffee).

  ; The man who smokes Old Golds also keeps snails.

  (avh (a smokes) (v old-golds) (h ?s1))                         ; the house s1 smokes Old Golds.
  (avh (a pet) (v snails) (h ?p2&~?p1&?s1))                      ; the house p2=s1 has snails, which is a different house from p1 (which has a dog).

  ; The Ukrainian drinks tea.

  (avh (a nationality) (v ukrainian) (h ?n3&~?n2&~?n1))          ; the Ukrainian lives in the house n3, which is different from n2 and n1 (who are Spanish and English).
  (avh (a drink) (v tea) (h ?d3&~?d2&~?d1&?n3))                  ; the house d3=n3 drinks tea, which is a different houes from d2 and d1 (who drink milk and coffee).

  ; The Norwegian resides in the first house on the left.

  (avh (a nationality) (v norwegian) (h ?n4&~?n3&~?n2&~?n1&1))   ; the Norwegian lives in house n4=1, which is different from n3, n2, and n1
                                                                 ; (who are Ukrainian, Spanish, and English).

  ; Chesterslots smoker lives next door to the fox owner.

  (avh (a smokes) (v chesterfields) (h ?s2&~?s1))                                    ; the Chesterfields smoker lives in the house s2, which is different from s1
                                                                                     ; (who smokes Old Golds).
  (avh (a pet) (v fox) (h ?p3&~?p2&~?p1&:(or (= ?s2 (- ?p3 1)) (= ?s2 (+ ?p3 1)))))  ; the house p3 has a pet fox, which is a different house from p2 and p1
                                                                                     ; (who have snails and a dog).
                                                                                     ; p3 is also next to s2 (the Chesterfields smoker).

  ; The Lucky Strike smoker drinks orange juice.

  (avh (a smokes) (v lucky-strikes) (h ?s3&~?s2&~?s1))           ; the Lucky Strike smoker lives in house s3, which is different from s2 and s1
                                                                 ; (where the Chesterfields and Old Golds smokers live).
  (avh (a drink) (v orange-juice) (h ?d4&~?d3&~?d2&~?d1&?s3))    ; the house d4=s3 drinks orange juice, which is different from d3, d2, and d1
                                                                 ; (who drink tea, milk, and coffee).

  ; The Japanese smokes Parliaments

  (avh (a nationality) (v japanese) (h ?n5&~?n4&~?n3&~?n2&~?n1)) ; the Japanese lives in house n5, which is not n4, n3, n2, or n1
                                                                 ; (where the Norwegian, Ukrainian, Spanish, and English live).
  (avh (a smokes) (v parliaments) (h ?s4&~?s3&~?s2&~?s1&?n5))    ; The house s4=n5 smokes Parliaments, which is not s3, s2, or s1
                                                                 ; (who smoke Lucky Strikes, Chesterfields, and Old Golds).

  ; The horse owner lives next to the Kools smoker,
  ; whose house is yellow.

  ; the house p4 has a pet horse, which is a different house from p3, p2, and p1 (which have a fox, snails, and a dog).
  (avh (a pet) (v horse) (h ?p4&~?p3&~?p2&~?p1))

  ; The house s5 smokes kools, wwhich is different from s4, s3, s2, and s1 (who smoke Parliaments, Lucky Strikes, Chesterfields, and Old Golds).
  (avh (a smokes) (v kools) (h ?s5&~?s4&~?s3&~?s2&~?s1&:(or (= ?p4 (- ?s5 1)) (= ?p4 (+ ?s5 1)))))
  ; the house c4=s5 is yellow, which is different from c3, c2, and c1 (which are green, ivory, and red)
  (avh (a color) (v yellow) (h ?c4&~?c3&~?c2&~?c1&?s5))

  ; The Norwegian lives next to the blue house.

  (avh (a color) (v blue) (h ?c5&~?c4&~?c3&~?c2&~?c1&:(or (= ?c5 (- ?n4 1)) (= ?c5 (+ ?n4 1)))))   ; the house c5 is blue, which is different from the houses c4, c3,
                                                                                                   ; c2, and c1 (which are yellow, green, ivory, and red).
                                                                                                   ; c5 is next to n4 (where the Norwegian lives).

  ; Who drinks water?  And Who owns the zebra?

  (avh (a drink) (v water) (h ?d5&~?d4&~?d3&~?d2&~?d1)) ; The person who drinks water lives in d5, which is not
                                                        ; d4, d3, d2, or d1 (who drink orange juice, tea, milk, and coffee.
  (avh (a pet) (v zebra) (h ?p5&~?p4&~?p3&~?p2&~?p1))   ; The pet zebra is in house p5, which is a different house from
                                                        ; p4, p3, p2, and p1 (who have a horse, a fox, snails, and a dog).

  =>
  (assert (solution nationality englishman ?n1) ; after matching the pattern for the color, nationality, pet, drinks, and smokes
          (solution color red ?c1)              ; for each house in a manner that solves the problem, asserts each attribute with the
          (solution nationality spaniard ?n2)   ; house number that it matches, labeling it as the solution.
          (solution pet dog ?p1)
          (solution color ivory ?c2)
          (solution color green ?c3)
          (solution drink coffee ?d1)
          (solution drink milk ?d2)
          (solution smokes old-golds ?s1)
          (solution pet snails ?p2)
          (solution nationality ukrainian ?n3)
          (solution drink tea ?d3)
          (solution nationality norwegian ?n4)
          (solution smokes chesterfields ?s2)
          (solution pet fox ?p3)
          (solution smokes lucky-strikes ?s3)
          (solution drink orange-juice ?d4)
          (solution nationality japanese ?n5)
          (solution smokes parliaments ?s4)
          (solution pet horse ?p4)
          (solution smokes kools ?s5)
          (solution color yellow ?c4)
          (solution color blue ?c5)
          (solution drink water ?d5)
          (solution pet zebra ?p5))
  )

/*
* Prints out the numbers, nationalities, colors, pets, drinks, and smokes of each house in the solution asserted in find-solution.
*/
(defrule print-solution
  ?f1 <- (solution nationality ?n1 1)
  ?f2 <- (solution color ?c1 1)
  ?f3 <- (solution pet ?p1 1)
  ?f4 <- (solution drink ?d1 1)
  ?f5 <- (solution smokes ?s1 1)
  ?f6 <- (solution nationality ?n2 2)
  ?f7 <- (solution color ?c2 2)
  ?f8 <- (solution pet ?p2 2)
  ?f9 <- (solution drink ?d2 2)
  ?f10 <- (solution smokes ?s2 2)
  ?f11 <- (solution nationality ?n3 3)
  ?f12 <- (solution color ?c3 3)
  ?f13 <- (solution pet ?p3 3)
  ?f14 <- (solution drink ?d3 3)
  ?f15 <- (solution smokes ?s3 3)
  ?f16 <- (solution nationality ?n4 4)
  ?f17 <- (solution color ?c4 4)
  ?f18 <- (solution pet ?p4 4)
  ?f19 <- (solution drink ?d4 4)
  ?f20 <- (solution smokes ?s4 4)
  ?f21 <- (solution nationality ?n5 5)
  ?f22 <- (solution color ?c5 5)
  ?f23 <- (solution pet ?p5 5)
  ?f24 <- (solution drink ?d5 5)
  ?f25 <- (solution smokes ?s5 5)
  =>
  (retract ?f1 ?f2 ?f3 ?f4 ?f5 ?f6 ?f7 ?f8 ?f9 ?f10 ?f11 ?f12 ?f13 ?f14 ; I don't know why it retracts all of the rules here.
           ?f15 ?f16 ?f17 ?f18 ?f19 ?f20 ?f21 ?f22 ?f23 ?f24 ?f25)
  (printout t "HOUSE | Nationality Color Pet Drink Smokes" crlf)
  (printout t "--------------------------------------------------------------------" crlf)
  (printout t "  1   |" ?n1 " " ?c1 " " ?p1 " " ?d1 " " ?s1 crlf)
  (printout t "  2   |" ?n2 " " ?c2 " " ?p2 " " ?d2 " " ?s2 crlf)
  (printout t "  3   |" ?n3 " " ?c3 " " ?p3 " " ?d3 " " ?s3 crlf)
  (printout t "  4   |" ?n4 " " ?c4 " " ?p4 " " ?d4 " " ?s4 crlf)
  (printout t "  5   |" ?n5 " " ?c5 " " ?p5 " " ?d5 " " ?s5 crlf)
  (printout t crlf crlf))

/*
* The startup rule has no left hand side, so it will always fire first.
*/
(defrule startup
   =>
   (printout t
    "There are five houses, each of a different color, inhabited by men of"  crlf
    "different nationalities, with different pets, drinks, and cigarettes."  crlf
    crlf
    "The Englishman lives in the red house.  The Spaniard owns the dog."     crlf
    "The ivory house is immediately to the left of the green house, where"   crlf
    "the coffee drinker lives.  The milk drinker lives in the middle house." crlf
    "The man who smokes Old Golds also keeps snails.  The Ukrainian drinks"  crlf
    "tea.  The Norwegian resides in the first house on the left.  The"       crlf)
   (printout t
    "Chesterfields smoker lives next door to the fox owner.  The Lucky"      crlf
    "Strike smoker drinks orange juice.  The Japanese smokes Parliaments."   crlf
    "The horse owner lives next to the Kools smoker, whose house is yellow." crlf
    "The Norwegian lives next to the blue house."			     crlf
    crlf
    "Now, who drinks water?  And who owns the zebra?" crlf crlf)
    /*
    * Asserts all of the attributes in the problem, each of which will be eventually assigned to a house.
    */
   (assert (value color red)
           (value color green)
           (value color ivory)
           (value color yellow)
           (value color blue)
           (value nationality englishman)
           (value nationality spaniard)
           (value nationality ukrainian)
           (value nationality norwegian)
           (value nationality japanese)
           (value pet dog)
           (value pet snails)
           (value pet fox)
           (value pet horse)
           (value pet zebra)
           (value drink water)
           (value drink coffee)
           (value drink milk)
           (value drink orange-juice)
           (value drink tea)
           (value smokes old-golds)
           (value smokes kools)
           (value smokes chesterfields)
           (value smokes lucky-strikes)
           (value smokes parliaments))
   )

/*
* Generates all of the possible colors, nationalities, pets, drinks, and smokes for each house number by
* asserting every possible attribute with each house.
*/
(defrule generate-combinations
    ?f <- (value ?s ?e)                  ; matches the pattern of an example attribute type and value
   =>
   (retract ?f)                          ; retracts the example attribute since it is no longer needed
   (assert (avh (a ?s) (v ?e) (h 1))     ; asserts each attribute to every house number
           (avh (a ?s) (v ?e) (h 2))     ; so the find-solution rule can match the solution
           (avh (a ?s) (v ?e) (h 3))     ; from a combination of these facts.
           (avh (a ?s) (v ?e) (h 4))
           (avh (a ?s) (v ?e) (h 5))))


/*
* Sets the time to a global variable, which by default is changed back to its original value by the (reset) command.
* Then changes the property of global variables to maintain their current value after (reset), even if they were modified after
* their declaration.
*/
(defglobal ?*time* = (time))
(set-reset-globals FALSE)

/*
* Runs the rule engine n times, resetting all facts before each run and allowing the time to be measured for multiple runs.
*/
(deffunction run-n-times (?n)
  (while (> ?n 0) do
         (reset)
         (run)
         (bind ?n (- ?n 1))))

(run-n-times 1)

(printout t "Elapsed time: " (integer (- (time) ?*time*)) crlf)
