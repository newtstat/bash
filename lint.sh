#!/usr/bin/env bash
set -E -e -u -o pipefail
# このリポジトリ向け lint

# 関数 export
export  pipe_debug="exec awk \"{print \\\"\\\\033[0;34m\$(date +%Y-%m-%dT%H:%M:%S%z) [ debug] \\\"\\\$0\\\"\\\\033[0m\\\"}\" /dev/stdin" &&  Debugln () { [ "${LOG_SEVERITY:--1}" -gt 100 ] 2>/dev/null || echo "$*" | bash -c "${pipe_debug:?}"  1>&2; }
export   pipe_info="exec awk \"{print \\\"\\\\033[0;36m\$(date +%Y-%m-%dT%H:%M:%S%z) [  info] \\\"\\\$0\\\"\\\\033[0m\\\"}\" /dev/stdin" &&   Infoln () { [ "${LOG_SEVERITY:--1}" -gt 200 ] 2>/dev/null || echo "$*" | bash -c "${pipe_info:?}"   1>&2; }
export pipe_notice="exec awk \"{print \\\"\\\\033[0;32m\$(date +%Y-%m-%dT%H:%M:%S%z) [notice] \\\"\\\$0\\\"\\\\033[0m\\\"}\" /dev/stdin" && Noticeln () { [ "${LOG_SEVERITY:--1}" -gt 300 ] 2>/dev/null || echo "$*" | bash -c "${pipe_notice:?}" 1>&2; }
export   pipe_warn="exec awk \"{print \\\"\\\\033[0;33m\$(date +%Y-%m-%dT%H:%M:%S%z) [  warn] \\\"\\\$0\\\"\\\\033[0m\\\"}\" /dev/stdin" &&   Warnln () { [ "${LOG_SEVERITY:--1}" -gt 400 ] 2>/dev/null || echo "$*" | bash -c "${pipe_warn:?}"   1>&2; }
export  pipe_error="exec awk \"{print \\\"\\\\033[0;31m\$(date +%Y-%m-%dT%H:%M:%S%z) [ error] \\\"\\\$0\\\"\\\\033[0m\\\"}\" /dev/stdin" &&  Errorln () { [ "${LOG_SEVERITY:--1}" -gt 500 ] 2>/dev/null || echo "$*" | bash -c "${pipe_error:?}"  1>&2; }
export   pipe_crit="exec awk \"{print \\\"\\\\033[1;31m\$(date +%Y-%m-%dT%H:%M:%S%z) [  crit] \\\"\\\$0\\\"\\\\033[0m\\\"}\" /dev/stdin" &&   Critln () { [ "${LOG_SEVERITY:--1}" -gt 600 ] 2>/dev/null || echo "$*" | bash -c "${pipe_crit:?}"   1>&2; }

if [ ! "${BASH_VERSINFO:-0}" -ge 3 ]; then printf '\033[1;31m%s\033[0m\n' "bash 3.x or later is required" 1>&2; exit 1; fi


echo "\"<\" と文字列が隣接すると HTML タグとして解釈される問題。以下コマンドで、ヒアドキュメントの \"<<\" の後ろにスペースを追加するよう置換する。" | sh -c "${pipe_info:?}"
cmd='git grep -l "<<[^[:space:]]" | grep -v "lint\.sh" | xargs -I{} perl -pe "s/(<<)([^[:space:]])/\1 \2/g" -i {}'
Infoln "$ ${cmd:?}" && bash -c "${cmd:?}"



# memo
# git grep -l "##HttpGet##" | xargs -I{} perl -0pe 's@\n.*##HttpGet##@\nhttpGet="\$( { command -v curl 1>/dev/null \&\& printf "curl -LRsS "; } || { command -v wget 1>/dev/null \&\& printf "wget -qO- "; } )"; export httpGet; [ "\${httpGet:?"curl or wget are required"}" ] || exit 1; [ "\${envIsLoaded:-false}" = true ] || eval "\$(sh -c "exec \${httpGet} https://djeeno.github.io/bash/common/")" || exit 1 ##httpGet##@g' -i {}
