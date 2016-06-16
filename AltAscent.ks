//begin pressure-based ascent guidance

CLEARSCREEN.

//begin pre-launch sequence

SET THROTTLE TO 1.0.

LOCK STEERING TO UP.


//ascent guidance
PRINT "Ascent guidance engaged.".
SET DIRECTION TO HEADING(90,90).
LOCK STEERING TO DIRECTION.
PRINT "Launching.".
STAGE.

//staging logic
WHEN SHIP:MAXTHRUST = 0 {
    PRINT "Initiate Stage 1 Separation".
	SET THROTTLE TO 0.0.
	STAGE.
	PRINT "Interstage Fairing Jettisoned.".
	STAGE.
	PRINT "Stage Separation".
	WAIT 1.
	SET THROTTLE TO 1.0.
}

UNTIL SHIP:APOAPSIS > 80000 {
	//go (almost) straight up out of the thickest part of the atmosphere
	IF ALTITUDE > 500 { //heading by altitude, try not to hit the pad
		IF ALTITUDE > 5000 {
			IF ALTITUDE > 10000 {
			    IF ALTITUDE > 15000 {
				    IF ALTITUDE > 20000 { 
						IF ALTITUDE > 25000 {
						    IF ALTITUDE > 30000 {
							    IF ALTITUDE > 40000 {
								    IF ALTITUDE > 60000 {
									    SET DIRECTION TO HEADING(90,10).
									}
									} ELSE {
									    SET DIRECTION TO HEADING(90,20).
									}
								} ELSE {
								    SET DIRECTION TO HEADING(90,30).
								}
								
							} ELSE {
							    SET DIRECTION TO HEADING(90,40).
							}
						} ELSE {
						    SET DIRECTION TO HEADING(90,50).
						}
					} ELSE {
					    SET DIRECTION TO HEADING(90,60).
					}
				} ELSE {
				    SET DIRECTION TO HEADING(90,70).
				}
		    } ELSE {
			    SET DIRECTION TO HEADING(90,75).
		    }	
		} ELSE {
			SET DIRECTION TO HEADING(90,80).
		}		
	}
	WAIT 5.
}

//coast to space
SET THROTTLE TO 0.0.
UNTIL ALTITUDE > 70000 {
    LOCK STEERING TO SHIP:PROGRADE.
}

//make a node at the apoapsis to circularize
PRINT "Plotting Circularization Node.".

SET CIRC TO NODE(TIME:SECONDS+ETA:APOAPSIS,0,0,0). //set node at apoapsis, with no course changes

ADD CIRC. //add the node to the flight plan for the vessel

UNTIL CIRC:ORBIT:PERIAPSIS > 0 { //add velocity to node until periapsis is not in the ground
    SET CIRC:PROGRADE TO CIRC:PROGRADE+100.
}

UNTIL CIRC:ORBIT:PERIAPSIS > 40000 { //fine tuning
    SET CIRC:PROGRADE TO CIRC:PROGRADE+50.
}

UNTIL CIRC:ORBIT:PERIAPSIS > 60000 { //very fine tuning
    SET CIRC:PROGRADE TO CIRC:PROGRADE+10.
}

UNTIL CIRC:ORBIT:PERIAPSIS > 80000 { //more tuning
    SET CIRC:PROGRADE TO CIRC:PROGRADE+5.
}

//print new orbital parameters
PRINT "New Apoapsis: " + CIRC:ORBIT:APOAPSIS.
PRINT "New Periapsis: " + CIRC:ORBIT:PERIAPSIS.

//rotate the vessel to the correct orientation
PRINT "Aligning vessel with maneuver node burn direction.".
LOCK STEERING TO CIRC:DELTAV:DIRECTION.
WAIT 15.

//calculate time to maneuver burn
SET SHIPACC TO SHIP:MAXTHRUST/SHIP:MASS.
SET CRUDEBURNTIME TO CIRC:DELTAV:MAG/SHIPACC. //approximate maneuver burn time in seconds

SET ETATOBURN TO CIRC:ETA-(CRUDEBURNTIME/2). //time to node burn
PRINT "Time to burn = " + ETATOBURN + " seconds.".

WARPTO(TIME:SECONDS + ETATOBURN-10). 
WAIT 10.



