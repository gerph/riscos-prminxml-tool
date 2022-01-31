#!/bin/bash
##
# Set up the virtualenv for the RISC OS zip/unzip
#

# How we configured the virtualenv
version_venv=1

scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
rootdir="$(cd "$scriptdir/.." && pwd -P)"
venvdir="${rootdir}/venv"

# Set up virtualenv
venv_key_expect="$(echo "$version_venv" | md5sum | cut -d' ' -f1)"
venv_key_actual="$([ -f "$venvdir/key" ] && cat "$venvdir/key" || true)"

if [[ "${venv_key_actual}" != "${venv_key_expect}" ]] ; then
    echo rm -rf "${venvdir}"

    virtualenv -p python2 "${venvdir}"
    source "${venvdir}/bin/activate"
    pip install rozipinfo
    echo "$venv_key_expect" > "$venvdir/key"
    deactivate
fi

# Extract them
source "${venvdir}/bin/activate"

function riscos-zip() {
    python -m rozipfile --create "$@"
}
function riscos-unzip() {
    python -m rozipfile --extract "$@"
}
