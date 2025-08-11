export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
export CLICOLOR=1

#===================================#
#----------Prompt settings----------#
#===================================#
# CREDIT: https://github.com/necolas/dotfiles/blob/master/shell/bash_prompt

# Function to switch iTerm2 profile
switch_iterm2_profile() {
  echo -e "\033]1337;SetProfile=$1\007"
  echo -e "\033]50;SetProfile=$1\a"
}

toggle_theme() {
  if [[ $ITERM_PROFILE == solarized-light ]]; then
    set_dark
  else
    set_light
  fi
}

set_light() {
  export ITERM_PROFILE='solarized-light'
  export BAT_THEME='Solarized (light)'
  git config --global core.pager "delta --theme='Solarized (light)'"
  switch_iterm2_profile "$ITERM_PROFILE"
  echo "$ITERM_PROFILE" > ~/.current_color_theme_cache.txt
  printf "Theme set to %s\n" "$ITERM_PROFILE"
}

set_dark() {
  export ITERM_PROFILE='solarized-dark'
  export BAT_THEME='Solarized (dark)'
  git config --global core.pager "delta --theme='Solarized (dark)'"
  switch_iterm2_profile "$ITERM_PROFILE"
  echo "$ITERM_PROFILE" > ~/.current_color_theme_cache.txt
  printf "Theme set to %s\n" "$ITERM_PROFILE"
}

set_rose_pine() {
  export ITERM_PROFILE='rose-pine'
  export BAT_THEME='Monokai Extended'
  git config --global core.pager "delta --theme='Monokai Extended'"
  switch_iterm2_profile "$ITERM_PROFILE"
  echo "$ITERM_PROFILE" > ~/.current_color_theme_cache.txt
  printf "Theme set to %s\n" "$ITERM_PROFILE"
}

set_rose_pine_moon() {
  export ITERM_PROFILE='rose-pine-moon'
  export BAT_THEME='Monokai Extended'
  git config --global core.pager "delta --theme='Monokai Extended'"
  switch_iterm2_profile "$ITERM_PROFILE"
  echo "$ITERM_PROFILE" > ~/.current_color_theme_cache.txt
  printf "Theme set to %s\n" "$ITERM_PROFILE"
}

set_rose_pine_dawn() {
  export ITERM_PROFILE='rose-pine-dawn'
  export BAT_THEME='Monokai Extended Light'
  git config --global core.pager "delta --theme='GitHub'"
  switch_iterm2_profile "$ITERM_PROFILE"
  echo "$ITERM_PROFILE" > ~/.current_color_theme_cache.txt
  printf "Theme set to %s\n" "$ITERM_PROFILE"
}

set_kanagawa() {
  export ITERM_PROFILE='kanagawa'
  export BAT_THEME='Monokai Extended'
  git config --global core.pager "delta --theme='Monokai Extended'"
  switch_iterm2_profile "$ITERM_PROFILE"
  echo "$ITERM_PROFILE" > ~/.current_color_theme_cache.txt
  printf "Theme set to %s\n" "$ITERM_PROFILE"
}

set_theme_by_tod() {
  local hour
  hour=$(date +%H)
  if ((10#$hour > 9 && 10#$hour < 18)); then
    set_light
  else
    set_dark
  fi
}

# Set the initial theme based on time of day
# set_theme_by_tod

# Alias for toggling theme
alias tt="toggle_theme"

# Function to get current colorscheme
get_current_colorscheme() {
  echo "Current profile: $ITERM_PROFILE"
  echo "Current BAT theme: $BAT_THEME"
  echo "Current Git pager theme: $(git config --get core.pager | grep -o "theme='[^']*'" | cut -d"'" -f2)"
}

# Alias for getting current colorscheme
alias gcs="get_current_colorscheme"
