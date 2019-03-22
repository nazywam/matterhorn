#!/bin/sh

# Run the most recently-modified matterhorn binary in the matterhorn
# working tree.
#
# Portability: Linux, OS X

set -e

HERE=$(cd `dirname $0`; pwd)

# An array of the build directories we'll look for.
TRY_DIRS=("$HERE/dist-newstyle" "$HERE/dist")

function none_found {
    echo "No matterhorn build directories found. Looked for:"
    for d in ${TRY_DIRS[@]}
    do
        echo "  $d"
    done
    echo "Try:"
    echo "  $ cd ${HERE}"
    echo "  $ cabal new-build"
    exit 2
}

# Portability note: -executable is only compatible with GNU find but
# this invocation should be more portable.  Also be flexible about old
# and new cabal output locations, preferring new, but avoiding
# slurping up the entire current directory.
OPTIONS=$(find $(for D in ${TRY_DIRS[@]}; do [ -d $D ] && echo $D; done) -name matterhorn -type f \( -perm -u=x -o -perm -g=x -o -perm -o=x \) )
if [ -z "${FOUND_DIRS}" ] ; then
    none_found
fi

BINARIES=$(find $FOUND_DIRS -name matterhorn -type f \( -perm -u=x -o -perm -g=x -o -perm -o=x \) )
if [ -z "${BINARIES}" ] ; then
    none_found
fi

SORTED_BINARIES=$(ls -t ${BINARIES})

# Run the most recently-modified binary that we found. Note that since
# we use exec, this loop never makes it past one iteration.
for BINARY in ${SORTED_BINARIES}; do
  exec "${BINARY}" ${1+$@}
done

echo "No executables found."
