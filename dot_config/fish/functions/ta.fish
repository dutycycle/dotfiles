function ta --wraps='tmux attach' --description 'Attach to (or create) a tmux session'
    set -l argc (count $argv)
    if test $argc -gt 2
        echo "usage: ta [session] [template]"
        return 1
    end

    set -l inside_tmux 0
    if set -q TMUX
        set inside_tmux 1
    end

    set -l session ""
    set -l template ""

    if test $argc -eq 0
        set -l sessions (tmux list-sessions -F '#S' 2>/dev/null)
        if test $status -ne 0 -o (count $sessions) -eq 0
            echo "ta: no sessions available"
            return 1
        end

        set session (printf '%s\n' $sessions | fzf)
        set -l picker_status $status
        if test $picker_status -ne 0 -o -z "$session"
            return $picker_status
        end
    else
        set session $argv[1]
        if test $argc -eq 2
            set template $argv[2]
        end
    end

    set -l session_exists 0
    tmux has-session -t $session 2>/dev/null
    if test $status -eq 0
        set session_exists 1
    end

    if test -n "$template"
        set -l tplfile ~/tmux_sessions/$template.yaml
        if not test -f $tplfile
            echo "ta: template not found: $tplfile"
            return 1
        end

        if test $session_exists -eq 0
            if test $inside_tmux -eq 1
                tmuxp load -d -s $session $tplfile
                set -l load_status $status
                if test $load_status -ne 0
                    return $load_status
                end
                tmux switch-client -t $session
                return $status
            else
                tmuxp load -s $session $tplfile
                return $status
            end
        else
            if test $inside_tmux -eq 1
                tmux switch-client -t $session
            else
                tmux attach -t $session
            end
            return $status
        end
    end

    if test $session_exists -eq 0
        if test $inside_tmux -eq 1
            tmux new-session -ds $session
            set -l new_status $status
            if test $new_status -ne 0
                return $new_status
            end
            tmux switch-client -t $session
            return $status
        else
            tmux new -s $session
            return $status
        end
    else
        if test $inside_tmux -eq 1
            tmux switch-client -t $session
            return $status
        else
            tmux attach -t $session
            return $status
        end
    end
end
