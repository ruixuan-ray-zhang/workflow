#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
#  Claude Code status line — portable, self-contained installer
#
#  A two-line status bar showing model, effort, project, git branch, PR, token
#  counts, a context-usage bar, session cost, 5h/7d rate-limit usage, elapsed
#  time, and a diff summary.
#
#  Usage:
#    bash statusline-install.sh              install; refuse to touch an existing
#                                            status line (prints what to do next)
#    bash statusline-install.sh --replace    back up settings.json, then point
#                                            statusLine at this renderer
#    bash statusline-install.sh --chain      keep the existing status line script
#                                            and append a call to this renderer
#    bash statusline-install.sh --help
#
#  Safe by default: never overwrites settings.json (jq-merges the single
#  .statusLine key), never clobbers an existing status line without an explicit
#  flag, and backs up anything it edits as <file>.bak.<pid>.
#
#  Portable across macOS (BSD date) and Linux (GNU date). Requires: bash, jq.
#  Honors $CLAUDE_CONFIG_DIR; defaults to ~/.claude.
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

MODE=default
for arg in "$@"; do
  case "$arg" in
    --replace) MODE=replace ;;
    --chain)   MODE=chain ;;
    -h|--help) awk 'NR==1{next} /^#/{sub(/^#[ ]?/,""); print; next} {exit}' "$0"; exit 0 ;;
    *) echo "unknown option: $arg (try --help)" >&2; exit 2 ;;
  esac
done

CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
SL="$CLAUDE_DIR/statusline-command.sh"
SETTINGS="$CLAUDE_DIR/settings.json"

command -v jq >/dev/null 2>&1 || {
  echo "error: jq is required.  macOS: brew install jq   Debian/Ubuntu: apt-get install jq" >&2
  exit 1
}
mkdir -p "$CLAUDE_DIR"

# ── 1. install the renderer ──────────────────────────────────────────────────
cat > "$SL" <<'STATUSLINE_EOF'
#!/bin/bash
# Claude Code status line
# Format:
#   Line 1: [Model] [effort]  folder project  branch  PR#N(state)  ↑in ↓out  used% (usedK/totalK)  $cost  5h/7d rate  stopwatch elapsed
#   Line 2: N files +added -removed

input=$(cat)

# ---------- Raw data ----------
model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
cwd=$(echo "$input" | jq -r '.cwd // ""')
transcript=$(echo "$input" | jq -r '.transcript_path // ""')

total_in=$(echo "$input"  | jq -r '.context_window.total_input_tokens  // 0')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
ctx_size=$(echo "$input"  | jq -r '.context_window.context_window_size // 0')
used_pct=$(echo "$input"  | jq -r '.context_window.used_percentage // empty')

cur_in=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')

# ---------- Colors ----------
reset="\033[0m"
bold="\033[1m"
cyan="\033[36m"
blue="\033[38;5;27m"
green="\033[32m"
yellow="\033[33m"
orange="\033[38;5;214m"
red="\033[31m"
dim="\033[2m"
white="\033[37m"

# ---------- Model ----------
# e.g. "Claude Opus 4.6" -> "Opus 4.6"
short_model=$(echo "$model" | sed 's/^Claude //')
model_part=$(printf "${bold}${blue}[%s]${reset}" "$short_model")

# ---------- Effort level ----------
effort_part=""
effort=$(echo "$input" | jq -r '.effort.level // empty')
[ -n "$effort" ] && effort_part=$(printf "${dim}[%s]${reset}" "$effort")

# ---------- Project name ----------
project_name=$(basename "$cwd")
project_part=$(printf "📁 ${bold}%s${reset}" "$project_name")

