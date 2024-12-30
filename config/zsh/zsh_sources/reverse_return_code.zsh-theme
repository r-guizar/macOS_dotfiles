# Based on bira theme

setopt prompt_subst

() {

local PR_USER PR_USER_OP PR_PROMPT PR_HOST

local bg_user_host='%K{237}'
local fg_user_host='%F{26}'

local bg_wd='%K{39}'
local fg_wd='%F{237}'

local fg_git='%F{237}'
local bg_git='%K{11}'

local fg_time='%F{237}'
local bg_time='%K{7}'

local fg_command_count='%F{237}'
local bg_command_count='%K{15}'

local fg_return_code='%F{11}'
local bg_return_code='%K{1}'

# Check the UID
PR_USER="${fg_user_host} %n%f"
PR_USER_OP='%F{green}%#%f'
PR_PROMPT=' ❱'

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
  PR_HOST='%F{9}%M%f' # SSH
else
  PR_HOST="${fg_user_host}%m%f" # no SSH
fi

local user_host_start="%F{black}${bg_user_host}%f%k"
local apple_separator="%F{15}${bg_user_host}%k%f"
local user_host_separator="%F{237}${bg_wd}%k%f"
local time_separator="%F{7}${bg_command_count}%k%f"
local rprompt_start="%F{7}%K{black}%k%f"
local rprompt_end="%(?..%F{1}%K{black}%k%f)"

# set bg of wd_separator to bg_git if there is an active git branch
# else have no background
if [[ -n $(git_prompt_info) ]]; then
  local wd_separator_reverse_return_code="%F{39}%(?.%K${bg_git}%k.%K${bg_return_code}%k)%f"
  local git_end="%F{11}%f"
else
  local wd_separator_reverse_return_code="%F{39}%(?.%K{black}%k.%K${bg_return_code}%k)%f"
  local git_end=""
fi

local apple_symbol="%F{black}%K{15} %f%k"
local reverse_return_code="${bg_return_code}%(?.%F{46}%K{black} ✔%f%F{15}.${fg_return_code} %? ↵ %F{1}%K{black}%f)%k"
local command_count="${fg_command_count}${bg_command_count} %I %k%f"
local time="${time_separator}${fg_time}${bg_time} %D{%L:%M:%S %p}  %k%f"

local user_host="${apple_separator}${bg_user_host}${PR_USER}${fg_user_host}@${PR_HOST} %k${user_host_separator}"
local current_dir_reverse_return_code="%B${bg_wd}${fg_wd}  %~%f %b%k${wd_separator_reverse_return_code}"

local ruby=" \$(ruby_prompt_info)"
local git_branch="$(git_prompt_info)${git_end}"

PROMPT="
${apple_symbol}${user_host}${current_dir_reverse_return_code}%E${reverse_return_code}
$PR_PROMPT "

ZSH_THEME_GIT_PROMPT_PREFIX="${fg_git}${bg_git}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %f%k"
ZSH_THEME_RUBY_PROMPT_PREFIX="%F{red}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%f"

}

preexec() {
  echo ""
}
