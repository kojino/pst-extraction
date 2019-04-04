#!/usr/bin/env bash

set +x
set -e

START=$(date +%s)
PST_PATH=$1
PST_PREFIX=$2

echo $PST_PATH
echo $PST_PREFIX
if [[ -d "pst-extract/mbox/${PST_PREFIX}" ]]; then
    rm -rf "pst-extract/mbox/${PST_PREFIX}"
fi

mkdir -p "pst-extract/mbox/${PST_PREFIX}"

for f in ${PST_PATH}/${PST_PREFIX}*.pst;
do
     time readpst -r -j 16 -o pst-extract/mbox/${PST_PREFIX} ${f};
done;
END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds"
