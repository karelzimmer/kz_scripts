# shellcheck shell=bash source=/dev/null disable=SC2155,SC2034
###############################################################################
# Common module for shell scripts.
#
# Written by Karel Zimmer <info@karelzimmer.nl>, CC0 1.0 Universal
# <https://creativecommons.org/publicdomain/zero/1.0>, 2009-2024.
###############################################################################


###############################################################################
# Import
###############################################################################

export      TEXTDOMAIN=kz
export      TEXTDOMAINDIR=/usr/share/locale
source      /usr/bin/gettext.sh


###############################################################################
# Constants
###############################################################################

readonly    MODULE_NAME='kz_common.sh'
readonly    MODULE_DESC=$(gettext 'Common module for shell scripts')
readonly    MODULE_PATH=$(dirname "$(realpath "$0")")

readonly    OK=0
readonly    ERROR=1

readonly    NORMAL='\033[0m'
readonly    BOLD='\033[1m'
readonly    DIM='\033[2m'
readonly    ITALIC='\033[3m'
readonly    UNDERLINE='\033[4m'
readonly    BLINK='\033[5m'
readonly    REVERSE='\033[7m'
readonly    HIDDEN='\033[8m'

readonly    RED='\033[31m'
readonly    GREEN='\033[32m'
readonly    YELLOW='\033[33m'
readonly    BLUE='\033[34m'
readonly    MAGENTA='\033[35m'
readonly    CYAN='\033[36m'
readonly    GRAY='\033[37m'

readonly    OPTIONS_USAGE='[-h|--help] [-u|--usage] [-v|--version]'
readonly    OPTIONS_HELP="$(gettext '  -h, --help     give this help list')
$(gettext "  -u, --usage    give a short usage message")
$(gettext '  -v, --version  print program version')"

readonly    OPTIONS_SHORT='huv'
readonly    OPTIONS_LONG='help,usage,version'

readonly    DISTRO=$(lsb_release --id --short | tr '[:upper:]' '[:lower:]')
            if type gnome-shell &> /dev/null; then
                EDITION='desktop'
            else
                EDITION='server'
            fi
readonly    EDITION


###############################################################################
# Variables
###############################################################################

declare -a  commandline_args=()
declare     option_gui=false
declare     text=''
declare     title=''


###############################################################################
# Functions
###############################################################################

# This function checks whether the script is started as user root and restarts
# the script as user root if not.
function become_root {
    local   -i  pkexec_rc=0
    local       program_exec=$MODULE_PATH/$PROGRAM_NAME

    # shellcheck disable=SC2310
    if ! become_root_check; then
        exit $OK
    fi

    if [[ $UID -ne 0 ]]; then
        if $option_gui; then
            export DISPLAY=:0.0
            xhost +si:localuser:root |& $LOGCMD
            text="restart (pkexec $program_exec ${commandline_args[*]})"
            msg_log "$text"
            pkexec "$program_exec" "${commandline_args[@]}" || pkexec_rc=$?
            exit $pkexec_rc
        else
            text="restart (exec sudo $program_exec ${commandline_args[*]})"
            msg_log "$text"
            sudo --non-interactive true || true
            exec sudo "$program_exec" "${commandline_args[@]}"
        fi
    fi
}


# This function checks if the user is allowed to become root and returns 0 if
# so, otherwise returns 1 with descriptive message.
function become_root_check {
    # Can user perform sudo?
    if [[ $UID -eq 0 ]]; then
        # For the "grace" period of sudo, or as a root.
        return $OK
    elif groups "$USER" | grep --quiet --regexp='sudo'; then
        return $OK
    else
        text=$(gettext 'Already performed by the administrator.')
        msg_info "$text"
        return $ERROR
    fi
}


