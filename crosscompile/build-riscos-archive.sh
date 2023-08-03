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
mkdir -p "${tmpdir}/tool/LICENSES"
mkdir -p "${tmpdir}/download"

# The list of files we should add to our archive.
release_files=()
release_files+=("$tmpdir/tool/LICENSES")

# Build the tool in our temporary directory
"${scriptdir}/build-riscos-tool.sh" "$tmpdir/tool/Tools/XML"

# Import the prerequisite tools, which we can then process
"${scriptdir}/setup-riscos-prereqs.sh" "$tmpdir/download/"
mv "$tmpdir/download/Tools/XML/"* "$tmpdir/tool/Tools/XML/"

release_files+=("$tmpdir/tool/Tools/XML")

if [[ -f "$rootdir/LICENSE" ]] ; then
    cp "$rootdir/LICENSE" "$tmpdir/tool/LICENSES/riscos-prminxml"
fi

for lib in libxml2 libxslt ; do
    if [[ -f "$tmpdir/download/COPYING-$lib" ]] ; then
        cp "$tmpdir/download/COPYING-$lib" "$tmpdir/tool/LICENSES/$lib"
    fi
    if [[ -f "$tmpdir/download/README-$lib.md" ]] ; then
        cp "$tmpdir/download/README-$lib.md" "$tmpdir/tool/"
        release_files+=("$tmpdir/tool/README-$lib.md")
    fi
done

if [[ -f "$rootdir/README.md" ]] ; then
    cp "$rootdir/README.md" "$tmpdir/tool/README-prminxml.md"
    release_files+=("$tmpdir/tool/README-prminxml.md")
fi

eval "$(${scriptdir}/ci-vars)"
source "${scriptdir}/setup-venv.sh"

riscos-zip --chdir "$tmpdir/tool" "${archive}" "${release_files[@]}"

# Clean up
rm -rf "$tmpdir"
