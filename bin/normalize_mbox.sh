#!/usr/bin/env bash

set +x
set -e
echo "===========================================$0"

START=$(date +%s)

PST_PREFIX=$1
INGEST_ID=$2
CASE_ID=$3
ALTERNATE_ID=$4
LABEL=$5

if [[ -d "pst-extract/pst-json/${PST_PREFIX}" ]]; then
    rm -rf "pst-extract/pst-json/${PST_PREFIX}"
fi

mkdir "pst-extract/pst-json/${PST_PREFIX}"
./src/mbox.py pst-extract/mbox/${PST_PREFIX} pst-extract/pst-json/${PST_PREFIX} --ingest_id $INGEST_ID --case_id $CASE_ID --alt_ref_id $ALTERNATE_ID --label $LABEL
END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds"
