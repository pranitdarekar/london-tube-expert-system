(deffunction show-menu()
   (printout t "Hi Traveler! I am the London Tube Expert System" crlf)
   (printout t "What can I help you with today?" crlf)
   (printout t "1. Riding the Tube" crlf)
   (printout t "2. Attractions" crlf)
   (printout t "3. Fares" crlf)
   (printout t "4. Ask Question" crlf)
   (printout t "5. HELP" crlf)
   (printout t "6. General Information" crlf)
   (printout t "7. Exit System" crlf)
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
      (case 6 then (assert (UserInput (Choice GeneralInfo))))
      (case 7 then (assert (UserInput (Choice Exit))))
      (default (assert (UserInput (Choice InvalidOption))))
   )
)

(deffunction find-attractions-near-station (?station)
   (bind ?attractions (find-all-facts ((?a Attraction)) (eq ?a:NearestStation ?station)))
   return ?attractions
)

(deffunction extract-attraction-from-question (?userQuestion)
   ; List of attractions in facts
   (bind ?attractions (find-all-facts ((?a Attraction)) TRUE))

   ; Iterate through each attraction
   (loop-for-count (?index 1 (length$ ?attractions))
      (bind ?attraction (nth$ ?index ?attractions))
      (bind ?attractionName (fact-slot-value ?attraction Name))

      ; Check if the attraction name is present in the user's question
      (if (str-index (upcase ?attractionName) (upcase ?userQuestion))
         then 
         (return ?attractionName) ; Return the attraction name if found
      )
   )
   (return NIL) ; Return NIL if no attraction name is found
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

(deffunction get-line-info (?start ?end)
   (bind ?station-facts (find-all-facts ((?conn StationConnection)) 
      (or 
         (and (eq (fact-slot-value ?conn StartStation) ?start) (eq (fact-slot-value ?conn EndStation) ?end))
         (and (eq (fact-slot-value ?conn StartStation) ?end) (eq (fact-slot-value ?conn EndStation) ?start))
      )
   ))
   (foreach ?fact ?station-facts
      return (fact-slot-value ?fact Lines)
   )
)

(deffunction print-lines (?lines)
   (foreach ?line ?lines
      (if (neq ?line (nth$ 1 ?lines)) then
         (printout t "/")
      )
      (printout t ?line)
   )
)

(deffunction print-route (?stations)
   (foreach ?station ?stations
      (if (neq ?station (nth$ 1 ?stations)) then
         (printout t " - ")
      )
      (printout t ?station)
   )
   (printout t crlf)
)

(deffunction print-route-with-transfers (?route)
   (if (eq (length$ ?route) 0) then
      (printout t "No route found." crlf)
   else
      (print-route ?route)
      (bind ?current-line "")
      (bind ?current-station "")
      (foreach ?station ?route
         (if (neq ?current-station "") then
            (bind ?lines (get-line-info ?current-station ?station))
            (if (neq ?lines "") then
               (printout t "     from station " ?current-station " take line " (print-lines ?lines) crlf)
            )
         )
         (bind ?current-station ?station)
      )
      (printout t crlf)
   )
)

(deffunction find-route (?start ?end ?visited ?current-route ?origStart)
   (if (eq ?start ?end) then
      (bind ?new-route (create$ ?origStart ?current-route))
      (print-route-with-transfers (create$ ?origStart ?current-route))
   else
      (if (not (member$ ?start ?visited)) then
         (bind ?connectedStations (find-all-facts ((?conn StationConnection)) 
            (or 
               (and (eq (fact-slot-value ?conn StartStation) ?start) (not (member$ (fact-slot-value ?conn EndStation) ?visited)))
               (and (eq (fact-slot-value ?conn EndStation) ?start) (not (member$ (fact-slot-value ?conn StartStation) ?visited)))
            )
         ))
         (if (neq ?connectedStations NIL) then
            (foreach ?conn ?connectedStations
               (bind ?nextStation (if (eq (fact-slot-value ?conn StartStation) ?start) then (fact-slot-value ?conn EndStation) else (fact-slot-value ?conn StartStation)))
               (bind ?new-route (create$ ?current-route ?nextStation))
               (bind ?new-visited (create$ ?visited ?start))

               (if (< (length$ ?new-route) 10) then
                  ; Recursively find routes
                  (find-route ?nextStation ?end ?new-visited ?new-route ?origStart)
               )
            )
         )
      )
   )
)

(deffunction route-planning-action (?userQuestion)
   (printout t "You've asked about Travel Route." crlf crlf)
   (bind ?stations (extract-stations-from-question ?userQuestion))
   (if (eq ?stations NIL) then
      (printout t "Unable to determine start and end stations for route planning." crlf)
   else
      (bind ?startStation (nth$ 1 ?stations))
      (bind ?endStation (nth$ 2 ?stations))
      (printout t "start station: " ?startStation crlf)
      (printout t "end station: " ?endStation crlf)
      (printout t "Is this correct? (Y/N): ")
      (bind ?stationChoice (read))
      (if (neq (lowcase ?stationChoice) y) then
         (bind ?temp ?startStation)
         (bind ?startStation ?endStation)
         (bind ?endStation ?temp)
         (printout t crlf "This should be correct..." crlf)
         (printout t "Start station: " ?startStation crlf)
         (printout t "End station: " ?endStation crlf)
      )
      (printout t crlf)

      ; Check if either start or end station is not found
      (if (or (eq ?startStation "") (eq ?endStation "")) then
         (printout t "Unable to determine start and end stations for route planning." crlf)
      else
         ; Perform route planning based on the start and end stations
         (printout t "Route from " ?startStation " to " ?endStation ":" crlf)
         (printout t "-----------------" crlf)
         ;(print-route ?startStation ?endStation)
         (find-route ?startStation ?endStation (create$) (create$) ?startStation)
      )
   )
)

(deffunction get-station-time(?start ?end)
   (bind ?station-facts (find-all-facts ((?conn StationConnection)) 
      (or 
         (and (eq (fact-slot-value ?conn StartStation) ?start) (eq (fact-slot-value ?conn EndStation) ?end))
         (and (eq (fact-slot-value ?conn StartStation) ?end) (eq (fact-slot-value ?conn EndStation) ?start))
      )
   ))
   (foreach ?fact ?station-facts
      return (fact-slot-value ?fact Time)
   )
)

(deffunction print-time-for-route (?route)
   (if (eq (length$ ?route) 0) then
      (printout t "No route found." crlf)
   else
      (print-route ?route)
      (bind ?current-line "")
      (bind ?current-station "")
      (bind ?totalTime 0)
      (foreach ?station ?route
         (if (neq ?current-station "") then
            (bind ?totalTime (+ ?totalTime (get-station-time ?current-station ?station)))
         )
         (bind ?current-station ?station)
      )
      (printout t "Total Time: " ?totalTime "mins" crlf)
      (printout t crlf)
   )
)

(deffunction find-route-for-time (?start ?end ?visited ?current-route ?origStart)
   (if (eq ?start ?end) then
      (print-time-for-route (create$ ?origStart ?current-route))
   else
      (if (not (member$ ?start ?visited)) then
         (bind ?connectedStations (find-all-facts ((?conn StationConnection)) 
            (or 
               (and (eq (fact-slot-value ?conn StartStation) ?start) (not (member$ (fact-slot-value ?conn EndStation) ?visited)))
               (and (eq (fact-slot-value ?conn EndStation) ?start) (not (member$ (fact-slot-value ?conn StartStation) ?visited)))
            )
         ))
         (if (neq ?connectedStations NIL) then
            (foreach ?conn ?connectedStations
               (bind ?nextStation (if (eq (fact-slot-value ?conn StartStation) ?start) then (fact-slot-value ?conn EndStation) else (fact-slot-value ?conn StartStation)))
               (bind ?new-route (create$ ?current-route ?nextStation))
               (bind ?new-visited (create$ ?visited ?start))

               (if (< (length$ ?new-route) 10) then
                  ; Recursively find routes
                  (find-route-for-time ?nextStation ?end ?new-visited ?new-route ?origStart)
               )
            )
         )
      )
   )
)

(deffunction travel-time-action (?userQuestion)
   (printout t "You've asked about Travel Time." crlf crlf)
   (bind ?stations (extract-stations-from-question ?userQuestion))
   (if (eq ?stations NIL) then
      (printout t "Unable to determine start and end stations for route planning." crlf)
   else
      (bind ?startStation (nth$ 1 ?stations))
      (bind ?endStation (nth$ 2 ?stations))
      (printout t "start station: " ?startStation crlf)
      (printout t "end station: " ?endStation crlf)
      (printout t "Is this correct? (Y/N): ")
      (bind ?stationChoice (read))
      (if (neq (lowcase ?stationChoice) y) then
         (bind ?temp ?startStation)
         (bind ?startStation ?endStation)
         (bind ?endStation ?temp)
         (printout t crlf "This should be correct..." crlf)
         (printout t "Start station: " ?startStation crlf)
         (printout t "End station: " ?endStation crlf)
      )
      (printout t crlf)

      ; Check if either start or end station is not found
      (if (or (eq ?startStation "") (eq ?endStation "")) then
         (printout t "Unable to determine start and end stations for route planning." crlf)
      else
         ; Perform route planning based on the start and end stations
         (printout t "Time taken for all possible paths from " ?startStation " to " ?endStation ":" crlf)
         (printout t "-----------------" crlf)
         (find-route-for-time ?startStation ?endStation (create$) (create$) ?startStation)
      )
   )
)

;; Function to get the zone information for a given station
(deffunction get-station-zone (?station)
   (bind ?zone -1)
   (foreach ?fact (find-all-facts ((?s Station)) (eq ?s:Name ?station))
      (bind ?zone (fact-slot-value ?fact Zone))
   )
   (return ?zone)
)


;; Function to calculate fare based on zone difference
(deffunction calculate-fare-based-on-zones (?startZone ?endZone)
   (if (eq ?startZone ?endZone)
      then 2.40 ; Same zone
   else
      2.90
   )
)

(deffunction calculate-fare-action (?userQuestion)
   (printout t "You've asked about the Travel Fare." crlf crlf)
   ;; Extract start and end stations from the user question (replace this with your actual function)
   (bind ?stations (extract-stations-from-question ?userQuestion))
   (if (eq ?stations NIL) then
      (printout t "Unable to determine start and end stations for fare calculation." crlf)
      (printout t "(note: avoid using space and apostrophe in the station names when asking the question)" crlf)
   else
      (bind ?startStation (nth$ 1 ?stations))
      (bind ?endStation (nth$ 2 ?stations))
      (printout t "Start station: " ?startStation crlf)
      (printout t "End station: " ?endStation crlf)
      (printout t "Is this correct? (Y/N): ")
      (bind ?stationChoice (read))
      (if (neq (lowcase ?stationChoice) y) then
         (bind ?temp ?startStation)
         (bind ?startStation ?endStation)
         (bind ?endStation ?temp)
         (printout t crlf "This should be correct..." crlf)
         (printout t "Start station: " ?startStation crlf)
         (printout t "End station: " ?endStation crlf)
      )
      (printout t crlf)

      ;; Get zone information for start and end stations
      (bind ?startZone (get-station-zone ?startStation))
      (bind ?endZone (get-station-zone ?endStation))

      ;; Check if either start or end station is not found
      (if (or (eq ?startZone -1) (eq ?endZone -1)) then
         (printout t "Unable to determine zones for fare calculation." crlf)
      else
         ;; Calculate fare based on zone difference
         (bind ?fare (calculate-fare-based-on-zones ?startZone ?endZone))
         (printout t "Calculated Fare: £" ?fare crlf)
      )
   )
)

(deffunction find-attraction-nearest-station (?attractionName)
   (bind ?attractionFound FALSE)
   (foreach ?attraction (find-all-facts ((?a Attraction)) (eq ?a:Name ?attractionName))
      (bind ?attractionFound TRUE)
      (printout t "Attraction: " ?attractionName crlf)
      (printout t "Nearest Station: " (fact-slot-value ?attraction NearestStation) crlf)
      (printout t "Zone: " (fact-slot-value ?attraction Zone) crlf)
      (printout t "Description: " (fact-slot-value ?attraction Description) crlf)
      (printout t "---------------------" crlf)
   )
   (if (not ?attractionFound)
      then
      (printout t "Attraction name not found. Please enter correct name." crlf)
   )
)

(deffunction attraction-location-action (?userQuestion)
   (printout t "You've asked about the location of an Attraction." crlf crlf)
   (bind ?attractionName (extract-attraction-from-question ?userQuestion))

   ; Check if attraction name is found in the question
   (if ?attractionName then
      (find-attraction-nearest-station ?attractionName)
   else
      (printout t "Could not extract attraction name from the question." crlf)
   )
)

(deffunction station-attractions-action (?userQuestion)
   (printout t "You've asked about attractions near a Station." crlf crlf)
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
         (if (and (str-index "where is" ?userQuestion)
                  (str-index "attraction" ?userQuestion))
            then
            (return AttractionLocation)
         else
            (if (or (str-index "attractions" ?userQuestion) 
                 (str-index "attraction near" ?userQuestion) 
                 (str-index "nearby attractions" ?userQuestion))
            then
            (return StationAttractions)
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
)

(deffunction exit-action ()
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
      (case 2 then (exit-action))
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

      ; Determine the intent of the question
      (bind ?intent (classify-question ?userQuestion))

      ; Perform actions based on the intent
      (switch ?intent
         (case RoutePlanning then (route-planning-action ?userQuestion))
         (case TravelTime then (travel-time-action ?userQuestion))
         (case TravelFare then (calculate-fare-action ?userQuestion))
         (case AttractionLocation then (attraction-location-action ?userQuestion))
         (case StationAttractions then (station-attractions-action ?userQuestion))
         (case UnknownIntent then (unknown-question-action))
      )
   )
   (printout t crlf)
   (menu-or-exit)
)

(deffunction riding-tube-lines ()
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

(deffunction riding-tube-stations ()
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

(deffunction riding-tube-action ()
   (printout t "You've chosen 'Riding Tube' Here's some information about it:" crlf)
   (printout t "1. Tube Lines" crlf)
   (printout t "2. Stations" crlf)
   (printout t crlf)

   ; Read the user's sub-choice
   (bind ?subChoice (read))
   (printout t crlf)

   ; Switch based on the sub-choice
   (switch ?subChoice
      (case 1 then (riding-tube-lines))
      (case 2 then (riding-tube-stations))
      (default (printout t "Invalid choice. Please enter a valid sub-option (1 or 2)." crlf))
   )
   (prompt-for-question)
)

(deffunction attractions-action ()
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
   (printout t "(Sample Format: where is the attraction XXXX located?)" crlf)
   (printout t crlf)
   (prompt-for-question)
)

(deffunction fares-action ()
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

(deffunction question-action ()
   (printout t "You selected the option to ask question to the system" crlf)
   (prompt-for-question)
)

(deffunction help-action ()
   (printout t "Welcome to the HELP section!" crlf)
   (printout t "Here are some example question formats you can use to gather information about the London Tube:" crlf)
   (printout t crlf)
   (printout t "Route" crlf)
   (printout t "- How to go from station A to B?" crlf)
   (printout t "- What is the direction to go from station A to B?" crlf)
   (printout t "- What is the route for going from station A to B?" crlf)
   (printout t crlf)
   (printout t "Travel Time" crlf)
   (printout t "- What is the time taken to go from station A to B?" crlf)
   (printout t "- How long it takes to go from station A to B?" crlf)
   (printout t "- What is the travel time for station A to B?" crlf)
   (printout t crlf)
   (printout t "Nearby Attractions" crlf)
   (printout t "- What are the attractions near station A?" crlf)
   (printout t "- What are the nearby attractions to station A?" crlf)
   (printout t crlf)
   (printout t "Fare" crlf)
   (printout t "- How much is the fare to go from A to B?" crlf)
   (printout t "- What is the ticket cost to go from A to B?" crlf)
   (printout t crlf)
   (printout t "Location" crlf)
   (printout t "- Where is the attraction X located?" crlf)
   (printout t crlf)
   (prompt-for-question)
)

(deffunction general-info-action ()
   (printout t "General Information:" crlf)
   (printout t "-------------------" crlf)
   (printout t "Operating Hours: 5:30 AM to 12 Midnight daily." crlf)
   (printout t "Oyster Card: The Oyster card is the preferred method of fare payment." crlf)
   (printout t "Fare Information: The fare depends on the zones traveled. See Fares section for details." crlf)
   (printout t "Station Search: When searching for information about stations, type the station name without spaces, e.g., LondonBridge." crlf)
   (printout t "Close Stations: Following stations are closed for maintanence - Earls Court, Green Park, Bank (some routes affected).")
   (printout t crlf)
   (prompt-for-question)
)

(deffunction invalid-option-action ()
   (printout t "You've chosen invalid option. Please select option from the list. Please specify your question or topic:" crlf)
)

(defrule main-loop
   =>
   (show-menu)
)

(defrule loop-for-interaction
   ?u <- (UserInput (Choice ?choice))
   =>
   (retract ?u)
   (switch ?choice
      (case RidingTube then (riding-tube-action))
      (case Attractions then (attractions-action))
      (case Fares then (fares-action))
      (case Question then (question-action))
      (case Help then (help-action))
      (case GeneralInfo then (general-info-action))
      (case Exit then (exit-action))
      (case InvalidOption then (invalid-option-action))
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
