#!/usr/bin/env bash
#
# tmux command palette -- bound to prefix + B.
#
#   popup 1: pick a tmux command with fzf (history weighted), then choose which
#            of its parameters to set and fill them in.  The parameters are
#            parsed from `tmux list-commands`, so nothing here is hardcoded per
#            command: `new-session` offers -s session-name, -t target-session,
#            shell-command, ...; `kill-session` offers -t target-session; and
#            only the parameters you select are prompted for.
#   popup 2: for list-sessions, list-windows, list-panes and list-buffers it is
#            an fzf picker -- enter jumps to (or pastes) the chosen item; for
#            everything else it just shows the output.
#
# tmux cannot open a popup from inside a popup: "If the command is run inside
# an existing popup, that popup is modified" (tmux(1), display-popup), and only
# -b -B -C -E -EE -K -N -s -S are honoured there.  So the second popup has to
# be opened from outside the first one, which is why the picker runs as a child
# of this script instead of owning the popup itself.
#
# .tmux.conf:
#   bind-key B run-shell '~/.config/tmux/command-palette.sh "#{client_tty}"'

set -u
set -o pipefail
set -f # no globbing: user-entered values are split on purpose, never expanded

HIST_FILE="${HOME}/.tmux_popup_history"
MAX_HISTORY=50
TAB=$'\t'
SELF=$(readlink -f "$0")

# --------------------------------------------------------------------------
# command list
# --------------------------------------------------------------------------

# One line per command: "cmd<TAB>description<TAB>score".
# The description comes from `tmux list-commands` (authoritative), the score
# from how often and how recently the command was used.
command_candidates() {
	{
		tmux list-commands |
			awk '{ c = $1; $1 = ""; sub(/^[ \t]+/, ""); printf "U\t%s\t%s\n", c, $0 }'

		if [ -f "$HIST_FILE" ]; then
			tail -n "$MAX_HISTORY" "$HIST_FILE" |
				awk -F'\t' -v max="$MAX_HISTORY" '
					NF && $1 != "" { used[$1]++; last[$1] = NR }
					END {
						for (c in used)
							printf "H\t%s\t%.1f\n", c, used[c] * 2 + (max - last[c]) * 0.5
					}'
		fi
	} |
		awk -F'\t' '
			$1 == "U" { desc[$2] = $3; if (!($2 in seen)) { seen[$2] = 1; order[++n] = $2 }; next }
			$1 == "H" { score[$2] = $3; if (!($2 in seen)) { seen[$2] = 1; order[++n] = $2 }; next }
			END {
				for (i = 1; i <= n; i++) {
					c = order[i]
					printf "%s\t%s\t%s\n", c, desc[c], (c in score ? score[c] : "")
				}
			}' |
		sort -t "$TAB" -s -k3,3gr
}

# --------------------------------------------------------------------------
# parameters, parsed from a `tmux list-commands` usage string
# --------------------------------------------------------------------------

# A usage string looks like
#   (new) [-AdDEPX] [-c start-directory] ... [-t target-session] [shell-command [argument ...]]
# i.e. bracketed groups are optional, [-x value] takes a value, a bare [-xyz]
# is one or more switches, and anything else is a positional argument.
#
# Emits one row per settable parameter, value flags and positionals first
# (those are what you normally want), switches last:
#   label<TAB>kind<TAB>key<TAB>placeholder<TAB>seq<TAB>repeatable
command_params() {
	printf '%s\n' "$1" |
		sed 's/^([^)]*) *//' |
		sed -e 's/\[/ [ /g' -e 's/\]/ ] /g' |
		awk '
		{
			depth = 0; n = 0; ns = 0; seq = 0
			for (i = 1; i <= NF; i++) {
				t = $i
				if (t == "[") { depth++; continue }
				if (t == "]") { depth--; continue }
				if (t == "...") { if (n) rep[n] = 1; continue }

				if (t ~ /^-[A-Za-z0-9#]+$/) {
					# -x value  (single flag followed by its placeholder)
					if (length(t) == 2 && i < NF && $(i + 1) ~ /^[a-z][a-z0-9-]*$/) {
						i++
						printf "%s  %s\tflag\t%s\t%s\t%d\t0\n", t, $(i), t, $(i), ++seq
						continue
					}
					# -xyz  (a cluster of switches)
					for (j = 2; j <= length(t); j++) sw[++ns] = "-" substr(t, j, 1)
					continue
				}

				# positional argument
				if (t ~ /^[a-z][a-z0-9-]*$/) name[++n] = t
			}
			for (k = 1; k <= n; k++)
				printf "%s%s\tpos\t%d\t%s\t%d\t%d\n", name[k],
					(rep[k] ? " ..." : ""), k, name[k], ++seq, (rep[k] ? 1 : 0)
			for (k = 1; k <= ns; k++)
				printf "%s  (switch)\tswitch\t%s\t\t%d\t0\n", sw[k], sw[k], ++seq
		}'
}

# Candidate values for a placeholder, as "label<TAB>value" pairs.  Anything
# without candidates is plain text -- you just type it.
value_candidates() {
	case "$1" in
	target-session | session-id)
		tmux list-sessions -F "#{session_name} (#{session_windows} windows)${TAB}#{session_id}"
		;;
	target-window | window-id)
		tmux list-windows -a -F "#{session_name}:#{window_index} #{window_name}${TAB}#{window_id}"
		;;
	target-pane | pane-id)
		tmux list-panes -a -F "#{session_name}:#{window_index}.#{pane_index} #{pane_current_command}${TAB}#{pane_id}"
		;;
	target-client | client-tty)
		tmux list-clients -F "#{client_session} #{client_termname} ${TAB}#{client_tty}"
		;;
	buffer-name)
		tmux list-buffers -F "#{buffer_name} (#{buffer_size} bytes)${TAB}#{buffer_name}"
		;;
	format | key-format)
		tmux display-message -a -p |
			awk -F'=' '{ printf "%s = %s\t#{%s}\n", $1, substr($0, length($1) + 2), $1 }'
		;;
	*) : ;;
	esac
}

