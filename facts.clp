;Facts

(deffacts Stations
   (Station
      (Name OxfordCircus)
      (Lines Central Bakerloo Victoria)
      (Zone 1)
      (NextStation Central direction_forward Holborn
                   Central direction_backword MarbleArch
                   Bakerloo direction_forward PiccadillyCircus
                   Bakerloo direction_backword RegentsPark
                   Victoria direction_forward WarrenStreet
                   Victoria direction_backword GreenPark)
      (TransferStation yes)
   )

   (Station
      (Name NineElms)
      (Lines Northern)
      (Zone 1)
      (NextStation Northern direction_forward Kennington
                   Northern direction_backword BatterSeaPowerStation)
      (TransferStation no)
    )
)

(deffacts Fares "Fares for different zone combinations"
  (Fare (StartingZone 1) (EndingZone 1) (CalculatedFare 2.40))
  (Fare (StartingZone 1) (EndingZone 2) (CalculatedFare 2.90))
  (Fare (StartingZone 1) (EndingZone 3) (CalculatedFare 3.30))
  (Fare (StartingZone 1) (EndingZone 4) (CalculatedFare 3.90))
  (Fare (StartingZone 1) (EndingZone 5) (CalculatedFare 4.70))
  (Fare (StartingZone 1) (EndingZone 6) (CalculatedFare 5.90))
)


(deffacts Lines "Description of Bakerloo Line"
  (Line
    (Name Bakerloo)
    (StartingStation HarrowAndWealdstone)
    (EndingStation ElephantAndCastle)
    (Stations HarrowAndWealdstone Kenton SouthKenton NorthWembley Waterloo ElephantAndCastle)
    (StationToStationTimes 2 4 1 3 2)
    (TransferBetween Circle HammersmithAndCity Central Victoria Northern Piccadilly District Jubilee WaterlooAndCity)
  )
)


(deffacts Zones "Description of some London Tube zones"
  (Zone (Number 1) (Lines Bakerloo Central Circle District HammersmithCity Jubilee Northern Piccadilly Victoria WaterlooCity))
  (Zone (Number 2) (Lines Bakerloo Central Circle District HammersmithCity Jubilee Metropolitan Northern Piccadilly Victoria))
)

(deffacts SuggestedRoutes "Suggested route from King's Cross St. Pancras to London Bridge - Direct"
  (Route 
    (StartStation KingsCrossStPancras)
    (EndStation LondonBridge)
    (Path KingsCrossStPancras Angel OldStreet Moorgate Bank LondonBridge)
            (Lines Northern)
  )
)

(deffacts SuggestedRoutes "Suggested route from King's Cross St. Pancras to London Bridge - Via Transfer"
  (Route
    (StartStation KingsCrossStPancras)
    (EndStation LondonBridge)
    (Path KingsCrossStPancras Euston WarrenStreet OxfordCircus GreenPark Westminister Waterloo Southwark LondonBridge)
    (Lines Victoria Jubilee)
    (Transfers GreenPark)
  )
)