# This function checks for active updates and waits for the next check if so.
function check_for_active_updates {
    local   -i  check_wait=10

    sudo --non-interactive true || true
    while sudo  fuser                                       \
                /snap/core/*/var/cache/debconf/config.dat   \
                /var/cache/apt/archives/lock                \
                /var/cache/debconf/config.dat               \
                /var/lib/apt/lists/lock                     \
                /var/lib/dpkg/lock                          \
                /var/lib/dpkg/lock-frontend                 \
                &> /dev/null; do
        text="$(eval_gettext "Wait \${check_wait}s for another package manager\
 to finish...")"
        msg_info "$text"
        sleep $check_wait
    done
}


# This function checks to see if the computer is running on battery power and
# prompts the user to continue if so.
function check_on_ac_power {
    local   -i  on_battery=0

    on_ac_power |& $LOGCMD || on_battery=$?
    if [[ on_battery -eq 1 ]]; then
        text=$(gettext "The computer now uses only the battery for power.

It is recommended to connect the computer to the wall socket.")
        msg_warning "$text"
        if ! $option_gui; then
            wait_for_enter
        fi
    fi
}


# This function performs initial actions such as set traps (script-hardening).
function init_script {
    # Script-hardening.
    set -o errexit
    set -o errtrace
    set -o nounset
    set -o pipefail

    readonly LOGCMD="systemd-cat --identifier=$PROGRAM_NAME"

    trap 'signal err     $LINENO ${FUNCNAME:--} "$BASH_COMMAND" $?' ERR
    trap 'signal exit    $LINENO ${FUNCNAME:--} "$BASH_COMMAND" $?' EXIT
    trap 'signal sighup  $LINENO ${FUNCNAME:--} "$BASH_COMMAND" $?' SIGHUP
    trap 'signal sigint  $LINENO ${FUNCNAME:--} "$BASH_COMMAND" $?' SIGINT
    trap 'signal sigpipe $LINENO ${FUNCNAME:--} "$BASH_COMMAND" $?' SIGPIPE
    trap 'signal sigterm $LINENO ${FUNCNAME:--} "$BASH_COMMAND" $?' SIGTERM

    text="==== START log $PROGRAM_NAME ====
started ($MODULE_PATH/$PROGRAM_NAME $* as $USER)"
    msg_log "$text"

    commandline_args=("$@")
    readonly USAGE_LINE=$(eval_gettext "Type '\$DISPLAY_NAME --usage' for more\
 information.")
}


# This function returns an error message and logs it.
function msg_error {
    if $option_gui; then
        title=$(eval_gettext "Error message \$DISPLAY_NAME")
        zenity  --error                 \
                --width     600         \
                --height    100         \
                --title     "$title"    \
                --text      "$*"        2> >($LOGCMD) || true
    else
        printf "$RED%b$NORMAL\n" "$*" >&2
    fi
    msg_log "$RED$*$NORMAL"
}


# This function returns an informational message and logs it.
function msg_info {
    if $option_gui; then
        title=$(eval_gettext "Information \$DISPLAY_NAME")
        zenity  --info                  \
                --width     600         \
                --height    100         \
                --title     "$title"    \
                --text      "$*"        2> >($LOGCMD) || true
    else
        printf '%b\n' "$*"
    fi
    msg_log "$*"
}


# This function records a message to the log.
function msg_log {
    printf '%b\n' "$*" |& $LOGCMD
}


# This function returns a warning message and logs it.
function msg_warning {
    if $option_gui; then
        title=$(eval_gettext "Warning \$DISPLAY_NAME")
        zenity  --warning               \
                --width     600         \
                --height    100         \
                --title     "$title"    \
                --text      "$*"        2> >($LOGCMD) || true
    else
        printf "$YELLOW%b$NORMAL\n" "$*" >&2
    fi
    msg_log "$YELLOW$*$NORMAL"
}


# This function covers the general options.
function process_common_options {
    while true; do
        case $1 in
            -h|--help)
                process_option_help
                exit $OK
                ;;
            -u|--usage)
                process_option_usage
                exit $OK
                ;;
            -v|--version)
                process_option_version
                exit $OK
                ;;
            --)
                break
                ;;
            *)
                shift
                ;;
        esac
    done
}


# This function shows the available help.
function process_option_help {
    local   man_url="\033]8;;man:$PROGRAM_NAME(1)\033\\$DISPLAY_NAME "
            man_url+="$(gettext 'man page')\033]8;;\033\\"

    text="$(eval_gettext "Type 'man \$DISPLAY_NAME' or see the \$man_url for m\
ore information.")"
    printf  '%b\n\n%b\n'    \
            "$HELP"         \
            "$text"
}


# This function shows the available options.
function process_option_usage {
    text="$(eval_gettext "Type '\$DISPLAY_NAME --help' for more information.")"
    printf  '%b\n\n%b\n'    \
            "$USAGE"        \
            "$text"
}


# This function displays version, author, and license information.
function process_option_version {
    local   build_id=''
    local   grep_expr='# <https://creativecommons.org'
    local   program_year=''

    if [[ -e /usr/local/etc/kz-build.id ]]; then
        build_id=' ('$(cat /usr/local/etc/kz-build.id)')'
    else
        text=$(gettext 'Build ID cannot be determined.')
        msg_log "$text"
    fi

    program_year=$(
        grep    --regexp="$grep_expr" "$MODULE_PATH/$PROGRAM_NAME" |
        cut     --delimiter=' ' --fields=3
        ) || true
    if [[ $program_year = '' ]]; then
        text=$(gettext 'Program year cannot be determined.')
        msg_log "$text"
        program_year='.'
    else
        program_year=', '$program_year
    fi

    text="kz 2.4.7$build_id

$(gettext 'Written by') Karel Zimmer <info@karelzimmer.nl>, CC0 1.0 Universal'
<https://creativecommons.org/publicdomain/zero/1.0>$program_year"
    msg_info "$text"
}


# This function processes the signals for which the trap was set by function
# init_script (script-hardening).
function signal {
    local       signal=${1:-unknown}
    local   -i  lineno=${2:-unknown}
    local       function=${3:-unknown}
    local       command=${4:-unknown}
    local   -i  rc=${5:-$ERROR}
    local       rc_desc=''
    local   -i  rc_desc_signalno=0
    local       status=$rc/error

    case $rc in
        0)
            rc_desc='successful termination'
            status=$rc/OK
            ;;
        1)
            rc_desc='terminated with error'
            ;;
        6[4-9]|7[0-8])                  # 64--78
            rc_desc="open file '/usr/include/sysexits.h' and look for '$rc'"
            ;;
        126)
            rc_desc='command cannot execute'
            ;;
        127)
            rc_desc='command not found'
            ;;
        128)
            rc_desc='invalid argument to exit'
            ;;
        129)                            # SIGHUP (128+1)
            rc_desc='hangup'
            ;;
        130)                            # SIGINT (128+2)
            rc_desc='terminated by control-c'
            ;;
        13[1-9]|140)                    # 140 (128+12)
            rc_desc_signalno=$((rc - 128))
            rc_desc="typ 'trap -l' and look for $rc_desc_signalno"
            ;;
        141)                            # SIGPIPE (128+13)
            rc_desc='broken pipe: write to pipe with no readers'
            ;;
        142)                            # SIGALRM (128+14)
            rc_desc='timer signal from alarm'
            ;;
        143)                            # SIGTERM (128+15)
            rc_desc='termination signal'
            ;;
        14[4-9]|1[5-8][0-9]|19[0-2])    # 144 (128+16)--192 (128+64)
            rc_desc_signalno=$((rc - 128))
            rc_desc="typ 'trap -l' and look for $rc_desc_signalno"
            ;;
        255)
            rc_desc='exit status out of range'
            ;;
        *)
            rc_desc='unknown error'
            ;;
    esac
    text="signal: $signal, line: $lineno, function: $function, command: "
    text+="$command, code: $rc ($rc_desc)"
    msg_log "$text"

    case $signal in
        err)
            text=$(eval_gettext "Program \$PROGRAM_NAME encountered an error.")
            msg_error "$text"
            exit "$rc"
            ;;
        exit)
            signal_exit
            text="ended (code=exited, status=$status)
==== END log $PROGRAM_NAME ===="
            msg_log "$text"
            trap - ERR EXIT SIGHUP SIGINT SIGPIPE SIGTERM
            exit "$rc"
            ;;
        *)
            text=$(eval_gettext "Program \$PROGRAM_NAME has been interrupted.")
            msg_error "$text"
            exit "$rc"
            ;;
    esac
}


# This function controls the final termination of the script.
function signal_exit {
    case $PROGRAM_NAME in
        kz-install)
            if [[ $rc -ne $OK ]]; then
                text="$(gettext "If the package manager gives apt errors, laun\
ch a Terminal window and execute:")
[1] kz update
[2] sudo update-initramfs -u"
                msg_log "$text"
            fi
            ;;
        *)
            :
            ;;
    esac
}


# This function waits for the user to press Enter.
function wait_for_enter {
    text="
$(gettext 'Press the Enter key to continue [Enter]: ')"
    read -rp "$text" < /dev/tty
}
