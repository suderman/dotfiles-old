# opp=$(dirname ${0})
# source "$opp/opp.zsh"
# source "$opp/opp/textobj-between.zsh"
# source "$opp/opp/surround.zsh"

# Vim's text-objects-ish for zsh.

# Author: Takeshi Banse <takebi@laafc.net>
# License: Public Domain

# Thank you very much, Bram Moolenaar!
# I want to use the Vim's text-objects in zsh.

# Code

bindkey -N opp

typeset -A opps; opps=()
opp_keybuffer=

opp-accept-p () {
  [[ -n ${opps[$KEYS]-} ]] && return 0
  [[ $KEYS != *[1-9] ]]    && return 1
  return -1
}

opp-undefined-key () {
  opp_keybuffer+=$KEYS
  opp-accept-p; local ret=$?
  ((ret == 0)) && zle .accept-line
  ((ret == 1)) && zle .send-break
}

def-oppc () {
  # an abbreviation of DEFine OPerator-Pending-mode-Command.
  # see also opp-recursive-edit
  local keys="$1"
  local funcname="${2-opp+$1}"
  bindkey -M opp "$keys" .accept-line
  opps+=("$keys" "$funcname")
}

def-opp-skip () {
  eval "$(cat <<EOT
    $1 () { while [[ \${BUFFER[((CURSOR$3))]-} == $4 ]] do ((CURSOR$2)) done }
    zle -N $1
EOT
  )"
}
def-opp-skip opp-skip-blank-backward   -- -0 "[[:blank:]]"
def-opp-skip opp-skip-blank-forward    ++ +1 "[[:blank:]]"
def-opp-skip opp-skip-alnum-backward   -- -0 "[[:alnum:]_]"
def-opp-skip opp-skip-alnum-forward    ++ +1 "[[:alnum:]_]"
def-opp-skip opp-skip-punct-backward   -- -0 "[[:punct:]]~[_]"
def-opp-skip opp-skip-punct-forward    ++ +1 "[[:punct:]]~[_]"
def-opp-skip opp-skip-alpunum-backward -- -0 "[[:alnum:][:punct:]]"
def-opp-skip opp-skip-alpunum-forward  ++ +1 "[[:alnum:][:punct:]]"