(deffacts London-Attractions "Major attractions in London and their nearest tube stations"
  (Attraction
    (Name BritishMuseum)
    (NearestStation RussellSquare)
    (Zone 1)
    (Description "A renowned museum featuring a vast collection of world art and artifacts. Free entry.")
  )
  (Attraction
    (Name NaturalHistoryMuseum)
    (NearestStation SouthKensington)
    (Zone 1)
    (Description "A renowned institution showcasing a vast collection of natural specimens, including fossils, minerals, and life sciences exhibits.")
  )
  (Attraction
    (Name VictoriaAndAlbertMuseum)
    (NearestStation SouthKensington)
    (Zone 1)
    (Description "Is a world-class museum in London known for its extensive collection of art, design, and historical artifacts from various cultures and time periods.")
  )
  (Attraction
    (Name RoyalAlbertHall)
    (NearestStation SouthKensington)
    (Zone 1)
    (Description "Is an iconic London venue celebrated for its stunning architecture and world-class performances, including concerts, orchestral events, and cultural gatherings.")
  )
  (Attraction
    (Name RoyalAlbertHall)
    (NearestStation Knightsbridge)
    (Zone 1)
    (Description "Is an iconic London venue celebrated for its stunning architecture and world-class performances, including concerts, orchestral events, and cultural gatherings.")
  )
  (Attraction
    (Name TheAlbertMemorial)
    (NearestStation Knightsbridge)
    (Zone 1)
    (Description "Is an ornate monument located in Kensington Gardens, dedicated to Prince Albert and known for its elaborate Gothic Revival design and historical significance.")
  )
  (Attraction
    (Name Harrods)
    (NearestStation Knightsbridge)
    (Zone 1)
    (Description "Is a luxury department store in London, famous for its opulent shopping experience, extensive product offerings, and exceptional customer service.")
  )
  (Attraction
    (Name HydePark)
    (NearestStation Knightsbridge)
    (Zone 1)
    (Description "Is one of London's largest and most famous parks, offering a serene escape in the heart of the city, with beautiful green spaces, a large lake, and a variety of recreational activities.")
  )
  (Attraction
    (Name HydePark)
    (NearestStation LancasterGate)
    (Zone 1)
    (Description "Is one of London's largest and most famous parks, offering a serene escape in the heart of the city, with beautiful green spaces, a large lake, and a variety of recreational activities.")
  )
  (Attraction
    (Name HydePark)
    (NearestStation MarbleArch)
    (Zone 1)
    (Description "Is one of London's largest and most famous parks, offering a serene escape in the heart of the city, with beautiful green spaces, a large lake, and a variety of recreational activities.")
  )
  (Attraction
    (Name HydePark)
    (NearestStation HydeParkCorner)
    (Zone 1)
    (Description "Is one of London's largest and most famous parks, offering a serene escape in the heart of the city, with beautiful green spaces, a large lake, and a variety of recreational activities.")
  )
  (Attraction
    (Name BuckinghamPalace)
    (NearestStation StJamesPark)
    (Zone 1)
    (Description "The official residence of the British monarch, is an iconic symbol of the British monarchy, known for its stunning architecture and as the backdrop for royal ceremonies and events.")
  )
  (Attraction
    (Name TrafalgarSquare)
    (NearestStation CharingCross)
    (Zone 1)
    (Description "Is a bustling public square in central London, featuring Nelson's Column and numerous cultural events, surrounded by historic landmarks and galleries.")
  )
  (Attraction
    (Name StJamesPalace)
    (NearestStation GreenPark)
    (Zone 1)
    (Description "One of London's oldest royal palaces, is a historic residence located near Buckingham Palace and has served as the official residence for several members of the British royal family.")
  )
  (Attraction
    (Name StJamesPalace)
    (NearestStation PiccadillyCircus)
    (Zone 1)
    (Description "One of London's oldest royal palaces, is a historic residence located near Buckingham Palace and has served as the official residence for several members of the British royal family.")
  )
  (Attraction
    (Name Whitehall)
    (NearestStation CharingCross)
    (Zone 1)
    (Description "Is a historic street in London, known for its government buildings and iconic institutions, including the Prime Minister's residence at 10 Downing Street and Horse Guards Parade.")
  )
  (Attraction
    (Name Whitehall)
    (NearestStation Embankment)
    (Zone 1)
    (Description "Is a historic street in London, known for its government buildings and iconic institutions, including the Prime Minister's residence at 10 Downing Street and Horse Guards Parade.")
  )
  (Attraction
    (Name WestminsterAbbey)
    (NearestStation StJamesPark)
    (Zone 1)
    (Description "A magnificent Gothic church, is one of London's most revered landmarks, famous for hosting royal ceremonies, coronations, and as the final resting place for many notable figures in British history.")
  )
  (Attraction
    (Name WestminsterCathedral)
    (NearestStation Victoria)
    (Zone 1)
    (Description "A stunning neo-Byzantine church, is the largest Catholic cathedral in England and Wales, known for its impressive architecture and religious significance.")
  )
  (Attraction
    (Name VictoriaStation)
    (NearestStation Victoria)
    (Zone 1)
    (Description "Is a major railway and transportation hub in London, offering connections to various destinations and serving as a central point for commuters and travelers.")
  )
  (Attraction
    (Name TateBritain)
    (NearestStation Pimlico)
    (Zone 1)
    (Description "Is an art museum in London dedicated to British art, known for its vast collection of works by renowned British artists and its commitment to showcasing the nation's artistic heritage.")
  )
  (Attraction
    (Name TheMarbleArch)
    (NearestStation MarbleArch)
    (Zone 1)
    (Description "Is a prominent London landmark, an elegant white marble monument originally designed as a grand entrance to Buckingham Palace's forecourt, with historical and architectural significance.")
  )
  (Attraction
    (Name WellcomeCollection)
    (NearestStation EustonSquare)
    (Zone 1)
    (Description "Is a unique museum and library in London, focusing on the intersections of medicine, art, and science, with thought-provoking exhibitions and an extensive collection of artifacts and artworks.")
  )
  (Attraction
    (Name BritishLibrary)
    (NearestStation KingsCrossStPancras)
    (Zone 1)
    (Description "Is one of the world's largest and most comprehensive libraries, renowned for its vast collection of books, manuscripts, maps, and historical documents, including the Magna Carta and the Gutenberg Bible.")
  )
  (Attraction
    (Name ScoobsUsedBooks)
    (NearestStation RussellSquare)
    (Zone 1)
    (Description "Is a well-known second-hand bookstore famous for its extensive collection of used and rare books, covering a wide range of genres and interests. ")
  )
  (Attraction
    (Name GrantMuseumOfZoology)
    (NearestStation EustonSquare)
    (Zone 1)
    (Description "Is a fascinating museum that houses a diverse collection of zoological specimens, showcasing the wonders of the animal kingdom and providing insights into the world of zoology and comparative anatomy.")
  )
  (Attraction
    (Name LondonTransportMuseum)
    (NearestStation CoventGarden)
    (Zone 1)
    (Description "Is a captivating museum in London, dedicated to the history of public transportation in the city, featuring an impressive collection of vehicles, posters, and artifacts that showcase the evolution of London's transport systems.")
  )
  (Attraction
    (Name TheCourtauldGallery)
    (NearestStation Temple)
    (Zone 1)
    (Description "Is an art museum celebrated for its exceptional collection of Impressionist and Post-Impressionist masterpieces, including works by renowned artists such as Monet, Van Gogh, and Cézanne.")
  )
  (Attraction
    (Name TwiningsTeaShoppe)
    (NearestStation Temple)
    (Zone 1)
    (Description "A renowned tea emporium in London, is a cherished destination for tea lovers, offering a wide array of exquisite teas, blends, and accessories with a rich history dating back to the 18th century.")
  )
  (Attraction
    (Name SomersetHouse)
    (NearestStation Temple)
    (Zone 1)
    (Description "Is a historic neoclassical building in London, now transformed into a cultural center, housing art exhibitions, live events, and creative spaces, and serving as a hub for arts and culture in the city.")
  )
  (Attraction
    (Name TemplarChurch)
    (NearestStation Temple)
    (Zone 1)
    (Description "Is a remarkable historical church in London, recognized for its medieval architecture and its association with the Knights Templar, making it a site of historical and architectural significance.")
  )
  (Attraction
    (Name StPaulsCathedral)
    (NearestStation StPauls)
    (Zone 1)
    (Description "Is a magnificent Anglican cathedral renowned for its awe-inspiring dome and stunning architecture, serving as a symbol of resilience and spiritual significance for the city.")
  )
  (Attraction
    (Name BarbicanCentre)
    (NearestStation Barbican)
    (Zone 1)
    (Description "Is a renowned arts and cultural venue in London, featuring a diverse range of events and performances, including concerts, theater, exhibitions, and film screenings, making it a hub for artistic expression and creativity.")
  )
  (Attraction
    (Name BankOfEnglandMuseum)
    (NearestStation BankStation)
    (Zone 1)
    (Description "Provides a fascinating glimpse into the history of banking and currency, offering visitors insights into the institution's role in the UK's financial system.")
  )
  (Attraction
    (Name CharlesDkickensMuseum)
    (NearestStation RussellSquare)
    (Zone 1)
    (Description "Is a delightful museum dedicated to the life and work of the famous Victorian author, Charles Dickens, offering a glimpse into his world and literary contributions.")
  )
  (Attraction
    (Name TateModern)
    (NearestStation Blackfriars)
    (Zone 1)
    (Description "Is celebrated for its extensive collection of contemporary and modern art, featuring renowned works by artists like Picasso, Warhol, and Hockney, in a striking industrial building along the Thames.")
  )
  (Attraction
    (Name BoroughMarket)
    (NearestStation LondonBridge)
    (Zone 1)
    (Description "Is one of London's most vibrant and diverse food markets, offering a wide array of fresh produce, artisanal foods, and international culinary delights, making it a food lover's paradise.")
  )
  (Attraction
    (Name MonmouthCoffeeCompany)
    (NearestStation LondonBridge)
    (Zone 1)
    (Description "Is known for its exceptional coffee beans and commitment to producing high-quality, ethically sourced coffee, providing a delightful caffeine experience for coffee enthusiasts.")
  )
  (Attraction
    (Name TowerOfLondon)
    (NearestStation TowerHill)
    (Zone 1)
    (Description "Is an iconic historical fortress on the banks of the River Thames, famous for its rich and sometimes dark history, including its use as a royal palace, prison, and housing the Crown Jewels, making it a must-visit for history enthusiasts.")
  )
  (Attraction
    (Name TowerBridge)
    (NearestStation TowerHill)
    (Zone 1)
    (Description "A stunning bascule and suspension bridge over the River Thames, is a London icon known for its architectural beauty and remarkable engineering, providing both a functional river crossing and a memorable landmark.")
  )
  (Attraction
    (Name HMSBelfast)
    (NearestStation LondonBridge)
    (Zone 1)
    (Description "Is a retired Royal Navy cruiser, now serving as a museum ship in London, offering visitors the opportunity to explore its historic decks and learn about its role in World War II and the Korean War.")
  )
  (Attraction
    (Name TheGoldenHinde)
    (NearestStation LondonBridge)
    (Zone 1)
    (Description "A full-scale replica of the historic galleon in which Sir Francis Drake circumnavigated the globe, is an interactive museum in London, providing insights into the maritime adventures of the Elizabethan era.")
  )
  (Attraction
    (Name GlobeTheatre)
    (NearestStation LondonBridge)
    (Zone 1)
    (Description "A faithful reconstruction of the original Elizabethan playhouse, is a renowned London theater that celebrates the works of William Shakespeare and the timeless art of live performances in a historical setting.")
  )
  (Attraction
    (Name ClinkPrisonMuseum)
    (NearestStation LondonBridge)
    (Zone 1)
    (Description "It offers visitors a captivating glimpse into the history of crime and punishment, with displays of medieval prison artifacts and stories of the city's notorious past.")
  )
  (Attraction
    (Name ImperialWarMuseum)
    (NearestStation LambethNorth)
    (Zone 1)
    (Description "A significant institution in London, is dedicated to preserving and showcasing the history of conflicts and their impact on society, featuring a vast collection of military artifacts, exhibits, and personal narratives.")
  )
  (Attraction
    (Name KensingtonPalace)
    (NearestStation NottingHillGate)
    (Zone 1)
    (Description "A historic royal residence in London, is celebrated for its elegant architecture and its role as the former home of Queen Victoria, offering visitors a window into the lives of British monarchs and their regal surroundings.")
  )
)

(deffacts InitialFacts
   (StationList (name Bakerloo))
   (StationList (name LondonBridge))
   (StationList (name Central))
   ; Add more stations as needed
)
