#!/usr/bin/env bash

set +x
set -e
echo "===========================================$0"

INGEST_ID=$1
CASE_ID=$2
ALTERNATE_ID=$3
LABEL=$4

if [[ -d "pst-extract/pst-json-withoutattachments/" ]]; then
    rm -rf "pst-extract/pst-json-withoutattachments/"
fi

mkdir "pst-extract/pst-json-withoutattachments/"
./src/mbox.py pst-extract/mbox pst-extract/pst-json-withoutattachments/ --ingest_id $INGEST_ID --case_id $CASE_ID --alt_ref_id $ALTERNATE_ID --label $LABEL --preserve_attachments False
