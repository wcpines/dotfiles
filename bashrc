# Use $HOME/dotfiles/bashrc.d

export PATH=/opt/homebrew/bin:$PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

if [[ -f ~/.env.sh ]]; then
	set -a
	source ~/.env.sh
	set +a
fi

# Source bashrc.d files in lexicographic order, but pin exports_and_path.sh
# first so PATH and env vars are set before anything else runs.
files=("${HOME}"/dotfiles/bashrc.d/*.sh)
pinned="${HOME}/dotfiles/bashrc.d/exports_and_path.sh"
files=("${files[@]/$pinned}")
files=("$pinned" "${files[@]}")

for file in "${files[@]}"; do
	[[ -n $file ]] || continue
	# If a file returns non-zero, warn so a single broken file is visible
	# instead of silently breaking everything that comes after it.
	source "$file" || echo "bashrc.d: $file exited $?" >&2
done

# Exit early for non-interactive shells (e.g. Claude Code, scripts)
[[ $- == *i* ]] || return

eval "$(starship init bash)"

# Repair terminal modes before each prompt. This makes Ctrl-Z from full-screen
# TUIs less likely to leave Bash reading mouse/key escape sequences.
__pi_prompt_fix_terminal_modes() {
	[[ -t 0 && -t 1 ]] || return
	stty sane 2>/dev/null
	printf '\033[?1000l\033[?1002l\033[?1003l\033[?1004l\033[?1006l\033[?1015l\033[?2004l\033[>4;0m' 2>/dev/null
}
PROMPT_COMMAND="__pi_prompt_fix_terminal_modes${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

trap '' SIGINT # Prevent Ctrl-C from killing the shell at the prompt

eval "$(direnv hook bash)"

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init bash)"; fi

[ -s "/Users/colby/.scm_breeze/scm_breeze.sh" ] && source "/Users/colby/.scm_breeze/scm_breeze.sh"
