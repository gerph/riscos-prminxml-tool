#!/bin/bash
##
# Tag and update a release's links.
#
# We will update the release files to contain the tag for the new
# release, as it will appear. Primarily this means updating the
# README.md to have links to where the release will appear once
# release has been made.
# Then commiting the change, and finally tagging it.
#

set -eo pipefail

tagscriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
tagrootdir="$(cd "$tagscriptdir/.." && pwd -P)"

sed_inline_args=(-E -i)
if [[ "$(uname -s)" = 'Darwin' ]] ; then
    # On macOS we need to specify the backup filename to sed.
    sed_inline_args+=('')
fi

cd "$tagrootdir"

eval $("${tagscriptdir}"/ci-vars --repo .)

if [[ "$CI_BRANCH_VERSION" =~ /-dirty$/ ]] ; then
    echo "Branch is dirty. Refusing to continue."
    exit 1
fi

sed "${sed_inline_args[@]}" 's!(https://github.com/gerph/riscos-prminxml-tool/releases/download)/[^/]*/(POSIX-PRMinXML|RISCOS-PRMinXML|Example-Output)-.*(\.zip|\.tar\.gz)!\1/GITTAG/\2-GITVERSION\3!g' "README.md"
git commit -m "Update README.md links for release" README.md


eval $("${tagscriptdir}"/ci-vars --repo .)

TAG="v$CI_BRANCH_VERSION"
echo "New tag will be: $TAG"

sed "${sed_inline_args[@]}" "s!GITTAG!$TAG!g" README.md
sed "${sed_inline_args[@]}" "s!GITVERSION!$CI_BRANCH_VERSION!g" README.md
git commit -m "Update README.md links for release $TAG" --amend README.md
git tag -f "$TAG"

echo "---- Update complete ----"
echo "Now you must push the changes:"
echo "    git push origin $CI_BRANCH"
echo "    git push origin $TAG"
