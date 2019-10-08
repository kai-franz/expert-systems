/*
* Tries to guess an animal the user is thinking of by asking yes/no questions.
*
* Kai Franz
* November 15, 2018
*/



(clear)
(reset)

(do-backward-chaining tentacles)
(do-backward-chaining stings)
(do-backward-chaining fish)
(do-backward-chaining twoTentacles)
(do-backward-chaining eightTentacles)
(do-backward-chaining water)
(do-backward-chaining sucksBlood)
(do-backward-chaining stinger)
(do-backward-chaining blob)
(do-backward-chaining bright)
(do-backward-chaining orange)
(do-backward-chaining shell)
(do-backward-chaining flies)
(do-backward-chaining under4Legs)
(do-backward-chaining food)
(do-backward-chaining pink)
(do-backward-chaining antarctica)
(do-backward-chaining dinosaur)
(do-backward-chaining pet)
(do-backward-chaining birdOfPrey)
(do-backward-chaining swim)
(do-backward-chaining big)
(do-backward-chaining fourLegs)
(do-backward-chaining tail)
(do-backward-chaining frog)
(do-backward-chaining amphibian)
(do-backward-chaining lizard)
(do-backward-chaining florida)
(do-backward-chaining yellow)
(do-backward-chaining honey)
(do-backward-chaining eightLegs)
(do-backward-chaining pet)
(do-backward-chaining ocean)
(do-backward-chaining stripes)
(do-backward-chaining spines)


(defglobal ?*questions* = 0)

