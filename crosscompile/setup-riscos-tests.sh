#!/bin/bash
##
# Download the xmllint and xsltproc binaries so that we can use them for testing.
# This is intended to check that the tool works on RISC OS.
#

# Configurables
version_xslt=v1.41/LibXSLT-1.41.zip
version_xml2=v1.41/LibXML2-1.41.zip

perlbin=~/projects/RO/commands/riscos-source/Sources/BuildUtils/Perl/aif32/perl,ff8

set -eo pipefail

scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
rootdir="$(cd "$scriptdir/.." && pwd -P)"
venvdir="${rootdir}/venv"
downloaddir="${rootdir}/riscos-bits"

mkdir -p "$downloaddir"

function download() {
    local output=$1
    local url=$2
    if wget -V >/dev/null 2>&1 ; then
        # We have wget.
        wget -O "$output" "$url"
    else
        # We don't have wget, so try curl
        curl --location --output "$output" "$url"
    fi
}

# Download the RISC OS tools
download_xslt="${downloaddir}/$(basename "$version_xslt")"
download_xml2="${downloaddir}/$(basename "$version_xml2")"
if [[ ! -f "${download_xslt}" ]] ; then
    download "${download_xslt}" "https://github.com/gerph/libxslt/releases/download/${version_xslt}"
fi
if [[ ! -f "${download_xml2}" ]] ; then
    download "${download_xml2}" "https://github.com/gerph/libxml2/releases/download/${version_xml2}"
fi

eval "$("${scriptdir}/ci-vars")"
source "${scriptdir}/setup-venv.sh"

# obtain a perl, if we have one (not needed when run under build service)
if [[ -f "${perlbin}" ]] ; then
    cp "${perlbin}" "${downloaddir}/"
fi

# Extract them
source "${venvdir}/bin/activate"
riscos-unzip --chdir "${downloaddir}" "${download_xml2}"
riscos-unzip --chdir "${downloaddir}" "${download_xslt}"

# We don't need the libraries
rm -rf "${downloaddir}/Lib"

# Put our tool in the top level
"${scriptdir}/build-riscos-tool.sh" "${downloaddir}"

# Put the examples in there
cp -R "${rootdir}/examples" "${downloaddir}/examples"

# Put the !Install tool in there
cp "${rootdir}/Resources/!Install,feb" "${downloaddir}/"
