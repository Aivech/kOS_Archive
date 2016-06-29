//functions for making and executing maneuver nodes
@lazyglobal off. //not permanent


//make a node to change an apsis
function apsisnode {
	parameter anomaly.  //true anomaly at burn, in degrees
	parameter semimajaxis. //desired semi-major axis of orbit after burn
	
	print "Building maneuver node to change apsis.".
	print "True anomaly at burn: " + round(anomaly,2) + " degrees.".
	print "Target semimajor axis: " + round(semimajaxis,2) + " meters.".
	
	//things we need
	//all the calculations use radians
	local radanomaly is anomaly*constant:degtorad.
	local anomalynow is ship:orbit:trueanomaly*constant:degtorad.
	
	//universal time at node
	//step 1: true anomaly to eccentric anomaly
	local eccanomalynow is arcsin((sqrt(1-ship:orbit:eccentricity^2)*sin(anomalynow))/(1+ship:orbit:eccentricity*cos(anomalynow))).
	local nodeeccanomaly is arcsin((sqrt(1-ship:orbit:eccentricity^2)*sin(radanomaly))/(1+ship:orbit:eccentricity*cos(radanomaly))).
	//step 2: eccentric anomaly to mean anomaly
	local meananomalynow is eccanomalynow-ship:orbit:eccentricity*sin(eccanomalynow).
	local nodemeananomaly is nodeeccanomaly-ship:orbit:eccentricity*sin(nodeeccanomaly).
	//step 3: pretend current position is epoch
	local meanangularmotion is (2*constant:pi)/ship:orbit:period. //average angular speed in radians per second
	local timeatnode is ((nodemeananomaly-meananomalynow)/meanangularmotion)+time:seconds. //solve M = M_0 + n(t - t_0) for t
	
	//orbital speed calculations
	local positionfromcurrent is positionat(ship,timeatnode). //vector pointing to future position from current position
	local radialaltatnode is positionfromcurrent-ship:body:position. //vector pointing to future position from SOI-BODY
	local positionatnode is radialaltatnode:mag. //but we want scalar altitude
	local orbitalspeedatnode is sqrt(ship:body:mu*((2/positionatnode)-(1/ship:orbit:semimajoraxis)). //orbital speed at node is:
	local desiredorbitalspeed is sqrt(ship:body:mu*((2/positionatnode)-(1/semimajaxis)). //orbital speed at node should be this for the orbit we want
	
	//delta-v calculations
	local nodedeltav is desiredorbitalspeed-orbitalspeedatnode.
	
	//return value
	print "Node complete! DeltaV required: " + nodedeltav + " m/s.".
	return node(timeatnode, 0, 0, nodedeltav).
}
