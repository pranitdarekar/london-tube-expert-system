(deffunction start-expert-system ()
   (load "templates.clp")
   (load "facts.clp")
   (load "rules.clp")
   (reset)
   (run)
)