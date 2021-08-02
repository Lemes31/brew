#:  * `shellenv`
#:
#:  Print export statements. When run in a shell, this installation of Homebrew will be added to your `PATH`, `MANPATH`, and `INFOPATH`.
#:
#:  The variables `HOMEBREW_PREFIX`, `HOMEBREW_CELLAR` and `HOMEBREW_REPOSITORY` are also exported to avoid querying them multiple times.
#:  The variable `HOMEBREW_SHELLENV_SET` will be exported to avoid adding duplicate entries to the environment variables.
#:  Consider adding evaluation of this command's output to your dotfiles (e.g. `~/.profile`, `~/.bash_profile`, or `~/.zprofile`) with: `eval $(brew shellenv)`

# HOMEBREW_CELLAR and HOMEBREW_PREFIX are set by extend/ENV/super.rb
# HOMEBREW_REPOSITORY is set by bin/brew
# shellcheck disable=SC2154
homebrew-shellenv() {
  case "$(/bin/ps -p "${PPID}" -c -o comm=)" in
    fish | -fish)
      echo "set -gx HOMEBREW_PREFIX \"${HOMEBREW_PREFIX}\";"
      echo "set -gx HOMEBREW_CELLAR \"${HOMEBREW_CELLAR}\";"
      echo "set -gx HOMEBREW_REPOSITORY \"${HOMEBREW_REPOSITORY}\";"
      [[ ":${HOMEBREW_SHELLENV_SET}:" == *":${HOMEBREW_PREFIX}:"* ]] && return
      echo "set -q PATH; or set PATH ''; set -gx PATH \"${HOMEBREW_PREFIX}/bin\" \"${HOMEBREW_PREFIX}/sbin\" \$PATH;"
      echo "set -q MANPATH; or set MANPATH ''; set -gx MANPATH \"${HOMEBREW_PREFIX}/share/man\" \$MANPATH;"
      echo "set -q INFOPATH; or set INFOPATH ''; set -gx INFOPATH \"${HOMEBREW_PREFIX}/share/info\" \$INFOPATH;"
      echo "set -q HOMEBREW_SHELLENV_SET; or set HOMEBREW_SHELLENV_SET ''; set -gx HOMEBREW_SHELLENV_SET \"${HOMEBREW_PREFIX}\" \$HOMEBREW_SHELLENV_SET;"
      ;;
    csh | -csh | tcsh | -tcsh)
      echo "setenv HOMEBREW_PREFIX ${HOMEBREW_PREFIX};"
      echo "setenv HOMEBREW_CELLAR ${HOMEBREW_CELLAR};"
      echo "setenv HOMEBREW_REPOSITORY ${HOMEBREW_REPOSITORY};"
      [[ ":${HOMEBREW_SHELLENV_SET}:" == *":${HOMEBREW_PREFIX}:"* ]] && return
      echo "setenv PATH ${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin:\$PATH;"
      echo "setenv MANPATH ${HOMEBREW_PREFIX}/share/man\`[ \${?MANPATH} == 1 ] && echo \":\${MANPATH}\"\`:;"
      echo "setenv INFOPATH ${HOMEBREW_PREFIX}/share/info\`[ \${?INFOPATH} == 1 ] && echo \":\${INFOPATH}\"\`;"
      echo "setenv HOMEBREW_SHELLENV_SET ${HOMEBREW_PREFIX}\`[ \${?HOMEBREW_SHELLENV_SET} == 1 ] && echo \":\${HOMEBREW_SHELLENV_SET}\"\`;"
      ;;
    *)
      echo "export HOMEBREW_PREFIX=\"${HOMEBREW_PREFIX}\";"
      echo "export HOMEBREW_CELLAR=\"${HOMEBREW_CELLAR}\";"
      echo "export HOMEBREW_REPOSITORY=\"${HOMEBREW_REPOSITORY}\";"
      [[ ":${HOMEBREW_SHELLENV_SET}:" == *":${HOMEBREW_PREFIX}:"* ]] && return
      echo "export PATH=\"${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin\${PATH+:\$PATH}\";"
      echo "export MANPATH=\"${HOMEBREW_PREFIX}/share/man\${MANPATH+:\$MANPATH}:\";"
      echo "export INFOPATH=\"${HOMEBREW_PREFIX}/share/info:\${INFOPATH:-}\";"
      echo "export HOMEBREW_SHELLENV_SET=\"${HOMEBREW_PREFIX}\${HOMEBREW_SHELLENV_SET+:\$HOMEBREW_SHELLENV_SET}\";"
      ;;
  esac
}
