#!/bin/bash
##
# Build the archive of the RISC OS prm-in-xml tool.
#

set -eo pipefail

scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

archive=$1

if [[ "${archive}" = '' ]] ; then
    echo "Syntax: $0 <archive>" >&2
    exit 1
fi

tmpdir="/tmp/build-riscos-archive.$$"
mkdir -p "${tmpdir}"

# Build the tool in our temporary directory
"${scriptdir}/build-riscos-tool.sh" "$tmpdir"

eval "$(${scriptdir}/ci-vars)"
source "${scriptdir}/setup-venv.sh"

riscos-zip --chdir "$tmpdir" "${archive}" "${tmpdir}/riscos-prminxml"

# Clean up
rm -rf "$tmpdir"
