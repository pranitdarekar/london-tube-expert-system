(deffunction show-menu()
   (printout t "Hi Traveler! I am the London Tube Expert System" crlf)
   (printout t "What can I help you with today?" crlf)
   (printout t "1. Riding the Tube" crlf)
   (printout t "2. Attractions" crlf)
   (printout t "3. Fares" crlf)
   (printout t "4. Ask Question" crlf)
   (printout t "5. HELP" crlf)
   (printout t "6. Exit System" crlf)
   (printout t "(Please select the number for the option you want to choose)" crlf)
   (printout t crlf)
   
   (bind ?userChoice (read)) ; Read user's choice
   (printout t crlf)

   (switch ?userChoice
      (case 1 then (assert (UserInput (Choice RidingTube))))
      (case 2 then (assert (UserInput (Choice Attractions))))
      (case 3 then (assert (UserInput (Choice Fares))))
      (case 4 then (assert (UserInput (Choice Question))))
      (case 5 then (assert (UserInput (Choice Help))))
      (case 6 then (assert (UserInput (Choice Exit))))
      (default (assert (UserInput (Choice InvalidOption))))
   )
)

(deffunction find-attractions-near-station (?station)
   (bind ?attractions (find-all-facts ((?a Attraction)) (eq ?a:NearestStation ?station)))
   return ?attractions
)

(deffunction extract-station-from-question (?userQuestion)
   (bind ?stationList (find-all-facts ((?f StationList)) TRUE)) ; Get a list of all station facts

   ; Iterate through each station in the list
   (loop-for-count (?index 1 (length$ ?stationList))
      (bind ?station (nth$ ?index ?stationList))
      (bind ?stationName (fact-slot-value ?station name))

      ; Check if the station name is present in the user's question
      (if (str-index (upcase ?stationName) (upcase ?userQuestion)) then 
         (return ?stationName) ; Return the station name if found
      )
   )
   (return NIL) ; Return NIL if no station name is found
)

(deffunction extract-stations-from-question (?userQuestion)
   (bind ?startStation "")
   (bind ?endStation "")

   ; Get a list of all station facts
   (bind ?stationList (find-all-facts ((?f StationList)) TRUE))

   ; Iterate through each station in the list
   (loop-for-count (?index 1 (length$ ?stationList))
      (bind ?station (nth$ ?index ?stationList))
      (bind ?stationName (fact-slot-value ?station name))

      ; Check if the station name is present in the user's question
      (if (str-index (upcase ?stationName) (upcase ?userQuestion)) then 
         (if (eq ?startStation "") then
            (bind ?startStation ?stationName)
         else
            (bind ?endStation ?stationName)
         )
      )
   )

   ; Return the extracted start and end stations
   (if (and (neq ?startStation "") (neq ?endStation "")) then
      (return (create$ ?startStation ?endStation))
   else
      (return NIL) ; Return NIL if either start or end station is not found
   )
)

(deffunction print-route (?startStation ?endStation)
   ; Add logic to find and print the route between start and end stations
   ; You can use your existing logic or add new rules for this purpose
   (printout t "Route details go here..." crlf)
)

(deffunction route-planning-action (?userQuestion)
   (printout t "Question Intent: Route Planning" crlf)
   (bind ?stations (extract-stations-from-question ?userQuestion))
   (if (eq ?stations NIL) then
      (printout t "Unable to determine start and end stations for route planning." crlf)
   else
      (bind ?startStation (nth$ 1 ?stations))
      (bind ?endStation (nth$ 2 ?stations))
      (printout t "start station: " ?startStation crlf)
      (printout t "end station: " ?endStation crlf)
      (printout t crlf)

      ; Check if either start or end station is not found
      (if (or (eq ?startStation "") (eq ?endStation "")) then
         (printout t "Unable to determine start and end stations for route planning." crlf)
      else
         ; Perform route planning based on the start and end stations
         (printout t "Route from " ?startStation " to " ?endStation ":" crlf)
         (print-route ?startStation ?endStation)
      )
   )
)

