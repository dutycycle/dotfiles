function ta --wraps='tmux attach' --description 'alias ta tmux attach'
    tmux new -A -s $argv
end