/*
* Asks the user a yes or no question and returns either "y", "n", or "d" (which stands for "don't know")
* Keeps prompting until the user answers with something that starts with either y, n, or ?, case insensitive
*/
(deffunction askYND (?prompt)
   (bind ?*questions* (+ ?*questions* 1))
   
   (bind ?answer "")
   (bind ?shortAns "")
   
   (while (and (<> (str-compare ?answer "?") 0) (<> (str-compare ?answer "y") 0) (<> (str-compare ?answer "n") 0))
      (printout t ?*questions* ". " ?prompt " (y/n/?)? ")
      (bind ?answer (lowcase (sub-string 1 1 (read))))
   )
   
   (if (= (str-compare ?answer "?") 0) then
      (bind ?shortAns d)
   elif (= (str-compare ?answer "y") 0) then
      (bind ?shortAns y)
   else
      (bind ?shortAns n)
   )
   
   (return ?shortAns)
) ; (deffunction askYND (?prompt)

/*
* Asks a question "Is it a ______" or "Is it an ______", depending on
* whether or not the string starts with a vowel.
*/
(deffunction isItA (?str)
   (bind ?ans "")
   (if (or (= (str-compare (sub-string 1 1 ?str) "a") 0)
         (= (str-compare (sub-string 1 1 ?str) "e") 0)
         (= (str-compare (sub-string 1 1 ?str) "i") 0)
         (= (str-compare (sub-string 1 1 ?str) "o") 0)
         (= (str-compare (sub-string 1 1 ?str) "u") 0)) then
      (bind ?ans (askYND (str-cat "Is it an " ?str "?")))
   else
     (bind ?ans (askYND (str-cat "Is it a " ?str "?")))
   )
   (return ?ans)
)

/*
* These three functions provide shorthand methods for asking the user questions about the animal.
*/

(deffunction isIt (?str)
    (return (askYND (str-cat "Is it " ?str "?")))
)

(deffunction doesIt (?str)
   (return (askYND (str-cat "Does it " ?str "?")))
)

(deffunction doesItHave (?str)
   (return (askYND (str-cat "Does it have " ?str "?")))
)


/*
* Asks the user if the given animal is the one they are thinking of, then
* ends the game.
*/
(deffunction guess (?animal)
   (if (not (= (str-compare (isItA ?animal) "y") 0)) then
      (printout t "I give up." crlf)
   )
   (printout t "Total questions: "?*questions* crlf)
   (halt)
)


/*
* Startup rule - asks if it is a mammal.
*/
(defrule startup
   =>
   (assert (mammal (isItA "mammal")))
)

/*
* If it is not a mammal, ask if it has legs.
*/
(defrule notMammal
   (mammal n)
   =>
   (assert (legs (doesItHave "legs")))
)

/*
* These following rules backward chain any characteristics of the animal that are needed.
*/

(defrule needFish
   (need-fish ?)
   =>
   (assert (fish (isItA "fish")))
)

(defrule needTentacles
   (need-tentacles ?)
   =>
   (assert (tentacles (doesItHave "tentacles")))
)

(defrule needStings
   (need-stings ?)
   =>
   (assert (stings (doesIt "sting")))
)

(defrule needTwoTentacles
   (need-twoTentacles ?)
   =>
   (assert (twoTentacles (doesItHave "exactly two tentacles")))
)

(defrule needEightTentacles
   (need-eightTentacles ?)
   =>
   (assert (eightTentacles (doesItHave "exactly eight tentacles")))
)

(defrule needSucksBlood
   (need-sucksBlood ?)
   =>
   (assert (sucksBlood (doesIt "suck blood")))
)

(defrule needStinger
   (need-stinger ?)
   =>
   (assert (stinger (doesItHave "a stinger")))
)

(defrule needBlob
   (need-blob ?)
   =>
   (assert (blob (doesIt "look like a blob")))
)

(defrule needBright
   (need-bright ?)
   =>
   (assert (bright (isIt "brightly colored")))
)

(defrule needOrange
   (need-orange ?)
   =>
   (assert (orange (isIt "orange")))
)

(defrule needWater
   (need-water ?)
   =>
   (assert (water (doesIt "live in water")))
)

(defrule needShell
   (need-shell ?)
   =>
   (assert (shell (doesItHave "a shell")))
)

(defrule needFlies
   (need-flies ?)
   =>
   (assert (flies (doesIt "fly")))
)

(defrule needUnder4Legs
   (need-under4Legs ?)
   =>
   (assert (under4Legs (doesItHave "fewer than 4 legs")))
)

(defrule needFood
   (need-food ?)
   =>
   (assert (food (isItA "common food")))
)

(defrule needPink
   (need-pink ?)
   =>
   (assert (pink (isIt "pink")))
)

(defrule needAntarctica
   (need-antarctica ?)
   =>
   (assert (antarctica (doesIt "live in Antarctica")))
)

(defrule needDinosaur
   (need-dinosaur ?)
   =>
   (assert (dinosaur (isItA "type of dinsoaur")))
)

(defrule needParrot
   (need-parrot ?)
   =>
   (assert (parrot (isItA "type of parrot")))
)

(defrule needBirdOfPrey
   (need-birdOfPrey ?)
   =>
   (assert (birdOfPrey (isItA "bird of prey")))
)

(defrule needSwim
   (need-swim ?)
   =>
   (assert (swim (doesIt "swim")))
)

(defrule needBig
   (need-big ?)
   =>
   (assert (big (isIt "bigger than a person")))
)

(defrule needFourLegs
   (need-fourLegs ?)
   =>
   (assert (fourLegs (doesItHave "4 legs")))
)

(defrule needTail
   (need-Tail ?)
   =>
   (assert (tail (doesItHave "a long tail")))
)

(defrule needFrog
   (need-frog ?)
   =>
   (assert (frog (isItA "type of frog")))
)

(defrule needAmphibian
   (need-amphibian ?)
   =>
   (assert (amphibian (isIt "an amphibian")))
)

(defrule needLizard
   (need-lizard ?)
   =>
   (assert (lizard (isItA "type of lizard")))
)

(defrule needFlorida
   (need-florida ?)
   =>
   (assert (florida (doesIt "live in Florida")))
)

(defrule needYellow
   (need-yellow ?)
   =>
   (assert (yellow (isIt "yellow")))
)

(defrule needHoney
   (need-honey ?)
   =>
   (assert (honey (doesIt "make honey")))
)

(defrule needEightLegs
   (need-eightLegs ?)
   =>
   (assert (eightLegs (doesItHave "eight legs")))
)

(defrule needPet
   (need-pet ?)
   =>
   (assert (pet (isItA "common household pet")))
)

(defrule needOcean
   (need-ocean ?)
   =>
   (assert (ocean (doesIt "live in the ocean")))
)

(defrule needStripes
   (need-stripes ?)
   =>
   (assert (stripes (doesItHave "stripes")))
)

(defrule needSpines
   (need-spines ?)
   =>
   (assert (spines (doesItHave "quills")))
)

/*
* The following rules identify an animal based on their characteristics and ask
* the user if the identified animal is correct.
*/

(defrule jellyfish
   (mammal n)
   (legs n)
   (fish n)
   (tentacles y)
   (stings y)
   =>
   (guess "jellyfish")
)

(defrule cuttlefish
   (mammal n)
   (legs n)
   (or (fish n) (fish d))
   (tentacles y)
   (twoTentacles y)
   =>
   (guess "cuttlefish")
)

(defrule octopus
   (mammal n)
   (legs n)
   (fish n)
   (tentacles y)
   (eightTentacles y)
   =>
   (guess "octopus")
)

(defrule snail
   (mammal n)
   (legs n)
   (fish n)
   (tentacles n)
   (water n)
   (shell y)
   =>
   (guess "snail")
)

(defrule boaConstrictor
   (mammal n)
   (legs n)
   (fish n)
   (tentacles n)
   (water n)
   (shell n)
   =>
   (guess "boa constrictor")
)

(defrule sandDollar
   (mammal n)
   (legs n)
   (fish n)
   (tentacles n)
   (water y)
   (sucksBlood n)
   =>
   (guess "sand dollar")
)

(defrule leech
   (mammal n)
   (legs n)
   (fish n)
   (tentacles n)
   (water y)
   (sucksBlood y)
   =>
   (guess "leech")
)

(defrule eel
   (mammal n)
   (legs n)
   (fish y)
   (bright n)
   (sucksBlood n)
   (stinger n)
   =>
   (guess "eel")
)

(defrule stingray
   (mammal n)
   (legs n)
   (fish y)
   (bright n)
   (stinger y)
   =>
   (guess "stingray")
)

(defrule blobfish
   (mammal n)
   (legs n)
   (fish y)
   (bright n)
   (blob y)
   =>
   (guess "blobfish")
)

(defrule clownfish
   (mammal n)
   (legs n)
   (fish y)
   (bright y)
   (orange y)
   =>
   (guess "clownfish")
)


(defrule chicken
   (mammal n)
   (legs y)
   (under4Legs y)
   (flies n)
   (food y)
   =>
   (guess "chicken")
)

(defrule flamingo
   (mammal n)
   (legs y)
   (under4Legs y)
   (flies n)
   (pink y)
   =>
   (guess "flamingo")
)

(defrule penguin
   (mammal n)
   (legs y)
   (under4Legs y)
   (flies n)
   (antarctica y)
   =>
   (guess "penguin")
)

(defrule t-rex
   (mammal n)
   (legs y)
   (under4Legs y)
   (flies n)
   (dinosaur y)
   =>
   (guess "T-Rex")
)

(defrule parrot
   (mammal n)
   (legs y)
   (under4Legs y)
   (flies y)
   (pet y)
   =>
   (guess "parrot")
)

(defrule eagle
   (mammal n)
   (legs y)
   (under4Legs y)
   (flies y)
   (pet n)
   (birdOfPrey y)
   =>
   (guess "eagle")
)

(defrule duck
   (mammal n)
   (legs y)
   (under4Legs y)
   (flies y)
   (pet n)
   (swim y)
   =>
   (guess "duck")
)

(defrule turtle
   (mammal n)
   (legs y)
   (under4Legs n)
   (fourLegs y)
   (big n)
   (tail n)
   (frog n)
   =>
   (guess "turtle")
)

(defrule toad
   (mammal n)
   (legs y)
   (under4Legs n)
   (fourLegs y)
   (big n)
   (tail n)
   (frog y)
   =>
   (guess "toad")
)

(defrule axolotl
   (mammal n)
   (legs y)
   (under4Legs n)
   (fourLegs y)
   (big n)
   (tail y)
   (amphibian y)
   =>
   (guess "axolotl")
)

(defrule gecko
   (mammal n)
   (legs y)
   (under4Legs n)
   (fourLegs y)
   (big n)
   (tail y)
   (amphibian n)
   =>
   (guess "gecko")
)

(defrule komodo
   (mammal n)
   (legs y)
   (under4Legs n)
   (fourLegs y)
   (big y)
   (lizard y)
   =>
   (guess "Komodo dragon")
)

(defrule crocodile
   (mammal n)
   (legs y)
   (under4Legs n)
   (fourLegs y)
   (big y)
   (florida y)
   =>
   (guess "crocodile")
)

(defrule stegosaurus
   (mammal n)
   (legs y)
   (under4Legs n)
   (fourLegs y)
   (big y)
   (dinosaur y)
   =>
   (guess "stegosaurus")
)

(defrule bee
   (mammal n)
   (legs y)
   (under4Legs n)
   (fourLegs n)
   (fly y)
   (yellow y)
   (honey y)
   =>
   (guess "bee")
)

(defrule wasp
   (mammal n)
   (legs y)
   (under4Legs n)
   (fourLegs n)
   (fly y)
   (yellow y)
   (honey n)
   =>
   (guess "wasp")
)

(defrule chigger
   (mammal n)
   (legs y)
   (under4Legs n)
   (or (eightLegs d) (eightLegs y))
   =>
   (guess "chigger")
)

(defrule crab
   (mammal n)
   (legs y)
   (under4Legs n)
   (eightLegs n)
   =>
   (guess "crab")
)

(defrule dog
   (mammal y)
   (big n)
   (pet y)
   =>
   (guess "dog")
)

(defrule porcupine
   (mammal y)
   (big n)
   (spines y)
   =>
   (guess "porcupine")
)

(defrule flyingSquirrel
   (mammal y)
   (big n)
   (or (fly y) (fly d) (fly n))
   =>
   (guess "flying squirrel")
)

(defrule tiger
   (mammal y)
   (big y)
   (stripes y)
   (orange y)
   =>
   (guess "tiger")
)

(defrule zebra
   (mammal y)
   (big y)
   (stripes y)
   (orange n)
   =>
   (guess "zebra")
)

(defrule whale
   (mammal y)
   (big y)
   (ocean y)
   =>
   (guess "whale")
)

/*
* Gives up if there are no other options.
*/
(defrule giveUp
   (declare (salience -100))
   =>
   (printout t "I give up." crlf)
   (printout t "Total questions: "?*questions* crlf)
)


(run)
