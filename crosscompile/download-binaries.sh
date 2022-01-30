#!/bin/bash
##
# Download the xmllint and xsltproc binaries so that we can use them for testing.
# This is intended to check that the tool works on RISC OS.
#

# Configurables
version_xslt=v1.41/LibXSLT-1.41.zip
version_xml2=v1.41/LibXML2-1.41.zip

perl_bin=~/projects/RO/commands/riscos-source/Sources/BuildUtils/Perl/aif32/perl,ff8

# How we configured the virtualenv
version_venv=1

set -eo pipefail

scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
rootdir="$(cd "$scriptdir/.." && pwd -P)"
venvdir="${rootdir}/venv"
downloaddir="${rootdir}/riscos-bits"

mkdir -p "$downloaddir"

# Download the RISC OS tools
download_xslt="${downloaddir}/$(basename "$version_xslt")"
download_xml2="${downloaddir}/$(basename "$version_xml2")"
if [[ ! -f "${download_xslt}" ]] ; then
    wget -O "${download_xslt}" "https://github.com/gerph/libxslt/releases/download/${version_xslt}"
fi
if [[ ! -f "${download_xml2}" ]] ; then
    wget -O "${download_xml2}" "https://github.com/gerph/libxml2/releases/download/${version_xml2}"
fi

# Set up virtualenv
venv_key_expect="$(echo "$version_xslt $version_xml2 $version_venv" | md5sum | cut -d' ' -f1)"
venv_key_actual="$([ -f "$venvdir/key" ] && cat "$venvdir/key" || true)"

if [[ "${venv_key_actual}" != "${venv_key_expect}" ]] ; then
    echo rm -rf "${venvdir}"

    virtualenv -p python2 "${venvdir}"
    source "${venvdir}/bin/activate"
    pip install rozipinfo
    echo "$venv_key_expect" > "$venvdir/key"
    deactivate
fi

# obtain a perl, if we have one (not needed when run under build service)
if [[ -f "${perlbin}" ]] ; then
    cp "${perlbin}" "${downloaddir}/"
fi

# Extract them
source "${venvdir}/bin/activate"
python -m rozipfile --chdir "${downloaddir}" --extract "${download_xml2}"
python -m rozipfile --chdir "${downloaddir}" --extract "${download_xslt}"

# We don't need the libraries
rm -rf "${downloaddir}/Lib"

# Put our tool in the top level
cp "${rootdir}/riscos-prminxml" "${downloaddir}/riscos-prminxml.pl"

# Put the examples in there
cp -R "${rootdir}/examples" "${downloaddir}/examples"

# Put the !Install tool in there
cp -R "${rootdir}/catalog" "${downloaddir}/"
cp "${rootdir}/Resources/!Install,feb" "${downloaddir}/"