opp-generic-w () {
  local -a fun1 fun2
  zparseopts -D 1+:=fun1 2+:=fun2
  local beg end fun
  local -a fs
  fs=(${=fun1}); for fun in ${fs:#-1}; do "$fun"; done; ((beg=$CURSOR))
  fs=(${=fun2}); for fun in ${fs:#-2}; do "$fun"; done; ((end=$CURSOR))
  "$@" $beg $end
}

def-oppc iw; opp+iw () {
  if [[ $BUFFER[((CURSOR+1))] == [[:blank:]] ]]; then
    opp-generic-w \
      -1 opp-skip-blank-backward \
      -2 opp-skip-blank-forward \
      -- \
      "$@"
  elif [[ $BUFFER[((CURSOR+1))] == [[:punct:]]~[_] ]]; then
    opp-generic-w \
      -1 opp-skip-punct-backward \
      -2 opp-skip-punct-forward \
      -- \
      "$@"
  else
    opp-generic-w \
      -1 opp-skip-alnum-backward \
      -2 opp-skip-alnum-forward \
      -- \
      "$@"
  fi
}

opp-skip-aw-forward-on-blank () {
  zle opp-skip-blank-forward
  if [[ $BUFFER[((CURSOR+1))] == [[:punct:]]~[_] ]]; then
    opp-skip-punct-forward
  else
    opp-skip-alnum-forward
  fi
}

def-oppc aw; opp+aw () {
  if [[ $BUFFER[((CURSOR+1))] == [[:blank:]] ]]; then
    opp-generic-w \
      -1 opp-skip-blank-backward \
      -2 opp-skip-aw-forward-on-blank \
      "$@"
  elif [[ $BUFFER[((CURSOR+1))] == [[:punct:]]~[_] ]]; then
    opp-generic-w \
      -1 opp-skip-punct-backward \
      -1 opp-skip-blank-backward \
      -2 opp-skip-blank-forward \
      -2 opp-skip-punct-forward \
      "$@"
  else
    opp-generic-w \
      -1 opp-skip-alnum-backward \
      -2 opp-skip-alnum-forward \
      -2 opp-skip-blank-forward \
      "$@"
  fi
}

def-oppc iW; opp+iW () {
  if [[ $BUFFER[((CURSOR+1))] == [[:blank:]] ]]; then
    opp-generic-w \
      -1 opp-skip-blank-backward \
      -2 opp-skip-blank-forward \
      "$@"
  else
    opp-generic-w \
      -1 opp-skip-alpunum-backward \
      -2 opp-skip-alpunum-forward \
      "$@"
  fi
}

def-oppc aW; opp+aW () {
  if [[ $BUFFER[((CURSOR+1))] == [[:space:]] ]]; then
    opp-generic-w \
      -1 opp-skip-blank-backward \
      -2 opp-skip-blank-forward \
      -2 opp-skip-alpunum-forward \
      "$@"
  else
    opp-generic-w \
      -1 opp-skip-alpunum-backward \
      -2 opp-skip-alpunum-forward \
      -2 opp-skip-blank-forward \
      "$@"
  fi
}

opp-generic () {
  local fix1="$1"; shift
  local fun1="$1"; shift
  local fix2="$1"; shift
  local fun2="$1"; shift
  local beg end
  [[ $fun1 != none ]] && zle $fun1; ((beg=$CURSOR $fix1))
  [[ $fun2 != none ]] && zle $fun2; ((end=$CURSOR $fix2))
  "$@" $beg $end
}

opp-generic-pair-scan () {
  local -i  pos="${1}"
  local       a="${2}"
  local       b="${3}"
  local     buf="${4}"
  local     suc="${5}"
  local -i nest="${6}"
  local   place="${7}"

  ((pos==0))           && return -1
  ((pos==(($#buf+1)))) && return -1

  opp-generic-pair-scan-1 () {
    local newnest="$1"
    opp-generic-pair-scan $((pos $suc)) $a $b "$buf" "$suc" $newnest $place
    return $?
  }

  [[ ${buf[$pos, $((pos+$#a-1))]-} == $a ]] && {
    ((nest==0)) && { : ${(P)place::=$pos}; return 0 } ||
    opp-generic-pair-scan-1 $((nest-1)); return $?
  } ||
  [[ ${buf[$pos, $((pos+$#b-1))]-} == $b ]] && {
    opp-generic-pair-scan-1 $((nest+1)); return $?
  }
  opp-generic-pair-scan-1 $nest; return $?
}

def-oppc-pair-1 () {
  local -a xs; : ${(A)xs::=${(s; ;)1}}
  local a=$xs[1]    # '('
  local b=$xs[2]    # ')'
  local c=${xs[3]-} # 'b' (optional)
  eval "$(cat <<EOT
    opp-gps-${(q)a} () {
      local k
      opp-pair-scan \$CURSOR ${(q)a} ${(q)b} \$BUFFER -1 0 k
      ((\$?==0)) && CURSOR=\$k
    }
    zle -N opp-gps-${(q)a}
    opp-gps-${(q)b} () {
      local k
      opp-generic-pair-scan "\$((\$CURSOR+1))" ${(q)b} ${(q)a} \$BUFFER +1 0 k
      ((\$?==0)) && ((CURSOR=\$k - 1))
    }
    zle -N opp-gps-${(q)b}

    def-oppc i${(q)a}; def-oppc i${(q)b}; ${c:+def-oppc i${(q)c}}
    opp+i${(q)a} opp+i${(q)b} ${c:+opp+i${(q)c}} () {
      opp-generic \
        -0 opp-gps-${(q)a} \
        -0 opp-gps-${(q)b} \
        "\$@"
    }
    def-oppc a${(q)a}; def-oppc a${(q)b}; ${c:+def-oppc a${(q)c}}
    opp+a${(q)a} opp+a${(q)b} ${c:+opp+a${(q)c}} () {
      opp-generic \
        -1 opp-gps-${(q)a} \
        +1 opp-gps-${(q)b} \
        "\$@"
    }
EOT
  )"
}

opp-pair-scan () {
  shift
  local -i ret=0
  local a; a="$1"
  [[ "${BUFFER[((CURSOR+1))]-}" ==  "$a" ]] && {
    opp-generic-pair-scan $((CURSOR+1)) "$@"; return $?
  }
  opp-generic-pair-scan $CURSOR "$@"; return $?
}

def-oppc-pair () {
  local x; while read x; do
    [[ -n $x ]] && def-oppc-pair-1 $x
  done <<< "$1"
}

# XXX: 'k' stands for 'bracKet'. (my taste)
def-oppc-pair '
  [ ] k
  < >
  ( ) b
  { } B
'

def-oppc-inbetween-1 () {
  def-oppc-inbetween-2 "$1" "opp+i$1" "opp+a$1" "$2"
}

def-oppc-inbetween-2 () {
  local s="$1"
  local ifun="$2"
  local afun="$3"
  local gsym="$4"
  eval "$(cat <<EOT
    opp-gps-${(q)gsym}-s-ref () { : \${(P)1:=${(q)s}} }
    opp-gps-${(q)gsym}-a () {
      local k
      local s=; opp-gps-${(q)gsym}-s-ref s
      opp-inbetween-scan "\$s" k
      ((\$?==0)) && CURSOR=\$k
    }
    zle -N opp-gps-${(q)gsym}-a
    opp-gps-${(q)gsym}-b () {
      local k
      local s=; opp-gps-${(q)gsym}-s-ref s
      opp-generic-pair-scan "\$((\$CURSOR+1))" \$s \$s \$BUFFER +1 0 k
      ((\$?==0)) && ((CURSOR=\$k - 1))
    }
    zle -N opp-gps-${(q)gsym}-b
    def-oppc i${(q)s}; ${(q)ifun} () {
      opp-generic \
        -0 opp-gps-${(q)gsym}-a \
        -0 opp-gps-${(q)gsym}-b \
        "\$@"
    }
    def-oppc a${(q)s}; ${(q)afun} () {
      opp-generic \
        -1 opp-gps-${(q)gsym}-a \
        +1 opp-gps-${(q)gsym}-b \
        "\$@"
    }
EOT
  )"
}

opp-inbetween-scan () {
  local -i ret=0
  local a="$1"; shift
  local kplace="$1"; shift
  local buf="$BUFFER";
  if [[ "${buf[((CURSOR+1))]-}" == "$a" ]]; then
    () {
      local -i i=0 nest=0
      local c=;
      for ((i=1; i<CURSOR; i++)); do
        ((i+1==CURSOR)) && break
        [[ "${buf[$i,$((i+$#a-1))]-}" == "$a" ]] && {
          ((nest++)); continue
        }
      done
      ((nest & 1))
    }
    ((?==1)) && {
      opp-generic-pair-scan $CURSOR "$a" "$a" "$buf" +1 0 "$kplace"; ((ret=?))
      ((ret==0)) && {
        : ${(P)kplace:=$CURSOR}
        return ret
      }
    }
  fi
  opp-generic-pair-scan $CURSOR "$a" "$a" "$buf" -1 0 "$kplace"; ((ret=?))
  ((ret==0)) || {
    [[ "${buf[((CURSOR+1))]-}" == "$a" ]] && {
      ((CURSOR++))
      opp-generic-pair-scan $CURSOR "$a" "$a" "$buf" +1 0 "$kplace"
      ((ret=?))
    }
  }
  return ret
}

def-oppc-inbetween () {
  local -i i=0
  local s; for s in "$@"; do
    def-oppc-inbetween-1 "$s" "inbetween-$((i++))"
  done
}

def-oppc-inbetween '"' "'" '`'

with-opp () {
  {
    emulate -L zsh
    setopt extended_glob
    zle -N undefined-key opp-undefined-key
    opp_keybuffer=$KEYS
    "$@[1,-2]" "$opp_keybuffer" "$5"
  } always {
    zle -N undefined-key opp-id # TODO: anything better?
  }
}

opp-recursive-edit-1 () {
  local oppk="${1}"
  local fail="${2}"
  local succ="${3}"
  local   op="${4}"
  local mopp="${5}" # Mimic the OPerator or not.

  local numeric=$NUMERIC
  zle recursive-edit -K opp && {
    ${opps[$KEYS]} opp-k $oppk
    zle $succ
  } || {
    [[ -z "${numeric-}" ]] || { local NUMERIC=$numeric }
    local arg=$opp_keybuffer[(($#op+1)),-1]
    [[ -n $arg ]] && {
      opp-read-motion "$op" "$arg[-1]" "$arg" \
        opp-linewise~ opp-motion "$oppk" "$succ" "$fail" "$mopp"
    }
  }
}

opp-read-motion () {
  local   op="${1}"; shift
  local   cc="${1}"; shift
  local  acc="${1}"; shift
  local succ="${1}"; shift
  local fail="${1}"; shift

  [[ $op  == $acc   ]] && {"$succ" "$op" "$acc"   "$@";return $?} ||
  { opp-read-motion-p "$cc" "$acc" } && {
    local c;read -s -k 1 c
    opp-read-motion "$op" "$c" "$acc$c" "$succ" "$fail" "$@";return $?
  } ||
  [[ $op != "$acc"* ]] && {"$fail" "$op" "$acc"   "$@";return $?} ||
  [[ $cc == ''      ]] && {"$fail" "$op" "$acc"   "$@";return $?} ||
  [[ $op == "$acc"* ]] && {
    local c;read -s -k 1 c
    opp-read-motion "$op" "$c" "$acc$c" "$succ" "$fail" "$@";return $?
  }
}

opp-read-motion-p () {
  local   c="${1}"
  local acc="${2}"
  local -a match mbegin mend
  local -i len=${#acc/*[[:digit:]](#b)(*)/$match}
  ((len==1)) ||\
    # Already read a motion char. This prevents an infinite looping
    # like 'dttt...'.
    return 1
  # TODO: This may not be enough, or may be too much.
  [[ $c == 't' ]] && return 0
  [[ $c == 'T' ]] && return 0
  [[ $c == 'f' ]] && return 0
  [[ $c == 'F' ]] && return 0
  [[ $c == "'" ]] && return 0
  [[ $c == 'g' ]] && return 0
  [[ $c == '[' ]] && return 0
  [[ $c == ']' ]] && return 0
  return 1
}

opp-linewise () {
  zle vi-goto-column -n 0
  zle set-mark-command
  zle end-of-line
  zle "$1"
}

opp-linewise~ () {
  local   _op="${1}"
  local  _arg="${2}"
  local appk="${3}"
  local succ="${4}"
  opp-linewise $oppk
  zle $succ
}

opp-oneshot-region () {
  local fn="$1"
  local c0="$2"
  local c1=$CURSOR
  local c2="$2"
  (($c0 < $c1)) || { local tmp=$c0; c0=$c1; c1=$tmp }
  CURSOR=$c0
  zle set-mark-command
  CURSOR=$c1
  zle $fn
  CURSOR=$c2
}

opp-motion () {
  local   _op="${1}"
  local  arg="${2}"
  local _appk="${3}"
  local _succ="${4}"
  local fail="${5}"
  local mopp="${6}"
  if [[ ${mopp} == t ]]; then
    # Execute the ${fail} function after *THIS* zle widget finished
    # because of the use of a "zle -U" to mimic the operators.
    OPP_ONESHOT_KEY="\033[999~"
    eval "
      opp+oneshot+ () {
        bindkey -M $KEYMAP -r '$OPP_ONESHOT_KEY'
        opp-oneshot-region $fail \"$CURSOR\"
      }; zle -N opp+oneshot+"
    bindkey -M $KEYMAP "$OPP_ONESHOT_KEY" opp+oneshot+
    zle -U "${arg}$OPP_ONESHOT_KEY"
  else
    zle -U "$arg"
    zle $fail
  fi
}

opp-recursive-edit () {
  with-opp opp-recursive-edit-1 "$@"
}; zle -N opp-recursive-edit

opp-k () {
  CURSOR="$2"
  zle set-mark-command
  CURSOR="$3"
  zle "$1"
}

opp-id () { "$@" }; zle -N opp-id

with-opp-regioned () {
  ((REGION_ACTIVE)) || return
  {
    "$@"
  } always {
    zle set-mark-command -n -1
  }
}

opp-copy-region () {
  with-opp-regioned zle copy-region-as-kill
}; zle -N opp-copy-region

opp-regioned-buffer-each () {
  local i; for i in {$((MARK+1))..$((CURSOR))}; do
    local c=$BUFFER[$i]
    "$@" $i "$c"
  done
}

opp-regioned-buffer-each~ () { with-opp-regioned opp-regioned-buffer-each "$@" }

opp-swap-case-region-0 () {
  local -i i=$1; local c="$2"
  case "$c" in
    ([[:lower:]]) BUFFER[$i]="${(U)c}" ;;
    ([[:upper:]]) BUFFER[$i]="${(L)c}" ;;
  esac
}

opp-swap-case-region () {
  opp-regioned-buffer-each~ opp-swap-case-region-0
}; zle -N opp-swap-case-region

opp-register-zle () {
  eval "$1 () { zle opp-recursive-edit -- $2 $3 $4 ${5:=nil} }; zle -N $1"
}

opp-register-zle opp-vi-change kill-region vi-change vi-insert
opp-register-zle opp-vi-delete kill-region vi-delete opp-id
opp-register-zle opp-vi-yank opp-copy-region vi-yank opp-id

opp-register-zle-operator-mimic () { opp-register-zle "$1" "$2" "$2" "$3" t }

opp-register-zle-operator-mimic opp-vi-tilde opp-swap-case-region opp-id

opp-register-zle-operator-mimic-case () {
  local case="$1" buffexpnflags="$2"
  eval "$(cat <<EOT
    opp-${case}-case-region-0 () {
      BUFFER[\$1]="\${${buffexpnflags}2}"
    }
    opp-${case}-case-region () {
      opp-regioned-buffer-each~ opp-${case}-case-region-0
    }; zle -N opp-${case}-case-region
    opp-register-zle-operator-mimic \
     opp-vi-${case}case opp-${case}-case-region opp-id
EOT
  )"
}
opp-register-zle-operator-mimic-case upper "(U)"
opp-register-zle-operator-mimic-case lower "(L)"

# Entry point.
typeset -gA opp_operators; opp_operators=()
opp () {
  # to implement autoloading easier,
  # all of the operator commands will be dispatched through this func.
  opp1
}
opp1 () { $opp_operators[$KEYS]; }

opp-install () {
  {
    zle -N opp opp
    typeset -gA opp_operators; opp_operators=()
    BK () {
      opp_operators+=("$1" $2)
      bindkey -M vicmd "$1" opp
      { bindkey -M afu-vicmd "$1" opp } > /dev/null 2>&1
    }
    BK "c" opp-vi-change
    BK "d" opp-vi-delete
    BK "y" opp-vi-yank
    BK "~" opp-vi-tilde
    BK "gU" opp-vi-uppercase
    BK "gu" opp-vi-lowercase
    { "$@" }
  } always {
    unfunction BK
  }
}
opp-install

# zcompiling code.

opp-clean () {
  local d=${1:-~/.zsh/zfunc}
  rm -f ${d}/{opp,opp.zwc*(N)}
  rm -f ${d}/{opp-install,opp-install.zwc*(N)}
}

opp-install-installer () {
  local match mbegin mend
  eval ${${${"$(<=(cat <<"EOT"
    opp-install-after-load () {
      typeset -g opp_keybuffer
      bindkey -N opp
      { $opp_installer_codes }
      { $body }
      opp_loaded_p=t
    }
    opp-install-maybe () {
      [[ -z ${opp_loaded_p-} ]] || return
      opp-install-after-load
    }
    # redefine opp
    opp () {
      opp-install-maybe
      opp1
    }
EOT
  ))"}/\$body/
  $(print -l \
    "# opp's zle widget" \
    ${${(M)${(@f)"$(zle -l)"}:#(opp*)}/(#b)(*)/zle -N ${(qqq)match}} \
    "# bindkeys on the opp keymap" \
    ${(q@f)"$(bindkey -M opp -L)"})
  }/\$opp_installer_codes/$(opp-installer-expand)}
}

opp_installer_codes=()

opp-installer-add () { opp_installer_codes+=($1) }

opp-installer-expand () {
  local c; for c in $opp_installer_codes; do
    "$c"
  done
}

opp-installer-install-opps () {
  echo ${"$(typeset -p opps)"/typeset -A/typeset -gA}
}; opp-installer-add opp-installer-install-opps

opp-zcompile () {
  #local opp_zcompiling_p=t
  local s=${1:?Please specify the source file itself.}
  local d=${2:?Please specify the directory for the zcompiled file.}
  emulate -L zsh
  setopt extended_glob no_shwordsplit

  echo "** zcompiling opp in ${d} for a little faster startups..."
  [[ -n ${OPP_PARANOID-} ]] && {
    echo "* reloading ${s}"
    source ${s} >/dev/null 2>&1
  }
  echo "mkdir -p ${d}" | sh -x
  opp-clean ${d}
  opp-install-installer

  local g=${d}/opp
  echo "* writing code ${g}"
  {
    local -a fs
    : ${(A)fs::=${(Mk)functions:#(*opp*)}}
    echo "#!zsh"
    echo "# NOTE: Generated from opp.zsh ($0). Please DO NOT EDIT."; echo
    local -a es; es=('def-*' '*register*' 'opp-installer-*' \
      opp-clean opp-install-installer opp-zcompile opp-install opp+oneshot+)
    echo "$(functions ${fs:#${~${(j:|:)es}}})"
    echo "\nopp"
  }>! ${g}

  local gi=${d}/opp-install
  echo "* writing code ${gi}"
  {
    echo "#!zsh"
    echo "# NOTE: Generated from opp.zsh ($0). Please DO NOT EDIT."; echo
    echo "$(functions opp-install)"
  }>! ${gi}

  [[ -z ${OPP_NOZCOMPILE-} ]] || return
  autoload -U zrecompile && {
    Z () { echo -n "* "; zrecompile -p -R "$1" }; Z ${g} && Z ${gi}
  } && {
    zmodload zsh/datetime
    touch --date="$(strftime "%F %T" $((EPOCHSECONDS + 10)))" {${g},${gi}}.zwc
    [[ -z ${OPP_ZCOMPILE_NOKEEP-} ]] || { echo "rm -f ${g} ${gi}" | sh -x }
    echo "** All done."
    echo "** Please update your .zshrc to load the zcompiled file like this,"
    cat <<EOT
-- >8 --
## opp.zsh stuff.
# source ${s/$HOME/~}
autaload opp
{ . ${gi/$HOME/~}; opp-install; }
-- 8< --
EOT
  }
}

# (os=(${(ok)opp_operators}); os=(${(j:, :)os[1,-2]} and $os[-1]); echo $os)


# surround.vim-ish for zsh.

# Author: Takeshi Banse <takebi@laafc.net>
# Licence: Public Domain

# Thank you very much, Tim Pope!
# I want to use the surround.vim in zsh.

# Configuration
# Predefined targets as follows,
#
# Eight punctiation marks with aliased by, (k is my taste)
#   [ ]  < >  ( )  { }
#     k         b    B
# When insertion,
#   [, <, ( and { will add the pairs with one whitespace
#   ], >, ) and } will add the pairs without whitespaces
#   k,    b and B will add the pairs without whitespaces
# When deletion,
#   [, <, ( and { will remove the pairs with stripping any whitespaces
#   ], >, ) and } will remove the pairs without stripping
#   k,    b and B will remove the pairs without stripping
#
# and three quate marks.
#   " ' `
#
# To customize the surroundings, you can use the function `def-opp-surround'.
#   def-opp-surround KEYBINDING LEFT RIGHT STRIPP(t|nil)
# For example,
# % def-opp-surround '${' '${' '}' t
# will associate a keybinding '${' to replace the pair # '${','}'.
# You will get the followings,
#   Old text              Command  New text
#   "Hello ${ w*orld }!"  ds${     Hello world!
#   "Hello ${w*orld}!"    ds${     Hello world!
#   "Hello ${w*orld}!"    cs${'    Hello 'world'!
#   "Hello w*orld!"       ysiw${   Hello ${world}!
# (An asterisk (*) is used to denote the cursor position.)
#
# STRIPP (t|nil) controls the whitespace retaining/stripping behavior.
# If you use 'nil' instead of 't', for example,
# % def-opp-surround '${' '${' '}' nil
# You will get the following,
#   Old text              Command  New text
#   "Hello ${ w*orld }!"  ds${     Hello  world !
# Please notice that the whitespaces surrounding the "world" are not
# stripped in this case.

# TODO: parameterize these 'y, c, d and s's.
# TODO: insert mode mappings.

# Code

opp_surround_op=
def-oppc s opp+surround; opp+surround () {
  local op="$opp_keybuffer"
  {
    opp_surround_op=${opp_surround_op:-$op}
    # TODO: parameterize
    [[ $op == 'y' ]] && {
      zle opp-recursive-edit opp-s-read+y opp-id opp-id nil; return $?
    } || [[ -n $opp_surround_op ]] && {
      opp-s-read $opp_surround_op opp-surround; return $?
    }
  } always {
    opp_surround_op=
    zle set-mark-command -n -1
    zle -R
    succ=vi-cmd-mode # TODO: THIS IS VERY BAD
  }
}

opp-s-reading () {
  [[ -n ${OPP_SURROUND_VERBOSE-} ]] || return
  local f0="$1"
  local op="$2"
  local  a="$3"
  shift 3
  local b=; # b+="$f0"
  b+="${op[1]}s"; (($#@!=0)) && { b+="{$@[1]|$@[2]}" }; b+="$a"
  zle -R "$b"
}

opp-s-read+y () {
  opp-s-reading "$0" "y" ''
  opp-s-read $opp_surround_op opp-surround
}; zle -N opp-s-read+y

opp-s-read () {
  local   op="$1"; shift
  local succ="$1"; shift
  # TODO: parameterize
  [[ $op == 'y' ]] && [[ $KEYS == 's' ]] && {
    opp-s-read+linewise; return $?
  } || {
    opp-s-read-1 "$op" "$succ" opp-s-reading "$@"
  }
}

opp-s-read+linewise () {
  opp-s-read "linewise" opp-surround
}

opp-s-read-1 () {
  local   op="$1"; shift
  local succ="$1"; shift
  local mess="$1"; shift
  opp-s-read-acc () {
    opp-s-read-acc-base "$@";{local -i ret=$?; ((ret==255)) || return $((ret))}
    local      c="$1"
    local aplace="$2"
    local avalue="$3"
    [[ $op == 'c' ]] && {
      local e="$4"; local -a ks; {eval "ks=($e)"}
      local -i n0; ((n0=${#${(@M)ks:#$avalue${c}*}}))
      local -i n1; ((n1=${#${(@M)ks:#${c}*}}))
      ((n0==0)) && ((n1!=0)) && {
        # XXX: ambigous.
        zle -U "$c"; return 0
      }
    }
    : ${(P)aplace::=$avalue$c}
    return -1
  }
  opp-s-read-2 "$op" opp-s-read-acc "$succ" opp-s-read-fail "$mess" "$@"
}

opp-s-read-acc-base () {
  local      c="$1"
  local aplace="$2"
  local avalue="$3"
  [[ $c == "" ]]          && return -255 # XXX: read interrupted
  [[ $c == "" ]]        && return 0
  [[ $c == "" ]]        && {: ${(P)aplace::=$avalue[1,-2]}; return  1}
  [[ $c != [[:print:]] ]] && return 0
  [[ -z $avalue ]]        && {: ${(P)aplace::=$avalue$c}    ; return -1}
  return 255 # indicate to the caller that it did *not* return.
}

opp-s-read-2 () {
  local   op="$1"; shift
  local pacc="$1"; shift
  local succ="$1"; shift
  local fail="$1"; shift
  local mess="$1"; shift

  "$mess" "$0" "$op" '' "$@"

  local c; read -s -k 1 c
  { # TODO: parameterize
    [[ $op == 'd' ]] && [[ $c == 's' ]] && return -1
    [[ $op == 'c' ]] && [[ $c == 's' ]] && {opp-s-read+linewise; return $?}
  }
  opp-s-loop \
    "$op" \
    '${(@k)opp_surrounds}' \
    "$c" \
    "$pacc" \
    '' \
    0 \
    "$succ" \
    "$fail" \
    "$mess" \
    "$succ" \
    "$fail" \
    "$@"
}

opp-s-loop () {
  local o="$1"
  local e="$2"; local -a ks; { eval "ks=($e)" }
  local c="$3"
  local p="$4"
  local a="$5"; "$p" "$c" a "$a" "$e"; local -i r=$?
  local f="$6"
  local succ="$7"
  local fail="$8"
  local mess="$9"
  local sk="$10"
  local fk="$11"
  shift 11 # At this point "$@" indicates refering the &rest argument.

  ((r==-255)) && { return -1 }
  ((r==   1)) && { f=0; succ=$sk; fail=$fk } # XXX: >_<

  "$mess" "$0" "$o" "$a" "$@"

  opp-s-loop-1 () {
    local fn="$1"; shift
    "$fn" $o $e "$c" $p "$a" $f $succ $fail $mess $sk $fk "$@"
  }
  local -i n0; ((n0=${#${(@M)ks:#${a}}} ))
  local -i n1; ((n1=${#${(@M)ks:#${a}*}}))
  ((n0==1)) && ((r ==0)) &&              {"$succ" "$o" "$a" "$@";return $?} ||
  ((n0==1)) && ((n1==1)) &&              {"$succ" "$o" "$a" "$@";return $?} ||
  ((n1==0)) && ((r ==0)) && ((f ==1)) && {"$succ" "$o" "$a" "$@";return $?} ||
  ((n1==0)) && {   opp-s-loop-1    "$fail" "$@";return $?                 } ||
  { read -s -k 1 c;opp-s-loop-1 opp-s-loop "$@";return $?}
}

opp-s-read-fail () {
  local o="$1"
  local e="$2"; local -a ks; { eval "ks=($e)" }
  local c="$3"
  local p="$4"
  local a="$5"
  local f="$6"
  local succ="$7"
  local fail="$8"
  local mess="$9"
  local sk="$10"
  local fk="$11"
  shift 11 # At this point "$@" indicates refering the &rest argument.

  opp-surround-tagish () {
    local o="$1"
    local tagish="$2"; [[ $tagish == '<'* ]] || return -1
    local tag1="$tagish"
    local tag2="</$tag1[2,-1]"
    shift 2
    [[ -z ${1-} ]] && [[ -z ${2-} ]] && {
      "$opp_sopps[$o]" "$tag1" "$tag2"; return $?
    } || {
      opp-s-wrap-maybe nil $tag1 $tag2 $1 $2
    }
  }
  # TODO: Add an appropriate code for editing the command line.
  # XXX: Embeded the tag code for the place-holder purpose.
  # XXX: Please `unset "opp_surrounds[<]"' if you want to see the effect.
  opp-s-read-acc-tagish () {
    opp-s-read-acc-base "$@";{local -i ret=$?; ((ret==255)) || return $((ret))}
    local      c="$1"
    local aplace="$2"
    local avalue="$3"
    : ${(P)aplace::=$avalue$c}
    [[ -n ${avalue-} ]] && [[ $avalue[1] == '<' ]] && [[ $c == '>' ]] && {
      return 0
    }
    return -1
  }
  [[ $o == 'c' ]] && (($#@!=0)) && [[ -n $c ]] &&
  [[ $c != '<' ]] && [[ $a[1] != '<' ]] && [[ $c != '>' ]]  && {
    opp-s-wrap-maybe nil $c $c "$@"; return $?
  }

  "$mess" "$0" "$o" "$a" "$@"

  read -s -k 1 c
  opp-s-loop  $o $e "$c" \
    opp-s-read-acc-tagish "$a" 1 opp-surround-tagish \
    $fail $mess $sk $fk "$@"
}

typeset -A opp_surrounds; opp_surrounds=()
def-opp-surround-raw () {
  local keybind="$1"
  local     fun="$2"
  local       a="$3"
  local       b="$4"
  local  stripp="$5"
  shift 5
  local expanded=
  local x; for x in $@; do
    expanded+="reply+=${(q)x};"
  done
  opp_surrounds+=("$keybind" opp+surround"$keybind")
  eval "$(cat <<EOT
    opp+surround${(q)keybind} () {
      reply=(${(q)fun} ${(q)a} ${(q)b} ${(q)stripp})
      ${expanded}
    }
EOT
  )"
}

def-opp-surround-0 () {
  local k="$1" a="$2" b="$3" sp="$4"; shift 4
  def-opp-surround-raw "$k" opp-surround-sopp "$a" "$b" "$sp" "$@"
}

def-opp-surround () {
  local k="$1" a="$2" b="$3"
  local sp;
  (($#@==3)) && { sp=nil       ; shift 3}
  (($#@>=4)) && { sp="${4-nil}"; shift 4}
  def-opp-surround-0 "$k" "$a" "$b" "$sp" "$@"
}

def-opp-surround-pair () {
  {
    DAS () {
      def-opp-surround "$1" "$1 " " $2" t "$1" "$2"
      def-opp-surround "$2" "$1" "$2" nil
      [[ -n ${3-} ]] && def-opp-surround "$3" "$1" "$2" nil
    }
    local x; while read x; do
      [[ -n $x ]] && {
        local -a y; while read -A y; do
          DAS "$y[1]" "$y[2]" "${y[3]-}"
        done <<< "$x"
      }
    done
  } always { unfunction DAS } <<< "$1"
}

# XXX: 'k' stands for 'bracKet'. (my taste)
def-opp-surround-pair '
  [ ] k
  < >
  ( ) b
  { } B
'

def-opp-surround-q () {
  local s; for s in "$@"; do
    def-opp-surround "$s" "$s" "$s" nil
  done
}

def-opp-surround-q '"' "'" '`'

typeset -A opp_sopps; opp_sopps=()
opp_sopps+=(linewise opp-surround+linewise)
opp_sopps+=(y opp-surround+y) # TODO: link this key 'y' <=> def-oppc's 'y'
opp_sopps+=(d opp-surround+d)
opp_sopps+=(c opp-surround+c)

opp-surround () {
  local o="$1"
  local k="$2"
  local -a box; opp-s-ref $opp_surrounds[$k] box
  local   proc="$box[1]"
  local   arg1="$box[2]"
  local   arg2="$box[3]"
  local stripp="$box[4]"
  shift 4 box
  "$proc" "$o" "$arg1" "$arg2" "$stripp" "$box[@]"
}

opp-surround-sopp () {
  local o="$1"; shift
  "$opp_sopps[$o]" "$@"
}

opp-s-ref () {
  local ebody=$1
  local place=$2
  local -a reply; "$ebody"; eval "$place=(${(q)reply[@]})"
}

opp-surround+linewise () {
  zle vi-goto-column -n 0
  [[ ${BUFFER[((CURSOR+1))]-} == [[:blank:]] ]] && opp-skip-blank-forward
  RBUFFER="${1}$RBUFFER"
  zle vi-goto-column -n 0; zle end-of-line
  [[ ${BUFFER[((CURSOR+0))]-} == [[:blank:]] ]] && opp-skip-blank-backward
  LBUFFER="$LBUFFER${2}"
}

opp-surround+y () {
  RBUFFER="${2}${RBUFFER}"
  zle exchange-point-and-mark
  LBUFFER="${LBUFFER}${1}"
  zle set-mark-command -n -1
}

opp-surround+d () {
  local a1="$1"; shift
  local a2="$1"; shift
  local sp="$1"; shift
  opp-s-wrap-maybe "$sp" '' '' "$a1" "$a2" "$@"
}

opp-surround+c () {
  opp-s-read "c" opp-surround+c-1 "$@"
}

opp-surround+c-1 () {
  shift
  local  k="$1"
  local s1="$2"
  local s2="$3"
  local sp="$4"
  shift 4
  [[ -n "$opp_surrounds[$k]" ]] && {
    local -a box; opp-s-ref "$opp_surrounds[$k]" box
    local   _proc="$box[1]"
    local    arg1="$box[2]"
    local    arg2="$box[3]"
    local _stripp="$box[4]"
    shift 4 box # TODO: pass the 'box[@]' downward somehow.
    opp-s-wrap-maybe $sp $arg1 $arg2 $s1 $s2 "$@"
  } || {
    opp-s-wrap-maybe $sp $k $k $s1 $s2 "$@"
  }
}

opp-s-wrap-maybe () {
  local sp="$1"
  local t1="$2"
  local t2="$3"
  local s1="$4"
  local s2="$5"
  shift 5
  [[ $RBUFFER == *${s2}* ]] && [[ $LBUFFER == *${s1}* ]] && {
    [[ $RBUFFER == *${s2}* ]] && {
      local -i k; opp-s-wrap-scan 1 ${s2} ${s1} "$RBUFFER" +1 0 k
      (($?==0)) || return -1
      CURSOR+=k; ((CURSOR--))
      [[ $sp == t ]] && {
        zle set-mark-command
        opp-skip-blank-backward
        zle kill-region
      }
      zle set-mark-command
      CURSOR+=${#s2}
      zle kill-region
      RBUFFER=${t2}$RBUFFER
    }
    [[ $LBUFFER == *${s1}* ]] && {
      local -i k; opp-s-wrap-scan $#LBUFFER ${s1} ${s2} "$LBUFFER" -1 0 k
      (($?==0)) || return -1
      CURSOR=k; ((CURSOR--))
      zle set-mark-command
      CURSOR+=${#s1}
      [[ $sp == t ]] && opp-skip-blank-forward
      zle kill-region
      LBUFFER=$LBUFFER${t1}
    }
    return 0
  }
  (($#@<2)) && return -1
  opp-s-wrap-maybe "$sp" "$t1" "$t2" "$@"; return $?
}

opp-s-wrap-scan () {
  local -i  pos="${1}"
  local       a="${2}"
  local       b="${3}"
  local     buf="${4}"
  local     suc="${5}"
  local -i nest="${6}"
  local   place="${7}"

  ((pos==0))           && return -1
  ((pos==(($#buf+1)))) && return -1

  [[ $a != $b  ]] && {       opp-generic-pair-scan "$@"; return $?}||
  [[ $suc = +1 ]] && { : ${(P)place::=${(BS)buf#${a}*}}; return 0 }||
  [[ $suc = -1 ]] && { : ${(P)place::=${(BS)buf%${a}*}}; return 0 }
}

# opp-installer
opp-installer-install-surround () {
  echo "typeset -g opp_surround_op="
  echo ${"$(typeset -p opp_sopps)"/typeset -A/typeset -gA}
  echo ${"$(typeset -p opp_surrounds)"/typeset -A/typeset -gA}
}; opp-installer-add opp-installer-install-surround


# textobj-between code for opp.zsh.

# Author Takeshi Banse <takebi@laafc.net>
# Licence: Public Domain

# Thank you very much, thinca and tarao!
#
# http://d.hatena.ne.jp/thinca/20100614/1276448745
# http://d.hatena.ne.jp/tarao/20100715/1279185753

def-oppc-inbetween-1 f tb

with-opp-tb-read () {
  local OPP_TB_READ_CHAR=;
  local c; read -s -k 1 c
  [[ "$c" == [[:print:]] ]] || return
  OPP_TB_READ_CHAR="$c"
  "$@"
}

# XXX: redefined!
opp-gps-tb-s-ref () { : ${(P)1:=$OPP_TB_READ_CHAR} }
opp+if () {
  with-opp-tb-read \
    opp-generic \
      -0 opp-gps-tb-a \
      -0 opp-gps-tb-b \
      "$@"
}
opp+af () {
  with-opp-tb-read \
    opp-generic \
      -1 opp-gps-tb-a \
      +1 opp-gps-tb-b \
      "$@"
}
