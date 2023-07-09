BLK="04" CHR="04" DIR="04" EXE="00" REG="00" HARDLINK="00" SYMLINK="06" MISSING="00" ORPHAN="01" FIFO="0F" SOCK="0F" OTHER="02"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"

n () {
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi
    export NNN_OPENER="$(which xdg-open)"
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    nnn -e -a "$@"
    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi

	if [ $TERM = "tmux-256color" ]; then
		echo $(pwd) >> /tmp/nnn/tmuxcd
	fi
}

nnn_cd() {
    if ! [ -z "$NNN_PIPE" ]; then
        printf "%s\0" "0c${PWD}" > "${NNN_PIPE}" !&
    fi
}

np () {
    tmux new 'n -P p'
	cd $(cat /tmp/nnn/tmuxcd)
    rm /tmp/nnn/tmuxcd
}

trap nnn_cd EXIT
export NNN_TERMINAL="tmux"
export NNN_FIFO="/tmp/nnn.fifo"
