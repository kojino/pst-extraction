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

if [[ -d "pst-extract/${PST_PREFIX}/pst-json/" ]]; then
    rm -rf "pst-extract/${PST_PREFIX}/pst-json/"
fi

mkdir "pst-extract/${PST_PREFIX}/pst-json/"
./src/mbox.py pst-extract/${PST_PREFIX}/mbox pst-extract/${PST_PREFIX}/pst-json/ --ingest_id $INGEST_ID --case_id $CASE_ID --alt_ref_id $ALTERNATE_ID --label $LABEL
END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds"
