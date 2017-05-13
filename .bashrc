#!/usr/bin/env bash

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh

if [[ -n $TMUX_PANE ]]; then
    HISTFILE=~/.tmux/bash_history/bash_history.$(tmux display-message -p '#S').$TMUX_PANE
    export HISTFILE
    if [ ! -f "$HISTFILE" ]; then
        if [ -f ~/temp/tmux_restore_running ]; then
		    pane_index=$(tmux display -pt "${TMUX_PANE}" '#{pane_index}')
		    window_number=$(tmux display -pt "${TMUX_PANE}" '#{window_index}')
		    session_name=$(tmux display -pt "${TMUX_PANE}" '#{session_name}')
            restore_file=~/.tmux/resurrect/bash_history-"$session_name:$window_number.$pane_index"
            if [ -f "$restore_file" ]; then
		        cp "$restore_file" "$HISTFILE"
            fi
        fi
    fi

    touch "$HISTFILE"
    preexec() {
        if [ ! -s "$HISTFILE" ]; then
            history -w
        fi
        history -a
        history -c
        history -r
    }
fi