(deffunction attractions-action (?userQuestion)
   (printout t "Question Intent: Attractions" crlf)
   (bind ?stationName (extract-station-from-question ?userQuestion))

   ; Check if the station name is valid
   (if (neq ?stationName NIL) then
      (printout t "Attractions near " ?stationName ":" crlf)
      (bind ?attractions (find-attractions-near-station ?stationName))

      ; Print attractions if found
      (if (> (length$ ?attractions) 0) then
         (foreach ?attraction ?attractions
            (printout t "Attraction: " (fact-slot-value ?attraction Name) crlf)
            (printout t "Description: " (fact-slot-value ?attraction Description) crlf)
            (printout t "---------------------" crlf)
         )
      else
         (printout t "No attractions found near " ?stationName crlf)
      )
   else
      (printout t "Station name not found. Please enter correct station name." crlf)
   )
)

(deffunction classify-question (?userQuestion)
   (bind ?userQuestion (lowcase ?userQuestion)) ; Convert to lowercase for case-insensitivity

   (if (or (str-index "how to go" ?userQuestion) 
           (str-index "directions" ?userQuestion) 
           (str-index "route" ?userQuestion))
      then
      (return RoutePlanning)
   else
      (if (or (str-index "time taken" ?userQuestion) 
              (str-index "travel time" ?userQuestion) 
              (str-index "how long" ?userQuestion))
         then
         (return TravelTime)
      else
         (if (or (str-index "attractions" ?userQuestion) 
                 (str-index "attraction near" ?userQuestion) 
                 (str-index "nearby attractions" ?userQuestion))
            then
            (return Attractions)
         else
            (if (or (str-index "fare" ?userQuestion) 
                    (str-index "ticket cost" ?userQuestion) 
                    (str-index "how much is the fare" ?userQuestion))
               then
               (return TravelFare)
            else
               (return UnknownIntent) ; Default intent if no match
            )
         )
      )
   )
)

(deffunction ExitAction ()
   (printout t "You've chosen to 'Exit' the system. Goodbye! Have a great day!" crlf)
)

(deffunction menu-or-exit ()
   (printout t "Please select one option:" crlf)
   (printout t "1. Main Menu" crlf)
   (printout t "2. Exit" crlf)
   (bind ?menuChoice (read))
   (printout t crlf)
   (switch ?menuChoice
      (case 1 then (show-menu))
      (case 2 then (ExitAction))
      (default (printout t "You've chosen invalid option. Exiting the system." crlf))
   )
)

(deffunction unknown-question-action ()
   (printout t "I couldn't understand your question well, please check the help section on sample question examples." crlf crlf)
)

(deffunction prompt-for-question ()
   (printout t "Do you have any questions? (Y/N): ")
   (bind ?questionChoice (read))
   (printout t crlf)
   (if (eq (upcase ?questionChoice) Y) then
      (printout t "Enter your question: ")
      (bind ?userQuestion (readline))
      (printout t crlf)
      (printout t "You've asked: " ?userQuestion crlf)

      ; Determine the intent of the question
      (bind ?intent (classify-question ?userQuestion))

      ; Perform actions based on the intent
      (switch ?intent
         (case RoutePlanning then (route-planning-action ?userQuestion))
         (case TravelTime then (printout t "Intent: Travel Time" crlf))
         (case TravelFare then (printout t "Intent: Travel Fare" crlf))
         (case Attractions then (attractions-action ?userQuestion))
         (case UnknownIntent then (unknown-question-action))
      )
   )
   (printout t crlf)
   (menu-or-exit)
)

(deffunction RidingTubeLines ()
   (printout t "List of Tube Lines:" crlf)
   (printout t "1. Bakerloo Line" crlf)
   (printout t "2. Central Line" crlf)
   (printout t "3. Circle Line" crlf)
   (printout t "4. District Line" crlf)
   (printout t "5. Hammersmith & City Line" crlf)
   (printout t "6. Jubilee Line" crlf)
   (printout t "7. Metropolitian Line" crlf)
   (printout t "8. Northern Line" crlf)
   (printout t "9. Piccadilly Line" crlf)
   (printout t "10. Victoria Line" crlf)
   (printout t "11. Waterloo & City Line" crlf)
   (printout t crlf)
)

(deffunction RidingTubeStations ()
   (printout t "List of some major Tube Stations:" crlf)
   (printout t "Victoria" crlf)
   (printout t "Liverpool Street" crlf)
   (printout t "Paddington" crlf)
   (printout t "Cannon Street" crlf)
   (printout t "Farringdon" crlf)
   (printout t "King's cross" crlf)
   (printout t "Camden Town" crlf)
   (printout t crlf)
)

