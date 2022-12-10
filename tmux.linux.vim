
set -g default-terminal "screen-256color"
# tell Tmux that outside terminal supports true color
set -ga terminal-overrides ",xterm-256color*:Tc"
set-window-option -g mode-keys vi

set -sg escape-time 0
set -g base-index 1
setw -g pane-base-index 1

#Escape Prefix
#set-option -g prefix C-Space
#unbind-key C-b
#bind-key C-Space send-prefix

#Mouse works as expected
set -g mouse on

#Copy as vim
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi y send-keys -X copy-selection
bind-key -T copy-mode-vi r send-keys -X rectangle-toggle

# Clipboard Copy
bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "xclip -i -f -selection primary | xclip -i -selection clipboard"
bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -i -f -selection primary | xclip -i -selection clipboard"

setw -g monitor-activity on
set -g visual-activity on

set -g mode-keys vi
set -g history-limit 10000

# moving between panes with vim movement keys
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# moving between windows with vim movement keys
bind -r C-h select-window -t :-
bind -r C-l select-window -t :+

# resize panes with vim movement keys
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5
set-option -g lock-command vlock
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'kristijanhusak/tmux-simple-git-status'
set -g @plugin 'schasse/tmux-jump'
#set -g @plugin 'wfxr/tmux-fzf-url'
set -g @plugin 'tmux-plugins/tmux-urlview'
set -g @plugin 'tmux-plugins/tmux-open'
set -g @plugin 'xamut/tmux-network-bandwidth'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'tmux-plugins/tmux-copycat'
set -g @plugin 'tmux-plugins/tmux-sidebar'
set -g @plugin "arcticicestudio/nord-tmux"
set -g @plugin 'Morantron/tmux-fingers'
set -g @plugin 'fcsonline/tmux-thumbs'
set -g @tpm_plugins "                 \
  tmux-plugins/tpm                    \
  stonevil/tmux-lan-status            \
"
set -g @tpm_plugins "                 \
  tmux-plugins/tpm                    \
  stonevil/tmux-wan-status            \
"
# Jump Short cut
set -g @jump-key 'S'
# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
run-shell 'powerline-config tmux setup'