# --------------------------------------------------------------------------
# popup 1: pick a command and its arguments (runs in the popup, on its tty)
# --------------------------------------------------------------------------

# Ask for one parameter's value; prints it, returns non-zero if cancelled.
# Pick a candidate with enter, or type and press enter for anything else (a new
# session name, a shell command, ...): fzf exits 0 when a candidate was taken
# and 1 when the typed text matched nothing.
prompt_value() {
	local kind=$1 key=$2 ph=$3 hint candidates out rc
	local -a fzf_args=(--reverse --delimiter="$TAB" --with-nth=1 --nth=1 --print-query)

	if [ "$kind" = flag ]; then hint="$key $ph"; else hint=$ph; fi

	candidates=$(value_candidates "$ph")
	if [ -n "$candidates" ]; then
		hint="$hint   (enter: pick or type · esc: cancel)"
	else
		# nothing to pick from: hide fzf's "0/0" counter
		fzf_args+=(--no-info)
		hint="$hint   (type a value · esc: cancel)"
	fi

	out=$(printf '%s\n' "$candidates" | fzf "${fzf_args[@]}" --header " $hint ")
	rc=$?
	[ "$rc" -eq 130 ] && return 1 # cancelled

	if [ "$rc" -eq 0 ]; then
		# a candidate was chosen
		printf '%s' "$(printf '%s\n' "$out" | sed -n 2p | cut -f2)"
	else
		# no match: whatever was typed
		printf '%s' "$(printf '%s\n' "$out" | sed -n 1p)"
	fi
}

do_pick() {
	local cmd desc line chosen kind key ph seq rep value
	local -a args=() posargs=() parts=()

	: "${PALETTE_PICK:?not called from main}"

	line=$(command_candidates |
		fzf --reverse --delimiter="$TAB" --with-nth=1,2 --nth=1,2) || return 0
	[ -n "$line" ] || return 0

	cmd=$(printf '%s' "$line" | cut -f1)
	desc=$(printf '%s' "$line" | cut -f2)

	# Which parameters to set?  The first row runs the command unchanged.
	chosen=$(
		{
			printf '▶  run with no arguments\trun\t-\t-\t0\t0\n'
			command_params "$desc"
		} |
			fzf --reverse --delimiter="$TAB" --with-nth=1 --nth=1 --multi \
				--header ' tab: set a parameter · enter: run '
	) || return 0
	[ -n "$chosen" ] || return 0

	while IFS="$TAB" read -r _label kind key ph seq rep; do
		[ "$kind" = run ] && continue

		if [ "$kind" = switch ]; then
			args+=("$key")
			continue
		fi

		value=$(prompt_value "$kind" "$key" "$ph") || return 0
		[ -n "$value" ] || continue
		if [ "$kind" = flag ]; then
			args+=("$key" "$value")
			continue
		fi
		if [ "$rep" = 1 ]; then
			read -ra parts <<<"$value"
			posargs+=("${parts[@]}")
		else
			posargs+=("$value")
		fi
	done < <(
		printf '%s\n' "$chosen" |
			awk -F'\t' '$2 != "run"' |
			sort -t "$TAB" -s -k5,5n
	)

	args+=("${posargs[@]}")
	printf '%s\0' "$cmd" "$desc" "${args[@]}" >"$PALETTE_PICK"
}

# --------------------------------------------------------------------------
# popup 2, kind 1: the command listed things that can be jumped to -- pick one
# and act on it (runs inside the popup, on the popup's tty)
# --------------------------------------------------------------------------
do_choose() {
	local list_file=$1 pick_file=$2 hint=$3

	# field 1 is the label the user sees and searches, field 2 is the id.
	# (--with-nth renumbers the fields for --nth, so keep the id last.)
	fzf --reverse --delimiter="$TAB" --with-nth=1 --nth=1 \
		--header " enter: $hint   esc: cancel " <"$list_file" |
		cut -f2 >"$pick_file"
}

