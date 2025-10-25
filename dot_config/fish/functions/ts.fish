function ts
    # usage guard
    if test (count $argv) -lt 2
        echo "usage: ts <session_name> <template_name>"
        return 1
    end

    set session $argv[1]
    set template  $argv[2]
    set tplfile  ~/tmux_sessions/$template.yaml

    if not test -f $tplfile
        echo "ts: template not found: $tplfile"
        return 1
    end

    tmuxp load -s $session $tplfile
end
