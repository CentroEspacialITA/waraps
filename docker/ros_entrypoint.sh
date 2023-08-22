export DISPLAY=:20
Xvfb $DISPLAY -screen 0 1366x768x16 &
x11vnc -display $DISPLAY -passwd C2801it@  -N -forever -rfbport 8000 &
exec "$@"
