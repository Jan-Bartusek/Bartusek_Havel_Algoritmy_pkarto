# create a small PROJ test script to compare projection offsets
cat << 'EOF' > proj_test.sh

#!/bin/bash
# PROJ gnomonic projection definition
P="+proj=gnom +lat_0=35.2644 +lon_0=45 +R=6380000"
# step size in degrees
h=0.0001
# base geographic point (lon lat)
Q="10 10"
# offset points for northward and eastward moves
Q_u="10 10.0001"
Q_v="10.0001 10"
# project the base and offset points
read x0 y0 <<< $(echo $Q   | proj $P)
read xu yu <<< $(echo $Q_u | proj $P)
read xv yv <<< $(echo $Q_v | proj $P)
# compute projected coordinate differences
du_x=$(echo "$xu - $x0" | bc -l)
du_y=$(echo "$yu - $y0" | bc -l)
dv_x=$(echo "$xv - $x0" | bc -l)
dv_y=$(echo "$yv - $y0" | bc -l)
# compute vector lengths in projected space
mp=$(echo "sqrt($du_x^2 + $du_y^2)" | bc -l)
mr=$(echo "sqrt($dv_x^2 + $dv_y^2)" | bc -l)
echo "mp (meridian): $mp"
echo "mr (parallel): $mr"
EOF