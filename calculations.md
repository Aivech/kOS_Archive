List of formulas used in making scripts.
-------------------------------------------------------------
orbital velocity vector ==  vOV
orbital position vector == vOP
eccentricity vector == vE

true anomaly == tA
mean anomaly == mA
eccentric anomaly == eA

apoapse == ap
periapse == pe
eccentricity == e

arg. of periapse: argPe

precision == p

true anomaly at current location 
------------
if vOV * vOP >= 0
arccos({*vE*vOP}/{abs[vE]*abs[vOP]})
else
-[-2pi+arccos({*vE*vOP}/{abs[vE]*abs[vOP]})]

eccentricity from ap and pe
------------------------------
(ap+pe)/(ap-pe)

eccentric anomaly from true anomaly and eccentricity
---------------
arcsin([sqrt{1-e^2}*sin{tA}]/[1+e*cos{tA}])

mean anomaly from eccentric anomaly and eccentricity
---------------------------

eA- e sin eA

eccentric anomaly from mean anomaly
--------------------------------------
initial guess == (180-mA)/2

f(eA) == eA - e*sin(eA) - mA
f'(eA) == 1 - e*cos(eA)

eA - [(eA - e*sin(eA) - mA)/(1 - e*cos(eA))]

iterate for either desired precision or fixed number of iterations

true anomaly at ascending node
------------------------------------------------------------
2pi - argPe

true anomaly at position "north"
----------------------------------------------
(tA at AN) + pi/2
if result > 2pi
result-2pi

ETA to position of given mean anomaly
------------------------------------------------------
avgAngSpeed == 2pi/orbital_period

((targetmA - currentmA)/avgAngSpeed) + timenow == timeattarget

timeattarget - timenow == ETA to target


