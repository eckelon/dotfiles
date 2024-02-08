show_git() {
  local index=$1
  local icon="$(get_tmux_option "@catppuccin_git_icon" "")"
  local color="$(get_tmux_option "@catppuccin_git_color" "$thm_blue")"
  local text="$(get_tmux_option "@catppuccin_git_text" "")"

  local module=$( build_status_module "$index" "$icon" "$color" "$text" )

  echo "$module"
}