# ---------- Git branch ----------
branch=""
if [ -n "$cwd" ] && [ -d "$cwd" ]; then
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
  if [ -z "$branch" ]; then
    branch=$(git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  fi
fi
if [ -n "$branch" ]; then
  branch_part=$(printf "🌿 ${green}%s${reset}" "$branch")
else
  branch_part=""
fi

# ---------- PR badge ----------
pr_part=""
pr_num=$(echo "$input" | jq -r '.pr.number // empty')
pr_state=$(echo "$input" | jq -r '.pr.review_state // "open"')
[ -n "$pr_num" ] && pr_part=$(printf "PR#%s(%s)" "$pr_num" "$pr_state")

# ---------- Token counts (↑ input ↓ output) ----------
fmt_k() {
  local n=$1
  if [ "$n" -ge 1000 ]; then
    printf "%dk" $(( n / 1000 ))
  else
    printf "%d" "$n"
  fi
}
in_fmt=$(fmt_k "$total_in")
out_fmt=$(fmt_k "$total_out")
tokens_part=$(printf "${white}↑%s ↓%s${reset}" "$in_fmt" "$out_fmt")

# ---------- Context bar + percentage ----------
ctx_part=""
# When used_pct is empty (no API calls yet) but ctx_size is known, treat as 0%
if [ -z "$used_pct" ] && [ "$ctx_size" -gt 0 ]; then
  used_pct=0
fi
if [ -n "$used_pct" ] && [ "$ctx_size" -gt 0 ]; then
  used_pct_int=$(printf "%.0f" "$used_pct")
  total_k=$(( ctx_size / 1000 ))
  # Derive used_k directly from used_percentage * context_window_size
  used_k=$(awk "BEGIN { printf \"%d\", $used_pct * $ctx_size / 100000 }")

  # Color based on usage
  if [ "$used_pct_int" -ge 90 ]; then
    bar_color="$red"
  elif [ "$used_pct_int" -ge 70 ]; then
    bar_color="$orange"
  elif [ "$used_pct_int" -ge 40 ]; then
    bar_color="$yellow"
  else
    bar_color="$green"
  fi

  # Build a 10-char progress bar
  filled=$(( used_pct_int / 10 ))
  empty=$(( 10 - filled ))
  bar=""
  i=0
  while [ $i -lt $filled ]; do bar="${bar}█"; i=$(( i + 1 )); done
  i=0
  while [ $i -lt $empty ]; do bar="${bar}░"; i=$(( i + 1 )); done

  ctx_part=$(printf "${bar_color}%s${reset} ${bold}%d%%${reset} ${dim}(%dk/%dk)${reset}" \
    "$bar" "$used_pct_int" "$used_k" "$total_k")
fi

# ---------- Cost ----------
cost_part=""
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  # Sum all costUSD fields in the transcript JSONL (handles scientific notation and missing fields)
  total_cost=$(jq -rs '[.[].costUSD // 0] | add | if . > 0 then . else empty end' "$transcript" 2>/dev/null \
    | awk '{printf "%.2f", $1}')
  if [ -n "$total_cost" ]; then
    cost_part=$(printf "${orange}\$%s${reset}" "$total_cost")
  fi
fi

# ---------- Rate limits ----------
rate_part=""
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
[ -n "$five_pct" ] && rate_part="5h:$(printf '%.0f' "$five_pct")%"
[ -n "$week_pct" ] && rate_part="$rate_part 7d:$(printf '%.0f' "$week_pct")%"
rate_part=$(echo "$rate_part" | sed 's/^ //') # trim leading space when five_pct absent

# ---------- Elapsed time ----------
# GNU date (-d) on Linux/HPC, BSD date (-j -f) on macOS. Only the difference
# t2-t1 is used, so the UTC-vs-local offset cancels out on the BSD path.
to_epoch() {
  local ts="${1%%.*}"
  date -d "$ts" "+%s" 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%S" "$ts" "+%s" 2>/dev/null
}

time_part=""
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  # First and last timestamps in the transcript
  first_ts=$(grep -o '"timestamp":"[^"]*"' "$transcript" 2>/dev/null | head -1 | grep -o '[0-9T:\.Z+-]*"$' | tr -d '"')
  last_ts=$(grep -o '"timestamp":"[^"]*"' "$transcript" 2>/dev/null | tail -1 | grep -o '[0-9T:\.Z+-]*"$' | tr -d '"')
  if [ -n "$first_ts" ] && [ -n "$last_ts" ]; then
    t1=$(to_epoch "$first_ts")
    t2=$(to_epoch "$last_ts")
    if [ -n "$t1" ] && [ -n "$t2" ] && [ "$t2" -ge "$t1" ]; then
      elapsed=$(( t2 - t1 ))
      mins=$(( elapsed / 60 ))
      secs=$(( elapsed % 60 ))
      time_part=$(printf "⏱  ${dim}%dm %ds${reset}" "$mins" "$secs")
    fi
  fi
fi

# ---------- Git file changes ----------
changes_part=""
if [ -n "$cwd" ] && [ -d "$cwd" ]; then
  git_diff=$(git -C "$cwd" --no-optional-locks diff --shortstat HEAD 2>/dev/null)
  if [ -n "$git_diff" ]; then
    files=$(echo "$git_diff" | grep -o '[0-9]* file' | grep -o '[0-9]*')
    added=$(echo "$git_diff" | grep -o '[0-9]* insertion' | grep -o '[0-9]*')
    removed=$(echo "$git_diff" | grep -o '[0-9]* deletion' | grep -o '[0-9]*')
    [ -z "$files" ]   && files=0
    [ -z "$added" ]   && added=0
    [ -z "$removed" ] && removed=0
    if [ "$files" -gt 0 ] || [ "$added" -gt 0 ] || [ "$removed" -gt 0 ]; then
      changes_part=$(printf "${dim}%s files${reset} ${green}+%s${reset} ${red}-%s${reset}" \
        "$files" "$added" "$removed")
    fi
  fi
fi

# ---------- Assemble line 1 ----------
line1="$model_part"
[ -n "$effort_part" ]  && line1="$line1 $effort_part"
line1="$line1  $project_part"
[ -n "$branch_part" ]  && line1="$line1  $branch_part"
[ -n "$pr_part" ]      && line1="$line1  $pr_part"
line1="$line1  $tokens_part"
[ -n "$ctx_part" ]     && line1="$line1  $ctx_part"
[ -n "$cost_part" ]    && line1="$line1  $cost_part"
[ -n "$rate_part" ]    && line1="$line1  $(printf "${dim}%s${reset}" "$rate_part")"
[ -n "$time_part" ]    && line1="$line1  $time_part"

printf "%b\n" "$line1"

# ---------- Assemble line 2 ----------
if [ -n "$changes_part" ]; then
  printf "%b\n" "$changes_part"
fi
STATUSLINE_EOF
chmod +x "$SL"
echo "✓ installed  $SL"

# ── 2. wire it into settings.json ────────────────────────────────────────────
set_statusline() {
  local tmp
  if [ -f "$SETTINGS" ]; then
    cp "$SETTINGS" "$SETTINGS.bak.$$"
    tmp=$(mktemp)
    # Merge: only .statusLine is replaced; every other key is preserved.
    jq --arg cmd "$SL" '.statusLine = {type:"command", command:$cmd}' "$SETTINGS" > "$tmp"
    mv "$tmp" "$SETTINGS"
    echo "✓ merged     $SETTINGS   (backup: $SETTINGS.bak.$$)"
  else
    jq -n --arg cmd "$SL" '{statusLine:{type:"command", command:$cmd}}' > "$SETTINGS"
    echo "✓ created    $SETTINGS"
  fi
}

# Append a call to the renderer at the end of an existing status line script,
# forwarding the stdin JSON that script already consumed.
chain_into() {
  local target="$1" var
  if [ ! -w "$target" ]; then
    echo "error: $target is not writable; cannot chain." >&2
    return 1
  fi
  if grep -q 'statusline-command.sh' "$target"; then
    echo "= already chained  $target"
    return 0
  fi
  # A status line script must read stdin exactly once. Find the variable it
  # stored that JSON in, so we can forward the same value instead of re-reading
  # an already-drained stdin.
  # '|| true': under 'set -o pipefail' a no-match grep would otherwise abort the
  # script before the explanatory error below can be printed.
  var=$(grep -oE '^[[:space:]]*[A-Za-z_][A-Za-z0-9_]*=\$\(cat\)' "$target" \
        | head -1 | sed -E 's/^[[:space:]]*([A-Za-z_][A-Za-z0-9_]*)=.*/\1/') || true
  if [ -z "$var" ]; then
    echo "error: no 'var=\$(cat)' line found in $target, so the stdin JSON cannot" >&2
    echo "       be forwarded safely. Chain it by hand, or use --replace." >&2
    return 1
  fi
  cp "$target" "$target.bak.$$"
  cat >> "$target" <<CHAIN_EOF

# ── Render via statusline-command.sh (added by statusline-install.sh) ──
# Forwards the stdin JSON already consumed into \$$var above.
if [ -x "$SL" ]; then
  printf '%s' "\$$var" | "$SL"
fi
CHAIN_EOF
  echo "✓ chained    $target   (backup: $target.bak.$$)"
}

CURRENT=""
[ -f "$SETTINGS" ] && CURRENT=$(jq -r '.statusLine.command // ""' "$SETTINGS" 2>/dev/null || echo "")

if [ -z "$CURRENT" ] || [ "$CURRENT" = "$SL" ]; then
  set_statusline
else
  case "$MODE" in
    replace) set_statusline ;;
    chain)   chain_into "$CURRENT" ;;
    default)
      echo
      echo "! A status line is already configured and was left untouched:"
      echo "    $CURRENT"
      echo
      echo "  Choose one and re-run:"
      echo "    --chain     keep it and append a call to the new renderer"
      echo "                (correct when that script does other work too, e.g."
      echo "                 feeding data to another tool)"
      echo "    --replace   back up settings.json and point statusLine here"
      echo
      exit 3 ;;
  esac
fi

# ── 3. preview ───────────────────────────────────────────────────────────────
echo
echo "preview:"
jq -nc --arg cwd "$PWD" '{
  model:{display_name:"Claude Opus 5"},
  cwd:$cwd,
  effort:{level:"high"},
  context_window:{total_input_tokens:45000,total_output_tokens:8000,
                  context_window_size:200000,used_percentage:12},
  rate_limits:{five_hour:{used_percentage:31},seven_day:{used_percentage:59}}
}' | bash "$SL"
echo
echo "Done. Claude Code re-runs the status line on every message, so no restart"
echo "is needed - send a message to see it."
