#!/bin/bash
echo Connecting to local IP $1, via $2

ssh -N -L 8000:$1:443 -L 5900:$1:5900 -L 5901:$1:5901 -L 3668:$1:3668 -L 3669:$1:3669 $2

echo Exiting
