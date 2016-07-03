//DaMachinator's PartModule Lister - 2016
//Creates a text file (.txt) with:
// - The name and title of every part on the active vessel
// - The name of every module associated with each part
// - Every field, action, and event visible to kOS in each module
//in a multi-level format for greater readability.
//After file creation, it is copied to the archive (volume 0).
//WARNING: Running this program will overwrite any files on the current volume AND the archive with the name "verboseparts.txt".
//Do not run this directly from the archive. Copy it to the desired volume first.

clearscreen.

if core:currentvolume:files:haskey("verboseparts.txt") {
    delete verboseparts.txt.
}

print "TESTING IN PROGRESS".
FOR item in ship:parts { //for every part
    log item:name to verboseparts.txt. //log the name
	log item:title to verboseparts.txt. //and the title
	log "===" to verboseparts.txt.
	
    FOR modulename in item:modules { //iterate thru the modules, for every module:
        log "    " + modulename to verboseparts.txt. //log the name
		log "    " + "---" to verboseparts.txt.
		
		local module is item:getmodule(modulename).
	    
		log "        --FIELDS--" to verboseparts.txt. //iterate and log name of every field
	    FOR field in module:allfields { 
    	    log "            " + field to verboseparts.txt.
    	}
    	
		log "        --EVENTS--" to verboseparts.txt. //iterate and log name of every event
    	FOR event in module:allevents {
    	    log "            " + event to verboseparts.txt.
    	}
    	
		log "        --ACTIONS--" to verboseparts.txt. //iterate and log name of every action
    	for partaction in module:allactions {
    	    log "            " + partaction to verboseparts.txt.
    	}
    	
		log "    --------------------" to verboseparts.txt. //put a seperator to help seperate the modules
    }
	
	log "=========================================="  to verboseparts.txt. //put a different seperator to help seperate the parts
}

copy verboseparts.txt to 0.

print "FINISHED".
