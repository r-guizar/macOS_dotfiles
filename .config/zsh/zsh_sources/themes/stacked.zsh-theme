setopt prompt_subst

git_wd_separator() {
  if [[ -n $(git_prompt_info) ]]; then
    echo "%F{39}${bg_git}%k"
  else
    echo "%F{39}%f%k"
  fi
}

python_info() {
  local venv=$(virtualenv_prompt_info)
  if [[ -n $venv ]]; then
    echo $venv
  else
    local pyenv=$PYENV_VERSION
    [[ -n $pyenv ]] && echo "${ZSH_THEME_PYENV_PREFIX=}${pyenv}${ZSH_THEME_PYENV_SUFFIX=}"
  fi
}

() {

local PR_USER PR_USER_OP PR_PROMPT PR_HOST

local bg_user_host='%K{237}'
local fg_user_host='%F{26}'

local bg_wd='%K{39}'
local fg_wd='%F{237}'

local fg_git='%F{237}'
local bg_git='%K{202}'

local fg_time='%F{237}'
local bg_time='%K{7}'

local fg_command_count='%F{237}'
local bg_command_count='%K{15}'

local fg_return_code='%F{11}'
local bg_return_code='%K{9}'

PR_USER="${fg_user_host} %n%f"
PR_PROMPT=' ❱'
PR_HOST="${fg_user_host}%m%f"

local user_host_start="%F{black}${bg_user_host}%f%k"
local apple_separator="%F{15}${bg_user_host}%k%f"

local user_host_separator="%F{237}%(?..${bg_return_code}%k)%f"

local time_separator="%F{7}${bg_command_count}%k%f"
local rprompt_start="%F{7}%K{black}%k%f"
local rprompt_end="%(?..%F{1}%K{black}%k%f)"

local wd_separator="%F{39}%f%k"
local git_end=""

local apple_symbol="%F{15}█%F{black}%K{15} %f%k"
local return_code="${bg_return_code}%(?.%F{46}%k ✔%f%F{15}.${fg_return_code} %? ✘ %F{9}%k%f)%k"
local command_count="${fg_command_count}${bg_command_count} %I %k%f"
local time="${time_separator}${fg_time}${bg_time} %D{%L:%M:%S %p}  %k%f"

local user_host="${apple_separator}${bg_user_host}${PR_USER}${fg_user_host}@${PR_HOST} %k${user_host_separator}"
local current_dir="%B%F{39}█%f${bg_wd}${fg_wd} %~%f %b%k${wd_separator}"

local ruby=" \$(ruby_prompt_info)"
local git_branch="\$(git_prompt_info)${git_end}"
local venv_prompt='$(virtualenv_prompt_info)'
local pyenv_prompt='$(python_info)'

PROMPT="
${apple_symbol}${user_host}${return_code}
${current_dir}${git_branch}${pyenv_prompt}%E 
$PR_PROMPT "

ZSH_THEME_GIT_PROMPT_PREFIX="\n%F{202}%K{237}█${fg_git}${bg_git} "
ZSH_THEME_GIT_PROMPT_SUFFIX=" %F{202}%k%f"
ZSH_THEME_RUBY_PROMPT_PREFIX="%F{red}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%f"
ZSH_THEME_VIRTUALENV_PREFIX="\n%F{82}█%F{237}%K{82}󱔎 "
ZSH_THEME_VIRTUALENV_SUFFIX=" %F{82}%k%f"
ZSH_THEME_PYENV_PREFIX="\n%F{82}█%F{237}%K{82}󱔎 "
ZSH_THEME_PYENV_SUFFIX=" %F{82}%k%f"

}

preexec() {
  echo ""
}
