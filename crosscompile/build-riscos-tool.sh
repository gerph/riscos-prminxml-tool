#!/bin/bash
##
# Build the RISC OS prm-in-xml tool.
#

set -eo pipefail

scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
rootdir="$(cd "$scriptdir/.." && pwd -P)"

install_dir=$1

if [[ "${install_dir}" = '' ]] ; then
    echo "Syntax: $0 <install-directory>" >&2
    exit 1
fi

if [[ "$CI_BRANCH_VERSION" = '' ]] ; then
    echo "ERROR: Cannot build the tool without the CI_BRANCH_VERSION variable (use ci-vars)" >&2
    exit 1
fi

# Get the version we are building
version=${CI_BRANCH_VERSION:-VERSION}

mkdir -p "${install_dir}/riscos-prminxml"

# Perl filetype is &102
if [[ -f "${rootdir}/process.pl" ]] ; then
    tool_file="${rootdir}/process.pl"
else
    tool_file="${rootdir}/riscos-prminxml"
fi
sed "s!VERSION!$version!" "${rootdir}/riscos-prminxml" > "${install_dir}/riscos-prminxml/riscos-prminxml.pl,102"
cp -R "${rootdir}/catalog" "${install_dir}/riscos-prminxml/catalog"
cp -R "${rootdir}/Resources/!Run,feb" "${install_dir}/riscos-prminxml/!Run,feb"
cp -R "${rootdir}/Resources/perl,ff8" "${install_dir}/riscos-prminxml/perl,ff8"

find "${install_dir}" -name '*.xml' -exec mv '{}' '{},f80' \;
find "${install_dir}" -name '*.dtd' -exec mv '{}' '{},f7f' \;
find "${install_dir}" -name '*.xsl' -exec mv '{}' '{},f7e' \;
