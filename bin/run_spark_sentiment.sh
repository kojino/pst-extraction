#!/usr/bin/env bash

set +x
set -e
echo "===========================================$0 $@"

START=$(date +%s)

OUTPUT_DIR=spark-emails-sentiment
if [[ -d "pst-extract/${PST_PREFIX}/$OUTPUT_DIR" ]]; then
    rm -rf "pst-extract/${PST_PREFIX}/$OUTPUT_DIR"
fi

spark-submit --master local[*] --driver-memory 16g --conf spark.storage.memoryFraction=.8 --files spark/sentiment.py pst-extract/spark-emails-text-rmhtml pst-extract/${PST_PREFIX}/$OUTPUT_DIR

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds"
#./bin/validate_lfs.sh $OUTPUT_DIR
