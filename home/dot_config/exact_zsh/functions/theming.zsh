zwhiskers() {
  emulate -L zsh
  if [[ -z "$1" ]]; then
    echo "usage: zwhiskers <template> [latte|mocha] [whiskers-args...]" >&2
    return 1
  fi

  local template="$1"
  local mode="${2:-mocha}"
  shift $(( $# >= 2 ? 2 : 1 ))

  local flavor palette
  case "$mode" in
    dark|mocha)  flavor=mocha palette=dark  ;;
    light|latte) flavor=latte palette=light ;;
    *) echo "mode must be 'mocha' or 'latte'" >&2; return 1 ;;
  esac

  local repo_root source_json overrides
  repo_root=$(git -C "$(chezmoi source-path)" rev-parse --show-toplevel) || return 1
  source_json="$repo_root/themes/zuppuccin.json"
  overrides=$(jq -c ".${palette}.palette" "$source_json") || return 1

  whiskers -f "$flavor" --color-overrides "$overrides" "$template" "$@"
}
