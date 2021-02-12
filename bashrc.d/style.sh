export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
export CLICOLOR=1

#===================================#
#----------Prompt settings----------#
#===================================#
# CREDIT: https://github.com/necolas/dotfiles/blob/master/shell/bash_prompt

set_theme_by_tod() {
	dt=$(date +%H)
	if [[ ${dt#0} -gt 8 && ${dt#0} -lt 16 ]]; then
		set_light
	else
		set_dark
	fi

	echo -e "\033]50;SetProfile=$ITERM_PROFILE\a"
}

toggle_theme() {
	if [[ $ITERM_PROFILE == cpl ]]; then
		set_dark
	else
		set_light
	fi
	echo -e "\033]50;SetProfile=$ITERM_PROFILE\a"
}

set_light() {
	export BAT_THEME='Solarized (light)'
	export ITERM_PROFILE=cpl
	git config --global core.pager "delta --theme='Solarized (light)'"
}

set_dark() {
	export BAT_THEME='Solarized (dark)'
	export ITERM_PROFILE='cpd'
	git config --global core.pager "delta --theme='Solarized (dark)'"
}
set_theme_by_tod

unset set_prompts
