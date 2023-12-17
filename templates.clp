(deftemplate Station
	;; The name of the station
	(slot Name (type SYMBOL))

	;; The list of lines that serve the station
	(multislot Lines (type SYMBOL))

	;; The zone in which the station is located
	(slot Zone (type INTEGER))

	;; The list of next stations based on direction of travel, each station of the list is described by the line, direction, and the station name
	(multislot NextStation (type SYMBOL))

	;; Indicates whether the station allows transfers to other lines
	(slot TransferStation (type SYMBOL) (allowed-symbols yes no) (default no))
)

(deftemplate Fare
	;; The starting zone for the fare calculation
	(slot StartingZone (type INTEGER))

	;; The ending zone for the fare calculation
	(slot EndingZone (type INTEGER))

	;; The calculated fare for the journey
	(slot CalculatedFare (type FLOAT))
)


(deftemplate Line
	;; The name of the London Tube line
	(slot Name (type SYMBOL))

	;; The starting station of the line
	(slot StartingStation (type SYMBOL))

	;; The ending station of the line
	(slot EndingStation (type SYMBOL))

	;; The list of stations served by this line
	(multislot Stations (type SYMBOL))

	;; The list of times it takes to travel between consecutive stations
	(multislot StationToStationTimes (type INTEGER))

	;; The list of lines where passengers can transfer between
	(multislot TransferBetween (type SYMBOL))
)


(deftemplate Zone
	;; The zone number for the zone
	(slot Number (type INTEGER))

	;; The list of London Tube lines that belong to this zone
	(multislot Lines (type SYMBOL))
)

(deftemplate Route
	;; The starting station of the route
	(slot StartStation (type SYMBOL))

	;; The ending station of the route
	(slot EndStation (type SYMBOL))

	;; The path, i.e., the list of stations, along the route
	(multislot Path (type SYMBOL))

	;; The list of London Tube lines used in the route
	(multislot Lines (type SYMBOL))

	;; The list of stations where transfers occur during the route
	(multislot Transfers (type SYMBOL))
)

(deftemplate Attraction
	;; The name of the attraction
	(slot Name (type SYMBOL))

	;; The nearest London Tube station to the attraction
	(slot NearestStation (type SYMBOL))

	;; The zone in which the attraction is located
	(slot Zone (type INTEGER))

	;; A description of the attraction
	(multislot Description (type STRING))
)

(deftemplate UserInput
   (slot Choice (type SYMBOL))
   (multislot SubChoice)
)

(deftemplate StationList
   (slot name (type SYMBOL))
)

(deftemplate StationConnection
   (slot StartStation (type SYMBOL))
   (slot EndStation (type SYMBOL))
   (multislot Lines (type SYMBOL))
   (slot Time (type INTEGER))
)


