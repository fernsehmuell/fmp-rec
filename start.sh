tmux start-server
tmux new-session -d -s FMP -n REC
tmux split-window -t FMP:REC.0
tmux split-window -h -t FMP:REC.0

tmux select-pane -t FMP:REC.0

tmux send-keys -t FMP:REC.0 /home/pi/fmp-rec/fmprec.sh C-m
tmux send-keys -t FMP:REC.2 /home/pi/fmp-rec/info-window.sh C-m


tmux select-pane -t FMP:REC.0



tmux attach
