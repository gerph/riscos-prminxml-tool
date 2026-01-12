#!/bin/bash
##
# Build the RISC OS prerequisites for the prm-in-xml tool.
#
# Specifically, obtains the XSLTProc and XMLLint tools.
#

set -eo pipefail

# The versions we're going to use
LIBXSLT_VERSION=1.41
LIBXML2_VERSION=1.41

scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
rootdir="$(cd "$scriptdir/.." && pwd -P)"
venvdir="${rootdir}/venv"

install_dir=$1

if [[ "${install_dir}" = '' ]] ; then
    echo "Syntax: $0 <install-directory>" >&2
    exit 1
fi

LIBXML2_URL=https://github.com/gerph/libxml2/releases/download/v${LIBXML2_VERSION}/LibXML2-${LIBXML2_VERSION}.zip
LIBXSLT_URL=https://github.com/gerph/libxslt/releases/download/v${LIBXSLT_VERSION}/LibXSLT-${LIBXSLT_VERSION}.zip


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
download_xslt="${install_dir}/$(basename "$LIBXSLT_URL")"
download_xml2="${install_dir}/$(basename "$LIBXML2_URL")"
if [[ ! -f "${download_xslt}" ]] ; then
    download "${download_xslt}" "${LIBXSLT_URL}"
fi
if [[ ! -f "${download_xml2}" ]] ; then
    download "${download_xml2}" "${LIBXML2_URL}"
fi

source "${scriptdir}/setup-venv.sh"

# Extract them
echo +++ Extracting xml/xslt tools for RISC OS
riscos-unzip --chdir "${install_dir}" "${download_xml2}"
mv "${install_dir}/README.md" "${install_dir}/README-libxml2.md"
mv "${install_dir}/COPYING" "${install_dir}/COPYING-libxml2"
riscos-unzip --chdir "${install_dir}" "${download_xslt}"
#mv "${install_dir}/README.md" "${install_dir}/README-libxslt.md"
mv "${install_dir}/COPYING" "${install_dir}/COPYING-libxslt"
