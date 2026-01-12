#!/bin/bash
##
# Download the xmllint and xsltproc binaries so that we can use them for testing.
# This is intended to check that the tool works on RISC OS.
#

perlbin=~/projects/RO/commands/riscos-source/Sources/BuildUtils/Perl/aif32/perl,ff8

set -eo pipefail

scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
rootdir="$(cd "$scriptdir/.." && pwd -P)"
downloaddir="${rootdir}/riscos-bits"

mkdir -p "$downloaddir"

# obtain a perl, if we have one (not needed when run under build service)
if [[ -f "${perlbin}" ]] ; then
    cp "${perlbin}" "${downloaddir}/"
fi

# Obtain XSLTProc and LibXML2
echo +++ Setting up prerequisites
"${scriptdir}/setup-riscos-prereqs.sh" "${downloaddir}"

# We don't need the libraries
rm -rf "${downloaddir}/Lib"

# Put our tool in the top level
eval "$(${scriptdir}/ci-vars)"
echo +++ Building RISC OS Tool
"${scriptdir}/build-riscos-tool.sh" "${downloaddir}"

# Put the examples in there
cp -R "${rootdir}/examples" "${downloaddir}/examples"

# Put the !Install tool in there
cp "${rootdir}/Resources/!Install,feb" "${downloaddir}/"
