export DISPLAY=:20
Xvfb $DISPLAY -screen 0 1366x768x16 &
x11vnc -display $DISPLAY -passwd C2801it@  -N -forever -rfbport 8000 &
source "/opt/conceptio/conceptio_msgs/install/setup.bash"
source "/opt/conceptio/remote_id/ros2_ws/install/setup.bash"
tmux new -d 'ros2 run remoteid_pubsub talker'
tmux new -d '/opt/conceptio/remote_id/RemoteID/build/remote l'

exec "$@"