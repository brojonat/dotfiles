# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "$HOME/projects/router-templates"

# Create session with specified name if supplied, else does not specify.
# The current project name is used if this line is not present.
if initialize_session "router-templates"; then

  # Create a new window inline within session layout definition.
  new_window "main"

  # Split window into panes and send commands immediately after each split

  # Split vertically (left 50%, right 50%)
  split_h 50
  # Currently in RIGHT pane after split, move to left
  tmuxifier-tmux select-pane -t "$session:$window" -L
  # Send vim command to left pane
  run_cmd "vim"

  # Move to right pane
  tmuxifier-tmux select-pane -t "$session:$window" -R
  # Split right pane horizontally (top 50%, bottom 50%)
  split_v 50
  # Currently in BOTTOM right pane after split_h, move to top
  tmuxifier-tmux select-pane -t "$session:$window" -U
  # Send claude-yolo command to top right pane
  run_cmd "claude-yolo -c || claude-yolo"

  # Move down to bottom right pane
  tmuxifier-tmux select-pane -t "$session:$window" -D
  # Send source .env command to bottom right pane
  run_cmd "set +o allexport; source .env; set -o allexport"

  # Move back to left pane (vim)
  tmuxifier-tmux select-pane -t "$session:$window" -L

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
