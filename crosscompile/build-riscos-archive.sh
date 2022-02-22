#!/bin/bash
##
# Build the archive of the RISC OS prm-in-xml tool.
#

set -eo pipefail

scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
rootdir="$(cd "$scriptdir/.." && pwd -P)"

archive=$1

if [[ "${archive}" = '' ]] ; then
    echo "Syntax: $0 <archive>" >&2
    exit 1
fi

tmpdir="/tmp/build-riscos-archive.$$"
mkdir -p "${tmpdir}"

# The list of files we should add to our archive.
release_files=()

# Build the tool in our temporary directory
"${scriptdir}/build-riscos-tool.sh" "$tmpdir/Tools/XML"
release_files+=("$tmpdir/Tools/XML")

if [[ -f "$rootdir/LICENSE" ]] ; then
    cp "$rootdir/LICENSE" "$tmpdir/COPYING"
    release_files+=("$tmpdir/COPYING")
fi
if [[ -f "$rootdir/README.md" ]] ; then
    cp "$rootdir/README.md" "$tmpdir/README.md"
    release_files+=("$tmpdir/README.md")
fi

eval "$(${scriptdir}/ci-vars)"
source "${scriptdir}/setup-venv.sh"

riscos-zip --chdir "$tmpdir" "${archive}" "${release_files[@]}"

# Clean up
rm -rf "$tmpdir"
