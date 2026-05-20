#!/bin/bash
# Keyboard teleop for AXIOM D1 in Gazebo Classic
# Arrow keys: move | Space: stop | R: reset world | Q: quit

T="/gazebo/drain_cleaning/axiom_d1/vel_cmd"
W="/gazebo/drain_cleaning/world_control"

send() {
  gz topic -p "$T" -m "position{x:$1 y:0 z:0} orientation{x:0 y:0 z:$2 w:1}"
}

echo "=== AXIOM D1 Teleop ==="
echo "  UP    = forward"
echo "  DOWN  = reverse"
echo "  LEFT  = turn left"
echo "  RIGHT = turn right"
echo "  SPACE = stop"
echo "  R     = reset world"
echo "  Q     = quit"
echo "========================"

# Put terminal in raw mode
stty -echo -icanon min 1 time 0

cleanup() { stty sane; echo; echo "Stopped."; }
trap cleanup EXIT

while true; do
  key=$(dd bs=1 count=1 2>/dev/null)
  case "$key" in
    $'\x1b')  # Escape sequence (arrow keys)
      dd bs=1 count=1 2>/dev/null  # read '['
      arrow=$(dd bs=1 count=1 2>/dev/null)
      case "$arrow" in
        A) send 0.15 0 ;;    # Up
        B) send -0.15 0 ;;   # Down
        C) send 0.1 -0.3 ;;  # Right
        D) send 0.1 0.3 ;;   # Left
      esac
      ;;
    ' ') send 0 0 ;;  # Space = stop
    r|R) gz topic -p "$W" -m "reset{all:true}"; echo "Reset!" ;;
    q|Q) break ;;
  esac
done
