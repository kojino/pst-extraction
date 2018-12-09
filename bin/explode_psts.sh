#!/usr/bin/env bash

set +x
set -e

START=$(date +%s)
PST_PATH=$1
PST_PREFIX=$2

echo $PST_PATH
echo $PST_PREFIX
if [[ -d "${PST_PREFIX}/pst-extract/mbox/" ]]; then
    rm -rf "${PST_PREFIX}/pst-extract/mbox/"
fi

mkdir -p "${PST_PREFIX}/pst-extract/mbox/"

for f in ${PST_PATH}/${PST_PREFIX}*.pst;
do
     time readpst -r -j 16 -o ${PST_PREFIX}/pst-extract/mbox ${f};
done;
END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds"