apply_action() { # command, chosen id, client tty, client's pane
	local cmd=$1 id=$2 client=${3:-} pane=${4:-}
	local -a copt=() popt=()

	[ -n "$client" ] && copt=(-c "$client")
	[ -n "$pane" ] && popt=(-t "$pane")

	case "$cmd" in
	list-sessions) tmux switch-client "${copt[@]}" -t "$id" ;;
	list-windows)
		tmux select-window -t "$id" &&
			tmux switch-client "${copt[@]}" -t "$id"
		;;
	list-panes)
		tmux select-window -t "$id" &&
			tmux select-pane -t "$id" &&
			tmux switch-client "${copt[@]}" -t "$id"
		;;
	list-buffers) tmux paste-buffer -b "$id" "${popt[@]}" ;;
	esac
}

# --------------------------------------------------------------------------
# main: run popup 1, run the command, then show it in popup 2
# --------------------------------------------------------------------------
main() {
	local client="${1:-}" cmd desc output chosen lines
	local list_fmt="" hint="" context="" history_args="" jump=""
	local -a argv=() copt=() fields=()

	[ -n "$client" ] && copt=(-c "$client")

	local PALETTE_PICK output_file selection_file
	PALETTE_PICK=$(mktemp) || exit 1
	output_file=$(mktemp) || exit 1
	selection_file=$(mktemp) || exit 1
	trap 'rm -f "$PALETTE_PICK" "$output_file" "$selection_file"' EXIT

	tmux display-popup -E "${copt[@]}" -w 50% -h 40% -T ' tmux command ' \
		-e "PALETTE_PICK=$PALETTE_PICK" \
		"$SELF" __pick

	mapfile -d '' -t fields <"$PALETTE_PICK"
	cmd=${fields[0]:-}
	desc=${fields[1]:-}
	argv=("${fields[@]:2}")
	[ -n "$cmd" ] || exit 0
	history_args="${argv[*]}"

	# Commands that list things you can jump to get an fzf picker instead of a
	# plain output popup: "label<TAB>id" lines, the id stays out of sight.
	case "$cmd" in
	list-sessions)
		list_fmt="#{session_name}#{?session_attached, (attached),}${TAB}#{session_id}"
		hint="switch to session"
		;;
	list-windows)
		list_fmt="#{window_index}: #{window_name}#{?window_active, (active),}${TAB}#{window_id}"
		hint="go to window"
		;;
	list-panes)
		list_fmt="#{pane_index}: #{pane_current_command}#{?pane_active, (active),}${TAB}#{pane_id}"
		hint="go to pane"
		;;
	list-buffers)
		list_fmt="#{buffer_name}: #{buffer_size} bytes${TAB}#{buffer_name}"
		hint="paste buffer"
		;;
	esac

	if [ -n "$list_fmt" ] && [ ${#argv[@]} -eq 0 ]; then
		jump=1
		# list-windows/list-panes need a place to start: the client's pane
		[ -n "$client" ] &&
			context=$(tmux display-message -c "$client" -p '#{pane_id}' 2>/dev/null)
		case "$cmd" in
		list-windows | list-panes)
			if [ -n "$context" ]; then
				output=$(tmux "$cmd" -t "$context" -F "$list_fmt" 2>&1)
			else
				output=$(tmux "$cmd" -F "$list_fmt" 2>&1)
			fi
			;;
		*) output=$(tmux "$cmd" -F "$list_fmt" 2>&1) ;;
		esac
	else
		output=$(tmux "$cmd" "${argv[@]}" 2>&1)
	fi

	# remember it
	printf '%s\t%s\t%s\n' "$cmd" "$desc" "$history_args" >>"$HIST_FILE"
	tail -n "$MAX_HISTORY" "$HIST_FILE" >"$HIST_FILE.tmp" &&
		mv "$HIST_FILE.tmp" "$HIST_FILE"

	# popup 2, kind 1: pick one of the listed items and jump to it
	if [ -n "$jump" ] && [ -n "$output" ]; then
		printf '%s\n' "$output" >"$output_file"
		tmux display-popup -E "${copt[@]}" -w 60% -h 50% \
			-T " tmux $cmd " \
			"$SELF" __choose "$output_file" "$selection_file" "$hint"
		chosen=$(sed -n 1p "$selection_file")
		[ -n "$chosen" ] && apply_action "$cmd" "$chosen" "$client" "$context"
		return 0
	fi

	# popup 2, kind 2: plain output
	if [ -n "$output" ]; then
		printf '%s\n' "$output" >"$output_file"
		lines=$(wc -l <"$output_file")
		if [ "$lines" -gt 20 ] && command -v less >/dev/null 2>&1; then
			# long output: scroll it, popup goes away when less quits
			tmux display-popup -E "${copt[@]}" -w 80% -h 70% \
				-T " tmux $cmd " "less -R '$output_file'"
		else
			tmux display-popup -k "${copt[@]}" -w 80% -h 45% \
				-T " tmux $cmd " \
				"cat '$output_file'; printf '\n[ any key to close ]\n'"
		fi
	else
		tmux display-message "${copt[@]}" "tmux $cmd $history_args"
	fi
}

case "${1:-}" in
__pick) do_pick ;;
__choose)
	shift
	do_choose "$@"
	;;
*) main "$@" ;;
esac
