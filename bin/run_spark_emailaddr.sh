#!/usr/bin/env bash

set +x
set -e
echo "===========================================$0 $@"

START=$(date +%s)

PST_PREFIX=$1
INGEST_ID=$2
CASE_ID=$3
ALTERNATE_ID=$4
LABEL=$5
JSON_VALIDATION_FLAG=$6

OUTPUT_DIR=spark-emailaddr
if [[ -d "pst-extract/${PST_PREFIX}/$OUTPUT_DIR" ]]; then
    rm -rf "pst-extract/${PST_PREFIX}/$OUTPUT_DIR"
fi

spark-submit --master local[*] --driver-memory 16g --conf spark.storage.memoryFraction=.8 --files spark/filters.py spark/emailaddr_agg.py pst-extract/spark-emails-text pst-extract/${PST_PREFIX}/$OUTPUT_DIR --ingest_id $INGEST_ID --case_id $CASE_ID --alt_ref_id $ALTERNATE_ID --label $LABEL $JSON_VALIDATION_FLAG

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds"
#./bin/validate_lfs.sh $OUTPUT_DIR
