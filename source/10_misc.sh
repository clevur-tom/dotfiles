# From http://stackoverflow.com/questions/370047/#370255
function path_remove() {
  IFS=:
  # convert it to an array
  t=($PATH)
  unset IFS
  # perform any array operations to remove elements from the array
  t=(${t[@]%%$1})
  IFS=:
  # output the new array
  echo "${t[*]}"
}

# tmux window renaming based on ssh hostname
ssh() {
    if [ "$HOSTNAME" = <secret1> ]; then
        tmux rename-window "$*"
        command ssh "$@"
    else
        command ssh "$@"
    fi
}

# make screens darker so I don't get blinded from my monitors
function brightness(){
    if [ $# -gt 0 ]; then
        # set brightnessValue
        brightnessValue=$1
        # get activeDisplay
        activeDisplay=$(xrandr | grep connected | cut -f1 -d" ")
        # change brightness if $activeDisplay is not empty
        if [ "$activeDisplay" != "" ]; then
            for screen in $activeDisplay
            do
                xrandr --output $screen --brightness $brightnessValue &> /dev/null
            done
        else
            echo "Could not determine active display, run 'xrandr --verbose' for detailed info"
        fi
    else
        echo -e "Error!!! Syntax: brightness <value (0.0 to 1.0)>"
    fi
}

# `s` with no arguments opens the current directory in Sublime Text, otherwise
# opens the given location
function s() {
        if [ $# -eq 0 ]; then
                subl .
        else
                subl "$@"
        fi
}

# `v` with no arguments opens the current directory in Vim, otherwise opens the
# given location
function v() {
        if [ $# -eq 0 ]; then
                vim .
        else
                vim "$@"
        fi
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
        tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX
}

# function to kill all tmux sessions
function killtmux() {
        tmux ls | awk '{print $1}' | sed 's/://g' | xargs -I{} tmux kill-session -t {} ;
}

#
# ALIASES
#

# ssh directly to <secret1> - look at ~/.ssh/config as well for applied options
alias sshb='ssh <secret1>'