(deffunction RidingTubeAction ()
   (printout t "You've chosen 'Riding Tube' Here's some information about it:" crlf)
   (printout t "1. Tube Lines" crlf)
   (printout t "2. Stations" crlf)
   (printout t crlf)

   ; Read the user's sub-choice
   (bind ?subChoice (read))
   (printout t crlf)

   ; Switch based on the sub-choice
   (switch ?subChoice
      (case 1 then (RidingTubeLines))
      (case 2 then (RidingTubeStations))
      (default (printout t "Invalid choice. Please enter a valid sub-option (1 or 2)." crlf))
   )
   (prompt-for-question)
)

(deffunction AttractionsAction ()
   (printout t "You've chosen 'Attractions' Here's some information about London attractions:" crlf)
   (printout t crlf)
   (printout t "British Museum - Nearest Station: RussellSquare" crlf)
   (printout t "South Kensington - Nearest Station: NaturalHistoryMuseum" crlf)
   (printout t "Knights bridge - Nearest Station: RoyalAlbertHall" crlf)
   (printout t "Grant Museum Of Zoology - Nearest Station: EustonSquare" crlf)
   (printout t "The Courtauld Gallery - Nearest Station: Temple" crlf)
   (printout t "Tate Modern - Nearest Station: Blackfriars" crlf)
   (printout t "Tower Of London - Nearest Station: TowerHill" crlf)
   (printout t "(NOTE: use questions option to get information on other attractions)" crlf)
   (printout t crlf)
   (prompt-for-question)
)

(deffunction FaresAction ()
   (printout t "You've chosen 'Fares' Here's information about ticket prices and fare options:" crlf)
   (printout t "Zones Traveled   Fare (£)" crlf)
   (printout t "1                £2.40" crlf)
   (printout t "1-2              £2.90" crlf)
   (printout t "1-3              £3.30" crlf)
   (printout t "1-4              £3.90" crlf)
   (printout t "1-5              £4.70" crlf)
   (printout t "1-6              £5.90" crlf)
   (printout t crlf)
   (prompt-for-question)
)

(deffunction QuestionAction ()
   (printout t "You selected the option to ask question to the system" crlf)
   (prompt-for-question)
)

(deffunction HelpAction ()
   (printout t "Welcome to the HELP section!" crlf)
   (printout t "Here are some example question formats you can use to gather information about the London Tube:" crlf)
   (printout t crlf)
   (printout t "- How to go from station A to B?" crlf)
   (printout t "- How to go to station A from B?" crlf)
   (printout t "- What is the direction to go from station A to B?" crlf)
   (printout t "- What is the route for going from station A to B?" crlf)
   (printout t "- What is the time taken to go from station A to B?" crlf)
   (printout t "- How long it takes to go from station A to B?" crlf)
   (printout t "- What is the travel time for station A to B" crlf)
   (printout t "- What are the attractions near station A" crlf)
   (printout t "- What are the nearby attractions to station A" crlf)
   (printout t crlf)
   (prompt-for-question)
)

(deffunction InvalidOptionAction ()
   (printout t "You've chosen invalid option. Please select option from the list. Please specify your question or topic:" crlf)
)

(defrule MainLoop
   =>
   (show-menu)
)

(defrule loop-for-interaction
   ?u <- (UserInput (Choice ?choice))
   =>
   (retract ?u)
   (switch ?choice
      (case RidingTube then (RidingTubeAction))
      (case Attractions then (AttractionsAction))
      (case Fares then (FaresAction))
      (case Question then (QuestionAction))
      (case Help then (HelpAction))
      (case Exit then (ExitAction))
      (case InvalidOption then (InvalidOptionAction))
      (case Continue then
         (printout t "Do you want to ask another question or make another choice? (Y/N): ")
         (bind ?continueChoice (read))
         (printout t crlf)
         (if (eq (upcase ?continueChoice) Y) then
            (assert (UserInput (Choice Continue))) ; Continue the loop
         else
            (printout t "Returning to main menu" crlf)
            (show-menu)
         )
      )
   )
   ;(prompt-for-question)
)
