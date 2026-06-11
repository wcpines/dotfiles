# Use $HOME/dotfiles/bashrc.d

export PATH=/opt/homebrew/bin:$PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

if [[ -f ~/.env.sh ]]; then
  set -a
  source ~/.env.sh
  set +a
fi

for file in "${HOME}"/dotfiles/bashrc.d/*.sh; do
  # Source each file; if it returns non-zero, warn (interactive shells only)
  # so a single broken file is visible instead of silently breaking everything
  # that comes after it in the loop.
  source "$file" || {
    [[ $- == *i* ]] && echo "bashrc.d: $file exited $?" >&2
  }
done

# Exit early for non-interactive shells (e.g. Claude Code, scripts)
[[ $- == *i* ]] || return

eval "$(starship init bash)"
trap '' SIGINT # Prevent Ctrl-C from killing the shell at the prompt

eval "$(direnv hook bash)"

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init bash)"; fi
